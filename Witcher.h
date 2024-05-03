#import <QuartzCore/QuartzCore.h>
#import <SpringBoard/SpringBoard.h>

#import "Extensions/Extensions.h"

#import "UI/ApplicationLayoutStruct/WitcherApplicationLayoutStruct.h"
#import "UI/Router/RouterView.h"
#import "UI/ApplicationLayoutContainer/WitcherApplicationLayoutContainer.h"

#include <CoreFoundation/CoreFoundation.h>

@interface SBDeckSwitcherViewController: UIViewController
@end

@interface SBFluidSwitcherGestureManager
-(void)fluidSwitcherGestureTransaction:(id)arg1 didBeginGesture:(id)arg2;
-(void)fluidSwitcherGestureTransaction:(id)arg1 didUpdateGesture:(id)arg2;
-(void)fluidSwitcherGestureTransaction:(id)arg1 didEndGesture:(id)arg2;
@end

@interface SBMainSwitcherViewController : UIViewController
+(id)sharedInstance;
-(id)recentAppLayouts;
-(long long)sbActiveInterfaceOrientation;
-(BOOL)isMainSwitcherVisible;
-(void)_deleteAppLayoutsMatchingBundleIdentifier:(id)arg1;
-(void)_deleteAppLayout:(id)arg1 forReason:(long long)arg2;
@end

@interface SBDisplayItem: NSObject
-(id)bundleIdentifier;
@end

@interface SBFluidSwitcherSpaceTitleItem
-(NSString*)subtitleText;
-(NSString*)bundleIdentifier;
-(SBDisplayItem*)displayItem;
@end

@interface SBAppLayout: NSObject
@property (copy,readonly) NSString * description; 
-(id)allItems;
@end

@interface SBSwitcherSnapshotImageView: UIView
-(id)image;
@end

@interface SBSwitcherWallpaperPageContentView: UIView
@end

@interface SBAppSwitcherReusableSnapshotView: SBSwitcherWallpaperPageContentView
-(NSString *)description;
-(NSArray<SBSwitcherSnapshotImageView*>*)_allImageViews;
-(id)appLayout; // -> SBAppLayout
@end

@interface SBReusableSnapshotItemContainer : UIView
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
-(void)setAppLayout:(id)arg1;
-(void)setContentView:(id)arg1;
-(void)prepareForReuse;
-(void)conformsToProtocolSBFluidSwitcherItemContainerReusable;
-(void)_updateSnapshotViewWithAppLayout:(id)arg1;
-(id)_snapshotView; // -> SBAppSwitcherReusableSnapshotView
@end

@interface SBFluidSwitcherContentView: UIView
-(void)setPassesTouchesThrough:(BOOL)arg1;
@end

@interface SBFluidSwitcherViewController : UIViewController
@end

@interface SBAppSwitcherSettings
@property (assign) double spacingBetweenTrailingEdgeAndLabels;
@property (assign) double centerPoint;
@property (assign) long long switcherStyle;
-(long long)switcherStyle;
@end

@interface SBFTouchPassThroughView : UIView
@end

@interface SBApplication
-(UIImage *)imageForSnapshot:(id)arg1 interfaceOrientation:(long long)arg2;
-(NSString *)bundleIdentifier;
-(NSString *)displayName;
-(void)_didSuspend;
@end

@interface SpringBoard (SpotLight)
-(void)_revealSpotlight;
-(void)quitTopApplication:(id)arg1;
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2 ;
@end

@interface SBFluidSwitcherGesture : NSObject
-(NSString *)description;
-(id)gestureEvent;
@end

@interface SBGestureSwitcherModifierEvent
/*
@param phase
    1 - BEGAN
    2 - MOVE
    3 - END
*/
@property (assign,nonatomic) CGPoint locationInContainerView; 
@property (assign,nonatomic) unsigned long long phase; 

-(double)peakSpeed;
@end

@interface LSApplicationWorkspace : NSObject
+(id)defaultWorkspace;
-(BOOL)openApplicationWithBundleID:(NSString *)bundleID;
@end

@interface SBMediaController : NSObject
@property (nonatomic, weak,readonly) SBApplication * nowPlayingApplication;
+(id)sharedInstance;
@end

