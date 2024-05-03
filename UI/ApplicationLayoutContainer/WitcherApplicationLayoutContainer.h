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

@property(nonatomic, retain)UIImageView *snapshotImageView;
@property(nonatomic, retain)UIImageView *applicationIconImageView;
@property(nonatomic, retain)UIView *dropShadowView;
@property(nonatomic, retain)UIView *bottomViewContainer;
@property(nonatomic, retain)UILabel *applicationNameLabel;
@property(nonatomic, retain)UILabel *applicationBundleIDLabel;
@property(nonatomic, nullable, retain)WitcherApplicationLayoutStruct *layoutStruct;

-(instancetype)initWithLayoutStruct:(WitcherApplicationLayoutStruct *)layoutStruct_t;
-(void)updateWithLayoutStruct:(WitcherApplicationLayoutStruct *_Nullable)layoutStruct_t;
-(void)updateShadowWithColor:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
