//
//  LSYSectionHeaderView.m
//  TTClub
//
//  Created by RoyLei on 15/7/1.
//  Copyright (c) 2015年 TTClub. All rights reserved.
//

#import "LSYSectionHeaderView.h"
#import "LSYConstance.h"
#import "UIView+YYAdd.h"
#import "YYCGUtilities.h"
#import "LKMacros.h"
#import "Masonry.h"
#import "LVUIUtils.h"

@interface LSYSectionHeaderView()

@property(nonatomic, readwrite, strong) UIImageView  *leftImageView;
@property(nonatomic, readwrite, strong) UILabel      *titleLabel;
@property(nonatomic, readwrite, strong) UIButton     *rightButton;

@end

@implementation LSYSectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil != self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    return self;
}

#pragma mark - Getter

- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,20,20}];
        [self addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel =  ({
            UILabel *titleLable = [[UILabel alloc] initWithFrame:(CGRect){15,0,CGRectGetWidth(self.bounds)-52-20,self.height}];
            [titleLable setBackgroundColor:[UIColor clearColor]];
            [titleLable setTextAlignment:NSTextAlignmentLeft];
            titleLable.textColor = UIColorWithHex(0xffffff);
            titleLable.font = LKUIFont(15);
            titleLable;
        });
        
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = (CGRect){0,0,self.width,self.height};
            [btn.titleLabel setFont:LKUIFont(14)];
            [btn setImageEdgeInsets:(UIEdgeInsets){0,self.width-52,0,0}];
            [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        
        [self addSubview:_rightButton];
    }
    
    return _rightButton;
}

- (void)buttonPressed:(id)sender
{
    WS(weakSelf)
    if (self.rightButtonPressedBlock) {
        self.rightButtonPressedBlock(weakSelf);
    }
}

@end
