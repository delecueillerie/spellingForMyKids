//
//  SPSpellingTest.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 03/09/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPSpellingTest.h"
#import "SpellingTest.h"
#import "SPSpelling.h"

@interface SPSpellingTest ()

@property (strong, nonatomic) SpellingTest *spellingTestSelected;
@end

@implementation SPSpellingTest



/*/////////////////////////////////////////////////////////////////////////////////////////
 Accessors
 /*////////////////////////////////////////////////////////////////////////////////////////*/

- (SpellingTest *) spellingTestSelected {
    if (!_spellingTestSelected) {
        _spellingTestSelected = (SpellingTest *) self.objectSelected;
    }
    return _spellingTestSelected;
}


- (void) viewDidLoad {
    
    
    if (!self.spellingTestSelected.spelling) {
        NSManagedObjectContext * managedObjectContextAdd = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContextAdd setParentContext:self.managedObjectContext];
        
        NSManagedObject *objectNew = [NSEntityDescription insertNewObjectForEntityForName:@"Spelling" inManagedObjectContext:managedObjectContextAdd];
        SPSpelling *viewControllerAnObject = [self.storyboard instantiateViewControllerWithIdentifier:@"spellingList"];
        viewControllerAnObject.objectSelected = objectNew;
        viewControllerAnObject.managedObjectContext = managedObjectContextAdd;
        viewControllerAnObject.editing = NO;
        [self.navigationController pushViewController:viewControllerAnObject animated:NO];

        
    }
}
@end
