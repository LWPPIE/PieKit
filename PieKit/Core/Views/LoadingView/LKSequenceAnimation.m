//
//  LKSequenceLoadingAnimation.m
//  LKNovelty
//
//  Created by Pie on 17/3/31.
//  Copyright © 2017年 Laka. All rights reserved.
//

#import "LKSequenceAnimation.h"
#import "Masonry.h"
@interface LKSequenceAnimation ()
@property (strong, nonatomic) YYAnimatedImageView *animatedImageView;
@property (strong, nonatomic) UIImageView         *staticStateImageView;
@end

@implementation LKSequenceAnimation

- (void)initImageViewUI:(UIView*)baseView
{
    CGSize imageSize = CGSizeMake(30, 30);
    NSString *imagePrefix = @"loading_page";
    
    if(_lineType == LKSequenceAnimationBig) {
        imagePrefix = @"loading_page";
        imageSize = CGSizeMake(45, 45);
    }
    
    NSMutableArray * imageArray = [NSMutableArray array];
    for (int i = 0; i < 32; i ++) {
        @autoreleasepool {
            if(i < 10)
            {
                NSString * str = [NSString stringWithFormat:@"%@%02d",imagePrefix, i];
                UIImage * image = [UIImage imageNamed:str];
                NSData *data = UIImagePNGRepresentation(image);
                [imageArray addObject:data];
            }
            else
            {
                NSString * str = [NSString stringWithFormat:@"%@%02d",imagePrefix, i];
                UIImage * image = [UIImage imageNamed:str];
                NSData *data = UIImagePNGRepresentation(image);
                [imageArray addObject:data];
            }
        }
    }
        
    UIImage *image = [[YYFrameImage alloc] initWithImageDataArray:imageArray oneFrameDuration:0.02 loopCount:0];
    // 显示多图
    self.animatedImageView = [[YYAnimatedImageView alloc] initWithImage:image];
    self.animatedImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.animatedImageView.hidden = YES;
    
    NSString *imageName = [NSString stringWithFormat:@"%@31", imagePrefix];
    self.staticStateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    self.staticStateImageView.contentMode = UIViewContentModeScaleAspectFit;

    if(_lineType == LKSequenceAnimationSmall)
    {
        [baseView addSubview:self.animatedImageView];
        [baseView addSubview:_staticStateImageView];
        self.animatedImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        _staticStateImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    }
    else
    {
        UIView * newView = [[UIView alloc] init];
        [baseView addSubview:newView];
        [newView addSubview:self.animatedImageView];
        [newView addSubview:_staticStateImageView];
        [newView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(baseView);
        }];
        
        [_animatedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(newView);
            make.height.width.mas_equalTo(imageSize.width);
        }];
        
        [_staticStateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(baseView);
            make.height.width.mas_equalTo(imageSize.width);
        }];
    }
}

- (void)startAnimation
{
    self.animatedImageView.hidden = NO;
    self.staticStateImageView.hidden = YES;
    self.animatedImageView.currentAnimatedImageIndex = 0;
    [self.animatedImageView startAnimating];
}

- (void)startAnimationHaveBeginAnimation
{
    [self startAnimation];
}

- (void)stopAnimation
{
    self.animatedImageView.hidden = YES;
    self.staticStateImageView.hidden = NO;
    self.animatedImageView.currentAnimatedImageIndex = 31;
    [self.animatedImageView stopAnimating];
}

@end
