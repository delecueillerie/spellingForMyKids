//
//  SPAnObject.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 12/03/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPAnObject.h"
#import "DBCoreDataStack.h"

@interface SPAnObject ()


@end

@implementation SPAnObject

/*/////////////////////////////////////////////////////////
 //////////////////////////////////////////////////////////
 Accessor
 //////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////*/

- (NSManagedObjectContext *) managedObjectContext {
    if (!_managedObjectContext) {
        if (self.objectSelected.managedObjectContext) {
            _managedObjectContext = self.objectSelected.managedObjectContext;
        } else {
            _managedObjectContext = [DBCoreDataStack sharedInstanceFor:data].managedObjectContext;
        }
    }
    return _managedObjectContext;
}

- (void) setEditing:(BOOL)editing {
    [super setEditing:editing];
    [self navigationItemUpdate];
    if (editing) {
        [self setUpUndoManager];
    }
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// II - VC Life Cycle Management
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationItemUpdate];
}




//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// I - Trigered Action
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (void) buttonEditAction {
    //set up the undo manager
    self.editing = YES;
    //[self updateUI];
}
/*
- (void) updateUI {
    [self navigationItemUpdate];
    //the goal of this method is to be overridden in subclasses
}
*/

- (void) buttonCancelAction {
    //clean the undoManager∫
    [self.undoManager undo];
    if (self.newObject) {
        [self.managedObjectContext deleteObject:self.objectSelected];
    }
    [self.navigationController popViewControllerAnimated:NO];

}


// set up the table view in edit mode
- (void) buttonSaveAction {

    NSError *error;
    NSLog(@"name %@", [self.objectSelected description]);
    
    [self.managedObjectContext save:&error];
    if (self.newObject) {
        error = nil;
        NSManagedObjectContext *parentContext = [self.managedObjectContext parentContext];
        [parentContext save:&error];
    }

    //clean the undo manager
    [self cleanUpUndoManager];
    //switch the save button to an edit button
    [self.navigationController popViewControllerAnimated:NO];
}


- (void) navigationItemUpdate {

    //self.navigationItem.title = ...
    //set up the  Barbutton
    if (self.editing) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(buttonSaveAction)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(buttonCancelAction)];
    }

    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(buttonEditAction)];
    }

}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// II - Table view
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////
// II - a - delegate
//////////////////////////////////////////////////////////

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


//////////////////////////////////////////////////////////
// III - a - managedObjects
//////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////
//III - a - undo Support
//////////////////////////////////////////////////////////////////////////////////////////

- (void)setUpUndoManager {

    /*
     If the object's managed object context doesn't already have an undo manager, then create one and set it for the context and self.
     The view controller needs to keep a reference to the undo manager it creates so that it can determine whether to remove the undo manager when editing finishes.
     */
    if (self.managedObjectContext.undoManager == nil) {
        [self.managedObjectContext setUndoManager:[[NSUndoManager alloc] init]];
        [self.managedObjectContext.undoManager setLevelsOfUndo:3];
    }

    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(undoManagerDidUndo:) name:NSUndoManagerDidUndoChangeNotification object:self.managedObjectContext.undoManager];
}


- (void)cleanUpUndoManager {

    // Remove self as an observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUndoManagerDidUndoChangeNotification object:self.undoManager];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUndoManagerDidRedoChangeNotification object:self.undoManager];

    [self.managedObjectContext.undoManager removeAllActions];
}

- (void)undoManagerDidUndo:(NSNotification *)notification {
    // Redisplay the data.
}


@end
