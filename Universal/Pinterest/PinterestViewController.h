//
//  PinterestViewController.h
//
//  Copyright (c) 2018 Sherdle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardCell.h"
#import "SocialFetcher.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "STableViewController.h"

@interface PinterestViewController : STableViewController <CardCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property(strong,nonatomic)NSArray *params;
@property(strong,nonatomic)NSMutableArray *postItems;

@end
