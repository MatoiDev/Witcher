#import "WTRRootListController.h"


@implementation WTRRootListController

@synthesize backgroundImageView;

#pragma mark - Specifiers
-(NSArray *)specifiers {
    if (!_specifiers) {
        NSMutableArray *specifiers = [NSMutableArray array];
        PSSpecifier *spec;

        // Header Cell
        spec = [PSSpecifier preferenceSpecifierNamed:@""
                                              target:self
                                                 set:Nil
                                                 get:Nil
                                              detail:Nil
                                                cell:[PSTableCell cellTypeFromString:@""]
                                                edit:Nil];

        [spec setProperty:@"Witcher" forKey:@"name"];
        [spec setProperty:@"Magical iOS App Switcher" forKey:@"description"];
        [spec setProperty:@"logo_compressed" forKey:@"icon"];
        [spec setProperty:HeaderCell.class forKey:@"cellClass"];
        [specifiers addObject:spec];

        // Author Cell
        spec = [PSSpecifier preferenceSpecifierNamed:@""
                                              target:self
                                                 set:Nil
                                                 get:Nil
                                              detail:Nil
                                                cell:PSButtonCell
                                                edit:Nil];

        [spec setProperty:@"icon_compressed" forKey:@"icon"];
        [spec setProperty:@"https://github.com/MatoiDev/Witcher" forKey:@"url"];
        [spec setProperty:[AuthorCell class] forKey:@"cellClass"];
        [specifiers addObject:spec];

        [specifiers addObject:[PSSpecifier emptyGroupSpecifier]];

        // Power Cell
        spec = [PSSpecifier preferenceSpecifierNamed:@""
                                              target:self
                                                 set:@selector(setPreferenceValue:specifier:)
                                                 get:@selector(readPreferenceValue:)
                                              detail:Nil
                                                cell:[PSTableCell cellTypeFromString:@""]
                                                edit:Nil];

        [spec setProperty:@"isEnabled" forKey:@"key"];
        [spec setProperty:@NO forKey:@"default"];
        [spec setProperty:[WTRPowerCell class] forKey:@"cellClass"];
        [specifiers addObject:spec];

        // Hardware Button mode switch cell
        spec = [PSSpecifier preferenceSpecifierNamed:@""
                                              target:self
                                                 set:@selector(setPreferenceValue:specifier:)
                                                 get:@selector(readPreferenceValue:)
                                              detail:Nil
                                                cell:[PSTableCell cellTypeFromString:@""]
                                                edit:Nil];

        [spec setProperty:[WitcherSwitchCell class] forKey:@"cellClass"];
        [spec setProperty:@"Hardware button mode" forKey:@"title"];
        [spec setProperty:@"Need a respring" forKey:@"subtitle"];
        [spec setProperty:@NO forKey:@"default"];
        [spec setProperty:@"hardwareButtonMode" forKey:@"key"];
        [specifiers addObject:spec];

        // Header
        spec = [PSSpecifier preferenceSpecifierNamed:@"UI Customization"
                                              target:self
                                                 set:Nil
                                                 get:Nil
                                              detail:Nil
                                                cell:PSGroupCell
                                                edit:Nil];

        // [spec setProperty:@"No need for respring" forKey:@"footerText"];
        [specifiers addObject:spec];

        // ColorPicker for Router 
        spec = [PSSpecifier preferenceSpecifierNamed:@"Main color"
                                              target:self
                                                 set:@selector(setPreferenceValue:specifier:)
                                                 get:@selector(readPreferenceValue:)
                                              detail:Nil
                                                cell:PSButtonCell
                                                edit:Nil];

        [spec setProperty:[WTRColorPickerCell class] forKey:@"cellClass"];
        [spec setProperty:@"#FFFFFF" forKey:@"fallbackHex"];
        [spec setProperty:@YES forKey:@"supportsAlpha"];
        [spec setProperty:@"mainTintColor" forKey:@"key"];
        [spec setProperty:@"#000000:00" forKey:@"default"];
        [spec setProperty:@60 forKey:@"height"];
        [specifiers addObject:spec];

        // ColorPicker for Cells 
        spec = [PSSpecifier preferenceSpecifierNamed:@"Cells tint color"
                                              target:self
                                                 set:@selector(setPreferenceValue:specifier:)
                                                 get:@selector(readPreferenceValue:)
                                              detail:Nil
                                                cell:PSButtonCell
                                                edit:Nil];

        [spec setProperty:[WTRColorPickerCell class] forKey:@"cellClass"];
        [spec setProperty:@"#FFFFFF" forKey:@"fallbackHex"];
        [spec setProperty:@YES forKey:@"supportsAlpha"];
        [spec setProperty:@"cellsTintColor" forKey:@"key"];
        [spec setProperty:@"#FFFFFF" forKey:@"default"];
        [spec setProperty:@60 forKey:@"height"];
        [specifiers addObject:spec];

        // Actions
        spec = [PSSpecifier preferenceSpecifierNamed:@"Actions"
                                              target:self
                                                 set:Nil
                                                 get:Nil
                                              detail:Nil
                                                cell:PSGroupCell
                                                edit:Nil];

        [specifiers addObject:spec];

        // Hide/Show action buttons switch cell
        spec = [PSSpecifier preferenceSpecifierNamed:@""
                                              target:self
                                                 set:@selector(setPreferenceValue:specifier:)
                                                 get:@selector(readPreferenceValue:)
                                              detail:Nil
                                                cell:[PSTableCell cellTypeFromString:@""]
                                                edit:Nil];

        [spec setProperty:[WitcherSwitchCell class] forKey:@"cellClass"];
        [spec setProperty:@"Action buttons" forKey:@"title"];
        [spec setProperty:@"Hide / show action buttons" forKey:@"subtitle"];
        [spec setProperty:@YES forKey:@"default"];
        [spec setProperty:@"actionButtons" forKey:@"key"];
        [specifiers addObject:spec];

        // Kill playing application
        spec = [PSSpecifier preferenceSpecifierNamed:@""
                                              target:self
                                                 set:@selector(setPreferenceValue:specifier:)
                                                 get:@selector(readPreferenceValue:)
                                              detail:Nil
                                                cell:[PSTableCell cellTypeFromString:@""]
                                                edit:Nil];

        [spec setProperty:[WitcherSwitchCell class] forKey:@"cellClass"];
        [spec setProperty:@"Kill now playing app" forKey:@"title"];
        [spec setProperty:@"Music, video players, etc." forKey:@"subtitle"];
        [spec setProperty:@NO forKey:@"default"];
        [spec setProperty:@"killNPA" forKey:@"key"];
        [specifiers addObject:spec];

        _specifiers = [specifiers copy];

    }
    return _specifiers;
}

-(id)readPreferenceValue:(PSSpecifier *)specifier {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:WITCHER_PLIST_SETTINGS];
    if (!prefs[specifier.properties[@"key"]]) return specifier.properties[@"default"];
    return prefs[specifier.properties[@"key"]];
}


-(void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSMutableDictionary *prefs = [NSMutableDictionary dictionary];
    [prefs addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:WITCHER_PLIST_SETTINGS]];
    [prefs setObject:value forKey:specifier.properties[@"key"]];
    [prefs writeToFile:WITCHER_PLIST_SETTINGS atomically:YES];
	notify_post("dr.erast.witcherprefs/init");

    // CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("dr.erast.witcherprefs/init"), NULL, NULL, YES);
}

#pragma mark - UI
-(void)viewDidLoad {
    [super viewDidLoad];

    [self registerCustomFonts:nil];

    [self setupTitleView];
}

-(void)setupTitleView {
    [[self navigationItem] setTitleView: [UIView new]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];

    [[self titleLabel] setFont:[UIFont fontWithName:@"UbuntuSans-Bold" size:17]];
    [[self titleLabel] setText:@"1.0.1"];
    [[self titleLabel] setTextColor:[UIColor labelColor]];
    [[self titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[[self navigationItem] titleView] addSubview:[self titleLabel]];

    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
        [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
    ]];

}

-(void)setupWallpaperForTableView:(UITableView *)tableView {
    backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[WITCHER_PREFERENCES_BUNDLE_PATH stringByAppendingPathComponent:@"wallpaper.png"]]];
    [backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [backgroundImageView setFrame:[tableView bounds]];

    [tableView setSeparatorColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    
    [tableView setBackgroundView:backgroundImageView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self backgroundImageView]) {
        [self setupWallpaperForTableView:tableView];
    }

    return [super tableView:tableView cellForRowAtIndexPath:indexPath];

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

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleInsetGrouped;
}

@end

