//
//  SearchImages.m
//  WordWise
//
//  Created by Developer on 20/11/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import "SearchImages.h"
//#import "JSON.h"

@implementation SearchImages


- (id) initWithDelegate : (id) delegate{
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

- (NSURL *) getGoogleCustomSearchUrl : (NSString *) word{
//    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/customsearch/v1?q=%@&key=%@&cx=%@", word, @"AIzaSyAxlxWhYGYuimVNBkzD89yU1xkj42xj1fo", @"017659011722520714774:6bw9wrz22lk"];
//    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/customsearch/v1?q=%@cx=017659011722520714774%%3A6bw9wrz22lk&fileType=png%%2C+jpg&imgColorType=color&imgSize=medium&imgType=photo&searchType=image&key=AIzaSyAxlxWhYGYuimVNBkzD89yU1xkj42xj1fo", word];
    
    //parry's account's
  //https://www.googleapis.com/customsearch/v1?q=a&key=AIzaSyDuj9I-15-yCbW3v79KPpnN5UGRodj-M0o&cx=000925953623978402686:4ivsubwp3-y
    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/customsearch/v1?q=%@&safe=high&cx=000925953623978402686:4ivsubwp3-y&fileType=png%%2C+jpg&imgColorType=color&imgSize=medium&imgType=photo&searchType=image&key=AIzaSyDuj9I-15-yCbW3v79KPpnN5UGRodj-M0o", [word stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return [NSURL URLWithString:urlString];
}

- (void) searchImageForWord : (NSString *) word{
    _word = word;
    NSLog(@"word = %@", word);
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[self getGoogleCustomSearchUrl:word]]
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                           [self parseJSONData:data error:error];

    }];
}

- (void) parseJSONData : (NSData *) objectNotation error : (NSError *) error{
    NSError *localError = nil;
    id parsedObject = nil;
    if (objectNotation != nil)
        parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:kNilOptions error:&localError];
    
    [self.delegate searchResult:parsedObject error:error];
    
    
//    NSArray *results = [parsedObject valueForKey:@"results"];
//    NSLog(@"Count %lu", (unsigned long)results.count);
//    
//    NSString *response = [[NSString alloc] initWithData:<#(NSData *)#> encoding:<#(NSStringEncoding)#>];
//    id respJSON = [response JSONValue];
    
}

@end
