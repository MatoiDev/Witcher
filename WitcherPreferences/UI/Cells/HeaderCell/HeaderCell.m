//
//  HeaderCell.m
//  WitcherPreferencesUI
//
//  Created by Matoi on 09.05.2024.
//

#import "HeaderCell.h"

@implementation HeaderCell

@synthesize tweakNameLabel;
@synthesize descriptionLabel;
@synthesize verticalStackView;
@synthesize imageView;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier specifier:specifier];
    if (self) {
        tweakName = [[specifier properties] objectForKey:@"name"];
        tweakDescription = [[specifier properties] objectForKey:@"description"];
        iconName = [[specifier properties] objectForKey:@"icon"];

        [self registerCustomFonts:nil];
    }
    return self;
}

-(void)didMoveToWindow {
    [super didMoveToWindow];
    
    tweakNameLabel = [[UILabel alloc] init];
    [tweakNameLabel setFont:[UIFont fontWithName:@"UbuntuSans-Bold" size:50.0]];
    [tweakNameLabel setTextColor:[UIColor labelColor]];
    [tweakNameLabel setText:tweakName];
    [tweakNameLabel setNumberOfLines:1];
    [tweakNameLabel setAdjustsFontSizeToFitWidth:YES];
    
    descriptionLabel = [[UILabel alloc] init];
    [descriptionLabel setFont:[UIFont fontWithName:@"UbuntuSans-Medium" size:16.0]];
    [descriptionLabel setTextColor:[UIColor secondaryLabelColor]];
    [descriptionLabel setText:tweakDescription];
    [descriptionLabel setNumberOfLines:1];
    [descriptionLabel setAdjustsFontSizeToFitWidth:YES];

    imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[WITCHER_PREFERENCES_BUNDLE_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", iconName]]]];
    
    verticalStackView = [[UIStackView alloc] init];
    [verticalStackView setAxis:UILayoutConstraintAxisVertical];
    [verticalStackView setAlignment:UIStackViewAlignmentLeading];
    [verticalStackView setDistribution:UIStackViewDistributionFill];
    [verticalStackView addArrangedSubview:tweakNameLabel];
    [verticalStackView addArrangedSubview:descriptionLabel];
    [verticalStackView setSpacing:0];
    
    [[self contentView] addSubview:imageView];
    [[self contentView] addSubview:verticalStackView];
    
    [verticalStackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [NSLayoutConstraint activateConstraints:@[
        [[imageView topAnchor] constraintEqualToAnchor:[[self contentView] topAnchor] constant:16.0],
        [[imageView leadingAnchor] constraintEqualToAnchor:[[self contentView] leadingAnchor] constant:16.0],
        [[imageView bottomAnchor] constraintEqualToAnchor:[[self contentView] bottomAnchor] constant:-16.0],
        [[imageView widthAnchor] constraintEqualToConstant:118],
        [[imageView heightAnchor] constraintEqualToConstant:118],
        
        [[verticalStackView leadingAnchor] constraintEqualToAnchor:[imageView trailingAnchor] constant:16.0],
        [[verticalStackView trailingAnchor] constraintEqualToAnchor:[[self contentView] trailingAnchor] constant:-16.0],
        [[verticalStackView centerYAnchor] constraintEqualToAnchor:[[self contentView] centerYAnchor]]
    ]];
    
    [self setupBackground];

}

-(void)setupBackground {
    
    UIVisualEffectView * backgroundBlur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle: UIBlurEffectStyleSystemMaterial]];
    [backgroundBlur setAlpha:0.9];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [[self backgroundView] setBackgroundColor:[UIColor clearColor]];
    
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

