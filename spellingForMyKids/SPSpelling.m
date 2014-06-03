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

@property (weak, nonatomic) IBOutlet UIView *viewContainerWordList;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSpellingName;
@property (weak, nonatomic) IBOutlet UILabel *labelSpellingName;

@end

@implementation SPSpelling

@synthesize objectList = _objectList;

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// I - Lazy Instantiation
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (Spelling *) spellingSelected {
    if (! _spellingSelected) _spellingSelected = (Spelling *) self.objectSelected;
    return _spellingSelected;
}


- (void) setEditing:(BOOL)editing {
    [super setEditing:editing];
    
    //displaying UI view depends on editing mode
    self.textFieldSpellingName.hidden=!self.editing;
    self.labelSpellingName.hidden=self.editing;
}



- (NSSet *) objectList {
    _objectList = self.spellingSelected.words;
    return _objectList;
}

- (NSString *) key {
    return @"name";
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// II - overridding
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (void) viewDidLoad {
    [super viewDidLoad];
    self.objectListVC = [self addObjectListIdentifier:@"words" toView:self.viewContainerWordList];
    
    //update UI content
    self.labelSpellingName.text = self.spellingSelected.name;
    self.textFieldSpellingName.text = self.spellingSelected.name;
    self.textFieldSpellingName.delegate = self;}



- (void) buttonSaveAction {
    self.spellingSelected.name = self.textFieldSpellingName.text;
    self.spellingSelected.words = [self updatedRelationshipIn:self.objectListVC];
    
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
