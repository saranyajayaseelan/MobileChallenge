//
//  CustomLabel.m
//  PersonalCapitalRssFeed
//
//  Created by Saranya Jayaseelan on 5/28/17.
//
//

#import "CustomLabel.h"

@implementation CustomLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIEdgeInsets insets = {0, 5, 0, 0};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}


@end
