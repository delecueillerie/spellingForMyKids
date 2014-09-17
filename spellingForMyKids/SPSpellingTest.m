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

@interface SPSpellingTest ()

@property (weak, nonatomic) IBOutlet UILabel *spellingName;
@property (weak, nonatomic) IBOutlet UIView *containerWordList;
@property (weak, nonatomic) IBOutlet UIView *containerResult;

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
    if (!self.spellingTestSelected.spelling) {
        SPSpellingList *objectList = [self.storyboard instantiateViewControllerWithIdentifier:@"spellingList"];
        objectList.delegate = self;
        objectList.dataSource = self;
        [self.navigationController pushViewController:objectList animated:NO];
    }
    self.wordListVC = (SPWordList *)[self addObjectListIdentifier:@"wordList" toView:self.containerWordList];
    self.spellingTestListVC = (SPSpellingTestList *)[self addObjectListIdentifier:@"spellingTestList" toView:self.containerResult];

}

- (void) viewWillAppear:(BOOL)animated {
    [self updateUIWithObjectValues];
}

/*/////////////////////////////////////////////////////////////////////////////////////////
 Trigerred Actions
 /*////////////////////////////////////////////////////////////////////////////////////////*/

- (void) updateUIWithObjectValues {
    if (self.spellingTestSelected.spelling) {
        self.spellingName.text = self.spellingTestSelected.spelling.name;
    } else {
        self.spellingName.text = @"no spelling selected";
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
//- (void) objectAddedFromList:(NSManagedObject *)object;

- (NSArray *) arrayData:(id) sender {
    if ([sender isKindOfClass:[SPWordList class]]) {
        return [self.spellingTestSelected.spelling.words allObjects];
    } else {
        return nil;
    }
}

- (void) updateArrayData:(NSArray *)arrayUpdatedData {
    
}

- (void) addObjectToList:(NSManagedObject * ) object {
    if ([object isKindOfClass:[Spelling class]]) {
        self.spellingTestSelected.spelling = (Spelling *) object;
        [self updateUIWithObjectValues];
    }
}

- (rowSelected) rowSelected:(id)sender {
    return rowSelectedUniqueAndPop;
}

- (NSPredicate *) predicate:(id) sender {
    /*if ([sender isKindOfClass:[SPSpellingTestList class]]) {
        return [NSPredicate predicateWithFormat:<#(NSString *), ...#>]
    }*/
    return [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
}



@end
