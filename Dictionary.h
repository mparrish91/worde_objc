//
//  Dictionary.h
//  v2
//
//  Created by Sabir on 7/26/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lexicontext.h"

@interface Dictionary : NSObject

@property (nonatomic, strong) NSString *word;
@property (nonatomic, strong) NSDictionary *definitionResult;
@property (nonatomic, strong) Lexicontext *dictionary;
@property (nonatomic, strong) NSDictionary *thesaurusResult;
@property (nonatomic, strong) NSString *definition;

- (id)initWithTerm:(NSString *)term;
- (id)initWithRandomTerm;

- (NSString *)getDefinition;
- (NSArray *)getPartsOfSpeech;
- (NSArray *)getDefinitionsForPartOfSpeech:(NSString *)partOfSpeech;
- (NSArray *)getExampleSentenceForPartOfSpeech:(NSString *)partOfSpeech;
- (NSArray *)getSynonymsForPartOfSpeech:(NSString *)partOfSpeech;
//- (NSArray *)getImagesForPartOfSpeech:(NSString *)word;
- (NSURL *)getImageForWord:(NSString*)_word;

@end
