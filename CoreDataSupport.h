//
//  CoreDataSupport.h
//  v2
//
//  Created by Developer on 27/08/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Term.h"
#import "Example.h"
#import "Mneuomic.h"
#import "AppDelegate.h"

#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface CoreDataSupport : NSObject

//fetch request
+ (NSFetchRequest *) getFetchRequestForEntity : (NSString *) entityName predicate : (NSString *) predicateCondition;

//save request
+ (BOOL) saveExample : (NSString *) exampleString forTerm : (NSString *) term;
+ (BOOL) saveMneuomic : (NSString *) exampleString forTerm : (NSString *) term;

@end
