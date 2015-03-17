/**
 * @author   Vinay kumar Nishad
 *
 * @brief    Holds the feed overview
 *
 * @copyrigh Copyright (c) 2014 Cognizant. All rights reserved.
 *
 * @version  1.0
 *
 */

#import "OverViewModel.h"
#import "RowModel.h"

@implementation OverViewModel

-(instancetype)initWithTitle:(NSString *)newsTitle andFeeds:(NSMutableArray *)feeds
{
    self = [super init];
    if (self) {
        _newsTitle = newsTitle;
        _feeds = feeds;
    }
    return self;
}

@end