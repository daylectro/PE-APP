//
//  AppDelegate.h
//
//  Copyright (c) 2018 Sherdle. All rights reserved.
//
//  INFO: In this file you can edit some of your apps main properties, like API keys
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "RearTableViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SoundCloudPlayerController.h"
#import "RadioViewController.h"
#import <OneSignal/OneSignal.h>
#import <iRate/iRate.h>

//START OF CONFIGURATION

#define CONFIG @"https://gist.githubusercontent.com/daylectro/1b859d4efdcf3578f3b9a04035bc91d2/raw/33ee2764f0cae1bdbd62e7d810c2a22e7c35d1a3/config.json"

/**
 * Layout options
 */
#define APP_THEME_LIGHT NO
#define APP_THEME_COLOR [UIColor colorWithRed:80.0f/255.0f  green:80.0f/255.0f  blue:80.0f/255.0f  alpha:1.0]
#define APP_BAR_SHADOW YES

#define APP_DRAWER_HEADER YES
#define MENU_BACKGROUND_COLOR_1 [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0]
#define MENU_BACKGROUND_COLOR_2 [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.0]

/**
 * About / Texts
 **/
#define NO_CONNECTION_TEXT @"We weren't able to connect to the server. Make sure you have a working internet connection."
#define ABOUT_TEXT @"Thank you for downloading our app! \n\nIf you need any help, press the button below to visit our support."
#define ABOUT_URL @"http://pureencounter.com"

/**
 * Monetization
 **/
#define INTERSTITIAL_INTERVAL 5
#define ADMOB_INTERSTITIAL_ID @""
#define BANNER_ADS_ON false
#define ADMOB_UNIT_ID @""

#define IN_APP_PRODUCT @""

/**
 * API Keys
 **/
#define ONESIGNAL_APP_ID @""

#define MAPS_API_KEY @"AIzaSyBckAh7IQp-sUCXcMFaquHQwy7znxFGAbA"

#define YOUTUBE_CONTENT_KEY @"AIzaSyBckAh7IQp-sUCXcMFaquHQwy7znxFGAbA"

#define TWITTER_API @""
#define TWITTER_API_SECRET @""
#define TWITTER_TOKEN @""
#define TWITTER_TOKEN_SECRET @""

#define INSTAGRAM_ACCESS_TOKEN @""
#define FACEBOOK_ACCESS_TOKEN @""
#define PINTEREST_ACCESS_TOKEN @""

#define SOUNDCLOUD_CLIENT @""

#define FLICKR_API @""


/**
 * WooCommerce
 **/

#define WOOCOMMERCE_HOST @""
#define WOOCOMMERCE_KEY @""
#define WOOCOMMERCE_SECRET @""

/**
 * Other
 */
#define OPEN_IN_BROWSER false
#define WEBVIEW_HIDING_NAVIGATION true
#define openTargetBlankSafari NO

//END OF CONFIGURATION

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) AVPlayer *player;

@property (strong, nonatomic) OneSignal *oneSignal;

@property (nonatomic) int interstitialCount;


//Keeping a reference to controller that is currently playing audio. 
@property (strong, nonatomic) UIViewController* activePlayerController;
- (void) setActivePlayingViewController: (UIViewController *) active;
- (UIViewController *) activePlayingViewController;
- (void) closePlayerWithObserver: (NSObject *) observer;

//Utility methods
- (BOOL) shouldShowInterstitial;
+ (BOOL) hasPurchased;
+ (void) openUrl: (NSString *) url withNavigationController: (UINavigationController *) navController;

//Swift bridge
+ (NSString *) WooHost;
+ (NSString *) WooKey;
+ (NSString *) WooSecret;
@end
