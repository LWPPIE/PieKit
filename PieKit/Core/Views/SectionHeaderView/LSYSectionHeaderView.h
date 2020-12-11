//
//  LSYSectionHeaderView.h
//  TTClub
//
//  Created by RoyLei on 15/7/1.
//  Copyright (c) 2015年 TTClub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSYSectionHeaderView : UIView

@property(nonatomic, readonly) UIImageView  *leftImageView;
@property(nonatomic, readonly) UILabel      *titleLabel;
@property(nonatomic, readonly) UIButton     *rightButton;

@property(nonatomic, copy)void (^rightButtonPressedBlock)(LSYSectionHeaderView *view);

@end
