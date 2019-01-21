//
//  AppDelegate.m
//
//  Copyright (c) 2018 Sherdle. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Config.h"
#import "WBInAppHelper.h"
#import "WebViewController.h"
#import "TabNavigationController.h"

#import "Universal-Swift.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey: MAPS_API_KEY];
    
    // Ads
    if (BANNER_ADS_ON && ![AppDelegate hasPurchased]){
        
    }
    
    //In App purchases
    if ([IN_APP_PRODUCT length] > 0){
        [WBInAppHelper setProductsList:@[IN_APP_PRODUCT]];
    }
    
    //iRate
    [iRate sharedInstance].usesUntilPrompt = 5;
    
    //Cookies
    [self loadHTTPCookies];
    
    // OneSignal/Notifications
    if ([ONESIGNAL_APP_ID length] > 0){
        self.oneSignal = [OneSignal initWithLaunchOptions:launchOptions appId:ONESIGNAL_APP_ID];
    }
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSString *newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
	NSLog(@"My token is: %@", newToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveHTTPCookies];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self loadHTTPCookies];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveHTTPCookies];
}

//Player management

- (UIViewController *) activePlayingViewController {
    return self.activePlayerController;
}

- (void) setActivePlayingViewController: (UIViewController *) active {
    self.activePlayerController = active;
}

- (void) closePlayerWithObserver:(NSObject *)observer {
    if (self.player){
        
        @try{
            [self.player removeObserver:observer forKeyPath:@"rate"];
        }@catch(id anException){
            //do nothing, obviously it wasn't attached because an exception was thrown
        }
        
        /**
        @try{
            [self.player.currentItem removeObserver:observer forKeyPath:@"timedMetadata"];
        }@catch(id anException){
            //do nothing, obviously it wasn't attached because an exception was thrown
        }
         **/
        
        [self.player pause];
        self.player = nil;
    }
}

//-- Utility method

+ (void) openUrl: (NSString *) url withNavigationController: (UINavigationController *) navController {
    if (OPEN_IN_BROWSER || ![navController isKindOfClass:[UIViewController class]]){
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    } else {
        //Make the header/navbar solid
        if ([navController isKindOfClass:[TabNavigationController class]]){
            TabNavigationController *nc = (TabNavigationController *) navController;
            [nc.gradientView turnTransparencyOn:NO animated:YES tabController: nc];
        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WebViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        vc.params = @[url];
        [navController pushViewController:vc animated:YES];
    }
}

- (BOOL) shouldShowInterstitial {
    if ([ADMOB_INTERSTITIAL_ID length] == 0) return false;
    if (INTERSTITIAL_INTERVAL == 0) return false;
    if ([AppDelegate hasPurchased]) return false;
    
    if (!_interstitialCount) _interstitialCount = 0;
    
    BOOL shouldShowInterstitial = false;
    if (_interstitialCount == INTERSTITIAL_INTERVAL) {
        shouldShowInterstitial = true;
        _interstitialCount = 0;
    }
    
    _interstitialCount++;
    return shouldShowInterstitial;
}

+ (BOOL) hasPurchased {
    if ([IN_APP_PRODUCT length] == 0) return false;
    
    return [WBInAppHelper isProductPaid:IN_APP_PRODUCT];
}

-(void)loadHTTPCookies
{
    NSMutableArray* cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"cookieArray"];
    
    for (int i=0; i < cookieDictionary.count; i++)
    {
        NSMutableDictionary* cookieDictionary1 = [[NSUserDefaults standardUserDefaults] valueForKey:[cookieDictionary objectAtIndex:i]];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDictionary1];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}

-(void)saveHTTPCookies
{
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookieArray addObject:cookie.name];
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
        [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
        [cookieProperties setObject:cookie.domain forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:cookie.path forKey:NSHTTPCookiePath];
        [cookieProperties setObject:[NSNumber numberWithUnsignedInteger:cookie.version] forKey:NSHTTPCookieVersion];
        [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
        
        [[NSUserDefaults standardUserDefaults] setValue:cookieProperties forKey:cookie.name];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:cookieArray forKey:@"cookieArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//Swift bridge
+ (NSString *) WooHost { return WOOCOMMERCE_HOST; }
+ (NSString *) WooKey { return WOOCOMMERCE_KEY; }
+ (NSString* ) WooSecret { return WOOCOMMERCE_SECRET; }

@end
