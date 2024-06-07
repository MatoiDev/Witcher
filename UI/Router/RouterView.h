//
//  RouterView.h
//  Witcher
//
//  Created by Matoi on 16.04.2024.
//

#import <UIKit/UIKit.h>
#import "Cell/RouterReusableCellView.h"
#import "../ApplicationLayoutStruct/WitcherApplicationLayoutStruct.h"
#import <SpringBoard/SpringBoard.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LayoutUpdateBlock)(WitcherApplicationLayoutStruct *_Nullable);

@interface RouterView : UIView {
    UIImpactFeedbackGenerator *impactFeedbackGenerator;
}

@property(nonatomic, strong)UIBlurEffect *witcherBlurEffect;
@property(nonatomic, strong)UIColor *witcherViewBackgroundColor;
@property(nonatomic, strong)UIColor *cellsTintColor;
@property(nonatomic, strong)UIVisualEffectView *witcherBlurView;
@property(nonatomic, strong)NSArray<RouterReusableCellView *> *reusableRouterCells;
@property(nonatomic, strong)RouterReusableCellView *staticRouterStackCell;
@property(nonatomic, strong)UIButton *closeAppButton;
@property(nonatomic, strong)UIButton *goToPreviousAppButton;
@property(nonatomic, strong)UIButton *searchButton;

@property(nonatomic, copy) LayoutUpdateBlock layoutUpdateBlock;

-(instancetype)initWithBlurEffect:(UIBlurEffect*)blurEffect backgroundColor:(UIColor *_Nullable)color;
-(void)updateMainColor:(UIColor *)color;
-(void)updateCellsWithColor:(UIColor *)color;
-(void)updateCellsWithNewApplications:(NSArray<WitcherApplicationLayoutStruct *> *)layoutStructs includingFrontMostApplication:(_Bool)flag;
-(void)handleGestureWithPosition:(CGPoint)coordinates phase:(unsigned long long)phase interactionEnabled:(_Bool)interactionEnabled;
// Quick Actions
-(void)closeApp;
-(void)openPrevousApp;
-(void)searchApp;
-(void)updateActionButtonsWithState:(_Bool)state;

@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1, 11.0, 10.2, 10.1.1, 9.3.3, 9.0, 8.0, 7.0, 6.0
@interface AXServer : NSObject
@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1, 11.0, 10.2, 10.1.1, 9.3.3, 9.0, 8.0, 7.0, 6.0
@interface AXSpringBoardServer : AXServer
+(id)server;
-(void)revealSpotlight;
@end

@interface UIApplication (Launcher)
+(id)sharedApplication;
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

// HLOS: 17.1, 16.3, 15.2.1, 14.4, 13.1.3, 12.1, 11.1.2, 11.0.1, 10.2, 10.1.1, 9.3.3, 9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0
@interface SpringBoard (Launcher)
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

NS_ASSUME_NONNULL_END


