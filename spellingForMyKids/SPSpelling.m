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

//VC
#import "SPWordList.h"
#import "SPTestVC.h"

//UI Views




@interface SPSpelling ()

@property (strong, nonatomic) Spelling *spellingSelected;

@property (weak, nonatomic) IBOutlet UIView *viewContainerWordList;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSpellingName;
@property (weak, nonatomic) IBOutlet UILabel *labelSpellingName;


@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
//strong reference needed because if we remove barButton from toolbar for a specific state of the VC we will loose his reference
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonItemKeyboard;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonItemPlay;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonItemAdd;

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
    if (!(super.editing == editing)) {
        //displaying UI view depends on editing mode
        self.textFieldSpellingName.hidden=!editing;
        self.labelSpellingName.hidden=editing;
        [self updateToolbarButtons];
    }
    

    
    [super setEditing:editing];

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
    self.objectListVC.delegate = self;
    
    //displaying UI view depends on editing mode
    self.textFieldSpellingName.hidden=!self.editing;
    self.labelSpellingName.hidden=self.editing;
    
    //update UI content
    self.labelSpellingName.text = self.spellingSelected.name;
    self.textFieldSpellingName.text = self.spellingSelected.name;
    self.textFieldSpellingName.delegate = self;}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setEditing:self.editing];
    
    
}

/*/////////////////////////////////////////////////////////
 //////////////////////////////////////////////////////////
 Triggered actions
 //////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////*/

- (void) updateToolbarButtons {
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    
    if (!self.editing) {
        switch ([self.delegate objectMode:self]) {
            case objectModeRead:
            {
                self.toolbar.hidden = YES;
                [toolbarItems removeObject:self.barButtonItemKeyboard];
                [toolbarItems removeObject:self.barButtonItemPlay];
                [toolbarItems removeObject:self.barButtonItemAdd];
            }
                break;
                
            case objectModeTest:
            {
                self.toolbar.hidden = NO;
                [toolbarItems removeObject:self.barButtonItemAdd];
                if (![toolbarItems containsObject:self.barButtonItemKeyboard]) {
                    [toolbarItems insertObject:self.barButtonItemKeyboard atIndex:0];
                }
                if (![toolbarItems containsObject:self.barButtonItemPlay]) {
                    [toolbarItems insertObject:self.barButtonItemPlay atIndex:2];
                }
            }
                break;
            default:
                break;
        }
    } else {
        self.toolbar.hidden = NO;
        [toolbarItems removeObject:self.barButtonItemKeyboard];
        [toolbarItems removeObject:self.barButtonItemPlay];
        if (![toolbarItems containsObject:self.barButtonItemAdd] && self.barButtonItemAdd) {
            [toolbarItems insertObject:self.barButtonItemAdd atIndex:2];
        }
    }
    
    self.toolbar.items = toolbarItems;
}


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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"playTest"]) {
        SPTestVC *testVC = (SPTestVC *)segue.destinationViewController;
        testVC.spellingSelected = self.spellingSelected;
        //testVC.kidSelected = self.de
    }
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
