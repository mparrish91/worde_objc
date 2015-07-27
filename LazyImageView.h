//
//  CLAProfileImageView.h
//  ClassListApp
//
//  Created by Developer on 21/08/14.
//  Copyright (c) 2014 Modius. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageModel, ImageDownloader, ImageDownloadManager;

@interface ImageDownloader : NSObject

@property (nonatomic, strong) NSString *imageUrlString;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end

//image model
@interface ImageModel : NSObject

+ (ImageModel *) imInstanse;
@property (strong, nonatomic) NSMutableDictionary *downloadedImageDictionary;
@property (strong, nonatomic) NSMutableDictionary *downloadingImageDictionary;

- (void) setImage : (UIImage *) image forKey : (NSString *) key;
- (UIImage *) getImageForKey : (NSString *) key;
- (void) removeImageForKey : (NSString *) key;

- (void) setImageDownloader : (ImageDownloader *) imageDownloader forKey : (NSString *) key;
- (ImageDownloader *) getImageDownloaderForKey : (NSString *) key;
- (void) removeImageDownloderForKey : (NSString *) key;
@end

@interface ImageDownloadManager : NSObject

- (id) initToDownloadImage : (NSString *) imageUrlString
              forImageView : (UIImageView *) imageView
               inTableView : (UITableView *) tableView
               placeHolder : (NSString *) imageName;


@end

@interface LazyImageView : UIImageView
- (id) initWithFrame : (CGRect) frame andImagePath:(NSString *)imageUrlString;
- (void) setImageWithName:(NSString *)imageName inCircle : (BOOL) condition;
- (void) setImageWithUrl:(NSString *)imageUrl inCircle : (BOOL) condition;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end
