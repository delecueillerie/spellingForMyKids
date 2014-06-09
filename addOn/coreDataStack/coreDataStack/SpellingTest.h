//
//  SpellingTest.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 26/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Kid, Spelling, Test;

@interface SpellingTest : NSManagedObject

@property (nonatomic, retain) NSDate * startedAt;
@property (nonatomic, retain) NSDate * endedAt;
@property (nonatomic, retain) NSNumber * mode;
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) Kid *kid;
@property (nonatomic, retain) NSSet *wordTests;
@property (nonatomic, retain) Spelling *spelling;
@end

@interface SpellingTest (CoreDataGeneratedAccessors)

- (void)addWordTestsObject:(Test *)value;
- (void)removeWordTestsObject:(Test *)value;
- (void)addWordTests:(NSSet *)values;
- (void)removeWordTests:(NSSet *)values;

@end
