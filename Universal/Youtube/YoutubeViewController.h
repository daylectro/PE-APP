//
// YoutubeViewController.h
//
// Copyright (c) 2018 Sherdle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MWFeedParser.h"

typedef enum YouTubeType : NSUInteger {
    playlist,
    live,
    channel
} YouTubeType;

@interface YoutubeViewController : STableViewController <UISearchBarDelegate> {
  
    NSMutableArray *parsedItems;
    UITableView *tableView;
    
    NSDateFormatter *formatter;
    int count;
    NSDictionary *jsonDict;
    NSString *pageToken;
    
    UISearchBar *searchBar;
    UIBarButtonItem *searchButton;
    UIBarButtonItem *cancelButton;
    NSString *query;
    
    YouTubeType type;

}

@property(strong,nonatomic)NSArray *params;

@end
