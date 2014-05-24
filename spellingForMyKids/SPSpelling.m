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

//UI Views




@interface SPSpelling ()

@property (strong, nonatomic) Spelling *spellingSelected;
@property (strong, nonatomic) SPWordList *wordListVC;

@property (weak, nonatomic) IBOutlet UIView *viewContainerWordList;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSpellingName;
@property (weak, nonatomic) IBOutlet UILabel *labelSpellingName;



@end

@implementation SPSpelling

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// I - Lazy Instantiation
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (Spelling *) spellingSelected {
    if (! _spellingSelected) _spellingSelected = (Spelling *) self.objectSelected;
    return _spellingSelected;
}

- (NSPredicate *) predicate {
    if (self.editing) {
        _predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    } else {
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        for (Word *word in self.spellingSelected.words) {
            [mutableArray addObject:word.name];
        }
        _predicate = [NSPredicate predicateWithFormat: @"name IN %@", mutableArray];
    }
    return _predicate;
}

- (void) setEditing:(BOOL)editing {
    [super setEditing:editing];
    self.allowsMultipleSelection = editing;
    //refresh FRC & TV
    self.wordListVC.fetchedResultsController = nil;
    [self.wordListVC.tableView reloadData];
    
    if (editing) {
        [self updateAccessoryForTableView];
    }
    
    //displaying UI view depends on editing mode
    self.textFieldSpellingName.hidden=!self.editing;
    self.labelSpellingName.hidden=self.editing;
}

- (void) setAllowsMultipleSelection:(BOOL)flag {
    _allowsMultipleSelection = flag;
    self.wordListVC.allowsMultipleSelection = flag;
}

- (NSArray *) objectList {
    if (!_objectList) {
        _objectList = [self.spellingSelected.words allObjects];
    }
    return _objectList;
}



//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Trigerred action
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
- (void) updateAccessoryForTableView {
    //We select rows that represent the objectsSelected
    if (self.wordListVC.allowsMultipleSelection) {
        for (id object in self.objectList) {
            NSIndexPath *indexPath = [self.wordListVC.fetchedResultsController indexPathForObject:object];
            if (indexPath) {
                [self.wordListVC.tableView selectRowAtIndexPath:indexPath  animated:NO scrollPosition:UITableViewScrollPositionNone];
                [self.wordListVC.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
}
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// II - overridding
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (void) viewDidLoad {
    [super viewDidLoad];
    
    //load VC for container
    self.wordListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"words"];
    self.wordListVC.delegate = self;
    self.wordListVC.managedObjectContext=self.managedObjectContext;
    [self addChildViewController:self.wordListVC];
    [self.wordListVC didMoveToParentViewController:self];
    self.wordListVC.view.frame=self.viewContainerWordList.bounds;
    [self.viewContainerWordList addSubview:self.wordListVC.view];
    
    [self updateUI];
}



- (void) updateUI {
    
    [super updateUI];
    
    self.labelSpellingName.text = self.spellingSelected.name;
    self.textFieldSpellingName.text = self.spellingSelected.name;
    self.textFieldSpellingName.delegate = self;


}

- (void) buttonSaveAction {
    self.spellingSelected.name = self.textFieldSpellingName.text;
    
    //retrieving the words selected
    NSMutableArray *arrayWordsSelected = [[NSMutableArray alloc]init];
    for (NSIndexPath *indexPath in self.wordListVC.tableView.indexPathsForSelectedRows) {
        Word *word = [self.wordListVC.fetchedResultsController objectAtIndexPath:indexPath];
        [arrayWordsSelected addObject:word];
    }

    self.spellingSelected.words = [NSSet setWithArray:arrayWordsSelected];
    [super buttonSaveAction];
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

@end
