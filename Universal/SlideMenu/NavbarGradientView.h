//
//  NavbarGradientView.h
//  Universal
//
//  Created by Mu-Sonic on 29/10/2015.
//  Copyright © 2018 Sherdle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ILTranslucentView/ILTranslucentView.h>

@interface NavbarGradientView : UIView

@property (strong, nonatomic) IBOutlet UIView *plainView;
@property (weak, nonatomic) IBOutlet ILTranslucentView *translucentView;

- (void)turnTransparencyOn:(BOOL)on animated:(BOOL)animated tabController: (UIViewController *) controller;


@end
