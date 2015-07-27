//
//  Term.h
//  v2
//
//  Created by Developer on 30/08/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TermsList;

@interface Term : NSManagedObject

@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) TermsList *list;

@end
