//
//  DetailViewController.h
//  PersonalCapitalRssFeed
//
//  Created by Saranya Jayaseelan on 26/05/17.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@interface DetailViewController : UIViewController<UIWebViewDelegate> {
    UIWebView *detailWebView;
}

@property (nonatomic, retain) SpinnerView *spinnerView;
@property (nonatomic, strong) NSString *weblink;
@property (nonatomic, strong) NSString *articleTitle;

@end
