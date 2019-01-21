//
//  FrontNavigationController.m
//  Universal
//
//  Created by Mu-Sonic on 25/10/2015.
//  Copyright © 2018 Sherdle. All rights reserved.
//

#import "SWRevealViewController.h"
#import "TabNavigationController.h"
#import "AppDelegate.h"
#import "Config.h"
#import "Section.h"
#import "CustomNavigationBar.h"
#import <ILTranslucentView/ILTranslucentView.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

// This affects navbar animation during transitions to transparent bar in detail view.
// White color seems to work best here. APP_THEME_COLOR is another option.
#define NAVBAR_TRANSITION_BGCOLOR [UIColor whiteColor]

@implementation TabNavigationController
{
    UIColor *prevShadowColor;
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    prevShadowColor = self.revealViewController.frontViewShadowColor;
    [self createAndLoadInterstitial];
    [self configureNavbar];
}

- (void)configureNavbar {
    
    /**
     //GRADIENT
     if (gradient) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.gradientView.plainView.bounds;
        UIColor *color1 = [UIColor colorWithRed:71.0f/255.0f  green:191.0f/255.0f  blue:251.0f/255.0f  alpha:1.0];
        UIColor *color2 = [UIColor colorWithRed:69.0f/255.0f  green:148.0f/255.0f  blue:251.0f/255.0f  alpha:1.0];
        gradient.colors = [NSArray arrayWithObjects:(id)[color1 CGColor], (id)[color2 CGColor], nil];
        [_gradientView.plainView.layer insertSublayer:gradient atIndex:0];
    }**/
    
    /**
     //SOLID
     _gradientView.plainView.backgroundColor = APP_THEME_COLOR;
     **/
    
    _gradientView.translucentView.translucentAlpha = 1;
    _gradientView.translucentView.translucentStyle = UIBarStyleDefault;
    _gradientView.translucentView.translucentTintColor = APP_THEME_LIGHT ? [UIColor whiteColor] : APP_THEME_COLOR;
    _gradientView.translucentView.backgroundColor = [UIColor clearColor];
    
    if (APP_BAR_SHADOW) {
        _gradientView.translucentView.layer.shadowColor = [[UIColor blackColor] CGColor];
        _gradientView.translucentView.layer.shadowOffset = CGSizeMake(0, 1);
        _gradientView.translucentView.layer.shadowRadius = 5.0;
        _gradientView.translucentView.layer.shadowOpacity = 0.5;
    }
    
    // attach gradient view just below the nav bar
    [self.view insertSubview:_gradientView belowSubview:self.navigationBar];
    ((CustomNavigationBar *) self.navigationBar).backgroundView = _gradientView;
    
    // set appearance of status and nav bars
    [self forceDarkNavigation:false];
    self.navigationBar.translucent = true;
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationBar.prefersLargeTitles = false;
    self.navigationBar.shadowImage = [UIImage new];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // gradient view to cover both status bar (if present) and nav bar
    //CGRect barFrame = self.navigationBar.frame;
    //_gradientView.frame = CGRectMake(0, 0, barFrame.size.width, barFrame.origin.y + barFrame.size.height);
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    
    bool hasOneItem = [[Config config] count] == 1 && [((Section *)[[Config config] objectAtIndex:0]).items count] == 1;
    
    // add reveal button to the first nav item on the stack
    if (self.viewControllers.count == 1 && !hasOneItem) {
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]  style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
        viewController.navigationItem.leftBarButtonItem = leftBarButton;
    }
    
    if (self.viewControllers.count > 1) {
        self.revealViewController.frontViewShadowColor = NAVBAR_TRANSITION_BGCOLOR;
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *poppedVC = [super popViewControllerAnimated:animated];
    
    // switch off navbar transparency
    if (self.viewControllers.count <= 1) {
        [self.gradientView turnTransparencyOn:NO animated:YES tabController: self.navigationController];
        self.revealViewController.frontViewShadowColor = prevShadowColor;
    }
    
    return poppedVC;
}

- (void)createAndLoadInterstitial {
    
}


/**
 * Update the statusbar appearance to use the light theme or default theme as defined in AppDelegate
 * Boolean 'force' can be used to override the theme set for a dark theme (i.e. for detailview fade header).
 */
- (void) forceDarkNavigation: (BOOL) force {
    if (!APP_THEME_LIGHT || force) {
        //if (self.navigationBar.barStyle == UIBarStyleBlack) return;
        
        self.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationBar.tintColor = [UIColor whiteColor];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    } else {
        //if (self.navigationBar.barStyle == UIBarStyleDefault) return;
        
        self.navigationBar.barStyle = UIBarStyleDefault;
        self.navigationBar.tintColor = [UIColor blackColor];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil]];
    }
}


@end
