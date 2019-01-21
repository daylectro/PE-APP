//
//  MapsViewController.h
//
//  Copyright (c) 2018 Sherdle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapsViewController : UIViewController <GMSMapViewDelegate>

@property(strong,nonatomic)NSArray *params;

@property(strong,nonatomic)UIActivityIndicatorView *loadingIndicator;

@end
