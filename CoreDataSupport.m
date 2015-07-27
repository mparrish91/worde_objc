//
//  CoreDataSupport.m
//  v2
//
//  Created by Developer on 27/08/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import "CoreDataSupport.h"

@implementation CoreDataSupport

//save of update
+ (NSFetchRequest *) getFetchRequestForEntity : (NSString *) entityName predicate : (NSString *) predicateCondition{
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entityName
                                   inManagedObjectContext:context];
    [request setEntity:entity];
    predicateCondition = [predicateCondition stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateCondition];
    [request setPredicate:predicate];
    return request;
}

+ (BOOL) saveExample : (NSString *) exampleString forTerm : (NSString *) term{
    if ([CoreDataSupport exampleExists:exampleString froTerm:term]) {
        return NO;
    }
    Example *example = [NSEntityDescription
                                       insertNewObjectForEntityForName:NSStringFromClass([Example class])
                                       inManagedObjectContext:[APP_DELEGATE managedObjectContext]];
    [example setExample:exampleString];
    [example setTerm:term];
    
    NSError *error = nil;
    if (![[APP_DELEGATE managedObjectContext] save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
        return FALSE;
    }
    
    return YES;
}

+ (BOOL) exampleExists : (NSString *) example froTerm : (NSString *) term{
    NSFetchRequest *fRequest = [CoreDataSupport getFetchRequestForEntity:@"Example" predicate:[NSString stringWithFormat:@"example = \"%@\" AND term = \"%@\"", example, term]];
    NSError *error = nil;
    NSArray *mneuomicArray = [[APP_DELEGATE managedObjectContext] executeFetchRequest:fRequest error:&error];
    return [mneuomicArray count];
}

//ANMPG5351P
+ (BOOL) saveMneuomic : (NSString *) mneuomicString forTerm : (NSString *) term{
    if ([CoreDataSupport mneuomicExists:mneuomicString froTerm:term]) {
        return NO;
    }
    Mneuomic *mneuomic = [NSEntityDescription
                        insertNewObjectForEntityForName:NSStringFromClass([Mneuomic class])
                        inManagedObjectContext:[APP_DELEGATE managedObjectContext]];
    [mneuomic setMneuomic:mneuomicString];
    [mneuomic setTerm:term];
    
    NSError *error = nil;
    if (![[APP_DELEGATE managedObjectContext] save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
        return FALSE;
    }
    return YES;
}

+ (BOOL) mneuomicExists : (NSString *) mneuomic froTerm : (NSString *) term{
    NSFetchRequest *fRequest = [CoreDataSupport getFetchRequestForEntity:@"Mneuomic" predicate:[NSString stringWithFormat:@"mneuomic = \"%@\" AND term = \"%@\"", mneuomic, term]];
    NSError *error = nil;
    NSArray *mneuomicArray = [[APP_DELEGATE managedObjectContext] executeFetchRequest:fRequest error:&error];
    return [mneuomicArray count];
}


@end
