//
//  Kid.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 02/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Kid : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSSet *test;
@end

@interface Kid (CoreDataGeneratedAccessors)

- (void)addTestObject:(NSManagedObject *)value;
- (void)removeTestObject:(NSManagedObject *)value;
- (void)addTest:(NSSet *)values;
- (void)removeTest:(NSSet *)values;

@end
