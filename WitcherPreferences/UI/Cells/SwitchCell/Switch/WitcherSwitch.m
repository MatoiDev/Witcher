#import "WitcherSwitch.h"

@implementation WitcherSwitch
-(instancetype)init {
    self = [super init];
    if (self) {
        [self setThumbTintColor:[UIColor whiteColor]];
        [self setOnTintColor:[UIColor clearColor]];
        [self setBackgroundColor: [UIColor clearColor]];
        
        gradientLayer = [self gradientWithHEXColors:@[@"#cadef3", @"#f5ccd4", @"#bea8ca"]];
        
        CALayer *maskLayer = [CALayer layer];
        [maskLayer setFrame:CGRectMake(0.0, 0.0, 0.0, self.bounds.size.height)];
        [maskLayer setBackgroundColor:[[UIColor whiteColor] CGColor]];
        [maskLayer setCornerRadius:self.bounds.size.height / 2];
        [maskLayer setMasksToBounds:YES];
        
        [gradientLayer setMask:maskLayer];
        
        [[self layer] setCornerRadius:16.0];
        [[self layer] setMasksToBounds:YES];
        [[self layer] insertSublayer:gradientLayer atIndex:0];
        
        [self addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    
    }
    return self;
}

-(CAGradientLayer *)gradientWithHEXColors:(NSArray<NSString *> *)colors {
    CAGradientLayer *layer = [CAGradientLayer layer];
    NSMutableArray *cgColors = [NSMutableArray array];

    for (NSString *hexString in colors) {
        [cgColors addObject:(id)[[self colorFromHexString:hexString] CGColor]];
    }
    
    [layer setColors:cgColors];
    [layer setFrame: [self bounds]];
    [layer setStartPoint: CGPointMake(0.0, 0.0)];
    [layer setEndPoint:CGPointMake(1.0, 1.0)];

    return layer;
}

-(void)updateState {
    _Bool isOn = [self isOn];
    
    CALayer *maskLayer = [CALayer layer];
    [maskLayer setFrame:CGRectMake(0.0, 0.0, isOn ? self.bounds.size.width : 0.0, self.bounds.size.height)];
    [maskLayer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    [maskLayer setCornerRadius:self.bounds.size.height/2];
    [maskLayer setMasksToBounds:YES];
    
    [UIView animateWithDuration:0.0 animations:^{
        [self->gradientLayer setMask:maskLayer];
    }];
}

-(void)setState:(id)_
{
    [self updateState];
}

-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end