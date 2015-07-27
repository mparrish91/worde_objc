//
//  TermsList.h
//  v2
//
//  Created by Developer on 30/08/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Term;

@interface TermsList : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *word;
@end

@interface TermsList (CoreDataGeneratedAccessors)

- (void)addWordObject:(Term *)value;
- (void)removeWordObject:(Term *)value;
- (void)addWord:(NSSet *)values;
- (void)removeWord:(NSSet *)values;

@end
