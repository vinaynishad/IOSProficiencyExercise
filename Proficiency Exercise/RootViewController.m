/**
 * @author   Vinay kumar Nishad
 *
 * @brief    Proficiency Exercise
 *
 * @copyrigh Copyright (c) 2014 Cognizant. All rights reserved.
 *
 * @version  1.0
 *
 */

#import "RootViewController.h"
#import <objc/runtime.h>
// Cells
#import "TableViewCell.h"
// Models
#import "RowModel.h"
#import "OverViewModel.h"
// Service Client
#import "ImageDownloadClient.h"
// Constants
#import "Constants.h"
// Helpers
#import "HelperClass.h"

@interface RootViewController()

@property (nonatomic,strong) OverViewModel *data;

@property (nonatomic,strong) NSMutableDictionary *visibleCells;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic,strong) RowModel *newsRow;

@end


@implementation RootViewController

NSString * const kJSONResponseRowsKey                   =   @"rows";
NSString * const kJSONResponseDescriptionKey            =   @"description";
NSString * const kJSONResponseTitleKey                  =   @"title";
NSString * const kJSONResponseImageHrefKey              =   @"imageHref";

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.visibleCells = [[NSMutableDictionary alloc] initWithCapacity:30];
    // Register the custom cell
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:CellIdentifier];
    // An instance of UIrefreshview control is created.
    UIRefreshControl *refreshControl=[[UIRefreshControl alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100.0f)];
    self.refreshControl=refreshControl;
    [self.refreshControl addTarget:self action:@selector(reloadTable) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.activityIndicator hidesWhenStopped];
    [self.activityIndicator startAnimating];
    [self downloadJsonData];
}


-(void)loadView {
    [super loadView];
}

#pragma mark - Service Handlers

-(void)downloadJsonData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *response = [NSData dataWithContentsOfURL:[NSURL URLWithString:feedUrl]]; //use static string
        NSError *parseError = nil;
       
        NSString* string = [[[[NSString alloc] initWithData:response encoding:NSASCIIStringEncoding] stringByReplacingOccurrencesOfString:@"\t" withString:kEmptyString] stringByReplacingOccurrencesOfString:@"\0" withString:kEmptyString];
        response = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary * jsonFeedDictionary = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&parseError];
        if(!parseError){
            NSMutableArray *jsonArrayOfRowsFromDict = [NSMutableArray array];
            for(NSDictionary *rowDict in [jsonFeedDictionary objectForKey:kJSONResponseRowsKey]){
                //assign and reuse
                if(!([rowDict objectForKey:kJSONResponseTitleKey]==(id)[NSNull null] && [rowDict objectForKey:kJSONResponseDescriptionKey]==(id)[NSNull null]&& [rowDict objectForKey:kJSONResponseImageHrefKey]==(id)[NSNull null])){
                    
                    RowModel *records = [[RowModel alloc] init];
                    if([records containsAllElements:rowDict]){
                        [jsonArrayOfRowsFromDict addObject:records];
                    }

                }
            }
            self.data = [[OverViewModel alloc] initWithTitle:[jsonFeedDictionary objectForKey:kJSONResponseTitleKey] andFeeds:jsonArrayOfRowsFromDict];
            // Updating Title of Table View in Main Thread(Screen Title)
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationItem setTitle:self.data.newsTitle];
                if([self.refreshControl isRefreshing]) {
                    [self.refreshControl endRefreshing];
                }
                [self.tableView reloadData];
                [self.activityIndicator stopAnimating];
            });
        }
        else{
            [self showErrorAlert:parseError];
            [self.activityIndicator stopAnimating];
        }
       
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark TableView Datasource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.data feeds] count]; // The number of rows is the feeds count which is got from the response
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self basicCellAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *reuseIdentifier = CellIdentifier;
    TableViewCell *cell = [self.visibleCells objectForKey:reuseIdentifier];
    if (!cell) {
        cell = [[TableViewCell alloc] init];
        [self.visibleCells setObject:cell forKey:reuseIdentifier];
    }
    [self showCellObjects : indexPath : cell];
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    CGFloat cellHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return cellHeight + 1.0f; // Add 1.0f for the cell separator height
}

#pragma mark -
#pragma mark Orientation handlers

-(BOOL)shouldAutorotate
{
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Custom Methods

- (void) showCellObjects :(NSIndexPath*)indexPath :(TableViewCell*)cell
{
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    [cell loadDataInCell:[self.data.feeds objectAtIndex:indexPath.row]];
    
    if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
        if(![[[self.data.feeds objectAtIndex:indexPath.row] feedsImage] isEqualToString:kEmptyString]){
            [HelperClass startIconDownload:[self.data.feeds objectAtIndex:indexPath.row] forIndexPath:indexPath withContainerView:self.tableView];
        }
        else{
            [cell.feedImage  setImage:[UIImage imageNamed:kEmptyString]];
        }  
    }
    else
    {
        [cell.feedImage setImage: [(RowModel*)[self.data.feeds objectAtIndex:indexPath.row] appIcon]];
    }
    
   // [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //- Image failed to download //-- Show exclamation image
    if(cell.feedImage.image == nil){
        //-- If Image fails to download
        [cell.feedImage setImage:[UIImage imageNamed:@"ImageFailedtoDownload.png"]];
    }
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
}
/*
 
 This function is used to create or dequeue the instance of the cell
 and load the label and the imageview in the cell with data from the
 'Feed' object
 
*/
- (TableViewCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier] ;
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [ self showCellObjects:indexPath:cell];
    return cell ;
}

#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [HelperClass loadImagesForOnscreenRows:self.data WithContainerView:self.tableView];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:scrollView
//  When scrolling stops, proceed to load the app icons that are on screen.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [HelperClass loadImagesForOnscreenRows:self.data WithContainerView:self.tableView];
}

/*
 
 This function is suposed to return the dynamic height of the
 cells based on their content
 
*/

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *dynamicSizeCell = [self basicCellAtIndexPath:indexPath];
    return [HelperClass calculateHeightForConfiguredSizingCell:dynamicSizeCell containgView:self.tableView];
}

/*
 
 This function is called to make the service call
 and reload the table view.
 
*/

-(void)reloadTable{
    [self.refreshControl beginRefreshing];
    [self downloadJsonData];
}

/*
 This method is used to display the alertview
 
*/
-(void)showErrorAlert:(NSError *)error
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Network Issue." message:@"Network Issue encountered, Please try again later!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
    [alertView show];
}

@end