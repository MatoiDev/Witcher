#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <notify.h>

#import "UI/Cells/AuthorCell/AuthorCell.h"
#import "UI/Cells/HeaderCell/HeaderCell.h"
#import "UI/Cells/PowerCell/WTRPowerCell.h"
#import "UI/Cells/SwitchCell/WitcherSwitchCell.h"

#import "WitcherCustomFontsProtocol.h"


@interface WTRRootListController : PSListController <WitcherCustomFontsProtocol>

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UIImageView *backgroundImageView;

@end
