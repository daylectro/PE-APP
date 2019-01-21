//
//  ShowPageCell.h
//
//  Implements: KnomeiOS-SSO
//  Copyright (c) 2013 tcs. All rights reserved.
//
//  Copyright (c) 2018 Sherdle. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@interface ShowPageCell : UITableViewCell <UIWebViewDelegate>

- (void)loadContent:(NSString *)html;
- (CGFloat)updateWebViewHeightForWidth:(CGFloat)width;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) UITableView *parentTable;
@property (weak, nonatomic) UIViewController *parentViewController;

@end
