//
//  SPAnObjectWithList.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 30/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPAnObject.h"
#import "SPObjectList.h"

@interface SPAnObjectWithList : SPAnObject <objectListDelegate>



//objectListDelegate propoerties
@property (strong, nonatomic) NSPredicate *predicate;
@property (nonatomic) BOOL allowsMultipleSelection;

@property (strong, nonatomic) SPObjectList *objectListVC;
@property (strong, nonatomic) NSSet *objectList;
- (SPObjectList *) addObjectListIdentifier: (NSString *) identifier toView:(UIView *) view;
- (NSSet *) updatedRelationshipIn:(SPObjectList *)objectListVC;
@property (weak, nonatomic) NSString *key;
@end
