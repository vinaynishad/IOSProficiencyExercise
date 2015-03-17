/*
    File: ImageDownloadClient.m
    load images for visible cells
*/

 #import <Foundation/Foundation.h>

 
@class RowModel;

@interface ImageDownloadClient : NSObject

@property (nonatomic, strong) RowModel *appRecord;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end