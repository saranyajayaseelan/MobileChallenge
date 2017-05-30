//
//  ViewController.h
//  PersonalCapitalRssFeed
//
//  Created by Saranya Jayaseelan on 5/23/17.
//
//

#import <UIKit/UIKit.h>
#import "RSSFeedParser.h"
#import "SpinnerView.h"

@interface ViewController : UIViewController <NSXMLParserDelegate,RSSFeedParserDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    RSSFeedParser *xmlParserObject;             //  NSXMLParser
    SpinnerView *spinnerView;                   //  Activity Indiacator while parsing
    UIDeviceOrientation currentOrientation;     //  Holds current device orientation
}

@property (nonatomic, retain) NSArray *feedArticles;    // Source of CollectionView
@property (nonatomic, retain) UICollectionView *collectionView;

@end

