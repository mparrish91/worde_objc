//
//  SearchImages.h
//  WordWise
//
//  Created by Developer on 20/11/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import <Foundation/Foundation.h>
//jack account
//key:winged-will-769
//cx:004864556898075540981:kpks4pkhuae

//arpit account
//browserkey:    AIzaSyDTlsrnaHP1pKTqxHBsmjjryNa8JygNz_A
//wroking : https://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=QUERY

@protocol SearchImagesDelegate <NSObject>
- (void) searchResult : (id) result error : (NSError *)error;
- (void) imageDownloaded : (id) image error : (NSError *)error;
@end

@interface SearchImages : NSObject<NSURLConnectionDataDelegate>

//
- (id) initWithDelegate : (id) delegate;
- (void) searchImageForWord : (NSString *) word;

@property (nonatomic, strong) NSString *word;
@property (nonatomic, strong) id <SearchImagesDelegate> delegate;

@end
