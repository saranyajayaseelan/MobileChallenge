//
//  RSSFeedParser.m
//  PersonalCapitalRssFeed
//
//  Created by Saranya Jayaseelan on 5/25/17.
//
//

#import "RSSFeedParser.h"


@implementation RSSFeedParser
@synthesize  parserDelegate;

- (instancetype)initWithData:(NSData *)data {
    if(self = [super initWithData:data]) {
        self.feedItems = [NSMutableArray array];
        [self setDelegate:self];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName attributes: (NSDictionary *)attributeDict {
    currentElement = elementName;
    
    // Initialize variables if item tag found
    if([elementName isEqualToString:@"item"]) {
        self.rssFeeditem = [[RSSFeedArticleItem alloc] init];
        currentPath = @"";
        
    // Initialize items if media:content tag found
    } else if([currentElement isEqualToString:@"media:content"]) {
        NSString *mediaURL = [attributeDict objectForKey:@"url"];
        self.rssFeeditem.media.length == 0 ? self.rssFeeditem.media = mediaURL : [self.rssFeeditem.media stringByAppendingString:mediaURL];
    
    // Initialize items if channel tag found
    } else if([elementName isEqualToString:@"channel"]) {
        currentPath = @"channel";
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if([currentPath isEqualToString:@"channel"] && [currentElement isEqualToString:@"title"]) {
        
        // get Feeds title from channel
        self.feedsTitle.length == 0 ? self.feedsTitle = string : [self.feedsTitle stringByAppendingString:string];
    } else if([currentElement isEqualToString:@"title"]) {
       
        // get Article title from item
        self.rssFeeditem.title.length == 0 ? self.rssFeeditem.title = string : [self.rssFeeditem.title stringByAppendingString:string];
    } else if([currentElement isEqualToString:@"description"]) {
        
        // get Article description from item
        self.rssFeeditem.itemDescription.length == 0 ? self.rssFeeditem.itemDescription = string : [self.rssFeeditem.itemDescription stringByAppendingString:string];
    } else if([currentElement isEqualToString:@"link"]) {
       
        // get Article link from item
         self.rssFeeditem.link.length == 0 ? self.rssFeeditem.link = string : [self.rssFeeditem.link stringByAppendingString:string];
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"item"]) {
        [self.feedItems addObject:self.rssFeeditem];
    }
}

//parserDidEndDocument acknowledge the end of parsing and return back to Main UI.
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if([ self.parserDelegate respondsToSelector:@selector(feedParserDidFinish:)])
        [self.parserDelegate feedParserDidFinish: self.feedItems];
}

@end
