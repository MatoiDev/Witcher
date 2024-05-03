//
//  ApplicationLayoutStruct.h
//  Witcher
//
//  Created by Matoi on 16.04.2024.
//

#import <UIKit/UIKit.h>

@protocol ApplicationLayoutStruct <NSObject>

@property(nonatomic, strong) UIImage *snapshot;
@property(nonatomic, strong) UIImage *icon;
@property(nonatomic, copy) NSString *appName;
@property(nonatomic, copy) NSString *appBundleID;

- (instancetype)initWithSnapshot:(UIImage *)snapshot
                            icon:(UIImage *)icon
                         appName:(NSString *)appName
                     appBundleID:(NSString *)appBundleID;

@end

