//
//  Test.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 02/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Kid;

@interface Test : NSManagedObject

@property (nonatomic, retain) NSDate * endedAt;
@property (nonatomic, retain) NSNumber * result;
@property (nonatomic, retain) NSDate * startedAt;
@property (nonatomic, retain) NSSet *kid;
@property (nonatomic, retain) NSManagedObject *spelling;
@end

@interface Test (CoreDataGeneratedAccessors)

- (void)addKidObject:(Kid *)value;
- (void)removeKidObject:(Kid *)value;
- (void)addKid:(NSSet *)values;
- (void)removeKid:(NSSet *)values;

@end
