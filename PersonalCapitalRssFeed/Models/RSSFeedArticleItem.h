//
//  RSSFeedArticleItem.h
//  PersonalCapitalRssFeed
//
//  Created by Saranya Jayaseelan on 5/23/17.
//
//

#import <Foundation/Foundation.h>

@interface RSSFeedArticleItem : NSObject {
    NSString *title;
    NSString *media;
    NSString *itemDescription;
    NSDate   *pubDate;
    NSString  *link;
}

@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *media;
@property (nonatomic,retain) NSString *itemDescription;
@property (nonatomic,retain) NSDate *pubDate;
@property (nonatomic, retain) NSString *link;

@end
