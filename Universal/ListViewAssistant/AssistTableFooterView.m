//
// AssistTableFooterView.m
//
// Copyright (c) 2018 Sherdle. All rights reserved.
//
// Implements: STTableViewController
// Copyright (C) 2011 by BJ Basañes, http://shikii.net under MIT
//

#import "AssistTableFooterView.h"

@implementation AssistTableFooterView

@synthesize activityIndicator;
@synthesize infoLabel;

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
}

@end
