#import "Witcher.h"


#pragma mark - Views 
RouterView *router = nil;
WitcherApplicationLayoutContainer *container = nil;
UIView * sbfTouchPassThroughTransitionView = nil; // This magical view will contain the Witcher
UIVisualEffectView *witcherBackgroundBlurView = nil;
UIBlurEffect * witcherBackgroundBlurViewEffect = nil;

#pragma mark - Controllers
SBMainSwitcherViewController *mainAppSwitcherVC;

#pragma mark - Generators
UIImpactFeedbackGenerator *impactFeedbackGenerator = nil;
UIImpactFeedbackGenerator *heavyImpactFeedbackGenerator = nil;

#pragma mark - Data
NSMutableDictionary<NSString *, WitcherApplicationLayoutStruct *> *mutableReusableContainersData = nil;
NSMutableArray<WitcherApplicationLayoutStruct *> *sourceApplications = nil;

NSArray<SBAppLayout *> *appLayouts = nil;

#pragma mark - Other
_Bool witcherViewIsInitialized = NO;
_Bool handleRouterGestures = NO; // In essence, this is just a kind of crutch for `userInteractionEnabled` property for router
_Bool routerViewIsPresented = NO;
int applicationDidFinishLaunching;

#pragma mark - Preferences
NSUserDefaults *prefs;

_Bool isEnabled;
_Bool hardwareButtonMode;
_Bool killNowPlayingApplication;

static UIColor* colorFromHex(NSString *hexString, BOOL useAlpha);
static void updateSettings();

%hook SBMainSwitcherViewController

%new
-(void)addSBMainSwitcherObserers {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(performSBMainSwitcherViewControllerNotification:) 
											     name:@"UpdateAppLayouts"
											   object:nil
	];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(performSBMainSwitcherViewControllerNotification:) 
											     name:@"ReleaseFrontMostApplication"
											   object:nil
	];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(performSBMainSwitcherViewControllerNotification:) 
											     name:@"OpenRecentApplication"
											   object:nil
	];
}

%new
-(void)performSBMainSwitcherViewControllerNotification:(NSNotification *) notification {
	if (witcherViewIsInitialized) {
		if ([[notification name] isEqualToString: @"UpdateAppLayouts"]) { 
		 	[self performSelector: @selector(logBundles)]; 
		}
		else if ([[notification name] isEqualToString: @"ReleaseFrontMostApplication"]) {
			SBApplication *frontApp = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];

			if (!heavyImpactFeedbackGenerator) { 
				heavyImpactFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
				[heavyImpactFeedbackGenerator prepare];
			}

			[heavyImpactFeedbackGenerator impactOccurred];

			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[UIView animateWithDuration:0.5
									  delay:0
					 usingSpringWithDamping:0.7 
					  initialSpringVelocity:0.2 
					        		options:UIViewAnimationOptionCurveEaseInOut
								 animations:^{
												if (!frontApp) {
													NSArray<SBAppLayout *> *recentAppLayouts = [self performSelector:@selector(getApps)];
													for (SBAppLayout *appLayout in recentAppLayouts) {
														[self performSelector:@selector(removeAppLayout:) withObject:appLayout];
													}
												} else {
													[self performSelector:@selector(removeFrontMostApplication:) withObject:frontApp];
												}
								 }
								 completion:nil];
			});

		}
		else if ([[notification name] isEqualToString: @"OpenRecentApplication"]) {
			SBApplication *frontApp = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
			[self performSelector: @selector(logBundles)]; // Update appLayouts

			if (frontApp) { // If some applications is running
				NSString *lastAppBundleId = [self performSelector:@selector(getBundleIDFromAppLayout:) withObject:[appLayouts firstObject]];
				NSString *frontAppBundleId = [frontApp bundleIdentifier];
				if (lastAppBundleId && [frontAppBundleId isEqualToString:lastAppBundleId]) {
					NSString *bundleIdentifier = [self performSelector:@selector(getBundleIDFromAppLayout:) withObject:[appLayouts objectAtIndex: 1]];
					[(SpringBoard *)[UIApplication sharedApplication] launchApplicationWithIdentifier:bundleIdentifier suspended:NO];
				} else if (lastAppBundleId) {
					[(SpringBoard *)[UIApplication sharedApplication] launchApplicationWithIdentifier:lastAppBundleId suspended:NO];
				}
			} else if ([appLayouts firstObject]) {
				NSString *bundleIdentifier = [self performSelector:@selector(getBundleIDFromAppLayout:) withObject:[appLayouts firstObject]];
				[(SpringBoard *)[UIApplication sharedApplication] launchApplicationWithIdentifier:bundleIdentifier suspended:NO];
			}

		}
	}
}

-(void)viewDidLoad {
	%orig;
	mainAppSwitcherVC = self;

	[self performSelector: @selector(addSBMainSwitcherObserers)];

	for (SBAppLayout *appLayout in [self performSelector:@selector(getApps)]) {
		[self performSelector:@selector(removeAppLayout:) withObject:appLayout];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    %orig(animated);
    [self performSelector:@selector(logBundles)];
}

-(void)_deleteAppLayoutsMatchingBundleIdentifier:(id)arg1 {
	if (!mutableReusableContainersData) { mutableReusableContainersData =  [[NSMutableDictionary<NSString *, WitcherApplicationLayoutStruct *> alloc] init]; }
	[mutableReusableContainersData removeObjectForKey:arg1];

	// CAUSE OF CRASH
	// ----------------------------------------------------------------------------------------------------------------
	// if (sbfTouchPassThroughTransitionView) {
	// 	SBApplication *frontApp = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
	// 	[sbfTouchPassThroughTransitionView performSelector:@selector(updateRouterWithFrontMostApplications:) withObject:frontApp];
	// }
	// ----------------------------------------------------------------------------------------------------------------
	%orig;
}

%new
-(NSArray<SBAppLayout *> *)getApps {
    return (NSArray<SBAppLayout *> *)[self recentAppLayouts] ?: @[];
}

%new
-(void)logBundles {
    NSArray<SBAppLayout *> *layouts = [self performSelector:@selector(getApps)];
	appLayouts = layouts;
	__unused int counter = 1;
    for (SBAppLayout *appLayout in layouts) {
		NSString *bundleId = [self performSelector:@selector(getBundleIDFromAppLayout:) withObject:appLayout];
        if (bundleId) {
			 counter += 1;
        }
    }
}

%new
-(void)removeAppLayout:(SBAppLayout *_Nullable)item {	
	if (!item) { return; }
	NSString *itemBundleID = [self performSelector:@selector(getBundleIDFromAppLayout:) withObject:item];
	if (itemBundleID) {
		NSString *nowPlayingID = [[[%c(SBMediaController) sharedInstance] nowPlayingApplication] bundleIdentifier];

		if (!killNowPlayingApplication && [itemBundleID isEqualToString: nowPlayingID]) return;

		if (@available(iOS 14.0, *)) {
			[self _deleteAppLayoutsMatchingBundleIdentifier:itemBundleID];
		} else {
			[self _deleteAppLayout:item forReason: 1];
		}
		
	}
}

%new
-(void)removeFrontMostApplication:(SBApplication *)application {
	NSString *itemBundleID = [application bundleIdentifier];
	if (itemBundleID) {
		NSString *nowPlayingID = [[[%c(SBMediaController) sharedInstance] nowPlayingApplication] bundleIdentifier];

		if (!killNowPlayingApplication && [itemBundleID isEqualToString: nowPlayingID]) return;

		if (@available(iOS 14.0, *)) {
			[self _deleteAppLayoutsMatchingBundleIdentifier:itemBundleID];
		}
	}
}

%new
-(NSString *_Nullable)getBundleIDFromAppLayout:(SBAppLayout *_Nullable)appLayout {
	if (!appLayout) { return nil; }
	NSArray<SBDisplayItem *> *displayItems = [appLayout allItems];
    if ([displayItems firstObject]) {
        return [[displayItems firstObject] bundleIdentifier];
    }
	return nil;
}

%end

// The App starts here !
%hook SBFTouchPassThroughView

%new
-(void)addSBSwitcherObserers {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(performSBSwitcherAppSuggestionsContentViewNotification:) 
											     name:@"ShowWitcherView"
											   object:nil
	];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(performSBSwitcherAppSuggestionsContentViewNotification:) 
											     name:@"HideWitcherView"
											   object:nil
	];
}

-(void)didMoveToWindow {
	[self performSelector:@selector(setupSubviews)];
	%orig;
}

%new
-(void)setupSubviews {
		if (!sbfTouchPassThroughTransitionView && [[self parentViewController] isKindOfClass: %c(SBDeckSwitcherViewController)] && self.frame.size.width > 0.0 && self.frame.size.height > 0.0) {
		sbfTouchPassThroughTransitionView = [[self subviews] lastObject];
		if (!witcherViewIsInitialized) {
			NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:WITCHER_PLIST_SETTINGS];
			[self performSelector:@selector(addSBSwitcherObserers)];

			impactFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
			[impactFeedbackGenerator prepare];
			
			UIBlurEffect *witcherBackgroundBlurViewEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
			witcherBackgroundBlurView = [[UIVisualEffectView alloc] initWithEffect:witcherBackgroundBlurViewEffect];

			UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
			router = [[RouterView alloc] initWithBlurEffect:blurEffect backgroundColor:colorFromHex(prefs[@"mainTintColor"] ? prefs[@"mainTintColor"] : @"FFFFFF", YES)];
			container = [[WitcherApplicationLayoutContainer alloc] init];
			
			__weak typeof(self) weakSelf = self;
			[router setLayoutUpdateBlock:^(WitcherApplicationLayoutStruct *_Nullable layoutStruct) {
				typeof(self) strongSelf = weakSelf;
				if (strongSelf) {
					[strongSelf performSelector:@selector(updateLayoutContainerWithStruct:) withObject:layoutStruct];
				}
			}];
			
			[self addSubview: witcherBackgroundBlurView];
			[self addSubview:router];
			[self addSubview:container];
			
			[self performSelector:@selector(configureUI)];

			updateSettings(); // load router UI

			witcherViewIsInitialized = YES; // Now it is initialised
			
		}	

	}
}

%new
-(void)configureUI {
    [router setAlpha:0];
	[witcherBackgroundBlurView setAlpha: 0];

	[container updateWithLayoutStruct:nil];
	[router updateCellsWithNewApplications:@[] includingFrontMostApplication:false];

    [self performSelector:@selector(setupConstraints)];
}

%new
-(void)setupConstraints {
    [router setTranslatesAutoresizingMaskIntoConstraints:NO];
    [container setTranslatesAutoresizingMaskIntoConstraints:NO];
	[witcherBackgroundBlurView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [NSLayoutConstraint activateConstraints:@[
        [[router bottomAnchor] constraintEqualToAnchor:[self bottomAnchor] constant:90.0],
        [[router centerXAnchor] constraintEqualToAnchor:[self centerXAnchor]],
        [[router widthAnchor] constraintEqualToConstant: 300.0],
        [[router heightAnchor] constraintEqualToConstant: 300.0],
        
        [[container bottomAnchor] constraintEqualToAnchor: [router topAnchor] constant: -32.0],
        [[container leadingAnchor] constraintEqualToAnchor: [self leadingAnchor] constant: 16.0],
        [[container topAnchor] constraintEqualToAnchor: [[self safeAreaLayoutGuide] topAnchor] constant: 16.0],
        [[container trailingAnchor] constraintEqualToAnchor: [self trailingAnchor] constant: -16.0],

		[[witcherBackgroundBlurView topAnchor] constraintEqualToAnchor: [self topAnchor]],
		[[witcherBackgroundBlurView leadingAnchor] constraintEqualToAnchor: [self leadingAnchor]],
		[[witcherBackgroundBlurView trailingAnchor] constraintEqualToAnchor: [self trailingAnchor]],
		[[witcherBackgroundBlurView bottomAnchor] constraintEqualToAnchor: [self bottomAnchor]]

    ]];
}

%new
-(void)showWitcherView {
	if (!isEnabled) { return; }
	SBApplication *frontApp = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
	// NOTE: This message also update data
	__unused WitcherApplicationLayoutStruct *applicationStruct = [self performSelector:@selector(getPackedLayoutStructForApplication:) withObject:frontApp];

	if (!isEnabled) { return; }
	[self performSelector:@selector(updateRouterWithFrontMostApplications:) withObject:frontApp];

	handleRouterGestures = NO;
	[container updateWithLayoutStruct:nil]; // Clean up

	if(mainAppSwitcherVC.sbActiveInterfaceOrientation==1) { // If phone in portraitMode
		if(self.window != nil){
			[router setTransform: CGAffineTransformMakeScale(0, 0)];

			[UIView animateWithDuration: 0.7
								delay: 0.2
				usingSpringWithDamping: 0.6
				initialSpringVelocity: 1
								options: UIViewAnimationOptionCurveEaseIn
							animations:^{
				[router setTransform: CGAffineTransformMakeScale(1, 1)];
				[router setAlpha: 1.0];
				[container setAlpha: 1.0];
				[witcherBackgroundBlurView setAlpha:0.7];
				}
							completion:^(BOOL finished) { 
					handleRouterGestures = YES;
					routerViewIsPresented = YES;
				}
			];
		} 
	}
}

%new
-(void)HideWitcherView {
	    [UIView animateWithDuration: 0.7
                          delay: 0.2
         usingSpringWithDamping: 0.6
          initialSpringVelocity: 1
                        options: UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        [router setTransform: CGAffineTransformMakeScale(0, 0)];
        [router setAlpha:0.0];
		[container setAlpha:0.0];
		[witcherBackgroundBlurView setAlpha:0.0];
        }
                     completion:^(BOOL finished) { 
						[container updateWithLayoutStruct:nil]; // Clean up
						handleRouterGestures = NO;
						routerViewIsPresented = NO;
		}
    ];
}

%new
-(void)updateRouterWithFrontMostApplications:(SBApplication *)application {
	if (!appLayouts) { return; }

	NSMutableArray<WitcherApplicationLayoutStruct *> *layoutStructs = [[NSMutableArray<WitcherApplicationLayoutStruct *> alloc] init];
	NSString *frontMostBundleId = [application bundleIdentifier];

	for (SBAppLayout *appLayout in appLayouts) {
        NSArray<SBDisplayItem *> *displayItems = [appLayout allItems];
        if (displayItems.count > 0) {
            SBDisplayItem *item = [displayItems firstObject];
            NSString *bundleId = [item bundleIdentifier];
            if (bundleId && ![bundleId isEqualToString:frontMostBundleId]) {
				WitcherApplicationLayoutStruct *_struct = [mutableReusableContainersData objectForKey: bundleId];
				if (_struct) { [layoutStructs addObject: _struct]; }
            }
        }
    }

	sourceApplications = layoutStructs;
	[router updateCellsWithNewApplications:layoutStructs includingFrontMostApplication:application != nil];
}

%new
-(UIImage *)screenshot {
	CGSize size = [[UIScreen mainScreen] bounds].size;
	UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
	CGRect rec = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
	[self drawViewHierarchyInRect:rec afterScreenUpdates:YES];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

%new
-(void)updateLayoutContainerWithStruct:(WitcherApplicationLayoutStruct *_Nullable)layoutStruct {
    if ([container layoutStruct] != layoutStruct) {
        if (![container layoutStruct]) {
            [impactFeedbackGenerator impactOccurred];
        }
        [container updateWithLayoutStruct:layoutStruct];
    }
	if (!layoutStruct) { [container setAlpha: 0.0]; }
}

%new
-(WitcherApplicationLayoutStruct *_Nullable)getPackedLayoutStructForApplication:(SBApplication *)application {
	NSString *bundleID = [application bundleIdentifier];

	if (!bundleID) { return nil; }

	NSString *applicationName = [application displayName];
	UIImage *snapshot = [self performSelector:@selector(screenshot)];
	UIImage *icon = [UIImage _applicationIconImageForBundleIdentifier:bundleID format:12 scale:[UIScreen mainScreen].scale];

	WitcherApplicationLayoutStruct *layoutStruct = [[WitcherApplicationLayoutStruct alloc] initWithSnapshot:snapshot 
																									   icon:icon
																									appName:applicationName
																								appBundleID:bundleID
	];

	if (!mutableReusableContainersData) { mutableReusableContainersData = [[NSMutableDictionary<NSString *, WitcherApplicationLayoutStruct *> alloc] init]; }

	[mutableReusableContainersData setObject:layoutStruct forKey:bundleID];

	return layoutStruct;
}

%new
-(void)performSBSwitcherAppSuggestionsContentViewNotification:(NSNotification *) notification {
	if (witcherViewIsInitialized) {
		if ([[notification name] isEqualToString: @"ShowWitcherView"]) { [self performSelector: @selector(showWitcherView)]; }
		if ([[notification name] isEqualToString: @"HideWitcherView"]) { [self performSelector: @selector(HideWitcherView)]; }
	}
}

%end


%hook SBFluidSwitcherGestureManager

// %new 
// -(void)handleGestureOnRouterView:(SBFluidSwitcherGesture *_Nullable)gesture {
// 	if (router && [router alpha] > 0 && gesture) {
// 		CGPoint gesturePosition = [[gesture gestureEvent] locationInContainerView];
// 		unsigned long long gesturePhase = [[gesture gestureEvent] phase];
// 		[router handleGestureWithPosition:gesturePosition phase:gesturePhase interactionEnabled:handleRouterGestures];
// 	}
// }

-(void)fluidSwitcherGestureTransaction:(id)arg1 didBeginGesture:(id)arg2 {
	%orig;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAppLayouts" object:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ShowWitcherView" object:self];

	if (!isEnabled) { return; }

	if (router && [router alpha] > 0 && arg2) {
		CGPoint gesturePosition = [[arg2 gestureEvent] locationInContainerView];
		unsigned long long gesturePhase = [[arg2 gestureEvent] phase];
		[router handleGestureWithPosition:gesturePosition phase:gesturePhase interactionEnabled:handleRouterGestures];
	}
	

}

-(void)fluidSwitcherGestureTransaction:(id)arg1 didUpdateGesture:(id)arg2 { 

	if (!isEnabled) { %orig; return; }
	double speed = [[arg2 gestureEvent] peakSpeed];
	
	if ((speed < 2000 && router && [router alpha] > 0 && arg2) || routerViewIsPresented) {
		CGPoint gesturePosition = [[arg2 gestureEvent] locationInContainerView];
		unsigned long long gesturePhase = [[arg2 gestureEvent] phase];
		[router handleGestureWithPosition:gesturePosition phase:gesturePhase interactionEnabled:handleRouterGestures];
	} else if (!routerViewIsPresented) {
		handleRouterGestures = NO;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"HideWitcherView" object:self];
		%orig;
	}
	return; 
} // To avoid scaling while grabbing

-(void)fluidSwitcherGestureTransaction:(id)arg1 didEndGesture:(id)arg2 {
	%orig;	
	if (!isEnabled) { return; }
	if (router && [router alpha] > 0 && arg2) {
		CGPoint gesturePosition = [[arg2 gestureEvent] locationInContainerView];
		unsigned long long gesturePhase = [[arg2 gestureEvent] phase];
		[router handleGestureWithPosition:gesturePosition phase:gesturePhase interactionEnabled:handleRouterGestures];
	}

	[[NSNotificationCenter defaultCenter] postNotificationName:@"HideWitcherView" object:self];
}

%end


%hook SBFluidSwitcherSpaceTitleItem
-(NSString*)subtitleText {
	return (isEnabled ? [[self displayItem] bundleIdentifier] : %orig);
}
%end

%hook MTLumaDodgePillSettings
-(void)setHeight:(double)arg1 {
	if (hardwareButtonMode) { arg1 = 0; }
	%orig;
}

- (void)setMinWidth:(double)arg1 {
	if (hardwareButtonMode) { arg1 = 0; }
	%orig;
}
%end


%hook CSQuickActionsViewController
+ (BOOL)deviceSupportsButtons { return hardwareButtonMode ? NO : %orig; }
%end


%hook UIKeyboardImpl
+(UIEdgeInsets)deviceSpecificPaddingForInterfaceOrientation:(NSInteger)orientation inputMode:(id)mode {
    UIEdgeInsets orig = %orig;
	if (hardwareButtonMode) { orig.bottom = 0; }
    return orig;
}
%end


%hook BSPlatform
- (NSInteger)homeButtonType {
		return hardwareButtonMode ? 2 : %orig;
}
%end

%hook SBLockHardwareButtonActions
- (id)initWithHomeButtonType:(long long)arg1 proximitySensorManager:(id)arg2 {
	return %orig((hardwareButtonMode ? 1 : arg1), arg2);
}
%end

%hook SBHomeHardwareButtonActions
- (id)initWitHomeButtonType:(long long)arg1 {
	return (hardwareButtonMode ? %orig(1) : %orig);
}
%end

%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application {
	if (hardwareButtonMode) { applicationDidFinishLaunching = 2; } 
    %orig;
}
%end

%hook SBPressGestureRecognizer
- (void)setAllowedPressTypes:(NSArray *)arg1 {
	if (hardwareButtonMode) {
		NSArray * lockHome = @[@104, @101];
		NSArray * lockVol = @[@104, @102, @103];
		if ([arg1 isEqual:lockVol] && applicationDidFinishLaunching == 2) {
			%orig(lockHome);
			applicationDidFinishLaunching--;
			return;
		}
	}
    %orig;
}
%end

%hook SBClickGestureRecognizer
- (void)addShortcutWithPressTypes:(id)arg1 {
    if (hardwareButtonMode && applicationDidFinishLaunching == 1) {
        applicationDidFinishLaunching--;
        return;
    }
    %orig;
}
%end

%hook SBHomeHardwareButton
- (id)initWithScreenshotGestureRecognizer:(id)arg1 homeButtonType:(long long)arg2 {
	if (hardwareButtonMode) { return %orig(arg1, 1); }
	return %orig;
    
}
%end

%hook CCUIModularControlCenterOverlayViewController
- (void)setOverlayStatusBarHidden:(BOOL)arg1 {
	if (hardwareButtonMode) { return; }
    %orig;
}
%end

%hook CCUIOverlayStatusBarPresentationProvider
- (void)_addHeaderContentTransformAnimationToBatch:(id)arg1 transitionState:(id)arg2 {
    if (hardwareButtonMode) { return; }
    %orig;
}
%end

static UIColor* colorFromHex(NSString *hexString, BOOL useAlpha) {
	hexString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];

	if([hexString containsString:@":"] || hexString.length == 6) {
		NSArray *colorComponents = [hexString componentsSeparatedByString:@":"];
		CGFloat alpha = (colorComponents.count == 2) ? [[colorComponents lastObject] floatValue] / 100 : 1.0;
		hexString = [NSString stringWithFormat:@"%@%02X", [colorComponents firstObject], (int)(alpha * 255.0)];
	}

	unsigned int hex = 0;
	[[NSScanner scannerWithString:hexString] scanHexInt:&hex];

	CGFloat r = ((hex & 0xFF000000) >> 24) / 255.0;
	CGFloat g = ((hex & 0x00FF0000) >> 16) / 255.0;
	CGFloat b = ((hex & 0x0000FF00) >> 8) / 255.0;
	CGFloat a = (useAlpha) ? ((hex & 0x000000FF) >> 0) / 255.0 : 0xFF;

	return [UIColor colorWithRed:r green:g blue:b alpha:a];
}


static void updateSettings() {
	NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:WITCHER_PLIST_SETTINGS];
	isEnabled = prefs[@"isEnabled"] ? [prefs[@"isEnabled"] boolValue] : YES;
	hardwareButtonMode = prefs[@"hardwareButtonMode"] ? [prefs[@"hardwareButtonMode"] boolValue] : NO;
	killNowPlayingApplication = prefs[@"killNPA"] ? [prefs[@"killNPA"] boolValue] : NO;

	if (router) {
		[router updateMainColor:colorFromHex(prefs[@"mainTintColor"] ? prefs[@"mainTintColor"] : @"FFFFFF", YES)];
		[router updateCellsWithColor:colorFromHex(prefs[@"cellsTintColor"] ? prefs[@"cellsTintColor"] : @"FFFFFF", YES)];
		[router updateActionButtonsWithState:!(prefs[@"actionButtons"] ? [prefs[@"actionButtons"] boolValue] : YES)];
	}
}


static __attribute__((constructor)) void init() {
	
    
    // CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL,
  	// 							 (CFNotificationCallback)loadPrefs, CFSTR("dr.erast.witcherprefs/init"), NULL,
  	// 							  CFNotificationSuspensionBehaviorDeliverImmediately
    // );

	updateSettings();

	int _;
	notify_register_dispatch("dr.erast.witcherprefs/init", &_, dispatch_get_main_queue(), ^(int _) {
		updateSettings();
	});

}
