#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <UIKit/UIKit.h>

#import "../../../WitcherCustomFontsProtocol.h"
#import "Switch/WitcherSwitch.h"

@interface PSSpecifier (PrivateMethods)
-(void)performSetterWithValue:(id)value;
-(id)performGetter;
@end

@interface WitcherSwitchCell : PSTableCell <WitcherCustomFontsProtocol> {
    NSString *title;
    NSString *subtitle;
}

@property(nonatomic, strong)WitcherSwitch *controlSwitch;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *subtitleLabel;

@end

