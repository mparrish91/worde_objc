//
//  CLAProfileImageView.m
//  ClassListApp
//
//  Created by Developer on 21/08/14.
//  Copyright (c) 2014 Modius. All rights reserved.
//

#import "LazyImageView.h"

#define kAppIconSize 48

@interface ImageDownloader ()
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;
@end


@implementation ImageDownloader

#pragma mark

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_imageUrlString]];
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    [[ImageModel imInstanse] setImage:image forKey:[[[connection currentRequest] URL] absoluteString]];
    
    //    if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
    //	{
    //        CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
    //		UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
    //		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    //		[image drawInRect:imageRect];
    //		self.appRecord.appIcon = UIGraphicsGetImageFromCurrentImageContext();
    //		UIGraphicsEndImageContext();
    //    }
    //    else
    //    {
    //        self.appRecord.appIcon = image;
    //    }
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
        self.completionHandler();
}

@end

@implementation ImageModel


+ (ImageModel *) imInstanse{
    static ImageModel *instanse = nil;
    @synchronized(self){
        if (instanse == nil) {
            instanse = [[ImageModel alloc] init];
        }
    }
    return instanse;
}

- (id) init{
    if (self = [super init]) {
        //initialize image array
        _downloadedImageDictionary = [NSMutableDictionary dictionary];
        _downloadingImageDictionary= [NSMutableDictionary dictionary];
        
        //memory manage ment
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            _downloadedImageDictionary = nil;
            _downloadingImageDictionary = nil;
        }];
    }
    return self;
}


- (void) setImage : (UIImage *) image forKey : (NSString *) key{
    if (image == nil || key == nil) {
        //        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error!", nil) message:NSLocalizedString(@"Image or key can not be nil!", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil] show];
        return;
    }
    if (_downloadedImageDictionary == nil)
        _downloadedImageDictionary = [NSMutableDictionary dictionary];
    
    [_downloadedImageDictionary setObject:image forKey:key];
}

- (UIImage *) getImageForKey : (NSString *) key{
    UIImage *image = nil;
    image = (UIImage *)[_downloadedImageDictionary objectForKey:key];
    return image;
}

- (void) removeImageForKey : (NSString *) key{
    [_downloadedImageDictionary removeObjectForKey:key];
}

#pragma mark - Image Downloader
- (void) setImageDownloader : (ImageDownloader *) imageDownloader forKey : (NSString *) key{
    if (imageDownloader == nil || key == nil) {
        //        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error!", nil) message:NSLocalizedString(@"Image or key can not be nil!", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil] show];
        return;
    }
    if (_downloadingImageDictionary == nil)
        _downloadingImageDictionary= [NSMutableDictionary dictionary];
    
    [_downloadingImageDictionary setObject:imageDownloader forKey:key];
    
}

- (ImageDownloader *) getImageDownloaderForKey : (NSString *) key{
    ImageDownloader *imageDownloader = nil;
    imageDownloader = (ImageDownloader *) [_downloadingImageDictionary objectForKey:key];
    return imageDownloader;
}

- (void) removeImageDownloderForKey : (NSString *) key{
    [_downloadingImageDictionary removeObjectForKey:key];
}

@end

@implementation ImageDownloadManager

- (id) initToDownloadImage : (NSString *) imageUrlString
              forImageView : (UIImageView *) imageView
               inTableView : (UITableView *) tableView
               placeHolder : (NSString *) imageName{
    if (self = [super init]) {
        UIImage *image = [[ImageModel imInstanse] getImageForKey:imageUrlString];
        if (!image)
        {
            //            if (tableView.dragging == NO && tableView.decelerating == NO)
            //            {
            [self startIconDownload:imageUrlString forImageView:imageView];
            //            }
            //            // if a download is deferred or in progress, return a placeholder image
            if (imageName != nil) imageView.image = [UIImage imageNamed:imageName];
            
        }
        else
        {
            [self setImageViewFrame:imageView];
            imageView.image = image;
        }
    }
    return self;
}

- (void)startIconDownload:(NSString *)imageUrlString forImageView:(UIImageView *)imageView
{
    ImageDownloader *iconDownloader = [[ImageModel imInstanse] getImageDownloaderForKey:imageUrlString];
    
    if (iconDownloader == nil) {
        iconDownloader = [[ImageDownloader alloc] init];
        iconDownloader.imageUrlString = imageUrlString;
        [iconDownloader setCompletionHandler:^{
            
            // Display the newly loaded image
            [self setImageViewFrame:imageView];
            imageView.image = [[ImageModel imInstanse] getImageForKey:imageUrlString];
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [[ImageModel imInstanse] removeImageDownloderForKey:imageUrlString];
            
        }];
        [[ImageModel imInstanse] setImageDownloader:iconDownloader forKey:imageUrlString];
        [iconDownloader startDownload];
    }
}

- (void) setImageViewFrame : (UIImageView *) imageView{
//    CGPoint center = imageView.center;
//    CGRect frame = imageView.frame;
//    CGSize itemSize = (frame.size.width < 80) ? CGSizeMake(66, 66) : frame.size;
//
//
//    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
//    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//    [imageView.image drawInRect:imageRect];
//    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    imageView.center = center;
    
}

@end



@implementation LazyImageView

- (id) initWithFrame : (CGRect) frame andImagePath:(NSString *)imageUrlString{
    self = [super initWithFrame:frame];
    if (self) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        [self addSubview:_activityIndicator];
        [self setImageWithUrl:imageUrlString inCircle:NO];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void) awakeFromNib{
    CGPoint center = self.center;
    CGRect frame = self.frame;
    frame.size = CGSizeMake(60.0f, 60.0f);
    [self setFrame:frame];
    [self setCenter:center];
}

- (void) setImageWithName:(NSString *)imageName inCircle : (BOOL) condition{
    [self setImage:[UIImage imageNamed:imageName]];
    
//    if (condition) [self makeItCircled];
}

- (void) setImageWithUrl:(NSString *)imageUrl inCircle : (BOOL) condition{
//    ImageDownloadManager *downloadManager = [[ImageDownloadManager alloc]
//                                             initToDownloadImage:imageUrl
//                                             forImageView:self
//                                             inTableView:nil
//                                             placeHolder:nil];
//    downloadManager = nil;
    [_activityIndicator startAnimating];
    UIImage *image = [[ImageModel imInstanse] getImageForKey:imageUrl];
    
    if (image)
        [self updateImage:image];
    else
        [self performSelectorInBackground:@selector(downloadImage:) withObject:imageUrl];
    
    if (condition) [self makeItCircled];
}

- (void) downloadImage : (NSString *) imageUrl{
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
    if (image) {
        [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:YES];
        [[ImageModel imInstanse] setImage:image forKey:imageUrl];
    }
}

- (void) updateImage : (UIImage *) image{
    [_activityIndicator stopAnimating];
    self.image = image;
}

- (void) makeItCircled{
    float radius = self.frame.size.width / 2;
    CALayer *circle = [CALayer layer];
    circle.bounds = CGRectMake(0,0, radius, radius);
    CGRect frame =  self.frame;
    frame.origin = CGPointMake(0, 0);
    circle.frame = frame;
    circle.cornerRadius = radius/2;
    circle.backgroundColor = [UIColor clearColor].CGColor;
    circle.borderWidth = 1.0;
    circle.masksToBounds = YES;
    circle.borderColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:circle];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
