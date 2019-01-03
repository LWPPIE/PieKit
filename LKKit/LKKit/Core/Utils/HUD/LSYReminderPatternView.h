//
//  LSYReminderPatternView.h
//  TTClub
//
//  Created by RoyLei on 15/7/17.
//  Copyright (c) 2015年 TTClub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSYReminderPatternView : UIView
{
    CAShapeLayer  *_pathLayer;
    UIBezierPath  *_progressPath;
}
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat sectorWidth;
@property (nonatomic, assign) CGFloat percentage;

@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *drawColor;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIImage                 *image;
@property (nonatomic, assign) BOOL                     isProgressing;

- (void)setFinished;

@end