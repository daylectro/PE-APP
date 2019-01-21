//
//  TumblrImageViewController.m
//  Universal
//
//  Created by Mu-Sonic on 10/11/2015.
//  Copyright © 2018 Sherdle. All rights reserved.
//

#import "FlickrImageViewController.h"
#import "UIViewController+PresentActions.h"

@interface FlickrImageViewController ()
@end

@implementation FlickrImageViewController
{
    IBOutlet UIScrollView *scrollViewImage;
    IBOutlet UIImageView *largeImageView;

    bool reachedEnd;
    NSString *stringImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // set up gesture recognizers
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [largeImageView addGestureRecognizer:rightRecognizer];
    
    // Left Gesture
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [largeImageView addGestureRecognizer:leftRecognizer];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.delegate = self;
    //    [largeImageView setUserInteractionEnabled:YES];
    [largeImageView addGestureRecognizer:singleTap];

    // display selected image
    [self setImage];
}

#pragma mark - Left & Right UISwipeGestures

- (void) rightSwipeHandle:(UISwipeGestureRecognizer *)gestureRecognizer
{

    if (_fooIndex + 1 >= [_imagesArray count])
    {

    }
    else
    {
        _fooIndex = _fooIndex + 1;
        [self animationStart];

        [self setImage];
    }

}

- (void) setImage {
    NSDictionary *imageObject = [_imagesArray objectAtIndex:_fooIndex];
    NSString *imageUrl;
    if ([imageObject valueForKey:@"url_c"] != nil){
        imageUrl =[imageObject valueForKey:@"url_c"];
    } else if ([imageObject valueForKey:@"url_z"] != nil){
        imageUrl =[imageObject valueForKey:@"url_z"];
    } else if ([imageObject valueForKey:@"url_b"] != nil){
        imageUrl =[imageObject valueForKey:@"url_b"];
    } else if ([imageObject valueForKey:@"url_o"] != nil) {
        imageUrl =[imageObject valueForKey:@"url_o"];
    }
    [largeImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"wf.png"]];
}

- (void) leftSwipeHandle:(UISwipeGestureRecognizer *) gestureRecognizer
{
    if (_fooIndex > 0){
           [self animationStartFromLeft];
    }

    if (_fooIndex < 0)
    {
        _fooIndex = 0;
    }
    else if (_fooIndex > [_imagesArray count])
    {
        //        fooIndex = _fooIndex - 2;
        _fooIndex = (int)[_imagesArray count] - 1;

        [self setImage];
    }
    else
    {
        if (_fooIndex == 0) {

        }
        else
        {
            _fooIndex = _fooIndex - 1;
        }

        [self setImage];
    }
}

- (void) animationStart
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    [scrollViewImage.layer addAnimation:transition forKey:nil];
}

- (void) animationStartFromLeft
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    [scrollViewImage.layer addAnimation:transition forKey:nil];
}

- (void)tapDetected {
    NSLog(@"single Tap on imageview");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)close:(id)sender {
    [self tapDetected];
}

- (IBAction)btnShare:(id)sender {
    NSArray *activityItems = [NSArray arrayWithObjects:largeImageView.image,  nil];
    
    [self presentActions:activityItems sender:sender];
}

- (IBAction)btnSave:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"message", nil) message:NSLocalizedString(@"image_save_succesfull", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(largeImageView.image, nil, nil, nil);
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
