//
//  DetailLocationCell.h
//
//  Copyright (c) 2018 Sherdle. All rights reserved.
//
//  Implements TGFoursquareLocationDetail-Demo
//  Copyright (c) 2013 Thibault Guégan. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@protocol DetailViewActionDelegate <NSObject>
- (void)open;
- (void)share:(id)sender;
@end

@interface ActionCell : UITableViewCell

@property (weak, nonatomic) id<DetailViewActionDelegate> actionDelegate;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (nonatomic) bool disableDefaultSaveAction;
@property (weak, nonatomic) IBOutlet UIButton *btnOpen;
@end
