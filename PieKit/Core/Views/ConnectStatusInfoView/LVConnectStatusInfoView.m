//
//  LVConnectStatusInfoView.m
//  Live
//
//  Created by 熙文 张 on 16/3/29.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "LVConnectStatusInfoView.h"

#import "LSYConstance.h"
#import "UIView+YYAdd.h"
#import "YYCGUtilities.h"
#import "LKMacros.h"
#import "Masonry.h"
#import "LVUIUtils.h"

@implementation LVConnectStatusInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self setUserInteractionEnabled:YES];
    
    WS(weakSelf);
    UIView *centerView = [UIView new];
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
    
    [centerView addSubview:[self infoImageView]];
    [centerView addSubview:[self infoLabel]];
    
    [_infoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(centerView.mas_centerX);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(centerView.mas_centerX);
        make.top.mas_equalTo(_infoImageView.mas_bottom).with.offset(30);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - Getter

- (UIImageView *)infoImageView
{
    if (!_infoImageView)
    {
        _infoImageView = [UIImageView new];
        [_infoImageView setContentMode:UIViewContentModeCenter];
    }
    
    return _infoImageView;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel)
    {
        _infoLabel = [[UILabel alloc] init];
        [_infoLabel setTextAlignment:NSTextAlignmentCenter];
        [_infoLabel setFont:[UIFont systemFontOfSize:14]];
        [_infoLabel setTextColor:UIColorWithHex(0x686677)];//kColor333
    }
    
    return _infoLabel;
}

@end
