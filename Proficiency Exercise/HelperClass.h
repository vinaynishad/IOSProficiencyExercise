//
//  HelperClass.h
//  ProficiencyExercise
//
//  Created by Vinay kumar Nishad on 16/03/2015.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//
//

#import <Foundation/Foundation.h>
@class TableViewCell;
@class RowModel;
@class OverViewModel;
@interface HelperClass : NSObject

+(void)loadImagesForOnscreenRows:(OverViewModel*)dataModel WithContainerView:(UITableView*)tableView;
+(CGFloat)calculateHeightForConfiguredSizingCell:(TableViewCell *)sizingCell  containgView:(UITableView*)tableView;
+(void)startIconDownload:(RowModel *)appRecord forIndexPath:(NSIndexPath *)indexPath withContainerView:(UITableView*)tableView;
@end