//
//  Dictionary.m
//  v2
//
//  Created by Sabir on 7/26/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import "Dictionary.h"



@implementation Dictionary
@synthesize word;
@synthesize definitionResult;
@synthesize dictionary;
@synthesize thesaurusResult;
@synthesize definition;

- (id)initWithTerm:(NSString *)term
{
    self = [super init];
    if (self) {
        self.word = term;
        self.dictionary = [Lexicontext sharedDictionary];
        self.definitionResult = [self.dictionary definitionAsDictionaryFor:self.word];
        self.thesaurusResult = [self.dictionary thesaurusFor:self.word];
        self.definition = [self.dictionary definitionFor:self.word];
    }
    
    return self;
}

- (id)initWithRandomTerm
{
    self = [super init];
    if (self) {
        self.dictionary = [Lexicontext sharedDictionary];
        self.word = [self.dictionary randomWord];
        self.definitionResult = [self.dictionary definitionAsDictionaryFor:self.word];
        self.thesaurusResult = [self.dictionary thesaurusFor:self.word];
        self.definition = [self.dictionary definitionFor:self.word];
    }
    
    return self;
}


- (NSString *)getDefinition
{
    return self.definition;
}

- (NSArray *)getPartsOfSpeech
{
    return [self.definitionResult allKeys];
}


- (NSArray *)getDefinitionsForPartOfSpeech:(NSString *)partOfSpeech
{
    NSMutableArray *deflist = [[NSMutableArray alloc] init];
    
    for (NSString *oneDef in self.definitionResult[partOfSpeech] ) {      //loop over the values
        NSArray *listItems = [oneDef componentsSeparatedByString:@";"];   //split on the ;
        for (NSString *oneDefOrSent in listItems ) {                      //iterate over the new array to not get example sentences
            if ([oneDefOrSent rangeOfString:@"\""].location == NSNotFound) {
                [deflist addObject:oneDefOrSent];
            }
        }
    }
    
    return deflist;
}


- (NSArray *)getExampleSentenceForPartOfSpeech:(NSString *)partOfSpeech
{
    NSMutableArray *exlist = [[NSMutableArray alloc] init];
    
    for (NSString *oneDef in self.definitionResult[partOfSpeech] ) {
        NSArray *listItems = [oneDef componentsSeparatedByString:@"; "];
        for (NSString *oneDefOrSent in listItems ) {
            if ([oneDefOrSent rangeOfString:@"\""].location != NSNotFound) {      // Eliminates example sentences
                [exlist addObject:oneDefOrSent];
            }
        }
    }
    return exlist;
}

- (NSArray *)getSynonymsForPartOfSpeech:(NSString *)partOfSpeech
{
    NSMutableArray *synlist = [[NSMutableArray alloc] init];
    
    for (NSArray *Synarrays in self.thesaurusResult[partOfSpeech] ) {
        for (NSString *oneSyn in Synarrays ) {
            if ([oneSyn rangeOfString:self.word].location == NSNotFound) {  // Eliminates current word from output
                [synlist addObject:oneSyn];
            }
        }
    }
    return synlist;
}

- (NSURL *)getImageForWord:(NSString*)_word
{
    NSArray *images = [self.dictionary imageURLsFor:_word];
    NSLog(@"%@: %d, %@",_word, [images count],images);
    if ([images count] > 0) {
        return [images objectAtIndex:0];
    }
    return nil;
}



@end
