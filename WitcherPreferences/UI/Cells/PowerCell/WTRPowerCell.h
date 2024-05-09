#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <UIKit/UIKit.h>

#import "Button/PowerButton.h"

#import "../../../WitcherCustomFontsProtocol.h"

@interface PSSpecifier (PrivateMethods)
-(void)performSetterWithValue:(id)value;
-(id)performGetter;
@end

@interface WTRPowerCell: PSTableCell <WitcherCustomFontsProtocol> {
   UIImpactFeedbackGenerator *impactFeedbackGenerator;
}

@property(nonatomic, strong)UILabel *cellTitle;
@property(nonatomic, strong)UILabel *cellSubtitle;
@property(nonatomic, strong)PowerButton *powerButton;

@end