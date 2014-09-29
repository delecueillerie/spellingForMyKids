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

- (NSManagedObjectContext *) managedObjectContextAdd {
    if (!_managedObjectContextAdd) {
        _managedObjectContextAdd = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContextAdd setParentContext:self.managedObjectContext];
    }
    return _managedObjectContextAdd;
}


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
    [super setEditing:editing];
    if (editing) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAndPop)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(buttonCancelAction)];
        [self setUpUndoManager];
    }
}


- (void) setObjectSelected:(id)objectSelected {
    _objectSelected = objectSelected;
}

- (id) delegate {
    if (!_delegate) {
        _delegate = self;
    }
    return _delegate;
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// II - VC Life Cycle Management
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];

    switch ([self.delegate objectState:self]) {
        case objectStateRead:
        {
            self.editing = NO;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(buttonEditAction)];

            //self.navigationItem.rightBarButtonItem = nil;
            //self.navigationItem.leftBarButtonItem = nil;
            break;
        }
        
        case objectStateEdit:
        {
            self.editing = YES;
            break;
        }
            
        case objectStateTest:
        {
            self.editing = NO;
            self.navigationItem.rightBarButtonItem = nil;
            //self.navigationItem.leftBarButtonItem = nil;
            break;
        }
        
        case objectStateReadOnly:
        {
            self.editing = NO;
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = nil;
            break;
        }
            
        default:
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(buttonEditAction)];

            break;
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
    if ([self.delegate objectState:self] == objectStateEdit) {
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

- (objectState) objectState:(id)sender {
    return objectStateRead;
}


@end
