#import "WitcherSwitchCell.h"

@implementation WitcherSwitchCell

@synthesize controlSwitch;
@synthesize titleLabel;
@synthesize subtitleLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier specifier:specifier];
    if (self) {
        title = [[specifier properties] objectForKey:@"title"];
        subtitle = [[specifier properties] objectForKey:@"subtitle"];
        key = [[specifier properties] objectForKey:@"key"];

        [self registerCustomFonts:nil]; 
    }
    return self;
}

-(void)didMoveToWindow {
    [super didMoveToWindow];

    [self setupViews];
}

-(void)setupViews {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:WITCHER_PLIST_SETTINGS];
    _Bool hardwareButtonMode = prefs[key] ? [prefs[key] boolValue] : YES;

    controlSwitch = [[WitcherSwitch alloc] init];
    [controlSwitch setOn:hardwareButtonMode];
    [controlSwitch updateState];
    [controlSwitch addTarget:self action:@selector(switchDidChangedValue:) forControlEvents:UIControlEventValueChanged];

    titleLabel = [[UILabel alloc] init];
    [titleLabel setText:title];
    [titleLabel setFont:[UIFont fontWithName:@"UbuntuSans-Medium" size:17.0]];
    [titleLabel setTextColor:[UIColor labelColor]];


    subtitleLabel = [[UILabel alloc] init];
    [subtitleLabel setText:subtitle];
    [subtitleLabel setFont:[UIFont fontWithName:@"UbuntuSans-Medium" size:12.0]];
    [subtitleLabel setTextColor:[UIColor secondaryLabelColor]];
    
    for (UIView * view in @[controlSwitch, titleLabel, subtitleLabel]) {
        [[self contentView] addSubview:view];
    }
    
    [self setupBackground];
    [self setupConstraints];
}

-(void)setupConstraints {
    [controlSwitch setTranslatesAutoresizingMaskIntoConstraints:NO];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [subtitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [NSLayoutConstraint activateConstraints:@[
        [[controlSwitch trailingAnchor] constraintEqualToAnchor:[[self contentView] trailingAnchor] constant:-16.0],
        [[controlSwitch centerYAnchor] constraintEqualToAnchor:[[self contentView] centerYAnchor]],
        
        [[titleLabel leadingAnchor] constraintEqualToAnchor:[[self contentView] leadingAnchor] constant:16.0],
        [[titleLabel topAnchor] constraintEqualToAnchor:[[self contentView] topAnchor] constant:12.0],
        [[titleLabel trailingAnchor] constraintEqualToAnchor:[controlSwitch leadingAnchor] constant:-8.0],
        
        [[subtitleLabel leadingAnchor] constraintEqualToAnchor:[[self contentView] leadingAnchor] constant:16.0],
        [[subtitleLabel topAnchor] constraintEqualToAnchor:[titleLabel bottomAnchor] constant:2.0],
        [[subtitleLabel bottomAnchor] constraintEqualToAnchor:[[self contentView] bottomAnchor] constant:-12.0],
        [[subtitleLabel trailingAnchor] constraintEqualToAnchor:[controlSwitch leadingAnchor] constant:-8.0]
    ]];

}

-(void)switchDidChangedValue:(UISwitch *)sender
{
    [[self specifier] performSetterWithValue:@([sender isOn])];
}

-(void)setupBackground {
    
    UIVisualEffectView * backgroundBlur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle: UIBlurEffectStyleSystemMaterial]];
    [backgroundBlur setAlpha:0.9];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [[self backgroundView] setBackgroundColor:[UIColor clearColor]];
    [[self contentView] setBackgroundColor:[UIColor clearColor]];

    [self setBackgroundView: backgroundBlur];
    
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