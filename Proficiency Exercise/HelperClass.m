//
//  HelperClass.m
//  ProficiencyExercise
//
//  Created by Vinay kumar Nishad on 16/03/2015.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//
//

#import "HelperClass.h"
#import "TableViewCell.h"
#import "Constants.h"
#import "RowModel.h"
#import "OverViewModel.h"
#import "ImageDownloadClient.h"

@interface HelperClass()
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@end
@implementation HelperClass


static HelperClass *sharedManager = nil;
#pragma mark Singleton Methods

+ (id)initHelper {
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        
    //Initialize something here if needed
    }
    return self;
}



#pragma mark - Table cell image support

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
+(void)loadImagesForOnscreenRows:(OverViewModel*)dataModel WithContainerView:(UITableView*)tableView
{
    if (dataModel.feeds.count > 0)
    {
        NSArray *visiblePaths = [tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            RowModel *appRecord = (dataModel.feeds)[indexPath.row];
            if(![appRecord.feedsImage isEqualToString:kEmptyString]){
                
                if (!appRecord.appIcon)
                    // Avoid the app icon download if the app already has an icon
                {
                    [HelperClass startIconDownload:appRecord forIndexPath:indexPath withContainerView:tableView];
                }
            }
        }
    }
}

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
+(void)startIconDownload:(RowModel *)appRecord forIndexPath:(NSIndexPath *)indexPath withContainerView:(UITableView*)tableView
{
    ImageDownloadClient *iconDownloader = (sharedManager.imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[ImageDownloadClient alloc] init];
        iconDownloader.appRecord = appRecord;
        [iconDownloader setCompletionHandler:^{
            
            TableViewCell *cell = (TableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            [cell.feedImage setImage:appRecord.appIcon];
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [sharedManager.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (sharedManager.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}



/*
 
 The height of the tableview cell is calculated in this method.
 Since autolayout is used 'systemLayoutSizeFittingSize' method is
 used to find the size of tableview cell
 
 */

+ (CGFloat)calculateHeightForConfiguredSizingCell:(TableViewCell *)sizingCell  containgView:(UITableView*)tableView{
    
    [sizingCell setFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), CGRectGetHeight(sizingCell.bounds))];
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}
@end
