//
//  WitcherApplicationLayoutContainer.m
//  Witcher
//
//  Created by Matoi on 16.04.2024.
//

#import "WitcherApplicationLayoutContainer.h"

@interface WitcherApplicationLayoutContainer (Private)
-(void)setupContainer;
-(void)setupSubviews;
-(void)activateConstraints;
@end

@implementation WitcherApplicationLayoutContainer

@synthesize snapshotImageView;
@synthesize applicationIconImageView;
@synthesize dropShadowView;
@synthesize bottomViewContainer;
@synthesize applicationNameLabel;
@synthesize applicationBundleIDLabel;
@synthesize layoutStruct;

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setupContainer];
    }
    return self;
}

-(instancetype)initWithLayoutStruct:(WitcherApplicationLayoutStruct *)layoutStruct_t {
    self = [super init];
    if (self) {
        layoutStruct = layoutStruct_t;
        applicationName = [layoutStruct_t appName];
        applicationBundleID = [layoutStruct_t appBundleID];
        snapshotImage = [layoutStruct_t snapshot];
        applicationIconImage = [layoutStruct_t icon];
        dropShadowColor = [UIColor redColor];
        
        [self setupContainer];
    }
    return self;
}

- (void)updateWithLayoutStruct:(WitcherApplicationLayoutStruct *_Nullable)layoutStruct_t {
  
    [self setLayoutStruct:layoutStruct_t];
    if (!layoutStruct_t) {
        [self setAlpha: 0];
        [UIView animateWithDuration:0.1 animations:^{
            [self setAlpha:0];
        }];
        return;
    }

    self->applicationName = [layoutStruct_t appName];
    self->applicationBundleID = [layoutStruct_t appBundleID];
    self->snapshotImage = [layoutStruct_t snapshot];
    self->applicationIconImage = [layoutStruct_t icon];
    
    [UIView animateWithDuration:0.1 animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        
        [[self snapshotImageView] setImage:self->snapshotImage];
        [[self applicationIconImageView] setImage:self->applicationIconImage];
        [[self applicationNameLabel] setText:self->applicationName];
        [[self applicationBundleIDLabel] setText:self->applicationBundleID];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self setAlpha:finished];
        }];
    }];
 
    
}

-(void)setupContainer {
    [self setupSubviews];
}

-(void)setupSubviews {
    bottomViewContainer = [[UIView alloc] init];
    [bottomViewContainer setBackgroundColor:[UIColor clearColor]];
    [self addSubview:bottomViewContainer];
    
    dropShadowView = [[UIView alloc] init];
    [dropShadowView setBackgroundColor:[UIColor lightGrayColor]];
    [[dropShadowView layer] setCornerRadius:15.0];
    [[dropShadowView layer] setMasksToBounds:NO];
    [[dropShadowView layer] setShadowOpacity:0.5];
    [[dropShadowView layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[dropShadowView layer] setShadowRadius:10.0];
    [self addSubview:dropShadowView];
    
    snapshotImageView = [[UIImageView alloc] init];
    [snapshotImageView setImage:snapshotImage];
    [[snapshotImageView layer] setCornerRadius:15.0];
    [snapshotImageView setContentMode:UIViewContentModeScaleAspectFill];
    [snapshotImageView setClipsToBounds:YES];
    [self addSubview:snapshotImageView];
    
    applicationIconImageView = [[UIImageView alloc] init];
    [applicationIconImageView setImage:applicationIconImage];
    [[applicationIconImageView layer] setCornerRadius:10.0];
    [bottomViewContainer addSubview:applicationIconImageView];
    
    applicationNameLabel = [[UILabel alloc] init];
    [applicationNameLabel setText:applicationName];
    [applicationNameLabel setFont: [UIFont systemFontOfSize:22.0]];
    [applicationNameLabel setTextColor:[UIColor labelColor]];
    [bottomViewContainer addSubview:applicationNameLabel];
    
    applicationBundleIDLabel = [[UILabel alloc] init];
    [applicationBundleIDLabel setText:applicationBundleID];
    [applicationBundleIDLabel setFont: [UIFont systemFontOfSize:16.0]];
    [applicationBundleIDLabel setTextColor:[UIColor secondaryLabelColor]];
    [bottomViewContainer addSubview:applicationBundleIDLabel];

    [self activateConstraints];
}

-(void)activateConstraints {
    for (UIView * view in @[dropShadowView, snapshotImageView, applicationIconImageView, bottomViewContainer, applicationNameLabel, applicationBundleIDLabel]) {
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    [NSLayoutConstraint activateConstraints:@[
        
      
        [[bottomViewContainer bottomAnchor] constraintEqualToAnchor:[self bottomAnchor] constant:-16.0],
        [[bottomViewContainer centerXAnchor] constraintEqualToAnchor:[self centerXAnchor]],
        [[bottomViewContainer trailingAnchor] constraintEqualToAnchor: [applicationBundleIDLabel trailingAnchor]],
        
        [[applicationIconImageView widthAnchor] constraintEqualToConstant:45],
        [[applicationIconImageView heightAnchor] constraintEqualToConstant:45],
        [[applicationIconImageView bottomAnchor] constraintEqualToAnchor: [bottomViewContainer bottomAnchor]],
        [[applicationIconImageView leadingAnchor] constraintEqualToAnchor: [bottomViewContainer leadingAnchor]],
        [[applicationIconImageView topAnchor] constraintEqualToAnchor: [bottomViewContainer topAnchor]],
        
        [[dropShadowView leadingAnchor] constraintEqualToAnchor: [snapshotImageView leadingAnchor]],
        [[dropShadowView trailingAnchor] constraintEqualToAnchor: [snapshotImageView trailingAnchor]],
        [[dropShadowView topAnchor] constraintEqualToAnchor: [snapshotImageView topAnchor]],
        [[dropShadowView bottomAnchor] constraintEqualToAnchor: [snapshotImageView bottomAnchor]],
        
        [[snapshotImageView topAnchor] constraintEqualToAnchor: [self topAnchor] constant: 16.0],
        [[snapshotImageView leadingAnchor] constraintEqualToAnchor: [self leadingAnchor] constant: 16.0],
        [[snapshotImageView trailingAnchor] constraintEqualToAnchor: [self trailingAnchor] constant: -16.0],
        [[snapshotImageView bottomAnchor] constraintEqualToAnchor: [bottomViewContainer topAnchor] constant:-24.0],
        
        [[applicationNameLabel topAnchor] constraintEqualToAnchor:[applicationIconImageView topAnchor]],
        [[applicationNameLabel leadingAnchor] constraintEqualToAnchor:[applicationIconImageView trailingAnchor] constant:8.0],
        
        
        [[applicationBundleIDLabel bottomAnchor] constraintEqualToAnchor:[applicationIconImageView bottomAnchor]],
        [[applicationBundleIDLabel leadingAnchor] constraintEqualToAnchor:[applicationIconImageView trailingAnchor] constant:8.0],
        
        
    ]];
}

- (void)updateShadowWithColor:(UIColor *)color {
    dropShadowColor = color;
    [[dropShadowView layer] setShadowColor:[dropShadowColor CGColor]];
}

@end
