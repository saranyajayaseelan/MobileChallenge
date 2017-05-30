//
//  AsyncImageCellCache.m
//  PersonalCapitalRssFeed
//
//  Created by Saranya Jayaseelan on 5/28/17.
//
//

#import "AsyncImageCellCache.h"

static AsyncImageCellCache *sharedInstance;

@interface AsyncImageCellCache ()
@property (nonatomic, strong) NSCache *imageCache;
@end

@implementation AsyncImageCellCache

+ (AsyncImageCellCache *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AsyncImageCellCache alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.imageCache = [[NSCache alloc] init];
    }
    return self;
}

// cacheImage sets the image by key
- (void)cacheImage:(id)image forKey:(NSString*)key {
    [self.imageCache setObject:image forKey:key];
}

// getCachedImageForKey gets the image by key
- (id)getCachedImageForKey:(NSString*)key {
    return [self.imageCache objectForKey:key];
}

// clearCache clears cache
- (void)clearCache {
    [self.imageCache removeAllObjects];
}

@end
