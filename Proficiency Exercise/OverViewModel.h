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

#import <Foundation/Foundation.h>

@class Feeds;
@interface OverViewModel : NSObject


@property(nonatomic,strong) NSString *newsTitle;
@property(nonatomic,strong) NSMutableArray *feeds;

-(instancetype)initWithTitle:(NSString *)newsTitle andFeeds:(NSMutableArray *)feeds;

@end