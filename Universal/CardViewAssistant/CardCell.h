//
//  CardCell.h
//
//  Copyright (c) 2018 Sherdle. All rights reserved.
//  Implements Copyright (c) 2014 Audrey Manzano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialFetcher.h"
#import <KILabel/KILabel.h>
#import "ImageView.h"
#import <QuartzCore/QuartzCore.h>

@protocol CardCellDelegate <NSObject>

@end

@interface CardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *card;

@property (nonatomic, weak) IBOutlet UILabel *username;
@property (nonatomic, weak) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet KILabel *caption;

@property (nonatomic, weak) IBOutlet ImageView *photoView;
@property (nonatomic, weak) IBOutlet UIImageView *userPic;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UIButton *openButton;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *countOne;
@property (weak, nonatomic) IBOutlet UIImageView *countTwo;


@property (nonatomic, weak) id<CardCellDelegate>delegate;
@property (weak, nonatomic) UIViewController *parentController;

@property(strong,nonatomic)NSString *shareUrl;

- (void)updateImageAspectRatio;

@end
