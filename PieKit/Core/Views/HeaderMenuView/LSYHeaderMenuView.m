//
//  LSYHeaderMenuView.m
//  TTClub
//
//  Created by RoyLei on 15/7/16.
//  Copyright (c) 2015年 TTClub. All rights reserved.
//

#import "LSYHeaderMenuView.h"
#import "LSYZoomableLabel.h"
#import "LSYConstance.h"
#import "UIView+YYAdd.h"
#import "YYCGUtilities.h"
#import "LKMacros.h"
#import "Masonry.h"
#import "LVUIUtils.h"
#import "NSObject+YYAddForKVO.h"

#define CustomWidth   UI_SCREEN_WIDTH / 3.0

NSInteger const LSYHeaderMenuViewDefaultHeight = 44;

@implementation LSYTitleButton
@synthesize titleLabel = _titleLabel;

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[self titleLabel]];
    }
    return self;
}

- (void)stopTiledRenderingAndRemoveFromSuperlayer {
    ((CATiledLayer *)[self.titleLabel layer]).delegate = nil;
    self.titleLabel.layer.contents = nil;
    [self.titleLabel removeFromSuperview];
    [self.titleLabel.layer removeFromSuperlayer];
}

- (void)dealloc
{
    [self stopTiledRenderingAndRemoveFromSuperlayer];
}

- (LSYZoomableLabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel =  ({
            LSYZoomableLabel *titleLabel = [[LSYZoomableLabel alloc] initWithFrame:(CGRect){0,0,60,24}];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            titleLabel.contentScaleFactor = [UIScreen mainScreen].scale;
            titleLabel.layer.rasterizationScale = [[UIScreen mainScreen] scale];
            titleLabel;
        });
    }
    
    return _titleLabel;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.titleLabel setFrame:self.bounds];
}

@end

@interface LSYHeaderMenuView()
{
    BOOL                _solButton;
    CGFloat             _lineHeight;
    UIView              *_sliderLine;
    LSYTitleButton      *_selectButn;
    
    BOOL                _setSliderViewFollowScroll;
    CGFloat             _lastScalePercent;
    CGFloat             _tmpMargin;
}

@property (strong, nonatomic) UIScrollView *contentView;

@end

@implementation LSYHeaderMenuView

- (instancetype)init
{
    return [self initWithTitles:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithTitles:nil];
}

- (id)initWithTitles:(NSArray *)titles
{
    self = [super initWithFrame:(CGRect){0,0,YYScreenSize().width, LSYHeaderMenuViewDefaultHeight}];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _titleSelectedFont = LSYHeaderMenuViewTitleLargeFontSize;
        _titleNormalFont = LSYHeaderMenuViewTitleNormalFontSize;

        _buttons       = [[NSMutableArray alloc] initWithCapacity:titles.count];
        _solButton     = titles.count == 1 ? YES : NO;
        _lineHeight    = 2;
        _buttonMargin  = 12;
        _isEnabled     = YES;
        _selectedIndex = 0;
        _titleNormalColor = UIColorWithHex(0x000000);
        _titleSelectedColor = UIColorWithHex(0xf65843);
        _scaleRate     = 1.1;
        _fitSliderLineWidth = YES;
        _lineMinWidth = 18;
        
        _contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.bounces = NO;
        _contentView.scrollsToTop = NO;
        [self addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        self.titles = [NSMutableArray arrayWithArray:titles];
        self.sliderLineFollowScrollView = YES;
        
        _sliderLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _lineMinWidth, _lineHeight)];
        [_contentView addSubview:_sliderLine];
        _sliderLine.hidden = _solButton;
        
        [self setLineBottomMargin:10];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserverBlocks];
}

- (LSYTitleButton *)makeButtonWithTilte:(NSString *)title
{
    LSYTitleButton *button = [LSYTitleButton new];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button setExclusiveTouch:YES];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button.titleLabel setText:title];
    [button.titleLabel setTextColor:self.titleNormalColor];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - Setter

- (void)setTitles:(NSMutableArray <NSString *> *)titles
{
    if (_titles != titles) {
        _titles = nil;
        _titles = titles;
                
        [_buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_buttons removeAllObjects];

        __block CGFloat buttonWidth = 0;
        [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            
            LSYTitleButton *butn = [self makeButtonWithTilte:title];
            butn.titleLabel.font = _titleNormalFont;
            [butn setTag:idx];
            [butn setEnabled:_solButton?NO:YES];
            
            [_contentView addSubview:butn];
            
            [_buttons addObject:butn];
            
            buttonWidth = [title boundingRectWithSize:(CGSize){320,32}
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName : _titleSelectedFont}
                                              context:nil].size.width + kDeviceRatio*8;
            
            _buttonWidth = MAX(_buttonWidth, buttonWidth);
            [butn setWidth:_buttonWidth];
        }];
        
        [_sliderLine setFrame:CGRectMake(0, 0, _lineMinWidth, _lineHeight)];

        //滑动块
//        _sliderLine.backgroundColor = _titleSelectedColor;
        
        //初始化默认选中0
        [self setSelectedIndex:0];
    }
}

- (void)addButtonsWithTitles:(NSArray<NSString *> *)titles
{
    [_titles addObjectsFromArray:titles];
    
    LSYTitleButton *lastButton = [_buttons lastObject];
    CGFloat lastButtonMaxX = CGRectGetMaxX(lastButton.frame);
    
    __block CGRect butnRect = CGRectMake(lastButtonMaxX, 0, 0, self.height);
    __block CGFloat buttonWidth = 0;

    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        
        LSYTitleButton *butn = [self makeButtonWithTilte:title];
        butn.titleLabel.font = _titleNormalFont;
        [butn setTag:idx+_buttons.count];
        
        [_contentView addSubview:butn];
        [_buttons addObject:butn];
        
        buttonWidth = [title boundingRectWithSize:(CGSize){320,32}
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName : _titleSelectedFont}
                                          context:nil].size.width + kDeviceRatio*8;
        
        _buttonWidth = MAX(_buttonWidth, buttonWidth);

        butnRect.size.width = _buttonWidth;
        [butn setFrame:CGRectIntegral(butnRect)];
        butnRect.origin.x   += butn.width + _buttonMargin;
    }];
    
    LSYTitleButton *butn = [_buttons lastObject];
    [self.contentView setContentSize:CGSizeMake(CGRectGetMaxX(butn.frame), LSYHeaderMenuViewDefaultHeight)];
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor
{
    if (_titleSelectedColor != titleSelectedColor) {
        _titleSelectedColor = nil;
        _titleSelectedColor = titleSelectedColor;
        
        [_selectButn.titleLabel setTextColor:titleSelectedColor];
    }
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor
{
    if (_titleNormalColor != titleNormalColor) {
        _titleNormalColor = nil;
        _titleNormalColor = titleNormalColor;
        
        [_buttons enumerateObjectsUsingBlock:^(LSYTitleButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (_selectButn != obj) {
                [obj.titleLabel setTextColor:titleNormalColor];
            }
        }];
    }
}

- (void)setTitleNormalFont:(UIFont *)titleNormalFont
{
    if (_titleNormalFont != titleNormalFont) {
        _titleNormalFont = nil;
        _titleNormalFont = titleNormalFont;
        
        [_buttons enumerateObjectsUsingBlock:^(LSYTitleButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (_selectButn != obj) {
                [obj.titleLabel setFont:titleNormalFont];
            }
        }];
    }
}

- (void)setTitleSelectedFont:(UIFont *)titleSelectedFont
{
    if (_titleSelectedFont != titleSelectedFont) {
        _titleSelectedFont = nil;
        _titleSelectedFont = titleSelectedFont;
        
        [_selectButn.titleLabel setFont:titleSelectedFont];
    }
}

- (void)setContentScrollView:(UIScrollView *)contentScrollView
{
    if (_contentScrollView != contentScrollView) {
        _contentScrollView = nil;
        _contentScrollView = contentScrollView;
        
        WS(weakSelf)
        [self addObserverBlockForKeyPath:@"_contentScrollView.contentOffset" block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
            [weakSelf scrollViewDidScroll:weakSelf.contentScrollView];
        }];
    }
}

- (void)setButtonMargin:(NSInteger)buttonMargin
{
    _buttonMargin = buttonMargin;
    [self setButtonsAndSelfFrame];
}

- (void)setLineBottomMargin:(CGFloat)lineBottomMargin
{
    _lineBottomMargin = lineBottomMargin;
    
    [_sliderLine setTop:self.height -_lineBottomMargin - _sliderLine.height];
    [_sliderLine setCenterX:_selectButn.centerX];
    
    [self setButtonsAndSelfFrame];
}

- (void)setLineMinWidth:(CGFloat)lineMinWidth
{
    _lineMinWidth = lineMinWidth;
    
    [_sliderLine setWidth:lineMinWidth];
    [_sliderLine setCenterX:_selectButn.centerX];
}

- (void)setSliderPosition
{
    while(_selectedIndex >= _buttons.count) {
        _selectedIndex--;
    }
    
    if (_buttons.count) {
        _selectButn = _buttons[self.selectedIndex];
        [_sliderLine setFrame:CGRectMake(CGRectGetMinX(_selectButn.frame) + (CGRectGetWidth(_selectButn.frame) - _lineMinWidth)/2,
                                         CGRectGetMinY(_sliderLine.frame),
                                         _lineMinWidth,
                                         CGRectGetHeight(_sliderLine.frame))];
    }
}

- (void)setButtonsAndSelfFrame
{
    __block CGRect butnRect = CGRectMake(0, 0, 0, self.height);
    
    [_buttons enumerateObjectsUsingBlock:^(LSYTitleButton *butn, NSUInteger idx, BOOL *stop) {
        
        butnRect.size.width = _buttonWidth;
        [butn setFrame:CGRectIntegral(butnRect)];
        butnRect.origin.x   += butn.width + _buttonMargin;
    }];
    
    LSYTitleButton *butn = [_buttons lastObject];
    [self setWidth:CGRectGetMaxX(butn.frame)];
    [self setHeight:LSYHeaderMenuViewDefaultHeight];
    
    [self.contentView setContentSize:CGSizeMake(CGRectGetMaxX(butn.frame), LSYHeaderMenuViewDefaultHeight)];
    
    self.sliderLine.centerX = _selectButn.centerX;
}

- (void)setIsEnabled:(BOOL)isEnabled
{
    if (_isEnabled != isEnabled) {
        _isEnabled = isEnabled;
        
        [_buttons enumerateObjectsUsingBlock:^(LSYTitleButton *butn, NSUInteger idx, BOOL *stop) {
            [butn setEnabled:isEnabled];
        }];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (selectedIndex >= _buttons.count) {
        return;
    }
    
    NSInteger lastIndex = _selectedIndex;
    
    _selectedIndex = selectedIndex;
    _selectButn    = _buttons[selectedIndex];
    
    [_buttons enumerateObjectsUsingBlock:^(LSYTitleButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == selectedIndex) {
            [obj setHighlighted:YES];
            [obj setSelected:YES];
            [obj.titleLabel setTextColor:self.titleSelectedColor];
            [obj.titleLabel setFont:_titleSelectedFont];
            if (_scaleRate > 1.0) {
                [obj.titleLabel setTransform:CGAffineTransformMakeScale(_scaleRate, _scaleRate)];
            }
        }else {
            [obj setHighlighted:NO];
            [obj setSelected:NO];
            [obj.titleLabel setFont:_titleNormalFont];
            [obj.titleLabel setTextColor:self.titleNormalColor];
            [obj.titleLabel setTransform:CGAffineTransformIdentity];
        }
    }];
    
    if (_buttons.count > 3) {
        
        CGRect nextButtonFrame = _selectButn.frame;
        
        nextButtonFrame = _selectButn.frame;
        
        /*
         *如果上一次选中的index大于当前要切换的index,则滚动显示出当前要选择的index的前两个
         *否则滚动显示出显示当前要选择的index的后两个
         */
        if (lastIndex > selectedIndex) {

            if (selectedIndex <= 1) {
                nextButtonFrame = [_buttons firstObject].frame;
            }else if(selectedIndex > 1) {
                nextButtonFrame = _buttons[selectedIndex - 2].frame;
            }
            
        }else if (lastIndex < selectedIndex) {

            if (_buttons.count <= selectedIndex + 2) {
                nextButtonFrame = [_buttons lastObject].frame;
            }else if (_buttons.count > selectedIndex + 2) {
                nextButtonFrame = _buttons[selectedIndex + 2].frame;
            }
        }
        
        nextButtonFrame.origin.x -= 40;
        nextButtonFrame.size.width += 80;

        [_contentView scrollRectToVisible:nextButtonFrame animated:YES];
    }
}

- (void)selectAnimationWithIndex:(NSInteger)index
                  withScrollView:(UIScrollView *)scrollView
{
    if (index >= _buttons.count ||
        index == _selectedIndex ) {
        return;
    }
    
    self.contentScrollView = scrollView;
    
    [scrollView setScrollEnabled:NO];
    self.sliderLineFollowScrollView = NO;
    
    [scrollView setContentOffset:CGPointMake(index*scrollView.width, 0)];
    
    [UIView animateWithDuration:0.2 animations:^{

        [_sliderLine setWidth:66];
        if (index > self.selectedIndex) {
            [_sliderLine setLeft:_selectButn.centerX - _buttonWidth/4.0];
        }else if (index < self.selectedIndex) {
            [_sliderLine setRight:_selectButn.centerX + _buttonWidth/4.0];
        }
    }];
    
    self.selectedIndex = index;

    [UIView animateWithDuration:0.8
                          delay:0.15
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.5
                        options:(UIViewAnimationOptionCurveEaseInOut)
                     animations:^{
                         [self setSliderPosition];
                     } completion:^(BOOL finished) {
                         self.sliderLineFollowScrollView = YES;
                         [scrollView setScrollEnabled:YES];
                     }];
}

- (void)setSliderLinePositionWithScrollView:(UIScrollView *)scrollView
{
    if (self.sliderLineFollowScrollView) {
        
        self.isEnabled = NO;

        CGFloat percent = scrollView.contentOffset.x / (scrollView.width*(self.buttons.count-1));
        CGFloat positionX = (self.width - _buttonWidth)*percent;
        CGFloat scalePercent = fabs(scrollView.width*self.selectedIndex - scrollView.contentOffset.x) / scrollView.width;

        [self setSliderLinePositionX:positionX withPercent:scalePercent withScrollView:scrollView];
    }
}

/**
 *  根据滚动位置，设置标题颜色以及放缩文字大小
 *
 *  @param positionX    Slider滚动的位置
 */
- (void)setSliderLinePositionX:(CGFloat)positionX
                   withPercent:(CGFloat)scalePercent
                withScrollView:(UIScrollView *)scrollView
{
    NSInteger toIndex = scrollView.contentOffset.x/scrollView.width;
    
//    NSLog(@"scrollView.contentOffset.x %0.2f",scrollView.contentOffset.x);
    
    if(scrollView.contentOffset.x < 0.0 ||
       scrollView.contentOffset.x > (_buttons.count-1)*scrollView.width + 5){
        return;
    }
    
    if (fabs(scrollView.contentOffset.x - self.selectedIndex*scrollView.width) < 0.1 ||
        scalePercent >= 1.00) {
        scalePercent = 1.0;
    }
    
    if (scrollView.contentOffset.x > self.selectedIndex*scrollView.width) {
        toIndex = self.selectedIndex + 1;
    }else if (scrollView.contentOffset.x < self.selectedIndex*scrollView.width) {
        toIndex = self.selectedIndex - 1;
    }

    if (toIndex < 0 || toIndex >= _buttons.count) {
        return;
    }
    
    LSYTitleButton *toButton = _buttons[toIndex];
    
    //放缩titleLabel的比例
    if (_scaleRate > 1.0) {
        
        CGFloat dScale = (_scaleRate - 1.00)*scalePercent;
        
        UIColor *color1 = [LVUIUtils getColorOfPercent:scalePercent between:self.titleNormalColor and:self.titleSelectedColor];
        UIColor *color2 = [LVUIUtils getColorOfPercent:scalePercent between:self.titleSelectedColor and:self.titleNormalColor];
        
        if (scalePercent <= 0.0 || scalePercent >= 1.0) {
            [toButton.titleLabel setTransform:CGAffineTransformMakeScale(1 + dScale, 1 + dScale) color:self.titleSelectedColor];
        }else {
            [_selectButn.titleLabel setTransform:CGAffineTransformMakeScale(_scaleRate - dScale, _scaleRate - dScale) color:color1];
            [toButton.titleLabel setTransform:CGAffineTransformMakeScale(1 + dScale, 1 + dScale) color:color2];
        }
    }
    
    if (scalePercent >= 1.0) {
        self.isEnabled = YES;
    }
    
    CGFloat dWidth = 0;

    if (scalePercent <= 0.5) {
        
        _tmpMargin = (CGRectGetMaxX(toButton.frame) - CGRectGetMaxX(_selectButn.frame));
        dWidth = fabs(_tmpMargin*2*scalePercent) + _lineMinWidth;
        
        [_sliderLine setWidth:dWidth];

        if (_tmpMargin > 0) {
            [_sliderLine setLeft:_selectButn.centerX - _lineMinWidth/2.0];
        }else {
            [_sliderLine setRight:_selectButn.centerX + _lineMinWidth/2.0];
        }
        
    }else {
        
        dWidth = fabs(_tmpMargin) * (1.0 - scalePercent) * 2 + _lineMinWidth;
        dWidth = MAX(dWidth, _lineMinWidth);
        
        [_sliderLine setWidth:dWidth];

        if (_tmpMargin > 0) {
            [_sliderLine setRight:toButton.centerX + _lineMinWidth/2.0];
        }else {
            [_sliderLine setLeft:toButton.centerX - _lineMinWidth/2.0];
        }
    }
    
    if (self.menuWillToIndexBlock) {
        self.menuWillToIndexBlock(toIndex, scalePercent);
    }
    
    if (scalePercent >= 1.0 && toIndex != self.selectedIndex) {
        
        if (self.menuPressedButtonBlock) {
            self.menuPressedButtonBlock(self, toIndex);
        }
        if (toIndex != _selectedIndex) {
            [self setSelectedIndex:toIndex];
        }
        
        [self setSliderPosition];
    }
}

#pragma mark - UIButton Action Handle

- (void)buttonPressed:(LSYTitleButton *)button
{
    if(self.isEnabled && self.menuPressedButtonBlock){
        self.menuPressedButtonBlock(self, button.tag);
        [self selectAnimationWithIndex:button.tag withScrollView:self.contentScrollView];
    }
}

#pragma mark - UIScrollView ContentOffset Observer

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]])
        return;
    
    [self setSliderLinePositionWithScrollView:scrollView];
}


@end
