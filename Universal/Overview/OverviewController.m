//
//  OverviewController.m
//
//  Copyright (c) 2018 Sherdle. All rights reserved.
//
//

#import "OverviewController.h"
#import "NSString+HTML.h"
#import "AssistTableCell.h"
#import "AssistTableFooterView.h"
#import "FrontNavigationController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "ConfigParser.h"
#import "OverviewCell.h"
#import "Tab.h"

@implementation OverviewController

@synthesize params;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [self.tableView addGestureRecognizer: self.revealViewController.tapGestureRecognizer];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OverviewCell" bundle:nil] forCellReuseIdentifier:@"OverviewCell"];

    self.itemsToDisplay = [NSArray array];
    
    NSString *overview = params[0];
    ConfigParser * configParser = [[ConfigParser alloc] init];
    configParser.delegate = self;
    [configParser parseOverview:overview];
    
    loadedImages = [NSMutableSet new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UIImage *headerImage = [UIImage imageNamed:@"Godi.jpg"];
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:headerImage];

    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat imageRatio = headerImage.size.height / headerImage.size.width;

    CGRect frame = headerImageView.frame;
    frame.size.height = imageRatio * screenWidth;
    headerImageView.frame = CGRectIntegral(frame);

    self.tableView.tableHeaderView = headerImageView;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

// Reset and reparse
- (BOOL)refresh {
    return NO;
}

- (void) willBeginLoadingMore
{
    AssistTableFooterView *fv = (AssistTableFooterView *)self.tableView.tableFooterView;
    [fv.activityIndicator startAnimating];
}

- (void) loadMoreCompleted
{
    [super loadMoreCompleted];
    
    AssistTableFooterView *fv = (AssistTableFooterView *)self.tableView.tableFooterView;
    [fv.activityIndicator stopAnimating];
    
    if (!self.canLoadMore) {
        fv.infoLabel.hidden = YES;
    }
}

- (void)updateTableWithParsedItems {
    self.canLoadMore = NO;
    [self refreshCompleted];
    [self loadMoreCompleted];
    [self.tableView reloadData];
    self.tableView.userInteractionEnabled = YES;
}

#pragma mark

- (void)parseSuccess:(NSMutableArray *)result {
    if (result.count == 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"error", nil)message:NO_CONNECTION_TEXT preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
        [self refreshCompleted];
        [self loadMoreCompleted];
        
    } else {
        self.itemsToDisplay = result;
        [self updateTableWithParsedItems];
    }
}

- (void)parseFailed:(NSError *)error {
    NSLog(@"Error: %@", error);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"error", nil)message:NO_CONNECTION_TEXT preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
    
    [self refreshCompleted];
    [self loadMoreCompleted];

}

#pragma mark - Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsToDisplay.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"OverviewCell";
    OverviewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(OverviewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell.
    Tab *item = [self.itemsToDisplay objectAtIndex:indexPath.row];
    if (item) {

        cell.username.text = item.name;

        if (item.icon != nil){
            // Änderung war hier!
            UIImage *image = [UIImage imageNamed:item.icon];
            cell.image.image = image;
            cell.image.hidden = NO;
        } else {
            cell.image.hidden = YES;
        }
        
    }

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fID = nil;
    NSLog(@" current row is %ld", indexPath.row);

    switch (indexPath.row) {
        case 0:
        {
            fID = @"ÜberUnsID";
            break;
        }
        case 1:
        {
            fID = @"DepartmentsID";
            break;
        }
        case 3:
        {
            fID = @"KontaktID";
            break;
        }

        default:
        {
            Tab *item = [self.itemsToDisplay objectAtIndex:indexPath.row];
            UIViewController *controller = [FrontNavigationController createViewController:item withStoryboard:self.storyboard];

            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
    }

    if (fID) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *fVC = [storyBoard instantiateViewControllerWithIdentifier:fID];
        [self.navigationController pushViewController:fVC animated:YES];
    }
}

@end
