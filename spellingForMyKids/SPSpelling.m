//
//  SPASpellingTVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 11/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPSpelling.h"
//Managed Objects
#import "Word.h"
#import "Spelling.h"
#import "SpellingTest.h"

//VC
#import "SPWordList.h"
#import "SPSpellingTest.h"

//UI Views




@interface SPSpelling ()

@property (strong, nonatomic) Spelling *spellingSelected;

@property (weak, nonatomic) IBOutlet UIView *viewContainerWordList;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSpellingName;
@property (weak, nonatomic) IBOutlet UILabel *labelSpellingName;


@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonItemAdd;

@end

@implementation SPSpelling

@synthesize objectList = _objectList;

/*/////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
Accessors
//////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////*/

- (Spelling *) spellingSelected {
    if (! _spellingSelected) _spellingSelected = (Spelling *) self.objectSelected;
    return _spellingSelected;
}


- (void) setEditing:(BOOL)editing {
    [super setEditing:editing];
    
    //displaying UI view depends on editing mode
    self.textFieldSpellingName.hidden=!editing;
    self.labelSpellingName.hidden=editing;
    self.toolbar.hidden = !editing;
}

- (NSSet *) objectList {
    _objectList = self.spellingSelected.words;
    return _objectList;
}

/*//////////////////////////////////////////////////////////
 //////////////////////////////////////////////////////////
 Lifecycle
 //////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////*/

- (void) viewDidLoad {
    [super viewDidLoad];
    self.objectListVC = [self addObjectListIdentifier:@"wordList" toView:self.viewContainerWordList];
    self.objectListVC.dataSource = self;
    
    //displaying UI view depends on editing mode
    self.textFieldSpellingName.hidden=!self.editing;
    self.labelSpellingName.hidden=self.editing;
    
    //update UI content
    self.labelSpellingName.text = self.spellingSelected.name;
    self.textFieldSpellingName.text = self.spellingSelected.name;
    self.textFieldSpellingName.delegate = self;

    switch ([self.delegate objectState:self]) {
        case objectStateRead:
        {
            self.toolbar.hidden = YES;
            break;
        }
        case objectStateTest:
        {
            break;
        }
        case objectStateReadOnly:
        {
            break;
        }
        
        case objectStateEdit:
        {
            
            break;
        }
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self setEditing:self.editing];
    
    
}

/*/////////////////////////////////////////////////////////
 //////////////////////////////////////////////////////////
 Triggered actions
 //////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////*/

- (IBAction)addWords:(id)sender {
    SPWordList *wordList = [self.storyboard instantiateViewControllerWithIdentifier:@"wordList"];
    wordList.delegate = self;
    wordList.dataSource = self;
    [self.navigationController pushViewController:wordList animated:YES];
}


- (void) saveAndPop {
    self.spellingSelected.name = self.textFieldSpellingName.text;
    [super saveAndPop];
}

- (void) saveAndRefresh {
    self.spellingSelected.name = self.textFieldSpellingName.text;
    [super saveAndRefresh];
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Text Field Delegate
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////
// II - a - delegate
//////////////////////////////////////////////////////////

- (void) textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 0:
            self.spellingSelected.name = textField.text;
            break;
        case 1:
            self.spellingSelected.explication = textField.text;
        default:
            break;
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

/*///////////////////////////////////////////////////////
 objectList Delegate
 //////////////////////////////////////////////////////*/

- (datasource) datasource:(id)sender {
    if (sender == self.objectListVC) {
        return datasourceArray;
    } else {
        return datasourceFetched;
    }
}

- (NSArray *) arrayData:(id) sender {
    return [self.spellingSelected.words allObjects];
}

- (void) addObjectToList:(NSManagedObject * ) object {
    if ([object isKindOfClass:[Word class]]) {
        Word *wordNew = (Word *)object;
        [self.spellingSelected addWordsObject:wordNew];
        [super saveAndRefresh];
    }
}

- (void) removeObjectFromList:(NSManagedObject *)object {
    if ([object isKindOfClass:[Word class]]) {
        Word *wordNew = (Word *)object;
        [self.spellingSelected removeWordsObject:wordNew];
        [super saveAndRefresh];
    }
}
- (NSPredicate *) predicate:(id) sender {
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:10];
    for (Word *word in self.spellingSelected.words) {
        [mArray addObject:word.name];
        
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"!name IN %@", mArray];
    return predicate;
}

- (rowSelected) rowSelected:(id) sender {
    if (!(sender==self.objectListVC)) {
        return rowSelectedUniqueAndPop;
    } else {
        return rowSelectedOpenVC;
    }
}

@end
