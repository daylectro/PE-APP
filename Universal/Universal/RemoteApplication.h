//
//  RemoteApplication.h
//  Universal
//
//  Created by Mark on 05-12-15.
//  Copyright © 2018 Sherdle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoteApplication : UIApplication

-(void)remoteControlReceivedWithEvent:(UIEvent *)event;
-(BOOL)canBecomeFirstResponder;

@end

