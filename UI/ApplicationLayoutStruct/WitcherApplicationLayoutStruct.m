//
//  WitcherApplicationLayoutStruct.m
//  Witcher
//
//  Created by Matoi on 16.04.2024.
//

#import "WitcherApplicationLayoutStruct.h"

@implementation WitcherApplicationLayoutStruct

@synthesize snapshot = _snapshot;
@synthesize icon = _icon;
@synthesize appName = _appName;
@synthesize appBundleID = _appBundleID;

-(instancetype)initWithSnapshot:(UIImage *)snapshot
                           icon:(UIImage *)icon
                        appName:(NSString *)appName
                    appBundleID:(NSString *)appBundleID {
    self = [super init];
    if (self) {
        _snapshot = snapshot;
        _icon = icon;
        _appName = [appName copy];
        _appBundleID = [appBundleID copy];
    }
    return self;
}

@end
