//
//  HeaderCell.h
//  WitcherPreferencesUI
//
//  Created by Matoi on 09.05.2024.
//

#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <UIKit/UIKit.h>

#import "../../../WitcherCustomFontsProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HeaderCell : PSTableCell <WitcherCustomFontsProtocol> {
    NSString *tweakName;
    NSString *tweakDescription;
    NSString *iconName;
}

@property(nonatomic, strong)UILabel *tweakNameLabel;
@property(nonatomic, strong)UILabel *descriptionLabel;
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UIStackView *verticalStackView;

@end

NS_ASSUME_NONNULL_END
