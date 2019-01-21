//
//  WebViewController.h
//
//  Copyright (c) 2018 Sherdle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "JDFPeekabooCoordinator.h"
#import "NoConnectionView.h"

@interface WebViewController : UIViewController<WKNavigationDelegate>

@property (strong, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;

@property (nonatomic, strong) JDFPeekabooCoordinator *scrollCoordinator;

@property(strong,nonatomic) NSArray *params;
@property(strong,nonatomic) NSString *htmlString;
@property(nonatomic) bool basicMode;

@property(strong,nonatomic) UIActivityIndicatorView *loadingIndicator;
@property(strong,nonatomic) UIRefreshControl *refreshControl;
@property(nonatomic) NoConnectionView *connectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginConstraint;

@end
