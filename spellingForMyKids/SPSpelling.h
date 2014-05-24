//
//  SPASpellingTVC.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 11/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPAnObject.h"
#import "Spelling.h"
#import "SPObjectList.h"

@interface SPSpelling : SPAnObject <UITextFieldDelegate, objectListDelegate>

@property (strong, nonatomic) NSPredicate *predicate;
@property (nonatomic) BOOL allowsMultipleSelection;
@property (strong, nonatomic) NSArray *objectList;
@end
