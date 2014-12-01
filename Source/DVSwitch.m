//
//  DVSwitch.m
//  DVSwitcherExample
//
//  Created by Dmitry Volevodz on 08.10.14.
//  Copyright (c) 2014 Dmitry Volevodz. All rights reserved.
//

#import "DVSwitch.h"

@interface DVSwitch ()

@property (strong, nonatomic) NSMutableArray *labels;
@property (strong, nonatomic) NSMutableArray *onTopLabels;
@property (strong, nonatomic) NSArray *strings;

@property (strong, nonatomic) void (^handlerBlock)(NSUInteger index);
@property (strong, nonatomic) void (^willBePressedHandlerBlock)(NSUInteger index);

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *sliderView;

@property (nonatomic) NSInteger selectedIndex;

@end

@implementation DVSwitch

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [NSException raise:@"DVSwitchInitException" format:@"Init call is prohibited, use initWithStringsArray: method"];
    }
    
    return self;
}

+ (instancetype)switchWithStringsArray:(NSArray *)strings
{
    // to do
    return [[DVSwitch alloc] initWithStringsArray:strings];
}

- (instancetype)initWithStringsArray:(NSArray *)strings
{
    self = [super init];
    
    self.strings = strings;
    self.cornerRadius = 12.0f;
    self.sliderOffset = 1.0f;
    
    self.backgroundColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0];
    self.sliderColor = [UIColor whiteColor];
    self.labelTextColorInsideSlider = [UIColor blackColor];
    self.labelTextColorOutsideSlider = [UIColor whiteColor];
    
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = self.backgroundColor;
    self.backgroundView.userInteractionEnabled = YES;
    [self addSubview:self.backgroundView];
    
    self.labels = [[NSMutableArray alloc] init];
    
    for (int k = 0; k < [self.strings count]; k++) {
        
        NSString *string = self.strings[k];
        UILabel *label = [[UILabel alloc] init];
        label.tag = k;
        label.text = string;
        label.font = self.font;
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.labelTextColorOutsideSlider;
        [self.backgroundView addSubview:label];
        [self.labels addObject:label];
        
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRecognizerTap:)];
        [label addGestureRecognizer:rec];
        label.userInteractionEnabled = YES;
    }
    
    self.sliderView = [[UIView alloc] init];
    self.sliderView.backgroundColor = self.sliderColor;
    self.sliderView.clipsToBounds = YES;
    [self addSubview:self.sliderView];
    
    self.onTopLabels = [[NSMutableArray alloc] init];
    
    for (NSString *string in self.strings) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = string;
        label.font = self.font;
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.labelTextColorInsideSlider;
        [self.sliderView addSubview:label];
        [self.onTopLabels addObject:label];
    }
    
    UIPanGestureRecognizer *sliderRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderMoved:)];
    [self.sliderView addGestureRecognizer:sliderRec];
    
    return self;
}

- (instancetype)initWithAttributedStringsArray:(NSArray *)strings {
    self = [super init];
    
    self.strings        = strings;
    self.cornerRadius   = 12.0f;
    self.sliderOffset   = 1.0f;
    
    self.backgroundColor    = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0];
    self.sliderColor        = [UIColor whiteColor];
    self.labelTextColorInsideSlider     = [UIColor blackColor];
    self.labelTextColorOutsideSlider    = [UIColor whiteColor];
    
    self.backgroundView = [[UIView alloc] init];
    
    self.backgroundView.backgroundColor         = self.backgroundColor;
    self.backgroundView.userInteractionEnabled  = YES;
    [self addSubview:self.backgroundView];
    
    self.labels = [[NSMutableArray alloc] init];
    
    [self.strings enumerateObjectsUsingBlock:^(NSMutableAttributedString *str, NSUInteger idx, BOOL *stop) {
        
        [str addAttribute:NSForegroundColorAttributeName
                    value:self.labelTextColorOutsideSlider
                    range:NSMakeRange(0, str.length)];
        
        UILabel *label          = [[UILabel alloc] init];
        label.tag               = idx;
        label.attributedText    = str;
        label.textAlignment     = NSTextAlignmentCenter;
        
        [self.backgroundView addSubview:label];
        [self.labels addObject:label];
        
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(handleRecognizerTap:)];
        [label addGestureRecognizer:rec];
        label.userInteractionEnabled = YES;
    }];
    
    self.sliderView                 = [[UIView alloc] init];
    self.sliderView.backgroundColor = self.sliderColor;
    self.sliderView.clipsToBounds   = YES;
    [self addSubview:self.sliderView];
    
    self.onTopLabels = [[NSMutableArray alloc] init];
    
    [self.strings enumerateObjectsUsingBlock:^(NSMutableAttributedString *str, NSUInteger idx, BOOL *stop) {
        
        [str addAttribute:NSForegroundColorAttributeName
                    value:self.labelTextColorInsideSlider
                    range:NSMakeRange(0, str.length)];
        
        UILabel *label          = [[UILabel alloc] init];
        label.attributedText    = str;
        label.textAlignment     = NSTextAlignmentCenter;
       
        [self.sliderView addSubview:label];
        [self.onTopLabels addObject:label];
    }];
    
    UIPanGestureRecognizer *sliderRec = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(sliderMoved:)];
    [self.sliderView addGestureRecognizer:sliderRec];
    
    return self;
}

- (void)setPressedHandler:(void (^)(NSUInteger))handler
{
    self.handlerBlock = handler;
}

- (void)setWillBePressedHandler:(void (^)(NSUInteger))handler
{
    self.willBePressedHandlerBlock = handler;
}

- (void)forceSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index > [self.strings count]) {
        return;
    }
    
    self.selectedIndex = index;
    
    if (animated) {
        
        [self animateChangeToIndex:index callHandler:YES];
        
    } else {
        
        [self changeToIndexWithoutAnimation:index callHandler:YES];
    }
}

- (void)selectIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index > [self.strings count]) {
        return;
    }
    self.selectedIndex = index;
    
    if (animated) {
        
        [self animateChangeToIndex:index callHandler:NO];
        
    } else {
        
        [self changeToIndexWithoutAnimation:index callHandler:NO];
    }
}

- (void)layoutSubviews
{
    self.backgroundView.layer.cornerRadius = self.cornerRadius;
    self.sliderView.layer.cornerRadius = self.cornerRadius - 1;
    
    self.backgroundView.backgroundColor = self.backgroundColor;
    self.sliderView.backgroundColor = self.sliderColor;
    
    self.backgroundView.frame = [self convertRect:self.frame fromView:self.superview];
    
    self.backgroundView.layer.cornerRadius = self.cornerRadius;
    self.sliderView.layer.cornerRadius = self.cornerRadius;
    
    CGFloat sliderWidth = self.frame.size.width / [self.strings count];
    
    self.sliderView.frame = CGRectMake(sliderWidth * self.selectedIndex + self.sliderOffset, self.backgroundView.frame.origin.y + self.sliderOffset, sliderWidth - self.sliderOffset * 2, self.frame.size.height - self.sliderOffset * 2);
    
    for (int i = 0; i < [self.labels count]; i++) {
        
        UILabel *label = self.labels[i];
        label.frame = CGRectMake(i * sliderWidth, 0, sliderWidth, self.frame.size.height);
        if (self.font) {
            label.font = self.font;
        }
        label.textColor = self.labelTextColorOutsideSlider;
    }
    
    for (int j = 0; j < [self.onTopLabels count]; j++) {
        
        UILabel *label = self.onTopLabels[j];
        label.frame = CGRectMake([self.sliderView convertPoint:CGPointMake(j * sliderWidth, 0) fromView:self.backgroundView].x, - self.sliderOffset, sliderWidth, self.frame.size.height);
        if (self.font) {
            label.font = self.font;
        }
        label.textColor = self.labelTextColorInsideSlider;
    }
}

- (void)animateChangeToIndex:(NSUInteger)selectedIndex callHandler:(BOOL)callHandler
{
    
    if (self.willBePressedHandlerBlock) {
        self.willBePressedHandlerBlock(selectedIndex);
    }
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGFloat sliderWidth = self.frame.size.width / [self.strings count];
        
        CGRect oldFrame = self.sliderView.frame;
        CGRect newFrame = CGRectMake(sliderWidth * self.selectedIndex + self.sliderOffset, self.backgroundView.frame.origin.y + self.sliderOffset, sliderWidth - self.sliderOffset * 2, self.frame.size.height - self.sliderOffset * 2);
        
        CGRect offRect = CGRectMake(newFrame.origin.x - oldFrame.origin.x, newFrame.origin.y - oldFrame.origin.y, 0, 0);
        
        self.sliderView.frame = newFrame;
        
        for (UILabel *label in self.onTopLabels) {
            
            label.frame = CGRectMake(label.frame.origin.x - offRect.origin.x, label.frame.origin.y - offRect.origin.y, label.frame.size.width, label.frame.size.height);
        }
        
    } completion:^(BOOL finished) {
        
        if (self.handlerBlock && callHandler) {
            self.handlerBlock(selectedIndex);
        }
    }];
}

- (void)changeToIndexWithoutAnimation:(NSUInteger)selectedIndex callHandler:(BOOL)callHandler
{
    if (self.willBePressedHandlerBlock) {
        self.willBePressedHandlerBlock(selectedIndex);
    }
    
    CGFloat sliderWidth = self.frame.size.width / [self.strings count];
    
    CGRect oldFrame = self.sliderView.frame;
    CGRect newFrame = CGRectMake(sliderWidth * self.selectedIndex + self.sliderOffset, self.backgroundView.frame.origin.y + self.sliderOffset, sliderWidth - self.sliderOffset * 2, self.frame.size.height - self.sliderOffset * 2);
    
    CGRect offRect = CGRectMake(newFrame.origin.x - oldFrame.origin.x, newFrame.origin.y - oldFrame.origin.y, 0, 0);
    
    self.sliderView.frame = newFrame;
    
    for (UILabel *label in self.onTopLabels) {
        
        label.frame = CGRectMake(label.frame.origin.x - offRect.origin.x, label.frame.origin.y - offRect.origin.y, label.frame.size.width, label.frame.size.height);
    }
    
    if (self.handlerBlock && callHandler) {
        self.handlerBlock(selectedIndex);
    }
}

- (void)handleRecognizerTap:(UITapGestureRecognizer *)rec
{
    self.selectedIndex = rec.view.tag;
    [self animateChangeToIndex:self.selectedIndex callHandler:YES];
}

- (void)sliderMoved:(UIPanGestureRecognizer *)rec
{
    if (rec.state == UIGestureRecognizerStateChanged) {
        
        CGRect oldFrame = self.sliderView.frame;
        
        CGFloat minPos = 0 + self.sliderOffset;
        CGFloat maxPos = self.frame.size.width - self.sliderOffset - self.sliderView.frame.size.width;
        
        CGPoint center = rec.view.center;
        CGPoint translation = [rec translationInView:rec.view];
        
        center = CGPointMake(center.x + translation.x, center.y);
        rec.view.center = center;
        [rec setTranslation:CGPointZero inView:rec.view];
        
        if (self.sliderView.frame.origin.x < minPos) {
            
            self.sliderView.frame = CGRectMake(minPos, self.sliderView.frame.origin.y, self.sliderView.frame.size.width, self.sliderView.frame.size.height);
            
        } else if (self.sliderView.frame.origin.x > maxPos) {
            
            self.sliderView.frame = CGRectMake(maxPos, self.sliderView.frame.origin.y, self.sliderView.frame.size.width, self.sliderView.frame.size.height);
        }
        
        CGRect newFrame = self.sliderView.frame;
        CGRect offRect = CGRectMake(newFrame.origin.x - oldFrame.origin.x, newFrame.origin.y - oldFrame.origin.y, 0, 0);
        
        for (UILabel *label in self.onTopLabels) {
            
            label.frame = CGRectMake(label.frame.origin.x - offRect.origin.x, label.frame.origin.y - offRect.origin.y, label.frame.size.width, label.frame.size.height);
        }
        
    } else if (rec.state == UIGestureRecognizerStateEnded || rec.state == UIGestureRecognizerStateCancelled || rec.state == UIGestureRecognizerStateFailed) {
        
        NSMutableArray *distances = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [self.strings count]; i++) {
            
            CGFloat possibleX = i * self.sliderView.frame.size.width;
            CGFloat distance = possibleX - self.sliderView.frame.origin.x;
            [distances addObject:@(fabs(distance))];
        }
        
        NSNumber *num = [distances valueForKeyPath:@"@min.doubleValue"];
        NSInteger index = [distances indexOfObject:num];
        
        if (self.willBePressedHandlerBlock) {
            self.willBePressedHandlerBlock(index);
        }
        
        CGFloat sliderWidth = self.frame.size.width / [self.strings count];
        CGFloat desiredX = sliderWidth * index + self.sliderOffset;
        
        if (self.sliderView.frame.origin.x != desiredX) {
            
            CGRect evenOlderFrame = self.sliderView.frame;
            
            CGFloat distance = desiredX - self.sliderView.frame.origin.x;
            CGFloat time = fabs(distance / 300);
            
            [UIView animateWithDuration:time animations:^{
                
                self.sliderView.frame = CGRectMake(desiredX, self.sliderView.frame.origin.y, self.sliderView.frame.size.width, self.sliderView.frame.size.height);
                
                CGRect newFrame = self.sliderView.frame;
                
                CGRect offRect = CGRectMake(newFrame.origin.x - evenOlderFrame.origin.x, newFrame.origin.y - evenOlderFrame.origin.y, 0, 0);
                
                for (UILabel *label in self.onTopLabels) {
                    
                    label.frame = CGRectMake(label.frame.origin.x - offRect.origin.x, label.frame.origin.y - offRect.origin.y, label.frame.size.width, label.frame.size.height);
                }
            } completion:^(BOOL finished) {
                
                self.selectedIndex = index;
                
                if (self.handlerBlock) {
                    self.handlerBlock(index);
                }
                
            }];
            
        } else {
            
            self.selectedIndex = index;
            
            if (self.handlerBlock) {
                self.handlerBlock(self.selectedIndex);
            }
        }
    }
}


@end
