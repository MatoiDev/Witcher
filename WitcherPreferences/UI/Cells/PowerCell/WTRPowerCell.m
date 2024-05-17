#import "WTRPowerCell.h"

@implementation WTRPowerCell

@synthesize cellTitle;
@synthesize cellSubtitle;
@synthesize powerButton;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier specifier:specifier];
  if(self) {
      
        impactFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
        [impactFeedbackGenerator prepare];

        NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:WITCHER_PLIST_SETTINGS];
	    _Bool isEnabled = prefs[@"isEnabled"] ? [prefs[@"isEnabled"] boolValue] : YES;
        
        powerButton = [[PowerButton alloc] init];
        [powerButton setOn:isEnabled];
        
        [self registerCustomFonts:nil];
  }
  return self;
}

-(void)didMoveToWindow {

    [super didMoveToWindow];
    
    cellTitle = [[UILabel alloc] init];
    [cellTitle setText:([powerButton isOn] ? @"Enabled" : @"Disabled")];
    [cellTitle setTextColor:[UIColor labelColor]];
    [cellTitle setFont:[UIFont fontWithName:@"UbuntuSans-Medium" size:17.0]];

    cellSubtitle = [[UILabel alloc] init];
    [cellSubtitle setText:@"Enable / Disable the tweak."];
    [cellSubtitle setTextColor:[UIColor secondaryLabelColor]];
    [cellSubtitle setFont:[UIFont fontWithName:@"UbuntuSans-Medium" size:12.0]];
    
    [powerButton addTarget:self action:@selector(powerButtonPressed) forControlEvents:UIControlEventTouchDown];
    [powerButton addTarget:self action:@selector(powerButtonReleased) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    
    [[self contentView] addSubview:cellTitle];
    [[self contentView] addSubview:cellSubtitle];
    [[self contentView] addSubview:powerButton];
    
    [self setupBackground];
    [self setupConstraints];
}

-(void)setupBackground {
    
    UIVisualEffectView * backgroundBlur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle: UIBlurEffectStyleSystemMaterial]];
    [backgroundBlur setAlpha:0.9];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [[self backgroundView] setBackgroundColor:[UIColor clearColor]];
    [[self contentView] setBackgroundColor:[UIColor clearColor]];

    [self setBackgroundView: backgroundBlur];
    
}

-(void)setupConstraints {
    
    [cellTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cellSubtitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [powerButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [NSLayoutConstraint activateConstraints:@[
        
        [cellTitle.leadingAnchor constraintEqualToAnchor: self.contentView.leadingAnchor constant: 16.0],
        [cellTitle.trailingAnchor constraintEqualToAnchor: powerButton.leadingAnchor constant: -8],
        [cellTitle.topAnchor constraintEqualToAnchor: self.contentView.topAnchor constant: 12.0],
        
        [cellSubtitle.leadingAnchor constraintEqualToAnchor: self.contentView.leadingAnchor constant: 16.0],
        [cellSubtitle.trailingAnchor constraintEqualToAnchor: powerButton.leadingAnchor constant: -8],
        [cellSubtitle.topAnchor constraintEqualToAnchor: cellTitle.bottomAnchor constant:2.0],
        [cellSubtitle.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-12.0],
        
        [powerButton.widthAnchor constraintEqualToConstant:40],
        [powerButton.heightAnchor constraintEqualToConstant:40],
        [powerButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16.0],
        [powerButton.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor]
    ]];
    
}

-(void)powerButtonPressed {
    [impactFeedbackGenerator impactOccurred];
}

-(void)powerButtonReleased {
    [impactFeedbackGenerator impactOccurred];
    [powerButton toggle];
    [cellTitle setText:([powerButton isOn] ? @"Enabled" : @"Disabled")];
    [[self specifier] performSetterWithValue:@([powerButton isOn])];
}

-(void)registerCustomFonts:(NSArray<NSString *> *_Nullable)fonts {

    if (!fonts) {
        fonts = @[
            @"Fonts/UbuntuSans-Light.ttf", 
            @"Fonts/UbuntuSans-Thin.ttf", 
            @"Fonts/UbuntuSans-Medium.ttf",
            @"Fonts/UbuntuSans-Medium.ttf",
            @"Fonts/UbuntuSans-SemiBold.ttf",
            @"Fonts/UbuntuSans-Bold.ttf"
        ];
    }

    for (NSString *fontName in fonts) {
        NSData* inData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[WITCHER_PREFERENCES_BUNDLE_PATH stringByAppendingPathComponent:fontName]]];
        CFErrorRef error;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)inData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            CFRelease(errorDescription);
        }
        CFRelease(font);
        CFRelease(provider);
    }
}

@end