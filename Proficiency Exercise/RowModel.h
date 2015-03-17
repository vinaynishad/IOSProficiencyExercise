/**
 * @author   Vinay kumar Nishad
 *
 * @brief    Holds the feed information
 *
 * @copyrigh Copyright (c) 2014 Cognizant. All rights reserved.
 *
 * @version  1.0
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RowModel : NSObject

@property(nonatomic, copy) NSString *feedsTitle;
@property(nonatomic, copy) NSString *feedsDescription;
@property(nonatomic, copy) NSString *feedsImage;
@property(nonatomic, strong) UIImage *appIcon;

-(BOOL)containsAllElements:(NSDictionary *)attributes;

@end