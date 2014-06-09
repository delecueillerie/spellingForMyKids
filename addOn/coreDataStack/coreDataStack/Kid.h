//
//  Kid.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 26/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SpellingTest, Test;

@interface Kid : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * schoolLevel;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSSet *test;
@property (nonatomic, retain) SpellingTest *spellingTests;
@end

@interface Kid (CoreDataGeneratedAccessors)

- (void)addTestObject:(Test *)value;
- (void)removeTestObject:(Test *)value;
- (void)addTest:(NSSet *)values;
- (void)removeTest:(NSSet *)values;

@end
