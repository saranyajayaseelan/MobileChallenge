//
//  AppDelegate.m
//  PersonalCapitalRssFeed
//
//  Created by Saranya Jayaseelan on 5/23/17.
//
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:self.viewController];
    self.window.rootViewController = navigation;
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
