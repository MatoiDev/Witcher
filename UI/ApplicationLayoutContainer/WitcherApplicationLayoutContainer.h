//
//  WitcherApplicationLayoutContainer.h
//  Witcher
//
//  Created by Matoi on 16.04.2024.
//

#import <UIKit/UIKit.h>
#import "../ApplicationLayoutStruct/WitcherApplicationLayoutStruct.h"

NS_ASSUME_NONNULL_BEGIN

@interface WitcherApplicationLayoutContainer : UIView {
    NSString* applicationName;
    NSString* applicationBundleID;
    UIColor* dropShadowColor;
    UIImage* snapshotImage;
    UIImage* applicationIconImage;
}

@property(nonatomic, strong)UIImageView *snapshotImageView;
@property(nonatomic, strong)UIImageView *applicationIconImageView;
@property(nonatomic, strong)UIView *dropShadowView;
@property(nonatomic, strong)UIView *bottomViewContainer;
@property(nonatomic, strong)UILabel *applicationNameLabel;
@property(nonatomic, strong)UILabel *applicationBundleIDLabel;
@property(nonatomic, nullable, strong)WitcherApplicationLayoutStruct *layoutStruct;

-(instancetype)initWithLayoutStruct:(WitcherApplicationLayoutStruct *)layoutStruct_t;
-(void)updateWithLayoutStruct:(WitcherApplicationLayoutStruct *_Nullable)layoutStruct_t;
-(void)updateShadowWithColor:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
