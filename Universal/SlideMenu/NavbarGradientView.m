//
//  NavbarGradientView.m
//  Universal
//
//  Created by Mu-Sonic on 29/10/2015.
//  Copyright © 2018 Sherdle. All rights reserved.
//

#import "NavbarGradientView.h"
#import "TabNavigationController.h"

//IB_DESIGNABLE
@implementation NavbarGradientView
{
    BOOL isTransparent;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *lightGradientColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    UIColor *darkGradientColor = [UIColor clearColor];
    
    CGFloat locations[2] = {0.0, 1.0};
    CFArrayRef colors = (__bridge CFArrayRef) [NSArray arrayWithObjects:(id)lightGradientColor.CGColor,
                                      (id)darkGradientColor.CGColor,
                                      nil];
    
    CGColorSpaceRef colorSpc = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpc, colors, locations);
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds)), CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds)), kCGGradientDrawsAfterEndLocation); //Adjust second point according to your view height
    
    CGColorSpaceRelease(colorSpc);
    CGGradientRelease(gradient);
}

- (void)turnTransparencyOn:(BOOL)on animated:(BOOL)animated tabController: (UIViewController *) controller
{
    //Update navigationBar text color
    [((TabNavigationController *) controller) forceDarkNavigation:on];
    
    if (on == isTransparent) {
        return; // already in that state
    }

    isTransparent = on;
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _plainView.alpha = on ? 0 : 1;
        } completion:^(BOOL finished) {
        }];
    } else {
        _plainView.alpha = on ? 0 : 1;
    }
}


@end
