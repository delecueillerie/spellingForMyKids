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
#import "SPSpellingList.h"
#import "SPWordList.h"
#import "SPSpellingTestList.h"
#import "SPTestVC.h"

@interface SPSpellingTest ()

@property (weak, nonatomic) IBOutlet UILabel *spellingName;
@property (weak, nonatomic) IBOutlet UIView *containerWordList;


@property (strong, nonatomic) SPWordList *wordListVC;
@property (strong, nonatomic) SPSpellingTestList *spellingTestListVC;
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

- (void) setObjectAddedFromList:(NSManagedObject *)objectAddedFromList {
    if ([objectAddedFromList isKindOfClass:[Spelling class]]) {
        self.spellingTestSelected.spelling = (Spelling *) objectAddedFromList;
        self.spellingName.text = self.spellingTestSelected.spelling.name;
    }
}

/*/////////////////////////////////////////////////////////////////////////////////////////
 Life Cycle Management
 /*////////////////////////////////////////////////////////////////////////////////////////*/

- (void) viewDidLoad {
    self.spellingName.text = self.spellingTestSelected.spelling.name;
    self.wordListVC = (SPWordList *)[self addObjectListIdentifier:@"wordList" toView:self.containerWordList];
}

/*/////////////////////////////////////////////////////////////////////////////////////////
 Trigerred Actions
 /*////////////////////////////////////////////////////////////////////////////////////////*/

-( void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"playTest"]) {
        SPTestVC *testVC = (SPTestVC *)segue.destinationViewController;
        testVC.spellingTestSelected = self.objectSelected;
        testVC.managedObjectContext = self.managedObjectContext;
    } 
}
/*/////////////////////////////////////////////////////////////////////////////////////
 ObjectList delegate & datasource
 ////////////////////////////////////////////////////////////////////////////////////*/

- (NSString *) titleNavigationBar :(id) sender {
    if ([sender isKindOfClass:[Spelling class]]) {
    return @"Choose your spelling";
    }
    else return nil;
}

- (NSArray *) arrayData:(id) sender {
    if ([sender isKindOfClass:[SPWordList class]]) {
        return [self.spellingTestSelected.spelling.words allObjects];
    } else {
        return nil;
    }
}

- (rowSelected) rowSelected:(id)sender {
    if ([sender isKindOfClass:[SPWordList class]]) {
        SPWordList *wordListVC = (SPWordList *)sender;
        if (wordListVC.parentViewController == self) {
            return rowSelectedOpenVC;
        } else {
            return rowSelectedUniqueAndPop;
        }
    } else {
        return rowSelectedUniqueAndPop;
    }
}

- (NSPredicate *) predicate:(id) sender {
    /*if ([sender isKindOfClass:[SPSpellingTestList class]]) {
        return [NSPredicate predicateWithFormat:]
    }*/
    return [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
}



@end
