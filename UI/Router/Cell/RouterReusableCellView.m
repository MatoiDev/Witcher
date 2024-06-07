//
//  RouterReusableCellView.m
//  Witcher
//
//  Created by Matoi on 17.04.2024.
//

#import "RouterReusableCellView.h"

@interface RouterReusableCellView (Private)

-(void)configureCell;
-(void)setupSubviews;
-(void)activateConstraints;
-(void)removeBorder;
-(void)addBorder;

-(void)activateConstraintsForContainer:(UIStackView *)container;

@end

@implementation RouterReusableCellView

@synthesize iconImageView;
@synthesize layoutStruct;
@synthesize applicationsCounter;
@synthesize applicationsCounterLabel;

-(instancetype)initWithLayoutStruct:(WitcherApplicationLayoutStruct *)layoutStruct_t tintColor:(UIColor *)color {
    self = [super init];
    if (self) {
        layoutStruct = layoutStruct_t;
        routerCellTintColor = color;
        routerCellIcon = [layoutStruct_t icon];
        isStackStyle = NO;
        
        [self configureCell];
    }
    return self;
}

-(instancetype)initStaticCellWithTintColor:(UIColor *)tintColor {
    self = [super init];
    if (self) {
        applicationsCounter = 0;
        isStackStyle = YES;
        routerCellTintColor = tintColor;
        routerCellIcon = [UIImage systemImageNamed:@"square.stack.3d.down.right"];
        staticCellImpactGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [staticCellImpactGenerator prepare];
        
        [self configureCell];
    }
    return self;
}

-(void)updateWithLayoutStruct:(WitcherApplicationLayoutStruct *)layoutStruct_t tintColor:(UIColor *)color {
    layoutStruct = layoutStruct_t;
    routerCellTintColor = color;
    routerCellIcon = [layoutStruct_t icon];
    
    [self configureCell];
}

-(void)configureCell {
    [[self layer] setCornerRadius:30];

    [self setupSubviews];
}

-(void)setupSubviews {
    if (!iconImageView) { iconImageView = [[UIImageView alloc] init]; }
    

    [iconImageView setImage:routerCellIcon];
    
    if (!isStackStyle) { // Common application cell doesn't need container
        [[iconImageView layer] setCornerRadius:30];
        [iconImageView setClipsToBounds:YES];
        [self addSubview:iconImageView];
        [iconImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self activateConstraints];
    }
    
    if (isStackStyle && !applicationsCounterLabel) {
        
        [iconImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        UIStackView *cellStackView = [[UIStackView alloc] init];
        [self addSubview:cellStackView];
        [cellStackView setAxis:UILayoutConstraintAxisVertical];
        [cellStackView setAlignment:UIStackViewAlignmentCenter];
        
        [cellStackView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self setBackgroundColor:  [[UIColor systemGray2Color] colorWithAlphaComponent:0.8]];
        // [self setBackgroundColor: staticCellColor];
       
        
        applicationsCounterLabel = [[UILabel alloc] init];
        [applicationsCounterLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightSemibold]];
        [applicationsCounterLabel setTextColor:routerCellTintColor];
        [applicationsCounterLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)applicationsCounter]];
        
        [iconImageView setTintColor:routerCellTintColor];
        
        [cellStackView addArrangedSubview:iconImageView];
        [cellStackView addArrangedSubview:applicationsCounterLabel];
        
        [self activateConstraintsForContainer:cellStackView];
    }

}

-(void)activateConstraintsForContainer:(UIStackView *)container {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [NSLayoutConstraint activateConstraints:@[
        [[container centerXAnchor] constraintEqualToAnchor: [self centerXAnchor]],
        [[container centerYAnchor] constraintEqualToAnchor: [self centerYAnchor]],
        
        [[iconImageView widthAnchor] constraintEqualToConstant: 24.0],
        [[iconImageView heightAnchor] constraintEqualToConstant: 24.0],
        
        [[applicationsCounterLabel heightAnchor] constraintEqualToConstant: 17.0]
        
    ]];
}

-(void)activateConstraints {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [NSLayoutConstraint activateConstraints:@[
        [[iconImageView leadingAnchor] constraintEqualToAnchor: [self leadingAnchor]],
        [[iconImageView trailingAnchor] constraintEqualToAnchor: [self trailingAnchor]],
        [[iconImageView topAnchor] constraintEqualToAnchor: [self topAnchor]],
        [[iconImageView bottomAnchor] constraintEqualToAnchor: [self bottomAnchor]]
    ]];
}

-(void)addBorder {
    if (!self.borderLayer) {
        self.borderLayer = [CAShapeLayer layer];
        self.borderLayer.strokeColor = routerCellTintColor.CGColor;
        self.borderLayer.fillColor = [UIColor clearColor].CGColor;
        self.borderLayer.lineWidth = 2.5;
        [self.layer addSublayer:self.borderLayer];
    }

    CGRect ovalRect = CGRectInset(CGRectMake(0, 0, 60, 60), self.borderLayer.lineWidth / 2.0, self.borderLayer.lineWidth / 2.0);

    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
    self.borderLayer.path = ovalPath.CGPath;
    
}

-(void)removeBorder {
    [self.borderLayer removeFromSuperlayer];
    self.borderLayer = nil;
}

-(void)setSelected {
    if (!self.borderLayer) {
        if (isStackStyle) { [staticCellImpactGenerator impactOccurred]; }
        [UIView animateWithDuration:0.1 animations:^{
            if (self->isStackStyle) {
                [[self iconImageView] setTransform:CGAffineTransformMakeTranslation(0, 8)];
                [[self applicationsCounterLabel] setAlpha:0];
            } else {
                [[self iconImageView] setTransform:CGAffineTransformMakeScale(0.85, 0.85)];
            }
        }];
        [self addBorder];
    }
}

-(void)setUnselected {
    if (self.borderLayer) {
        [self removeBorder];
        [UIView animateWithDuration:0.1 animations:^{
            [[self iconImageView] setTransform:CGAffineTransformMakeScale(1, 1)];
            if (self->isStackStyle) { [[self applicationsCounterLabel] setAlpha:1]; }
        }];
    }

}

-(void)updateStaticCounterWithValue:(NSUInteger)arg {
    
    if (isStackStyle) {
        [self setApplicationsCounter:arg];
        [applicationsCounterLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)arg]];
        
    }
}

-(void)updateColor:(UIColor *)tintColor {
    routerCellTintColor = tintColor;
    if (applicationsCounterLabel) { [applicationsCounterLabel setTextColor:tintColor]; }
    if (iconImageView) { [iconImageView setTintColor:tintColor]; } 
}


@end
