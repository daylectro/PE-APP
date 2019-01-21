//
//  TumblrViewController.m
//
//  Copyright (c) 2018 Sherdle. All rights reserved.
//

#define iPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)

#import "FlickrViewController.h"
#import "TumblrViewCell.h"
#import "FlickrImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SWRevealViewController.h"
#import "FooterView.h"
#import "AppDelegate.h"

#define LOADING_CELL_IDENTIFIER @"LoadingItemCell"

@interface FlickrViewController ()
{
    IBOutlet UIScrollView *scrollViewImage;
    IBOutlet UIView *viewImage;
    IBOutlet UIImageView *largeImageView;
    
    int fooIndex;
    bool reachedEnd;
    NSString *stringImage;
    
    int totalPages;
    int page;
}
@end

@implementation FlickrViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    page = 1;
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];

    // fetch data
    [self fetchDataWithPage:page];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    FooterView *footer = nil;
    
    if([kind isEqual:UICollectionElementKindSectionFooter])
    {
        footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        
        [footer.activityIndicator startAnimating];
    }
    
    return footer;
}

// do not forget header & footer size

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    //header size
    if (!reachedEnd){
        CGSize size = {self.collectionView.bounds.size.width,50};
        return size;
    } else {
        CGSize size = {self.collectionView.bounds.size.width,0};
        return size;
    }
}

-(void)fetchDataWithPage:(int)page{
    
    NSLog(@"FetchDataWithPage: %d", page);
    NSString *method = self.params[1];
    NSString *galleryId = self.params[0];
    NSString *pathMethod = ![method isEqualToString:@"gallery"] ? @"photosets" : @"galleries";
    NSString *idMethod = ![method isEqualToString:@"gallery"] ? @"photoset_id" : @"gallery_id";
    
    NSString *strUrl = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.%@.getPhotos&api_key=%@&%@=%@&format=json&extras=path_alias,url_o,url_c,url_b,url_z&per_page=20&page=%d", pathMethod, FLICKR_API, idMethod, galleryId, page];
    NSLog(@"Url: %@", strUrl);
    
    NSURL *url = [[NSURL alloc]initWithString:strUrl];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc]initWithURL:url];
    
    [req setHTTPMethod:@"GET"];
    
    //    [req setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:req
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if (data == nil) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"error", nil)message:NO_CONNECTION_TEXT preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    reachedEnd = true;
                    
                    [self.collectionView reloadSections:[[NSIndexSet alloc] initWithIndex:0]];
                    
                    return ;
                } else {
                    
                    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSMutableString *responseMutable= [NSMutableString stringWithString:response];
                    
                    NSString *stringWithoutSpaces = [responseMutable stringByReplacingOccurrencesOfString:@"jsonFlickrApi(" withString:@""];
                    stringWithoutSpaces = [stringWithoutSpaces substringToIndex:[stringWithoutSpaces length] - 1];
                    
                    NSData *dataNew = [stringWithoutSpaces dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *jsonFetch =[NSJSONSerialization JSONObjectWithData:dataNew options:0 error:nil];
                    json = jsonFetch;
                    
                    if (!imagesArray){
                        imagesArray=[[NSMutableArray alloc]init];
                    }
                    
                    NSString *parentMethod = ![method isEqualToString:@"gallery"] ? @"photoset" : @"photos";
                    totalPages = [[[jsonFetch valueForKey:parentMethod] valueForKey:@"pages"] intValue];
                    for (id result in [[jsonFetch valueForKey:parentMethod] valueForKey:@"photo"]) {
                        [imagesArray addObject:result];
                    }
                    
                    NSLog(@"ARRAY COUNT %lu ",(unsigned long)imagesArray.count);
                    
                    [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                }

                
            }] resume];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imagesArray.count ;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TumblrViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    {
        UIImageView *image = cell.cellImage;
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        image.tag = indexPath.row;
        
        //  [images setImageWithURL:[NSURL URLWithString:[[imagesArray objectAtIndex:indexPath.row]valueForKey:@"photo-url-100"]] placeholderImage:nil];
        
        NSDictionary *imageObject = [imagesArray objectAtIndex:indexPath.row];
        NSString *imageUrl;
        if ([imageObject valueForKey:@"url_c"] != nil){
             imageUrl =[[imagesArray objectAtIndex:indexPath.row]valueForKey:@"url_c"];
        } else if ([imageObject valueForKey:@"url_z"] != nil){
            imageUrl =[[imagesArray objectAtIndex:indexPath.row]valueForKey:@"url_z"];
        } else if ([imageObject valueForKey:@"url_b"] != nil){
             imageUrl =[[imagesArray objectAtIndex:indexPath.row]valueForKey:@"url_b"];
        } else if ([imageObject valueForKey:@"url_o"] != nil) {
             imageUrl =[[imagesArray objectAtIndex:indexPath.row]valueForKey:@"url_o"];
        }
    
        [image sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"wf.png"]];

    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FlickrImageViewController *imageVC = (FlickrImageViewController *)((UINavigationController *)segue.destinationViewController).topViewController;
    imageVC.imagesArray = imagesArray;
    imageVC.fooIndex = ((TumblrViewCell *)sender).cellImage.tag;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize screen = [UIScreen mainScreen].bounds.size;
    NSInteger boxSize = ( MIN(screen.width, screen.height) - 0 ) / 3;
    return CGSizeMake(boxSize, boxSize);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height)
    {
        page = page + 1;
        
        if (page < totalPages) {
            reachedEnd = false;
            [self fetchDataWithPage:page];
        } else {
            reachedEnd = true;
            [self.collectionView reloadSections:[[NSIndexSet alloc] initWithIndex:0]];
        }
        
        // we are at the end
    }
}

@end
