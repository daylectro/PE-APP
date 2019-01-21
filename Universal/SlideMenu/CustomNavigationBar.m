//
//  UINavigationBar+Custom.m
//  Universal
//
//  Created by Mark on 22/04/2018.
//  Copyright © 2018 Sherdle. All rights reserved.
//

#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect barFrame = self.frame;
    self.backgroundView.frame = CGRectMake(0, 0, barFrame.size.width, barFrame.origin.y + barFrame.size.height);
}

@end
