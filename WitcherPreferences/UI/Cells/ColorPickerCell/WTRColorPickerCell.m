#import "WTRColorPickerCell.h"

@implementation WTRColorPickerCell {
    UIColorPickerViewController *_colorPicker;
    UIColor *_currentColor;
    NSString *_fallbackHex;
    BOOL _supportsAlpha;

    UIView *_indicatorView;
    CAShapeLayer *_indicatorShape;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier specifier:specifier];
    if (self) {
        _fallbackHex = [specifier propertyForKey:@"fallbackHex"];
        _supportsAlpha = [specifier propertyForKey:@"supportsAlpha"];

        NSBundle *bundle = [specifier.target bundle];
        NSString *label = [specifier propertyForKey:@"label"];
        NSString *localizationTable = [specifier propertyForKey:@"localizationTable"];

        _colorPicker = [[UIColorPickerViewController alloc] init];
        _colorPicker.delegate = self;
        _colorPicker.supportsAlpha = _supportsAlpha;
        _colorPicker.title = [bundle localizedStringForKey:label value:label table:localizationTable];

        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 29, 29)];
        _indicatorView.clipsToBounds = YES;
        _indicatorView.layer.borderColor = [UIColor opaqueSeparatorColor].CGColor;
        _indicatorView.layer.borderWidth = 3;
        _indicatorView.layer.cornerRadius = 14.5;
        self.accessoryView = _indicatorView;

        _indicatorShape = [CAShapeLayer layer];
        _indicatorShape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 29, 29) cornerRadius:14.5].CGPath;
        [_indicatorView.layer addSublayer:_indicatorShape];

        //Get saved hex or fallback hex, convert to color and set indicator color and hex subtitle
        NSString *hex = ([specifier performGetter]) ?: _fallbackHex;
        _currentColor = [self colorFromHex:hex useAlpha:_supportsAlpha];
        _indicatorShape.fillColor = _currentColor.CGColor;
        self.detailTextLabel.text = [self legibleStringFromHex:hex];

        [[self textLabel] setFont:[UIFont fontWithName:@"UbuntuSans-Medium" size:17.0]];
        [[self textLabel] setTextColor:[UIColor labelColor]];
        [[self detailTextLabel] setFont:[UIFont fontWithName:@"UbuntuSans-Medium" size:12.0]];
        [[self detailTextLabel] setTextColor:[UIColor secondaryLabelColor]];

        [self registerCustomFonts:nil];  
    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        [self presentColorPicker];
    } else {
        [super setSelected:selected animated:animated];
    }
}

- (void)presentColorPicker {
    _colorPicker.selectedColor = _currentColor;


    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIViewController *rootViewController = self._viewControllerForAncestor ?: [UIApplication sharedApplication].keyWindow.rootViewController;
    #pragma clang diagnostic pop

    [rootViewController presentViewController:_colorPicker animated:YES completion:nil];
}

#pragma mark - UIColorPickerViewControllerDelegate Methods
- (void)colorPickerViewControllerDidSelectColor:(UIColorPickerViewController *)colorPicker {
    _currentColor = colorPicker.selectedColor;

    NSString *selectedColorHex = [self hexFromColor:_currentColor useAlpha:_supportsAlpha];
    [self.specifier performSetterWithValue:selectedColorHex];

    [UIView transitionWithView:_indicatorView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _indicatorShape.fillColor = _currentColor.CGColor;
    }               completion:nil];

    [UIView transitionWithView:self.detailTextLabel duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.detailTextLabel.text = [self legibleStringFromHex:selectedColorHex];
    }               completion:nil];
}

#pragma mark - Converting Colors
- (UIColor *)colorFromHex:(NSString *)hexString useAlpha:(BOOL)useAlpha {
    hexString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];

    if ([hexString containsString:@":"] || hexString.length == 6) {
        NSArray *hexComponents = [hexString componentsSeparatedByString:@":"];
        CGFloat alpha = (hexComponents.count == 2) ? [[hexComponents lastObject] floatValue] / 100 : 1.0;
        hexString = [NSString stringWithFormat:@"%@%02X", [hexComponents firstObject], (int) (alpha * 255.0)];
    }

    unsigned int hex = 0;
    [[NSScanner scannerWithString:hexString] scanHexInt:&hex];

    CGFloat r = ((hex & 0xFF000000) >> 24) / 255.0;
    CGFloat g = ((hex & 0x00FF0000) >> 16) / 255.0;
    CGFloat b = ((hex & 0x0000FF00) >> 8) / 255.0;
    CGFloat a = (useAlpha) ? ((hex & 0x000000FF) >> 0) / 255.0 : 0xFF;

    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}


- (NSString *)hexFromColor:(UIColor *)color useAlpha:(BOOL)useAlpha {
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];

    NSString *hexString = [NSString stringWithFormat:@"#%02X%02X%02X%02X", (int) (r * 255.0), (int) (g * 255.0), (int) (b * 255.0), (int) (a * 255.0)];

    if (!useAlpha) {
        hexString = [hexString substringToIndex:hexString.length - 2];
    }

    return hexString;;
}

- (NSString *)legibleStringFromHex:(NSString *)hexString {
    hexString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];

    if ([hexString containsString:@":"]) {
        NSArray *hexComponents = [hexString componentsSeparatedByString:@":"];
        return [NSString stringWithFormat:@"#%@:%@", hexComponents[0], hexComponents[1]];

    } else if (hexString.length == 6) {
        return [NSString stringWithFormat:@"#%@", hexString];
    }

    unsigned int hex = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&hex];

    return [NSString stringWithFormat:@"#%@:%.2f", [hexString substringToIndex:hexString.length - 2], (
            (hex & 0x000000FF) >> 0) / 255.0];
}

-(void)didMoveToWindow {
    [super didMoveToWindow];
    [self setupBackground];
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

-(void)tintColorDidChange {
    [super tintColorDidChange];
    [[self textLabel] setTextColor:[UIColor labelColor]];
    [[self detailTextLabel] setTextColor:[UIColor secondaryLabelColor]];
}

-(void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];

    if([self respondsToSelector:@selector(tintColor)]) {
        [[self textLabel] setTextColor:[UIColor labelColor]];
        [[self detailTextLabel] setTextColor:[UIColor secondaryLabelColor]];
    }
}

@end
