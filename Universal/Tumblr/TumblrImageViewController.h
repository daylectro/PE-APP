//
//  TumblrImageViewController.h
//  Universal
//
//  Created by Mu-Sonic on 10/11/2015.
//  Copyright © 2018 Sherdle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface TumblrImageViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableArray *imagesArray;
@property long fooIndex;

@end
