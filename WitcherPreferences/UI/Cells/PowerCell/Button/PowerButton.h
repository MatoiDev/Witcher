//
//  PowerButton.h
//  WitcherPreferencesUI
//
//  Created by Matoi on 07.05.2024.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface PowerButton : UIButton

@property(nonatomic, strong)UIImageView *powerImageView;
@property(setter=setOn:, nonatomic, assign)_Bool isOn;

-(void)toggle;
@end

NS_ASSUME_NONNULL_END
