//
//  AsyncImageCellCache.h
//  PersonalCapitalRssFeed
//
//  Created by Saranya Jayaseelan on 5/28/17.
//
//

#import <Foundation/Foundation.h>

@interface AsyncImageCellCache : NSObject

+ (AsyncImageCellCache*)sharedInstance;
- (void)cacheImage:(id)image forKey:(NSString*)key;
- (id)getCachedImageForKey:(NSString*)key;
- (void)clearCache;

@end
