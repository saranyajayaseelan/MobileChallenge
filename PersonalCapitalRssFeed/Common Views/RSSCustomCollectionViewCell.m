//
//  RSSCustomCollectionViewCell.m
//  PersonalCapitalRssFeed
//
//  Created by Saranya Jayaseelan on 5/27/17.
//
//

#import "RSSCustomCollectionViewCell.h"
#import "RSSFeedArticleItem.h"
#import "AsyncImageCellCache.h"

#define summaryHeight 30
#define titleHeight 30

@implementation RSSCustomCollectionViewCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        if(self.articleImage == nil) {
            self.articleImage =  [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - summaryHeight)];
            self.articleImage.backgroundColor = [UIColor clearColor];
            self.articleImage.clipsToBounds = YES;
            self.articleImage.contentMode = UIViewContentModeScaleAspectFill;
            self.articleImage.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [self addSubview:self.articleImage];
        }
        if(!self.articleSummary) {
            self.articleSummary = [[CustomLabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - summaryHeight, self.frame.size.width,summaryHeight)];
            self.articleSummary.numberOfLines = 2;
            self.articleSummary.backgroundColor = [UIColor clearColor];
            self.articleSummary.font = [UIFont fontWithName:@"Helvetica" size: 12];
            [self addSubview:self.articleSummary];
        }
        
        //SpinnerView
        if(!self.spinnerView) {
            self.spinnerView = [[SpinnerView alloc]initWithFrame:self.bounds];
        }
        
        // Adding border to cell
        [self layer].borderColor=[UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:0.9].CGColor;
        [self layer].borderWidth=1;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.selected = NO;
    [self.articleTitle removeFromSuperview];
    self.articleTitle = nil;
    self.articleImage.image = nil;
}

// stringByStrippingHTML  converts the html String to default string
- (NSString *)stringByStrippingHTML:(NSString *)_text {
    NSRange r;
    NSString *s = _text;
    while((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

// setArticleItem binds the model to UI
- (void)setArticleItem:(RSSFeedArticleItem *)_articleItem indexPath:(NSIndexPath *)_indexpath {
    //Summary
    if(_indexpath.section == 0) {
        if(!self.articleTitle) {
            self.articleTitle = [[CustomLabel alloc]initWithFrame:CGRectMake(0,self.frame.size.height - (summaryHeight + titleHeight),self.frame.size.width,titleHeight)];
            self.articleTitle.numberOfLines = 1;
            self.articleTitle.backgroundColor = [UIColor clearColor];
            self.articleTitle.font = [UIFont fontWithName:@"Helvetica" size: 15];
            self.articleTitle.font = [UIFont boldSystemFontOfSize:15];
            [self addSubview:self.articleTitle];
        } else {
            self.articleTitle.frame = CGRectMake(0,self.frame.size.height - (summaryHeight + titleHeight),self.frame.size.width,titleHeight);
        }
        self.articleTitle.text = _articleItem.title;
        self.articleImage.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height - (summaryHeight + titleHeight));
        self.articleSummary.text = [self stringByStrippingHTML:_articleItem.itemDescription];
    } else {
        self.articleSummary.text = _articleItem.title;
        self.articleImage.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height - summaryHeight);
    }
    self.articleSummary.frame = CGRectMake(0,self.frame.size.height - summaryHeight,self.frame.size.width,summaryHeight);

    //Image
    self.spinnerView.frame =  self.articleImage.bounds;
    [self loadImageIntoCell:_articleItem.media];
}


// loadImageIntoCell downloads image asynchronously and caching the image
- (void) loadImageIntoCell:(NSString *)mediaURL {
    UIImage *cachedImage = [[AsyncImageCellCache sharedInstance] getCachedImageForKey:mediaURL];
    if(cachedImage) {
        self.articleImage.image = cachedImage;
    } else {
        [self addSubview:self.spinnerView];
        self.spinnerView.spinner.center = self.articleImage.center;
        
        //1 Starting the spinner
        [self.spinnerView startAnimation];
        
        //2 Converting string to  URL
        NSURL *url = [NSURL URLWithString:mediaURL];
        
        // Downloading imaging URL's asynchronously in backround Thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
            //3 Downloading URL asynchronously
            NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]
                                                           downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            //4 Updating the UI
            UIImage *downloadedImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:location]];
                                                               
            dispatch_sync(dispatch_get_main_queue(), ^(void) {
                //5 Resizing the downloaded image
                self.articleImage.image = [self imageWithImage: downloadedImage scaledToFillSize:self.articleImage.frame.size];
                //[self setNeedsLayout];
              
                //6 Saving in Cache
                [[AsyncImageCellCache sharedInstance]  cacheImage:self.articleImage.image forKey:mediaURL];
               
                //7 Ending the spinner
                [self stopAnimation];
            });
            }];
            [downloadPhotoTask resume];
        });
    }
}

// Image Resizing
- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size {
    CGFloat scale = MAX(size.width / image.size.width, size.height / image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width) / 2.0f,(size.height - height) / 2.0f,width,height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// Stopping Spinner
- (void)stopAnimation {
    [self.spinnerView removeFromSuperview];
    [self.spinnerView stopAnimation];
}


@end
