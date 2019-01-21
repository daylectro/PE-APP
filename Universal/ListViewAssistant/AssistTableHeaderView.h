//
// AssistTableHeaderView.h
//
// Copyright (c) 2018 Sherdle. All rights reserved.
//
// Implements: STTableViewController
// Copyright (C) 2011 by BJ Basañes, http://shikii.net under MIT
//

#import <UIKit/UIKit.h>


@interface AssistTableHeaderView : UIView {
  UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
