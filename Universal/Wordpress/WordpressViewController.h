//
// WordpressViewController.h
//
// Copyright (c) 2018 Sherdle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MWFeedParser.h"
#import "WordpressProvider.h"

@interface WordpressViewController : STableViewController <UISearchBarDelegate> {
  
    NSMutableArray *parsedItems;
    
    NSDateFormatter *formatter;
    int page;
    id <WordpressProvider> provider;
    
    UISearchBar *searchBar;
    UIBarButtonItem *searchButton;
    UIBarButtonItem *cancelButton;
    NSString *query;
    
    UIRefreshControl * refresher;

}

@property(strong,nonatomic)NSArray *params;

@end
