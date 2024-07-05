//
//  RouterView.m
//  Witcher
//
//  Created by Matoi on 16.04.2024.
//

#import "RouterView.h"
#include <RemoteLog.h>
#import <objc/runtime.h>

#include <CoreFoundation/CoreFoundation.h>


@interface RouterView (Private)

-(void)setupView;
-(void)setupCells;
-(void)setupConstraints;
-(void)setupQuickActionButtons;
-(void)setupStaticCell;
-(void)updateStaticCellPosition;
-(void)prepareReusableRouterCells:(NSArray<WitcherApplicationLayoutStruct *> *)layoutStructs;
-(void)activateConstraintsForCell:(RouterReusableCellView *)cell withCenter:(CGPoint)center;
-(void)activateConstraintsForQuickActionButton:(UIButton *)button withCenter:(CGPoint)center;
-(CGPoint)calculateCoordinatesForCellWithAngle:(CGFloat)angle radius:(CGFloat)radius;

@end

@implementation RouterView

@synthesize witcherBlurView;
@synthesize witcherBlurEffect;
@synthesize witcherViewBackgroundColor;
@synthesize cellsTintColor;
@synthesize reusableRouterCells;

@synthesize closeAppButton;
@synthesize goToPreviousAppButton;
@synthesize searchButton;
@synthesize staticRouterStackCell;
@synthesize actionButtonsIsActive;

-(instancetype)initWithBlurEffect: (UIBlurEffect *)blurEffect backgroundColor: (UIColor *_Nullable)color {
    self = [super init];
    if (self) {
        impactFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [impactFeedbackGenerator prepare];
        
        witcherBlurEffect = blurEffect;
        witcherViewBackgroundColor = (color == nil ? [UIColor clearColor] : color);
        
        staticRouterStackCell =  [[RouterReusableCellView alloc] initStaticCellWithTintColor:[UIColor whiteColor]];
        
        [self setupView];
    }
    return self;
}

-(void)setupView {
    witcherBlurView = [[UIVisualEffectView alloc] initWithEffect:witcherBlurEffect];
    
    [witcherBlurView setClipsToBounds:YES];
    
    [[self layer] setCornerRadius: 150];
    [self setAlpha: 1];
    [self setBackgroundColor: witcherViewBackgroundColor];

    [self becomeFirstResponder];
    
    [self addSubview:witcherBlurView];
    
    [witcherBlurView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [[witcherBlurView layer] setCornerRadius: 150];
    
    
    [NSLayoutConstraint activateConstraints:@[
        [[witcherBlurView bottomAnchor] constraintEqualToAnchor: [self bottomAnchor]],
        [[witcherBlurView leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
        [[witcherBlurView topAnchor] constraintEqualToAnchor: [self topAnchor]],
        [[witcherBlurView trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
    ]];
    
    [self setupStaticCell];
    [self setupQuickActionButtons];

}

-(void)setupStaticCell {
    [self updateStaticCellPosition];
}

-(void)setupQuickActionButtons {
    
    closeAppButton = [[UIButton alloc] init];
    [closeAppButton addTarget:self action:@selector(closeApp) forControlEvents:UIControlEventTouchUpInside];
    [closeAppButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
    
    goToPreviousAppButton = [[UIButton alloc] init];
    [goToPreviousAppButton addTarget:self action:@selector(openPrevousApp) forControlEvents:UIControlEventTouchUpInside];
    [goToPreviousAppButton setImage:[UIImage systemImageNamed:@"arrow.left"] forState:UIControlStateNormal];
    
    if ([reusableRouterCells count] < 1) {
        [goToPreviousAppButton setEnabled:NO];
    }
    
    searchButton = [[UIButton alloc] init];
    [searchButton addTarget:self action:@selector(searchApp) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setImage:[UIImage systemImageNamed:@"magnifyingglass" ] forState:UIControlStateNormal];
    
    NSArray<UIButton *> *buttons = @[goToPreviousAppButton, searchButton, closeAppButton];
    
    const CGFloat angle = 180.0 / [buttons count];
    
    for (int count=0; count < [buttons count]; count++) {
        CGFloat newAngle = angle * count + 30;
        UIButton *quickActionButton = [buttons objectAtIndex:count];
        
        [[quickActionButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
        [quickActionButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
        [quickActionButton setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
        [quickActionButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        
        [self addSubview:quickActionButton];
        [quickActionButton setTintColor:[UIColor whiteColor]];
        
        
        [self activateConstraintsForQuickActionButton:quickActionButton withCenter:[self calculateCoordinatesForCellWithAngle:newAngle radius:75.0]];
    }

}

-(void)closeApp {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReleaseFrontMostApplication" object:self];
}

-(void)searchApp {
    [(AXSpringBoardServer *)[objc_getClass("AXSpringBoardServer") server] revealSpotlight];
}

-(void)openPrevousApp {
    if ([reusableRouterCells count] >= 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenRecentApplication" object:self];
    }
}

-(void)updateCellsWithNewApplications:(NSArray<WitcherApplicationLayoutStruct *> *)layoutStructs includingFrontMostApplication:(_Bool)flag {
    if (!layoutStructs) {return;}

    if (!reusableRouterCells) { reusableRouterCells = [[NSArray<RouterReusableCellView *> alloc] init]; }
    if (([reusableRouterCells count] != 5 && [layoutStructs count] != [reusableRouterCells count]) || (([reusableRouterCells count] == 5) && ([layoutStructs count] < 5))) { [self prepareReusableRouterCells:layoutStructs]; }

    for (int count=0; count < ([layoutStructs count] > 5 ? 5 : [layoutStructs count]); count++) {
        [[[[reusableRouterCells reverseObjectEnumerator] allObjects] objectAtIndex:count] updateWithLayoutStruct:[layoutStructs objectAtIndex:count] tintColor:cellsTintColor];
    }
    
    [goToPreviousAppButton setEnabled:[layoutStructs count] > 0];
    [closeAppButton setEnabled:[layoutStructs count] + flag > 0];
    
    [self updateStaticCellPosition];
    
    [staticRouterStackCell updateStaticCounterWithValue:[layoutStructs count] + flag]; // Update static cell's value
}

-(void)updateStaticCellPosition {
    
    [staticRouterStackCell removeFromSuperview];
    staticRouterStackCell = nil;
    
    staticRouterStackCell = [[RouterReusableCellView alloc] initStaticCellWithTintColor:cellsTintColor];
    
    [self addSubview:staticRouterStackCell];
    
    [staticRouterStackCell setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    float angle = 0;

    if (reusableRouterCells) {
        switch ([reusableRouterCells count]) {
            case 0: angle = 90.0; break;
            case 1: angle = 105.0; break;
            case 2: angle = 120.0; break;
            case 3: angle = 135.0; break;
            case 4: angle = 150.0; break;
            case 5: angle = 165.0; break;
            default: angle = 180.0; break;
                
        }
    }
    CGPoint newCoords = [self calculateCoordinatesForCellWithAngle:angle radius:150.0];
    NSLog(@"%f %f", newCoords.x, newCoords.y);
    
    [NSLayoutConstraint activateConstraints:@[
        [[staticRouterStackCell widthAnchor] constraintEqualToConstant: 60.0],
        [[staticRouterStackCell heightAnchor] constraintEqualToConstant: 60.0],
        
        [[staticRouterStackCell centerXAnchor] constraintEqualToAnchor: [self centerXAnchor] constant:-newCoords.x],
        [[staticRouterStackCell centerYAnchor] constraintEqualToAnchor: [self centerYAnchor] constant:newCoords.y]
    ]];
    [staticRouterStackCell updateConstraints];
}


-(void)prepareReusableRouterCells:(NSArray<WitcherApplicationLayoutStruct *> *)layoutStructs {
    NSMutableArray<RouterReusableCellView *> *tempArr = [[NSMutableArray alloc] init];
    
    const CGFloat const_angle = 180.0 / (float)([layoutStructs count] > 5 ? 5: [layoutStructs count]);
    
    for (RouterReusableCellView * cell in reusableRouterCells) { [cell removeFromSuperview]; }
    reusableRouterCells = @[];
    CGFloat angle = 0.0;
    for (int count=0; count < ([layoutStructs count] > 5 ? 5: [layoutStructs count]); count++) {
        if ([layoutStructs count] >= 6) { angle = const_angle * (1 + count); }
        else {
            angle = [self getHardcodedAngleByApplicationsCount:[layoutStructs count] order:count];
        }
        
        RouterReusableCellView * cell = [[RouterReusableCellView alloc] init];
        
        [self addSubview:cell];
        [self activateConstraintsForCell:cell withCenter:[self calculateCoordinatesForCellWithAngle:angle radius:150.0]];
        
        [tempArr addObject:cell];
    }
    
    reusableRouterCells = [[NSArray alloc] initWithArray:tempArr];
    
}

-(CGFloat)getHardcodedAngleByApplicationsCount:(NSUInteger)appsCount order:(NSUInteger)order {
    #pragma mark - TODO: Deal with this
    switch (appsCount) {
        case 0:
            return 0.0;
        case 1:
            return 105.0;
        case 2:
            switch (order) {
                case 0: return 90.0;
                case 1: return 120.0;
            }
        case 3:
            switch (order) {
                case 0:
                    return 75.0;
                case 1:
                    return 105.0;
                case 2:
                    return 135.0;
            }
        case 4:
            switch (order) {
                case 0:
                    return 60.0;
                case 1:
                    return 90.0;
                case 2:
                    return 120.0;
                case 3:
                    return 150.0;
            }
        case 5:
            switch (order) {
                case 0:
                    return 45.0;
                case 1:
                    return 75.0;
                case 2:
                    return 105.0;
                case 3:
                    return 135.0;
                case 4:
                    return 165.0;
            }
    }
    return 0.0;
}

-(CGPoint)calculateCoordinatesForCellWithAngle:(CGFloat)angle radius:(CGFloat)radius {
    CGFloat x = (radius * cos((angle + 180.0) * M_PI / 180.0));
    CGFloat y = (radius * sin((angle + 180.0) * M_PI / 180.0));
    
    return CGPointMake(x, y);
}

-(void)activateConstraintsForCell:(RouterReusableCellView *)cell withCenter:(CGPoint)center {
    [cell setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [NSLayoutConstraint activateConstraints:@[
        [[cell widthAnchor] constraintEqualToConstant: 60.0],
        [[cell heightAnchor] constraintEqualToConstant: 60.0],
        [[cell centerXAnchor] constraintEqualToAnchor: [self centerXAnchor] constant:center.x],
        [[cell centerYAnchor] constraintEqualToAnchor: [self centerYAnchor] constant:center.y]
    ]];
}

-(void)activateConstraintsForQuickActionButton:(UIButton *)button withCenter:(CGPoint)center {
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [NSLayoutConstraint activateConstraints:@[
        [[button widthAnchor] constraintEqualToConstant: 48.0],
        [[button heightAnchor] constraintEqualToConstant: 48.0],
        [[button centerXAnchor] constraintEqualToAnchor: [self centerXAnchor] constant:center.x],
        [[button centerYAnchor] constraintEqualToAnchor: [self centerYAnchor] constant:center.y]
    ]];
}

-(void)handleGestureWithPosition:(CGPoint)coordinates phase:(unsigned long long)phase interactionEnabled:(_Bool)interactionEnabled {

    /*
    @param phase
        1 - BEGAN
        2 - MOVE
        3 - END
    
    @param interactionEnabled
        YES - handle quick action buttons
        NO - don't handle quick action buttons
    */

    _Bool someCellSelected = false;
    
    NSMutableArray<RouterReusableCellView *> *cells = [reusableRouterCells mutableCopy];
    [cells addObject:staticRouterStackCell];

    CGPoint localCoordinates = [self convertPoint:coordinates fromView:nil];
    
    // Handle touch for app cells
    for (RouterReusableCellView * cell in cells) {

        if (CGRectContainsPoint(cell.frame, localCoordinates)) {
            someCellSelected = true;
            [cell setSelected];
            if (self.layoutUpdateBlock) {
                self.layoutUpdateBlock([cell layoutStruct]);
            }
            if (phase == 3) {
                [cell setUnselected];
                #pragma mark - The app launches here
                [(SpringBoard *)[UIApplication sharedApplication] launchApplicationWithIdentifier:[[cell layoutStruct] appBundleID] suspended:NO];

                if (self.layoutUpdateBlock) {
                    self.layoutUpdateBlock(nil);
                }
            }
        } else {
            [cell setUnselected];
        }
    }
    
    if (!someCellSelected) {
        if (self.layoutUpdateBlock) {
            self.layoutUpdateBlock(nil);
        }
    }

    // Handle touch for quick action buttons
    if (!actionButtonsIsActive) { return; }
    if (interactionEnabled) {
        for (UIButton * button in @[closeAppButton, goToPreviousAppButton, searchButton]) {
            if (CGRectContainsPoint(button.frame, localCoordinates)) {
                if (![button isHighlighted] && [button isEnabled]) {
                    [button setHighlighted:YES];
                    [impactFeedbackGenerator impactOccurred];
                }
                if (phase == 3) {
                    [button setHighlighted:NO];
                    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
                }

            } else {
                if ([button isHighlighted]) {
                    [button setHighlighted:NO];
                }
        
            }
        }
    }

}

-(void)updateMainColor:(UIColor *)color {
    [self setWitcherViewBackgroundColor:color];
    [self setBackgroundColor: color];
}

-(void)updateCellsWithColor:(UIColor *)color {
    [self setCellsTintColor:color];
    for (RouterReusableCellView *cell in reusableRouterCells) {  [cell updateColor:color]; }
}

-(void)updateActionButtonsWithState:(_Bool)state {
    [goToPreviousAppButton setHidden:state];
    [searchButton setHidden:state];
    [closeAppButton setHidden:state];


    actionButtonsIsActive = !state; 
}

@end

