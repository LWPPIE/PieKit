//
//  LSYHeaderMenuSubView.m
//  TTClub
//
//  Created by RoyLei on 15/7/22.
//  Copyright (c) 2015年 TTClub. All rights reserved.
//

#import "LSYHeaderMenuSubView.h"
#import "UIView+YYAdd.h"

@implementation LSYHeaderMenuSubView
@synthesize buttonWidth = _buttonWidth;
@synthesize buttonMargin = _buttonMargin;

- (instancetype)initWithTitles:(NSArray *)titles
{
    self = [super initWithTitles:titles];
    if (self) {
        
        self.lineWidth = 20;
        self.fitSliderLineWidth = NO;
    }
    return self;
}

- (void)setButtonsAndSelfFrame
{
    _buttonWidth = roundf(self.width/self.buttons.count);
    _buttonMargin = 0;
    
    __block CGRect butnRect = CGRectMake(0, 0, _buttonWidth, self.height);
    
    [self.buttons enumerateObjectsUsingBlock:^(LSYTitleButton *butn, NSUInteger idx, BOOL *stop) {
        
        [butn setFrame:CGRectIntegral(butnRect)];
        butnRect.origin.x += butn.width;
    }];
    
    [self.sliderLine setTop:self.height - self.lineBottomMargin];
    [self.sliderLine setCenterX:self.selectButn.centerX];
}

@end
