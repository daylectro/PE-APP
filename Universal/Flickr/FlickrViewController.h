//
//  TumblrViewController.h
//
//  Copyright (c) 2018 Sherdle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *imagesArray;
    NSInteger _currentPage;
    id json;
}

@property(strong,nonatomic)NSArray *params;

@end
