//
//  ViewController.m
//  PersonalCapitalRssFeed
//
//  Created by Saranya Jayaseelan on 5/23/17.
//
//

#import "ViewController.h"
#import "RSSFeedParser.h"
#import "RSSCustomCollectionViewCell.h"
#import "AsyncImageCellCache.h"
#import "DetailViewController.h"


#define ItemCellInGap 20
#define FeedURL @"https://blog.personalcapital.com/feed/?cat=3,891,890,68,284"

@interface ViewController () {
    int     noOfCellPerRow,noOfSpacePerRow;
    CGFloat itemCellSize;
    UICollectionViewFlowLayout *flowLayout;
}

@end

@implementation ViewController

#pragma mark - Loading

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Refresh action to clear the cache and initiate the parser again and reload all the data's from the API.
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    self.navigationItem.rightBarButtonItem = button;
    
    // Add  activityIndicator while parsing
    [self loadMainActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        // Initialize parser
        [self initParser];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    currentOrientation = [[UIDevice currentDevice] orientation];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [flowLayout invalidateLayout];
  
    // Reloading collection View when orientation gets changed
    if(currentOrientation != [[UIDevice currentDevice] orientation]) {
       [self.collectionView reloadData];
        currentOrientation = [[UIDevice currentDevice] orientation];
    }
    
    // Resizing collectionView cells when orientation gets changed
    [self claculateItemSize];
}


//  Add activityIndicator in main View
- (void)loadMainActivityIndicator:(UIView *)view {
    spinnerView = [[SpinnerView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:spinnerView];
    [spinnerView startAnimation];
}

// Resizing collectionView cells when orientation gets changed
- (void)claculateItemSize {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        noOfCellPerRow = 3;
        noOfSpacePerRow = 2;
    } else {
        noOfCellPerRow = 2;
        noOfSpacePerRow = 1;
    }
    itemCellSize = ([[UIScreen mainScreen]bounds].size.width - (ItemCellInGap * noOfSpacePerRow)) / noOfCellPerRow;
}

// Refresh button action
- (void)refresh:(id)sender {
    // Removing collectionView data source
    self.feedArticles = nil;
   
    // Clearing cache
    [[AsyncImageCellCache sharedInstance] clearCache];
    [self.collectionView reloadData];
    [self.collectionView removeFromSuperview];
    
    // Add  activityIndicator while parsing
    [self loadMainActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        // Initialize parser
        [self initParser];
    });
}

// Initialize CollectionView
- (void)updateUI {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    flowLayout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    _collectionView.backgroundColor = [UIColor whiteColor];
    flowLayout.headerReferenceSize = CGSizeMake(20.0f,20.0f);
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_collectionView registerClass:[RSSCustomCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.view addSubview:_collectionView];
    [self claculateItemSize];
}

- (void)initParser {
    NSURL *feedURL = [NSURL URLWithString:FeedURL];
    NSData *xmlData = [[NSData alloc]initWithContentsOfURL:feedURL];
    xmlParserObject =[[RSSFeedParser alloc]initWithData:xmlData];
    xmlParserObject.parserDelegate = self;
    [xmlParserObject parse];
}

#pragma mark CollectionView Datasource & Delegates methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section == 0) {
        return 1;
    }
    return self.feedArticles.count - 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RSSCustomCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    RSSFeedArticleItem *item = (indexPath.section == 0) ? self.feedArticles.firstObject : self.feedArticles[indexPath.row + 1];
    // setArticleItem binds the model to UI
    [cell setArticleItem:item indexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return CGSizeMake([[UIScreen mainScreen]bounds].size.width - 10 ,300);
    } else {
        return CGSizeMake(itemCellSize,itemCellSize);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RSSFeedArticleItem *selectedItem = (indexPath.section == 0)? self.feedArticles.firstObject: [self.feedArticles objectAtIndex:indexPath.row + 1];
    NSString *embeddedLink = [selectedItem.link stringByAppendingString:@"?displayMobileNavigation=0"];
    
    // To load the detail View
    DetailViewController *detailView = [[DetailViewController alloc]init];
    detailView.weblink = embeddedLink;
    detailView.articleTitle = selectedItem.title;
    [self.navigationController pushViewController:detailView animated:NO];
}

//feedParserDidFinish acknowledge the end of parsing and update collectionView.
- (void)feedParserDidFinish: (NSArray *) allFeedItems {
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            self.title = xmlParserObject.feedsTitle;
            [self stopAnimation];
            if(self.collectionView == nil) {
                [self updateUI];
            } else {
                [self.view addSubview:self.collectionView];
            }
            self.feedArticles = allFeedItems;
            [self.collectionView reloadData];
        });
}

- (BOOL)shouldAutorotate {
    return YES;
}

//stopAnimation stops the spinner and remove from superview
- (void)stopAnimation {
    [spinnerView removeFromSuperview];
    [spinnerView stopAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
