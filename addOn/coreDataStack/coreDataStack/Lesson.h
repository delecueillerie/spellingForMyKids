//
//  Lesson.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 26/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Spelling;

@interface Lesson : NSManagedObject

@property (nonatomic, retain) NSData * contents;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSSet *spellings;
@end

@interface Lesson (CoreDataGeneratedAccessors)

- (void)addSpellingsObject:(Spelling *)value;
- (void)removeSpellingsObject:(Spelling *)value;
- (void)addSpellings:(NSSet *)values;
- (void)removeSpellings:(NSSet *)values;

@end
