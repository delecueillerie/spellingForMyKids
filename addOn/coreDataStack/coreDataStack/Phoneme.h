//
//  Phoneme.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 30/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Grapheme, Word;

@interface Phoneme : NSManagedObject

@property (nonatomic, retain) NSString * api;
@property (nonatomic, retain) NSData * audio;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *graphems;
@property (nonatomic, retain) NSSet *words;
@end

@interface Phoneme (CoreDataGeneratedAccessors)

- (void)addGraphemsObject:(Grapheme *)value;
- (void)removeGraphemsObject:(Grapheme *)value;
- (void)addGraphems:(NSSet *)values;
- (void)removeGraphems:(NSSet *)values;

- (void)addWordsObject:(Word *)value;
- (void)removeWordsObject:(Word *)value;
- (void)addWords:(NSSet *)values;
- (void)removeWords:(NSSet *)values;

@end
