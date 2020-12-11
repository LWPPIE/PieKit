//
//  LKGradientImageView.h
//  Pods
//
//  Created by RoyLei on 16/12/7.
//
//

#import <UIKit/UIKit.h>

@interface LKGradientImageView: UIImageView

@property (strong, nonatomic, readonly) UIImageView  *gradientImageView;

/**
 生成渐变层初始化方法
 */
- (instancetype)initWithGradientFrame:(CGRect)frame;

@end


