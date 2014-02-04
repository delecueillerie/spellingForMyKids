//
//  Word.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 02/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Word : NSManagedObject

@property (nonatomic, retain) NSData * audio;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSSet *spelling;
@end

@interface Word (CoreDataGeneratedAccessors)

- (void)addSpellingObject:(NSManagedObject *)value;
- (void)removeSpellingObject:(NSManagedObject *)value;
- (void)addSpelling:(NSSet *)values;
- (void)removeSpelling:(NSSet *)values;

@end
