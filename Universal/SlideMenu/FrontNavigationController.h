//
//  FrontNavigationController.h
//  Universal
//
//  Created by Mu-Sonic on 25/10/2015.
//  Copyright © 2018 Sherdle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavbarGradientView.h"
#import "ConfigParserDelegate.h"
#import "Tab.h"

@interface FrontNavigationController : UITabBarController <ConfigParserDelegate>

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

+(UIViewController *) createViewController:(Tab*) item withStoryboard:(UIStoryboard *) storyboard;

@end
