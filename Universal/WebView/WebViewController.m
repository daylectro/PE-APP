//
//  WebViewController.m
//
//  Copyright (c) 2018 Sherdle. All rights reserved.
//

#import "WebViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "TabNavigationController.h"
#import "Reachability.h"
#import "UIViewController+PresentActions.h"

#define OFFLINE_FILE_EXTENSION @"html"
#define HIDE_SHARE TRUE

@implementation WebViewController
@synthesize params;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Note: Jumping in WebView is cause of WKWebView (issue does not occur with UIWebView) and can potentially be resolved by disabling the dynamically 'hiding navigation'

    if (!APP_THEME_LIGHT)
        self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    else
        self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.loadingIndicator startAnimating];
    self.navigationItem.titleView = self.loadingIndicator;
    
    _webView.navigationDelegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [_webView.scrollView addSubview:self.refreshControl]; //<- this is point to use. Add "scrollView" property.
    
    if (self.basicMode){
        self.navigationItem.rightBarButtonItems = nil;
        self.refreshControl.enabled = false;
    }
    
    if (HIDE_SHARE){
        NSMutableArray *toolbarButtons = [self.navigationItem.rightBarButtonItems mutableCopy];
        [toolbarButtons removeObject:self.shareButton];
        self.navigationItem.rightBarButtonItems = toolbarButtons;
    }
    
    [self loadWebViewContent];
    
    //Hiding
    if (WEBVIEW_HIDING_NAVIGATION){
        TabNavigationController *parent = ((TabNavigationController *)self.navigationController);
        self.scrollCoordinator = [[JDFPeekabooCoordinator alloc] init];
        self.scrollCoordinator.scrollView = self.webView.scrollView;
        self.scrollCoordinator.topView = self.navigationController.navigationBar;
        self.scrollCoordinator.topViewBackground = parent.gradientView;
        self.scrollCoordinator.topViewItems = [NSArray arrayWithObjects: parent.menuButton, self.navigationController.navigationItem.titleView, [self.navigationController.navigationItem.rightBarButtonItem valueForKey:@"view"],  nil];
        self.topMarginConstraint.active = false;
    }
    
    /**if (true){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = APP_THEME_COLOR;
        }
    }**/


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)loadWebViewContent {
    //Set all the data
    //If the url begins with http (or https for that matter), load it as a webpage. Otherwise, load an asset
    if (self.htmlString) {
        [_webView loadHTMLString:self.htmlString baseURL:[NSURL URLWithString:params[0]]];
    } else {
        NSURL *url;
        NSString *urlString;
        
        //If a string does not start with http, does end with .html and does not contain any slashes, we'll assume it's a local page.
        if (![[params[0] substringToIndex:4] isEqualToString:@"http"] && [params[0] containsString: [NSString stringWithFormat: @".%@", OFFLINE_FILE_EXTENSION]] && ![params[0] containsString: @"/"]){
            urlString = [params[0] stringByReplacingOccurrencesOfString:
                          [NSString stringWithFormat: @".%@", OFFLINE_FILE_EXTENSION] withString:@""];
            url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:urlString ofType: OFFLINE_FILE_EXTENSION inDirectory:@"Local"]];
        } else {
            if (![[params[0] substringToIndex:4] isEqualToString:@"http"]){
                urlString = [NSString stringWithFormat:@"http://%@", params[0]];
            } else {
                urlString = params[0];
            }
            
            url = [NSURL URLWithString: urlString];
        }
        
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    UIApplication *app = [UIApplication sharedApplication];
    NSURL         *url = navigationAction.request.URL;
    
    if (openTargetBlankSafari) {
        if (!navigationAction.targetFrame) {
            if ([app canOpenURL:url]) {
                UIApplication *application = [UIApplication sharedApplication];
                [application openURL:url options:@{} completionHandler:nil];
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
        }
    }
    
    if ([url isFileURL]){
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"])
    {
        if ([app canOpenURL:url])
        {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:url options:@{} completionHandler:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (IBAction)goForward:(id)sender {
    [_webView goForward];
}

- (IBAction)goBack:(id)sender {
    [_webView goBack];
}

- (IBAction)share:(id)sender {
    NSArray *activityItems = [NSArray arrayWithObjects:self.webView.URL.absoluteString,  nil];
    [self presentActions:activityItems sender:(id)sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    if (![self.refreshControl isRefreshing]){
        self.navigationItem.titleView = self.loadingIndicator;
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.navigationItem.titleView = nil;
    
    if (self.refreshControl && [self.refreshControl isRefreshing]){
        [self.refreshControl endRefreshing];
    }
    
    // Enable or disable back button
    [_backButton setEnabled:[webView canGoBack]];
    
    // Enable or disable forward button
    [_forwardButton setEnabled:[webView canGoForward]];
}

- (void)webView:(WKWebView *)webView
didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error;
{
    if (error.code != NSURLErrorNotConnectedToInternet && error.code != NSURLErrorNetworkConnectionLost) {
        if (![Reachability connected]){
            [self updateForConnectivity:false];
        }
        //If the error is not a connection error, show a dialog
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"error_webview", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        //If the error is a connection error, and this is the page the user is now interacting with. Show a no connectivity warning.
        [self updateForConnectivity:false];
    }
    
    [self webView:webView didFinishNavigation:navigation];
    
}

- (void)loadRequest:(NSURLRequest *)request
{
    if ([_webView isLoading])
        [_webView stopLoading];
    [_webView loadRequest:request];
}

- (void)viewWillDisappear
{
    if ([_webView  isLoading])
        [_webView  stopLoading];
}

//Selectors cannot pass parameters, therefore we offer this utility method
- (void) updateForConnectivityFromScreen {
    [self updateForConnectivity:true];
}

- (void) updateForConnectivity:(BOOL)calledFromButton {

    if (![Reachability connected]){
        //If the no connection view is not already displayed
        if (!_connectionView.superview){
            _connectionView = [[[NSBundle mainBundle] loadNibNamed:@"NoConnectionView" owner:self options:nil] lastObject];
            _connectionView.frame = self.view.frame;
            //_connectionView.label.text = @"Error";
            [_connectionView.retryButton addTarget:self action:@selector(updateForConnectivityFromScreen) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:_connectionView];
            [self.view bringSubviewToFront:_connectionView];
        }
    } else {
        //If the view is shown, remove it.
        if (_connectionView.superview){
            [_connectionView removeFromSuperview];
            _connectionView = nil;
        }
        if (_webView.URL){
            [_webView reload];
        } else {
            [self loadWebViewContent];
        }
        
    }
    
}

-(void)handleRefresh:(UIRefreshControl *)refresh {
    // Reload my data
    [_webView reload];
}

@end
