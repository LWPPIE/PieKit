//
//  LKGradientImageView.m
//  Pods
//
//  Created by RoyLei on 16/12/7.
//
//

#import "LKGradientImageView.h"
#import "LSYConstance.h"
#import "Masonry.h"

static inline NSString *LKGradientImageViewResourcePath(NSString *subPath){
    return [[[NSBundle bundleForClass:[LKGradientImageView class]] resourcePath] stringByAppendingPathComponent:subPath];
}

#define LKGradientImage  [[UIImage imageNamed:LKGradientImageViewResourcePath(@"LKImage.bundle/public_icon_shade_bottom")] stretchableImageWithLeftCapWidth:15 topCapHeight:0]

@interface LKGradientImageView ()

@property (strong, nonatomic) UIImageView  *gradientImageView;

@end

@implementation LKGradientImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype)initWithGradientFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.gradientImageView];
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    [self.gradientImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - Getter

- (UIImageView *)gradientImageView
{
    if (!_gradientImageView) {
        
        UIImage *image = LKGradientImage;
        if (!image) {
            image = LKImage(@"public_icon_shade_bottom");
        }
        
        _gradientImageView = [[UIImageView alloc] initWithImage:image];
    }
    
    return _gradientImageView;
}


@end
