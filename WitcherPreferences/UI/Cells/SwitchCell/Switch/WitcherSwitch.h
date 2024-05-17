#import <UIKit/UIKit.h>
#import "../../../../../Extensions/Extensions.h"

@interface WitcherSwitch: UISwitch {
    CAGradientLayer *gradientLayer;
}

-(void)updateState;

@end