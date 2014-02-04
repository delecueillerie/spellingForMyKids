//
//  Spelling.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 02/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Test, Word;

@interface Spelling : NSManagedObject

@property (nonatomic, retain) NSString * explication;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *words;
@property (nonatomic, retain) Test *tests;
@end

@interface Spelling (CoreDataGeneratedAccessors)

- (void)addWordsObject:(Word *)value;
- (void)removeWordsObject:(Word *)value;
- (void)addWords:(NSSet *)values;
- (void)removeWords:(NSSet *)values;

@end
