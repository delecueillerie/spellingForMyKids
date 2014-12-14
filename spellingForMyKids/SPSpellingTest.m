//
//  SPSpellingTest.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 03/09/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//


//MODEL
#import "SpellingTest+enhanced.h"
#import "Spelling+enhanced.h"

#import "SPSpellingTest.h"
//#import "SPSpelling.h"
//#import "SPSpellingList.h"
#import "SPWordList.h"
#import "SPSpellingTestList.h"
#import "SPTestVC.h"
//#import "SPMenuVC.h"
#import "SPWordTestList.h"

//VIEW
#import "UIImageView+cornerRadius.h"
#import "UIImage+medal.h"

@interface SPSpellingTest ()

//UI outlet
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIView *viewResult;
@property (weak, nonatomic) IBOutlet UILabel *spellingName;
@property (weak, nonatomic) IBOutlet UIView *containerWordList;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUser;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLevel;

@property (strong, nonatomic) UIViewController *containerVC;
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
    [self.imageViewUser roundWithImage:[UIImage imageWithData:self.spellingTestSelected.kid.image]];
    self.imageViewLevel.image = [UIImage medalFor:[self.spellingTestSelected spellingTestMedal]];
    
    if (self.spellingTestSelected.endedAt) {
        //update UI visibility
        self.toolbar.hidden = YES;
        self.viewResult.hidden = NO;
        //add wordTest list
        self.containerVC = [self addObjectListIdentifier:@"wordTestList" toView:self.containerWordList];
    } else {
        //update UI visibility
        self.toolbar.hidden = NO;
        self.viewResult.hidden = YES;
        //add word list
        self.containerVC = [self addObjectListIdentifier:@"wordList" toView:self.containerWordList];
    }
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

- (datasource) datasource:(id)sender {
    return datasourceArray;
}

- (NSString *) titleNavigationBar :(id) sender {
    if ([sender isKindOfClass:[SPWordList class]]) {
        return @"Word list";
    } else if ([sender isKindOfClass:[SPWordTestList class]]) {
        return @"Word test";
    } else return nil;
}

- (NSArray *) arrayData:(id) sender {
    if ([sender isKindOfClass:[SPWordList class]]) {
        return [self.spellingTestSelected.spelling.words allObjects];
    } else if ([sender isKindOfClass:[SPWordTestList class]]) {
        //NSLog(@"number of wordTest %i", [[self.spellingTestSelected.wordTests allObjects] count] );
        return [self.spellingTestSelected.wordTests allObjects];
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
    } else if ([sender isKindOfClass:[SPWordTestList class]]) {
        return rowSelectedDisabled;
        
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
