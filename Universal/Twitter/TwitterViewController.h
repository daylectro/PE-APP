//
// TwitterViewController.h
//
// Copyright (c) 2018 Sherdle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MWFeedParser.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "MWFeedParser.h"

#import "FHSTwitterEngine.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "CardCell.h"

@interface TwitterViewController : STableViewController <CardCellDelegate, FHSTwitterEngineAccessTokenDelegate> {
    NSMutableArray *parsedItems;
    
    NSDateFormatter *formatter;
    int count;
    NSDictionary *jsonDict;
}

@property(strong,nonatomic)NSArray *params;

@property(strong,nonatomic)NSString *screenName;
@property(strong,nonatomic) NSMutableArray *tweetsArray;
@property(strong,nonatomic)NSString *latestTweetID;

@end
