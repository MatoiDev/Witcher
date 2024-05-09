//
//  AuthorCell.m
//
//  Created by Erast on 07.05.2024.
//

#import "AuthorCell.h"

@implementation AuthorCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier specifier:specifier];
    if (self) {
        projectURL = [[specifier properties] objectForKey:@"url"];
        iconName = [[specifier properties] objectForKey:@"icon"];
        
        profileURL = [projectURL stringByDeletingLastPathComponent];
        
        projectName = [[projectURL componentsSeparatedByString:@"/"] lastObject];
        authorName = [[profileURL componentsSeparatedByString:@"/"] lastObject];

        [self registerCustomFonts:nil];    
    }
    return self;
}

- (void)handleLeftTap {
    RLog(@"left view was tapped");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:profileURL] options:@{} completionHandler:nil];
}

- (void)handleRightTap {
    RLog(@"right view was tapped");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:projectURL] options:@{} completionHandler:nil];
}

-(void)didMoveToWindow {

    [super didMoveToWindow];

    UIView *cellView = [UIView new];
    

    UIButton *leftView = [[UIButton alloc] init];
    [leftView addTarget:self action:@selector(handleLeftTap) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightView = [[UIButton alloc] init];
    [rightView addTarget:self action:@selector(handleRightTap) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *authorAvatar = [UIImageView new];
    [self loadImageForImageView:authorAvatar url:[NSString stringWithFormat:@"https://unavatar.io/github/%@", authorName]];
    [[authorAvatar layer] setCornerRadius:18.0];
    [[authorAvatar layer] setMasksToBounds:YES];
    
    UIImageView *projectIcon = [UIImageView new];
    [projectIcon setImage:[UIImage imageWithContentsOfFile:[WITCHER_PREFERENCES_BUNDLE_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", iconName]]]];
    
    UILabel *authorNameLabel = [UILabel new];
    [authorNameLabel setText:authorName];
    [authorNameLabel setFont:[UIFont fontWithName:@"UbuntuSans-Medium" size:17.0]];
    [authorNameLabel setTextColor:[UIColor labelColor]];
    
    UILabel *projectNameLabel = [UILabel new];
    [projectNameLabel setText:@"Source code"];
    [projectNameLabel setFont:[UIFont fontWithName:@"UbuntuSans-Medium" size:17.0]];
    [projectNameLabel setTextColor:[UIColor labelColor]];
    
    UILabel *leftViewSubtitleLabel = [UILabel new];
    [leftViewSubtitleLabel setText:@"Developer's repo"];
    [leftViewSubtitleLabel setFont:[UIFont fontWithName:@"UbuntuSans-Medium" size:12.0]];
    [leftViewSubtitleLabel setTextColor:[UIColor secondaryLabelColor]];
    
    UILabel *rightCellSubtitleLabel = [UILabel new];
    [rightCellSubtitleLabel setText:@"Counting stars..."];
    [self fetchStarsForLabel:rightCellSubtitleLabel];
    
    [rightCellSubtitleLabel setFont:[UIFont fontWithName:@"UbuntuSans-Medium" size:12.0]];
    [rightCellSubtitleLabel setTextColor:[UIColor secondaryLabelColor]];
    
    UIView *separator = [UIView new];
    [separator setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    
    LOTAnimationView *githubLogoAnimationView = [LOTAnimationView animationWithFilePath:[WITCHER_PREFERENCES_BUNDLE_PATH stringByAppendingPathComponent:@"githubLogo.json"]];
    
    [githubLogoAnimationView setTintColor:[UIColor redColor]];
    [githubLogoAnimationView setContentMode:UIViewContentModeScaleAspectFit];
    [githubLogoAnimationView setLoopAnimation: NO];
    [githubLogoAnimationView play];
    
    _progressView = [[UIActivityIndicatorView alloc] init];
    
    [_progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_progressView setHidesWhenStopped:YES];
    [_progressView startAnimating];
    
    [[self contentView] addSubview:cellView];
    
    [cellView addSubview:leftView];
    [cellView addSubview:rightView];
    [cellView addSubview:separator];
    
    [leftView addSubview:authorAvatar];
    [leftView addSubview:authorNameLabel];
    [leftView addSubview:leftViewSubtitleLabel];
    [leftView addSubview:githubLogoAnimationView];
    
    [rightView addSubview:projectIcon];
    [rightView addSubview:projectNameLabel];
    [rightView addSubview:rightCellSubtitleLabel];
    
    [authorAvatar addSubview:_progressView];
    
    for (UIView * view in @[cellView, leftView, rightView, authorAvatar, projectIcon, authorNameLabel, projectNameLabel, leftViewSubtitleLabel, rightCellSubtitleLabel, separator, githubLogoAnimationView]) {
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
        
    [NSLayoutConstraint activateConstraints:@[
        // Cell View
        [[cellView topAnchor] constraintEqualToAnchor:[[self contentView] topAnchor]],
        [[cellView leadingAnchor] constraintEqualToAnchor:[[self contentView] leadingAnchor]],
        [[cellView trailingAnchor] constraintEqualToAnchor:[[self contentView] trailingAnchor]],
        [[cellView bottomAnchor] constraintEqualToAnchor:[[self contentView] bottomAnchor]],
        
        // Separator
        [[separator widthAnchor] constraintEqualToConstant:0.5],
        [[separator heightAnchor] constraintEqualToAnchor:[[self contentView] heightAnchor]],
        [[separator centerXAnchor] constraintEqualToAnchor:[[self contentView] centerXAnchor]],
        
        // Left View
        [[leftView topAnchor] constraintEqualToAnchor:[[self contentView] topAnchor]],
        [[leftView leadingAnchor] constraintEqualToAnchor:[[self contentView] leadingAnchor]],
        [[leftView trailingAnchor] constraintEqualToAnchor:[separator leadingAnchor]],
        [[leftView bottomAnchor] constraintEqualToAnchor:[[self contentView] bottomAnchor]],
        
        // Profile Avatar
        [[authorAvatar widthAnchor] constraintEqualToConstant:36],
        [[authorAvatar heightAnchor] constraintEqualToConstant:36],
        [[authorAvatar topAnchor] constraintEqualToAnchor:[leftView topAnchor] constant:12.0],
        [[authorAvatar bottomAnchor] constraintEqualToAnchor:[leftView bottomAnchor] constant:-12.0],
        [[authorAvatar leadingAnchor] constraintEqualToAnchor:[[self contentView] leadingAnchor] constant:12.0],
        
        // Author Name
        [[authorNameLabel leadingAnchor] constraintEqualToAnchor:[authorAvatar trailingAnchor] constant:8.0],
        [[authorNameLabel topAnchor] constraintEqualToAnchor:[authorAvatar topAnchor]],
        
        // Left View Subtitle
        [[leftViewSubtitleLabel leadingAnchor] constraintEqualToAnchor:[authorAvatar trailingAnchor] constant:8.0],
        [[leftViewSubtitleLabel bottomAnchor] constraintEqualToAnchor:[authorAvatar bottomAnchor]],
        [[leftViewSubtitleLabel trailingAnchor] constraintEqualToAnchor:[separator leadingAnchor] constant:-8.0],
        
        // Github Logo
        [[githubLogoAnimationView leadingAnchor] constraintEqualToAnchor:[authorNameLabel trailingAnchor] constant:-3.0],
        [[githubLogoAnimationView centerYAnchor] constraintEqualToAnchor:[authorNameLabel centerYAnchor]],
        [[githubLogoAnimationView widthAnchor] constraintEqualToConstant:36],
        [[githubLogoAnimationView heightAnchor] constraintEqualToConstant:36],
        
        // Right View
        [[rightView topAnchor] constraintEqualToAnchor:[[self contentView] topAnchor]],
        [[rightView leadingAnchor] constraintEqualToAnchor:[separator trailingAnchor]],
        [[rightView trailingAnchor] constraintEqualToAnchor:[[self contentView] trailingAnchor]],
        [[rightView bottomAnchor] constraintEqualToAnchor:[[self contentView] bottomAnchor]],
        
        // Project icon
        [[projectIcon leadingAnchor] constraintEqualToAnchor:[separator trailingAnchor] constant:12.0],
        [[projectIcon topAnchor] constraintEqualToAnchor:[rightView topAnchor] constant:12.0],
        [[projectIcon bottomAnchor] constraintEqualToAnchor:[rightView bottomAnchor] constant:-12.0],
        [[projectIcon widthAnchor] constraintEqualToConstant:36.0],
        [[projectIcon heightAnchor] constraintEqualToConstant:36.0],
        
        // Project name
        [[projectNameLabel leadingAnchor] constraintEqualToAnchor:[projectIcon trailingAnchor] constant:8.0],
        [[projectNameLabel topAnchor] constraintEqualToAnchor:[projectIcon topAnchor]],
        
        // Right View Subtitile
        [[rightCellSubtitleLabel leadingAnchor] constraintEqualToAnchor:[projectIcon trailingAnchor] constant:8.0],
        [[rightCellSubtitleLabel bottomAnchor] constraintEqualToAnchor:[projectIcon bottomAnchor]],
        [[rightCellSubtitleLabel trailingAnchor] constraintEqualToAnchor:[rightView trailingAnchor] constant:-8.0],
        
        // Progress Indicator
        [[_progressView centerYAnchor] constraintEqualToAnchor:[leftView centerYAnchor]],
        [[_progressView centerXAnchor] constraintEqualToAnchor:[authorAvatar centerXAnchor]]
        
    ]];
    
    [self setupBackground];
}

-(void)loadImageForImageView:(UIImageView *)imageView url:(NSString *)url {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        UIImage *avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView transitionWithView:imageView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [imageView setImage:avatar];
                if (avatar) {
                    [[self progressView] stopAnimating];
                }
            } completion:nil];
        });
    });
}

-(void)fetchStarsForLabel:(UILabel *)label {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        [GitHubStatsParser fetchStarCountForRepository:[NSString stringWithFormat:@"%@/%@", self->authorName, self->projectName] completionHandler:^(NSNumber *starCount, NSError *error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [label setText:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView transitionWithView:label duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        [label setText:[NSString stringWithFormat:@"Thanks for %@ ⭐", starCount]];
                    } completion:nil];
                    
                });
            }
        }];
    });
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
