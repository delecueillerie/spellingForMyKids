//
//  EDDetailVC.m
//  EditionMenu
//
//  Created by Olivier Delecueillerie on 05/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "EDDetailVC.h"
#import "WTViewController.h"


@interface EDDetailVC ()

@property (nonatomic, strong) NSUndoManager *undoManager;
- (void)updateRightBarButtonItemState;


@end

@implementation EDDetailVC

//////////////////////////////////////////////////////////////////////////////////////////
//LIFE CYCLE MANAGEMENT
//////////////////////////////////////////////////////////////////////////////////////////

@synthesize undoManager;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if ([self class] == [EDDetailVC class]) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    
    self.tableView.allowsSelectionDuringEditing = YES;
    
    // if the local changes behind our back, we need to be notified so we can update the date
    // format in the table view cells
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[self tableView]reloadData];
    // Redisplay the data.
    [self updateRightBarButtonItemState];
}

/*
 The view controller must be first responder in order to be able to receive shake events for undo. It should resign first responder status when it disappears.
 */
- (BOOL)canBecomeFirstResponder {
    
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

//////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    // Hide the back button when editing starts, and show it again when editing finishes.
    [self.navigationItem setHidesBackButton:editing animated:animated];
    
    /*
     When editing starts, create and set an undo manager to track edits. Then register as an observer of undo manager change notifications, so that if an undo or redo operation is performed, the table view can be reloaded.
     When editing ends, de-register from the notification center and remove the undo manager, and save the changes.
     */
    if (editing) {
        [self setUpUndoManager];
    }
    else {
        [self cleanUpUndoManager];
        // Save the changes.
        NSError *error;
        if (![self.object.managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}




//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//TABLE VIEW MANAGEMENT
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section. In this case, this is the number of attribute of the entity's managedObject
    NSEntityDescription *entity = [self.object entity];
    return [[entity attributesByName] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...

    if ([self.object valueForKey:[self attributeNameAtIndexPath:indexPath]]) {
        cell.textLabel.text = [self.object valueForKey:[self attributeNameAtIndexPath:indexPath]];
    } else {
        cell.textLabel.text = [self attributeNameAtIndexPath:indexPath];
    }

    return cell;
}

- (NSString *)attributeNameAtIndexPath:(NSIndexPath *)indexPath {

    NSString *attributeNameAtIndex;
    NSArray *attributesArray = [[[self.object entity] attributesByName] allKeys];
    for (NSString *attributeName in attributesArray) {
        if ([[self.entityDictionary valueForKey:attributeName] valueForKey:@"rank"] == [NSNumber numberWithInteger:indexPath.row]) {
            attributeNameAtIndex = attributeName;
        }
    }
    return attributeNameAtIndex;
}

- (void)updateRightBarButtonItemState {
    
    // Conditionally enable the right bar button item -- it should only be enabled if the book is in a valid state for saving.
    self.navigationItem.rightBarButtonItem.enabled = [self.object validateForUpdate:NULL];
}

//////////////////////////////////////////////////////////////////////////////////////////
//TABLE VIEW DELEGATE
//////////////////////////////////////////////////////////////////////////////////////////

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Only allow selection if editing.
    if (self.editing) {
        return indexPath;
    }
    return nil;
}

/*
 Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.editing) {
        UINavigationController *navigationController = [self navigationController];
        UIStoryboard *writingToolStoryboard = [UIStoryboard storyboardWithName:@"writingTool_iPhone" bundle:nil];
        WTViewController *viewController = [writingToolStoryboard instantiateViewControllerWithIdentifier:@"default"];

        NSDictionary * attributeDictionary = (NSDictionary *)[self.entityDictionary valueForKey:[self attributeNameAtIndexPath:indexPath]];
        viewController.attributeDictionary = [NSDictionary dictionaryWithDictionary:attributeDictionary];
        viewController.editedObject = self.object;
        viewController.selectedAttribute = [[[self.object entity] attributesByName] valueForKey:[self attributeNameAtIndexPath:indexPath]];

        
        [navigationController pushViewController:viewController animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}



//////////////////////////////////////////////////////////////////////////////////////////
//UNDO SUPPORT
//////////////////////////////////////////////////////////////////////////////////////////

- (void)setUpUndoManager {
    
    /*
     If the object's managed object context doesn't already have an undo manager, then create one and set it for the context and self.
     The view controller needs to keep a reference to the undo manager it creates so that it can determine whether to remove the undo manager when editing finishes.
     */
    if (self.object.managedObjectContext.undoManager == nil) {
        
        NSUndoManager *anUndoManager = [[NSUndoManager alloc] init];
        [anUndoManager setLevelsOfUndo:3];
        self.undoManager = anUndoManager;
        
        self.object.managedObjectContext.undoManager = self.undoManager;
    }
    
    // Register as an observer of the book's context's undo manager.
    NSUndoManager *drinkUndoManager = self.object.managedObjectContext.undoManager;
    
    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(undoManagerDidUndo:) name:NSUndoManagerDidUndoChangeNotification object:drinkUndoManager];
    [dnc addObserver:self selector:@selector(undoManagerDidRedo:) name:NSUndoManagerDidRedoChangeNotification object:drinkUndoManager];
}


- (void)cleanUpUndoManager {
    
    // Remove self as an observer.
    NSUndoManager *drinkUndoManager = self.object.managedObjectContext.undoManager;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUndoManagerDidUndoChangeNotification object:drinkUndoManager];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUndoManagerDidRedoChangeNotification object:drinkUndoManager];
    
    if (drinkUndoManager == self.undoManager) {
        self.object.managedObjectContext.undoManager = nil;
        self.undoManager = nil;
    }
}


- (NSUndoManager *)undoManager {
    
    return self.object.managedObjectContext.undoManager;
}


- (void)undoManagerDidUndo:(NSNotification *)notification {
    
    // Redisplay the data.
    [self updateRightBarButtonItemState];
}


- (void)undoManagerDidRedo:(NSNotification *)notification {
    
    // Redisplay the data.
    [self updateRightBarButtonItemState];
}



#pragma mark - Date Formatter

- (NSDateFormatter *)dateFormatter {
    
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }
    return dateFormatter;
}


#pragma mark - Locale changes

- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
}


@end
