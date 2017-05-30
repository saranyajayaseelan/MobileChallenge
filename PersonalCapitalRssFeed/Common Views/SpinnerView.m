//
//  SpinnerView.m
//  PersonalCapitalRssFeed
//
//  Created by Saranya Jayaseelan on 5/28/17.
//

#import "SpinnerView.h"

@implementation SpinnerView
@synthesize spinner;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.layer.backgroundColor = [[UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:0.9] CGColor];
        spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.layer.cornerRadius = 05;
        spinner.opaque = NO;
        spinner.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        spinner.center = self.center;
        spinner.color =  [UIColor whiteColor];
        [self addSubview:spinner];
    }
    return self;
}

- (void)startAnimation {
    [spinner startAnimating];
}

- (void)stopAnimation {
    [self removeFromSuperview];
    [spinner stopAnimating];
}


@end
