//
//  RSSFeedParser.h
//  PersonalCapitalRssFeed
//
//  Created by Saranya Jayaseelan on 5/25/17.
//
//

#import <Foundation/Foundation.h>
#import "RSSFeedArticleItem.h"

// Delegate
@protocol RSSFeedParserDelegate <NSObject>
@optional
- (void)feedParserDidFinish: (NSArray *) allFeedItems;
@end

@interface RSSFeedParser : NSXMLParser<NSXMLParserDelegate> {
     NSString *currentElement;
     NSString *currentPath;
}

@property (nonatomic, strong) RSSFeedArticleItem *rssFeeditem;
@property (nonatomic, strong) NSMutableArray *feedItems;
@property (nonatomic, assign) id <RSSFeedParserDelegate> parserDelegate;
@property (nonatomic, retain) NSString *feedsTitle;

@end

