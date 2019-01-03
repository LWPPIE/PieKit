//
//  LKDefaultImageView.m
//  LKNovelty
//
//  Created by RoyLei on 16/12/16.
//  Copyright © 2016年 Laka. All rights reserved.
//

#import "LKDefaultImageView.h"
#import "LKGradientImageView.h"
#import "UIImageView+LKWebImage.h"
#import "Masonry.h"

#import "LKMacros.h"
#import "LSYConstance.h"
#import <YYKit/UIView+YYAdd.h>
#import <YYKit/UIColor+YYAdd.h>

#import "LVUIUtils.h"

@interface LKDefaultImageView()

@property (strong, nonatomic) UIImageView *topImageView;
@property (strong, nonatomic) UIImageView *coverImageView;
@property (strong, nonatomic) UIImageView *bgMaskView;

@end

@implementation LKDefaultImageView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        
        [self setContentMode:UIViewContentModeCenter];
        [self setBackgroundColor:UIColorHex(0xefeff7)];
        
        [self addSubview:self.topImageView];
        [self setupConstraints];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(nullable UIImage *)highlightedImage
{
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if (self) {
        
        [self setContentMode:UIViewContentModeCenter];
        [self setBackgroundColor:UIColorHex(0xefeff7)];
        
        [self addSubview:self.topImageView];
        [self setupConstraints];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setContentMode:UIViewContentModeCenter];
        [self setBackgroundColor:UIColorHex(0xefeff7)];

        [self addSubview:self.topImageView];
        [self setupConstraints];

    }
    return self;
}

- (instancetype)initWithGradientFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setContentMode:UIViewContentModeCenter];
        [self setBackgroundColor:UIColorHex(0xefeff7)];

        [self setupGradientImageView];
        [self addSubview:_topImageView];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

/**
 增加过度效果显示图片
 
 @param imageURLStr image Url String
 */
- (void)setImageFadeWithURLStr:(NSString *)imageURLStr
{
    [self.topImageView lk_setImageFadeWithURLStr:imageURLStr];
}

- (void)setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr
{
    [self.topImageView lk_setImageFadeAndBlurWithURLStr:imageURLStr];
}

- (void)setImage:(NSString *)imageURL completion:(SDExternalCompletionBlock)completion
{
    [self.topImageView lk_setImageFadeWithURLStr:imageURL placeholder:nil completion:completion];
}

- (void)setImageFadeWithURLStr:(NSString *)imageURLStr querySize:(CGSize)querySize
{
    [self.topImageView lk_setImageFadeWithURLStr:imageURLStr querySize:querySize];
}

#pragma mark - Getter

- (UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_topImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_topImageView setUserInteractionEnabled:YES];
        [_topImageView setClipsToBounds:YES];
    }
    
    return _topImageView;
}

- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_coverImageView setClipsToBounds:YES];
        [_coverImageView setHidden:YES];
        
        [self addSubview:_coverImageView];
        
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    
    return _coverImageView;
}

- (UIImageView *)bgMaskView
{
    if (!_bgMaskView) {
        _bgMaskView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_bgMaskView setClipsToBounds:YES];
        [_bgMaskView setUserInteractionEnabled:NO];
        [_bgMaskView setBackgroundColor:UIColorWithHexAndAlpha(0x000000, 0.15)];
        _bgMaskView.alpha = 0.0f;
        
        [self addSubview:_bgMaskView];
        [self bringSubviewToFront:_coverImageView];

        [_bgMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return _bgMaskView;
}

- (UIImageView *)setupGradientImageView
{
    if (!_topImageView) {
        _topImageView = [[LKGradientImageView alloc] initWithGradientFrame:self.bounds];
        [_topImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_topImageView setUserInteractionEnabled:YES];
        [_topImageView setClipsToBounds:YES];
        _topImageView.backgroundColor = [UIColor clearColor];
    }
    
    return _topImageView;
}

@end
