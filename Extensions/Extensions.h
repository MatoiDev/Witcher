#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <rootless.h>

#define WITCHER_PLIST_SETTINGS ROOT_PATH_NS(@"/var/mobile/Library/Preferences/dr.erast.witcherprefs.plist")
#define WITCHER_PREFERENCES_BUNDLE_PATH ROOT_PATH_NS(@"/Library/PreferenceBundles/WitcherPreferences.bundle")

@interface UIImage (Icon)
/*
 @param format
    0 - 29x29
    1 - 40x40
    2 - 62x62
    3 - 42x42
    4 - 37x48
    5 - 37x48
    6 - 82x82
    7 - 62x62
    8 - 20x20
    9 - 37x48
    10 - 37x48
    11 - 122x122
    12 - 58x58
 */
+(UIImage *)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(CGFloat)arg3;
@end

@interface NSArray (Map)
-(NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block;
@end

@interface UIColor (HexStringConverter)
+(UIColor *)colorFromHexString:(NSString *)hexString;
@end

@interface UIView (parentViewController)
-(UIViewController *)parentViewController;
@end
