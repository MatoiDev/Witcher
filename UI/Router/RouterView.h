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
@property(nonatomic, strong)UIVisualEffectView *witcherBlurView;
@property(nonatomic, strong)NSArray<RouterReusableCellView *> *reusableRouterCells;
@property(nonatomic, strong)RouterReusableCellView *staticRouterStackCell;
@property(nonatomic, strong)UIButton *closeAppButton;
@property(nonatomic, strong)UIButton *goToPreviousAppButton;
@property(nonatomic, strong)UIButton *searchButton;

@property(nonatomic, copy) LayoutUpdateBlock layoutUpdateBlock;

-(instancetype)initWithBlurEffect:(UIBlurEffect*)blurEffect backgroundColor:(UIColor *_Nullable)color;
-(void)updateCellsWithNewApplications:(NSArray<WitcherApplicationLayoutStruct *> *)layoutStructs includingFrontMostApplication:(_Bool)flag;
-(void)handleGestureWithPosition:(CGPoint)coordinates phase:(unsigned long long)phase interactionEnabled:(_Bool)interactionEnabled;
// Quick Actions
-(void)closeApp;
-(void)openPrevousApp;
-(void)searchApp;

@end

@interface AXServer : NSObject
@end

@interface AXSpringBoardServer : AXServer
+(id)server;
-(void)revealSpotlight;
@end

@interface UIApplication (Launcher)
+(id)sharedApplication;
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

@interface SpringBoard (Launcher)
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

NS_ASSUME_NONNULL_END


