//
//  DetailViewController.m
//  PersonalCapitalRssFeed
//
//  Created by Saranya Jayaseelan on 26/05/17.
//  Copyright © 2017 Saranya Jayaseelan. All rights reserved.
//

#import "DetailViewController.h"


@implementation DetailViewController
@synthesize weblink,articleTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = articleTitle;
    [self loadWebView];
}

- (void)viewWillLayoutSubviews {
    [super  viewWillLayoutSubviews];
    [detailWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
}

#pragma mark load Article link

- (void)loadWebView {
    detailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    NSString *urlAddress = weblink;
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    detailWebView.delegate=self;
    [self.view addSubview:detailWebView];
    [self loadMainActivityIndicator:self.view];
    [detailWebView loadRequest:requestObj];
}

#pragma mark webView Delegates

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.spinnerView removeFromSuperview];
    [self.spinnerView stopAnimation];
}

#pragma mark - Loading

-(void)loadMainActivityIndicator:(UIView *)view {
    self.spinnerView = [[SpinnerView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.spinnerView];
    [self.spinnerView startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
