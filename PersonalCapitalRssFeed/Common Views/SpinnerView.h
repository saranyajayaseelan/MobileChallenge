//
//  SpinnerView.h
//  PersonalCapitalRssFeed
//
//  Created by Saranya Jayaseelan on 5/28/17.
//

#import <UIKit/UIKit.h>

@interface SpinnerView : UIView {
    UIActivityIndicatorView *spinner;
}

@property (nonatomic,retain) UIActivityIndicatorView *spinner;

- (void)startAnimation;
- (void)stopAnimation;

@end
