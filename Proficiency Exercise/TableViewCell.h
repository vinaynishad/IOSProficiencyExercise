/**
 * @author   Vinay kumar Nishad
 *
 * @brief    Cell to display the feed
 *
 * @copyrigh Copyright (c) 2014 Cognizant. All rights reserved.
 *
 * @version  1.0
 *
 */

#import <UIKit/UIKit.h>
#import "RowModel.h"
#import "Constants.h"

// This class doesn’t do much. I’m going to use it to send some NSNotifications when the table view
// cell is reused, etc. in order to avoid having application logic in the table view cell, which is,
// after all, the V in MVC.
@interface TableViewCell : UITableViewCell
@property(nonatomic,retain) UIImageView *feedImage;

-(void)loadDataInCell:(RowModel*)feeds;
-(void)loadDataInitialCell;
@end
