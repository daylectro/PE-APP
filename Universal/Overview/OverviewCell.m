//
//  CardCell.m
//
//  Copyright (c) 2018 Sherdle. All rights reserved.
//  Implements Copyright (c) 2014 Audrey Manzano. All rights reserved.
//

#import "OverviewCell.h"
#import "NSString+HTML.h"

@implementation OverviewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.image.image = nil;
}

@end
