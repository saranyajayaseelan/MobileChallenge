//
//  RSSCustomCollectionViewCell.h
//  PersonalCapitalRssFeed
//
//  Created by Saranya Jayaseelan on 5/27/17.
//
//

#import <UIKit/UIKit.h>
#import "RSSFeedArticleItem.h"
#import "SpinnerView.h"
#import "CustomLabel.h"

@interface RSSCustomCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain)  UIImageView *articleImage;
@property (nonatomic, retain)  CustomLabel *articleSummary;
@property (nonatomic, retain)  CustomLabel *articleTitle;
@property (nonatomic, retain)  SpinnerView *spinnerView;

-(void)setArticleItem : (RSSFeedArticleItem *)_articleItem indexPath : (NSIndexPath *)_indexpath;

@end
