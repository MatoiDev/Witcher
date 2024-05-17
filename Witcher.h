#import <QuartzCore/QuartzCore.h>
#import <SpringBoard/SpringBoard.h>
#include <CoreFoundation/CoreFoundation.h>

#import <notify.h>

#import "Extensions/Extensions.h"

#import "UI/ApplicationLayoutStruct/WitcherApplicationLayoutStruct.h"
#import "UI/Router/RouterView.h"
#import "UI/ApplicationLayoutContainer/WitcherApplicationLayoutContainer.h"


/*
  HLOS - iOS versions that support these headers, according to https://developer.limneos.net/
*/


// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1, 10.2, 10.1.1, 9.3.3, 9.0
@interface SBDeckSwitcherViewController: UIViewController  
@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1
@interface SBFluidSwitcherGestureManager
-(void)fluidSwitcherGestureTransaction:(id)arg1 didBeginGesture:(id)arg2;
-(void)fluidSwitcherGestureTransaction:(id)arg1 didUpdateGesture:(id)arg2;
-(void)fluidSwitcherGestureTransaction:(id)arg1 didEndGesture:(id)arg2;
@end

// HLOS: 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1, 10.2, 10.1.1, 9.3.3, 9.0
// Doesn't support iOS 16.* 17.* etc
@interface SBMainSwitcherViewController : UIViewController
+(id)sharedInstance;
-(id)recentAppLayouts;
-(long long)sbActiveInterfaceOrientation;
-(BOOL)isMainSwitcherVisible;
-(void)_deleteAppLayoutsMatchingBundleIdentifier:(id)arg1;
-(void)_deleteAppLayout:(id)arg1 forReason:(long long)arg2;
@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1, 10.2, 10.1.1, 9.3.3, 9.0, 8.0
@interface SBDisplayItem: NSObject
-(id)bundleIdentifier;
@end

// HLOS: 17.1, 16.3, 15.2.1
// Doesn't support ios 14.* && ios 13.*
@interface SBFluidSwitcherSpaceTitleItem
-(NSString*)subtitleText;
-(NSString*)bundleIdentifier;
-(SBDisplayItem*)displayItem;
@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1
@interface SBAppLayout: NSObject
@property (copy,readonly) NSString * description; 
-(id)allItems;
@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1, 10.2, 10.1.1, 9.3.3, 9.0
@interface SBSwitcherSnapshotImageView: UIView
-(id)image;
@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1, 10.2, 10.1.1, 9.3.3, 9.0
@interface SBSwitcherWallpaperPageContentView: UIView
@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1
@interface SBAppSwitcherReusableSnapshotView: SBSwitcherWallpaperPageContentView
-(NSString *)description;
-(NSArray<SBSwitcherSnapshotImageView*>*)_allImageViews;
-(id)appLayout; // -> SBAppLayout
@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1
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

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3
@interface SBFluidSwitcherContentView: UIView
-(void)setPassesTouchesThrough:(BOOL)arg1;
@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1
@interface SBFluidSwitcherViewController : UIViewController
@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1, 10.2, 10.1.1, 9.3.3, 9.0, 8.0
@interface SBAppSwitcherSettings
@property (assign) double spacingBetweenTrailingEdgeAndLabels;
@property (assign) double centerPoint;
@property (assign) long long switcherStyle;
-(long long)switcherStyle;
@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1, 10.2, 10.1.1
@interface SBFTouchPassThroughView : UIView
@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1, 10.2, 10.1.1, 9.3.3, 9.0, 8.0, 7.0, 5.0, 4.0, 3.0
@interface SBApplication
-(UIImage *)imageForSnapshot:(id)arg1 interfaceOrientation:(long long)arg2;
-(NSString *)bundleIdentifier;
-(NSString *)displayName;
-(void)_didSuspend;
@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1, 10.2, 10.1.1, 9.3.3, 9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0
@interface SpringBoard (SpotLight)
-(void)_revealSpotlight;
-(void)quitTopApplication:(id)arg1;
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2 ;
@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1
@interface SBFluidSwitcherGesture : NSObject
-(NSString *)description;
-(id)gestureEvent;
@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3
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

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1
@interface LSApplicationWorkspace : NSObject
+(id)defaultWorkspace;
-(BOOL)openApplicationWithBundleID:(NSString *)bundleID;
@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1, 10.2, 10.1.1, 9.3.3, 9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0
@interface SBMediaController : NSObject
@property (nonatomic, weak,readonly) SBApplication * nowPlayingApplication;
+(id)sharedInstance;
@end

