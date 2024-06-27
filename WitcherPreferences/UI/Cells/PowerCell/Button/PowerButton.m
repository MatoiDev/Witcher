//
//  PowerButton.m
//  WitcherPreferencesUI
//
//  Created by Matoi on 07.05.2024.
//

#import "PowerButton.h"

@implementation PowerButton

@synthesize powerImageView;

-(instancetype)init {
    self = [super init];
    if (self) {
        
        UIImage *tintedImage = [[UIImage systemImageNamed:@"power"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [self setPowerImageView:[[UIImageView alloc] initWithImage:tintedImage]];
        
        [self setBackgroundColor:[[UIColor alloc] initWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            switch (traitCollection.userInterfaceStyle) {
                case UIUserInterfaceStyleDark:
                    return [UIColor darkGrayColor];
                default:
                    return [UIColor whiteColor];
            }
        }]];
        
        [[self layer] setCornerRadius:20];
        [[self layer] setMasksToBounds:YES];
        

        [[powerImageView layer] setShadowOffset:CGSizeMake(0, 0)];
        [[powerImageView layer] setShadowOpacity:0.9];
        [[powerImageView layer] setShadowRadius:5.0];

        
        [self addSubview:powerImageView];
        [self setupConstraints];
    
    }
    return self;
}

-(void)setTintColor:(UIColor *)tintColor {
    [super setTintColor: tintColor];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.1 animations:^{
            [[self powerImageView] setTintColor:tintColor];
            [[[self powerImageView] layer] setShadowColor:[tintColor CGColor]];
        }];
    });
}

-(void)toggle {
    self.isOn = !self.isOn;
    
}

-(void)setOn:(_Bool)isOn {
    _isOn = isOn;
   [self setTintColor: (isOn ? [UIColor greenColor] : [UIColor redColor])];
}


-(void)setupConstraints {
    [powerImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [NSLayoutConstraint activateConstraints:@[
        [[powerImageView widthAnchor] constraintEqualToConstant:24.0],
        [[powerImageView heightAnchor] constraintEqualToConstant:24.0],
        [[powerImageView centerXAnchor] constraintEqualToAnchor:[self centerXAnchor]],
        [[powerImageView centerYAnchor] constraintEqualToAnchor:[self centerYAnchor]]
    ]];
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        [self setTintColor:[UIColor grayColor]];
    }
}



@end
