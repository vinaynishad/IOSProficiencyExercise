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

#import "RowModel.h"
#import "Constants.h"

@interface RowModel(){
    
}

@end

@implementation RowModel


-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -
#pragma mark Custom Methods

/*
 This function is used to check whether all the elements are returned
 from the response and to assign fefault values incase of any unexpected
 values in the response.
*/

-(BOOL)isValidString:(id)string{
    if ([string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}


-(BOOL)containsAllElements:(NSDictionary *)attributes
{
    if ([ self isValidString:[attributes valueForKeyPath:kTitleName]] ) {
        self.feedsTitle = [attributes valueForKeyPath:kTitleName];
    }
    else{
        return NO;
    }
    
    if ([ self isValidString:[attributes valueForKeyPath:kDescription]]) {
        self.feedsDescription = [attributes valueForKeyPath:kDescription];
    }
    else{
        self.feedsDescription = kEmptyString;
    }
    
    if ([ self isValidString:[attributes valueForKeyPath:kImageHref]]) {
        self.feedsImage = [attributes valueForKeyPath:kImageHref];
    }
    else{
        self.feedsImage=kEmptyString;
    }
    
    return YES;
}

#pragma mark -
#pragma mark Dealloc Method


@end
