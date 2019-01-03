//
//  LVBottomSheetView.m
//  Live
//
//  Created by RoyLei on 16/6/22.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "LVBottomSheetView.h"
#import "LVShowPopViewHandler.h"
#import "UIView+YYAdd.h"
#import "UIImage+YYAdd.h"
#import "UIColor+YYAdd.h"
#import "YYCGUtilities.h"
#import "LSYConstance.h"

@interface LVBottomSheetView()
{
    CGFloat _buttonWidth;
    CGFloat _buttonHeight;
    CGFloat _lastButtonGap;
}

@property (strong, nonatomic) NSMutableArray <UIButton *> *buttons;
@property (strong, nonatomic) UIView *tailView;

@property (strong, nonatomic) LVShowPopViewHandler *popViewHandler;
@property (strong, nonatomic) LVBottomSheetViewButtonPressedBlock buttonPressedBlock;

@end

@implementation LVBottomSheetView

+ (void)showBottomSheetViewWithButtonTitles:(NSArray <NSString *> *)titles
                              buttonPressed:(LVBottomSheetViewButtonPressedBlock)buttonPressedBlock
{
    LVBottomSheetView *sheetView = [LVBottomSheetView sharedSheetView];
    if(sheetView.popViewHandler) {
        [sheetView.popViewHandler dissmissWithCompletion:^{
            
            [sheetView setButtonTitles:titles];
            sheetView.buttonPressedBlock = buttonPressedBlock;
            
            LVShowPopViewHandler *popViewHandler = [LVShowPopViewHandler showContentView:sheetView
                                                                         inContainerView:[UIApplication sharedApplication].keyWindow
                                                                       useBlurBackground:YES
                                                                                 popType:LVShowPopViewTypeBottom];
            popViewHandler.backgroundView.enabled = YES;
            
            sheetView.popViewHandler = popViewHandler;
        }];
    }else {
        
        [sheetView setButtonTitles:titles];
        sheetView.buttonPressedBlock = buttonPressedBlock;
        
        LVShowPopViewHandler *popViewHandler = [LVShowPopViewHandler showContentView:sheetView
                                                                     inContainerView:[UIApplication sharedApplication].keyWindow
                                                                   useBlurBackground:YES
                                                                             popType:LVShowPopViewTypeBottom];
        popViewHandler.backgroundView.enabled = YES;

        sheetView.popViewHandler = popViewHandler;
    }
}

+ (instancetype)sharedSheetView
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:CGRectMake(0, 0, YYScreenSize().width, 0) buttonTitles:nil];
}

- (instancetype)initWithFrame:(CGRect)frame buttonTitles:(NSArray <NSString *> *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _buttonWidth = YYScreenSize().width;
        _buttonHeight = 50;
        _lastButtonGap = 5;
        _buttons = [NSMutableArray array];
        
        [self setButtonTitles:titles];
        
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.width, 8)];
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = UIColorHex(0x000000).CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
        self.layer.shadowOpacity = 0.3f;
        self.layer.shadowPath = shadowPath.CGPath;
        
    }
    return self;
}

- (UIButton *)makeButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setSize:CGSizeMake(_buttonWidth, _buttonHeight)];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorHexAndAlpha(0xffffff, 0.75) size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xD6D8DB) size:CGSizeMake(20, 20)] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColorHex(0x000000) forState:UIControlStateNormal];
    [button.titleLabel setFont:LKFont(18)];
    
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)addExtraViewToTail
{
    if (!_tailView) {
        _tailView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 100)];
        [_tailView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_tailView];
        [self setClipsToBounds:NO];
    }
}

#pragma mark - Setter

- (void)setButtonTitles:(NSArray <NSString *> *)titles
{
    [_buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [(NSMutableArray *)_buttons removeAllObjects];
    
    CGFloat extraBottomHeight = 0;
    
    if (@available(iOS 11.0, *)) {
        extraBottomHeight = [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
    }
    
    CGFloat viewTotalHeight = titles.count * _buttonHeight + _lastButtonGap + titles.count*1 + extraBottomHeight;
    [self setHeight:viewTotalHeight];
    
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [self makeButtonWithTitle:obj];
        [button setTag:idx];
        [self addSubview:button];
        
        if (idx == titles.count - 1) {// last button
            [button setTop:viewTotalHeight - _buttonHeight - extraBottomHeight];
        }else {
            [button setTop:idx*_buttonHeight + idx*1];
        }
        
        [(NSMutableArray *)_buttons addObject:button];
        
    }];
    
    [self addExtraViewToTail];
    
    _tailView.top = self.height - extraBottomHeight;
    _tailView.height = extraBottomHeight;
}

#pragma mark - IBAction

- (IBAction)buttonPressed:(UIButton *)button
{
    [button setEnabled:NO];
    [self performSelector:@selector(delayEnabledButton:) withObject:button afterDelay:0.4];
    
    [self.popViewHandler dissmiss];
    self.popViewHandler = nil;
    
    if (self.buttonPressedBlock) {
        self.buttonPressedBlock(button.tag, button);
    }
}

- (void)delayEnabledButton:(UIButton *)button
{
    [button setEnabled:YES];
}

#pragma mark - dissmiss

- (void)dissmiss
{
    @weakify(self)
    [self.popViewHandler dissmissWithCompletion:^{
        @strongify(self)
        
        self.popViewHandler = nil;
    }];
}

- (void)dissmissWithCompletion:(void(^)(void))completion
{
    @weakify(self)
    [self.popViewHandler dissmissWithCompletion:^{
        @strongify(self)

        self.popViewHandler = nil;
        
        if (completion) {
            completion();
        }
        
    }];
}

@end

