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
        if (self.objectSelected) {
            if ([self.objectSelected isKindOfClass:[NSManagedObject class]]) {
                _managedObjectContext = [self.objectSelected valueForKey:@"managedObjectContext"];
            }
        } else {
            _managedObjectContext = [DBCoreDataStack sharedInstanceFor:data].managedObjectContext;
        }
    }
    return _managedObjectContext;
}

- (void) setEditing:(BOOL)editing {
    if (self.isReadOnly) {
        [super setEditing:NO];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
    } else if (editing) {
        [super setEditing:editing];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAndPop)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(buttonCancelAction)];
        [self setUpUndoManager];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(buttonEditAction)];
    }
}

- (void) setIsReadOnly:(BOOL)isReadOnly {
    _isReadOnly = isReadOnly;
    if (isReadOnly) {
        self.editing = NO;
    }
}

- (void) setObjectSelected:(id)objectSelected {
    _objectSelected = objectSelected;
}
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// II - VC Life Cycle Management
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.delegate) {
        self.delegate = self;
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [self setEditing:self.editing]; //
    [self refresh];
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

- (void) buttonCancelAction {
    //clean the undoManager∫
    [self.undoManager undo];
    if (self.isNewObject) {
        if ([self.objectSelected isKindOfClass:[NSManagedObject class]]) {
            [self.managedObjectContext deleteObject:self.objectSelected];
        }
    }
    [self.navigationController popViewControllerAnimated:NO];
}


// set up the table view in edit mode
- (void) saveAndPop {
    [self loadInput];
    [self save];
    [self.delegate setObjectSelected:self.objectSelected];
    //[self.delegate refresh];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) saveAndRefresh {
    [self loadInput];
    [self save];
    self.editing = NO;
    [self refresh];
}

- (void) save {
    
    [self loadInput];
    NSError *error;
    NSLog(@"name %@", [self.objectSelected description]);
    
    [self.managedObjectContext save:&error];
    NSManagedObjectContext *parentContext = [self.managedObjectContext parentContext];
    
    if (parentContext) {
        error = nil;
        [parentContext save:&error];
    }
    //clean the undo manager
    [self cleanUpUndoManager];
}

- (void) loadInput {
    
}

- (void) refresh {
    
}

/*
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
*/

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

/*/////////////////////////////////////////////////////////
Object delegate
/////////////////////////////////////////////////////////*/

- (objectMode) objectMode:(id)sender {
    return objectModeRead;
}


@end
