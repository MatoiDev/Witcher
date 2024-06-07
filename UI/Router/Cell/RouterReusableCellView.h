//
//  RouterReusableCellView.h
//  Witcher
//
//  Created by Matoi on 17.04.2024.
//

#import <UIKit/UIKit.h>
#import "../../ApplicationLayoutStruct/WitcherApplicationLayoutStruct.h"

NS_ASSUME_NONNULL_BEGIN

@interface RouterReusableCellView : UIView {
    UIImpactFeedbackGenerator *staticCellImpactGenerator;
    UIImage *routerCellIcon;
    UIColor *routerCellTintColor;
    _Bool isStackStyle;
}

@property(nonatomic, strong)UIImageView *iconImageView;
@property(nonatomic, strong)WitcherApplicationLayoutStruct *layoutStruct;
@property(nonatomic, nullable, strong)CAShapeLayer *borderLayer;

@property(nonatomic, assign)NSUInteger applicationsCounter;
@property(nonatomic, nullable, strong)UILabel *applicationsCounterLabel;

-(instancetype)initWithLayoutStruct:(WitcherApplicationLayoutStruct *)layoutStruct_t tintColor:(UIColor *)color;
-(instancetype)initStaticCellWithTintColor:(UIColor *)tintColor;
-(void)updateColor:(UIColor *)tintColor;
-(void)updateWithLayoutStruct:(WitcherApplicationLayoutStruct *)layoutStruct_t tintColor:(UIColor *)color;
-(void)updateStaticCounterWithValue:(NSUInteger)arg;
-(void)setSelected;
-(void)setUnselected;

@end

NS_ASSUME_NONNULL_END
