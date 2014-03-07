//
//  EDRootVC.m
//  EditionMenu
//
//  Created by Olivier Delecueillerie on 05/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "SPEditTVC.h"
#import "DBCoreDataStack.h"

@interface SPEditTVC ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

@end

@implementation SPEditTVC


- (NSManagedObjectContext *) managedObjectContext {
    if (!_managedObjectContext) _managedObjectContext = [DBCoreDataStack sharedInstance].managedObjectContext;
    return _managedObjectContext;
}
////////////////////////////////////////////////////////////////////////
//LIFE CYCLE
////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    
    [super viewDidLoad];

    // Set up the add buttons.
    UINavigationItem *navigationItem = [[self tabBarController] navigationItem];
    navigationItem.title=@"Words list";
    navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addObject)];


    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}



- (void)viewDidUnload {
    // Release any properties that are loaded in viewDidLoad or can be recreated lazily.
    self.fetchedResultsController = nil;
}


////////////////////////////////////////////////////////////////////////
//TABLE VIEW DATA SOURCE
////////////////////////////////////////////////////////////////////////
/*
 The data source methods are handled primarily by the fetch results controller
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.fetchedResultsController sections] count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)configureCellFrom:(UITableView *)tableView withObject:(NSManagedObject *) object atIndexPath:(NSIndexPath *) indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [object valueForKey:@"name"];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *object= [self.fetchedResultsController objectAtIndexPath:indexPath];

    // Configure the cell.
    return [self configureCellFrom:tableView withObject:object atIndexPath:indexPath];
}


- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.objectSelected = [self.fetchedResultsController objectAtIndexPath:indexPath];

    return indexPath;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    // Display the authors' names as section headings.
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the managed object.
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error;
        if (![context save:&error]) {

            // Replace this implementation with code to handle the error appropriately.
             
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

////////////////////////////////////////////////////////////////////////
//TABLE VIEW EDITING
////////////////////////////////////////////////////////////////////////
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // The table view should not be re-orderable.
    return NO;
}


////////////////////////////////////////////////////////////////////////
//FETCH RESULT CONTROLLER
////////////////////////////////////////////////////////////////////////
/*
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // Create and configure a fetch request with the Book entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:[self entityName] inManagedObjectContext:self.managedObjectContext]];
    
    // Create the sort descriptors array.
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:[self sortDescriptor] ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Create and initialize the fetch results controller.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


/*
 NSFetchedResultsController delegate methods to respond to additions, removals and so on.
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCellFrom:tableView withObject:anObject atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}


////////////////////////////////////////////////////////////////////////
//SEGUE MANAGEMENT
////////////////////////////////////////////////////////////////////////
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"addObject"]) {
        
        /*
         The destination view controller for this segue is an AddViewController to manage addition of the book.
         This block creates a new managed object context as a child of the root view controller's context. It then creates a new book using the child context. This means that changes made to the book remain discrete from the application's managed object context until the book's context is saved.
         The root view controller sets itself as the delegate of the add controller so that it can be informed when the user has completed the add operation -- either saving or canceling (see addViewController:didFinishWithSave:).
         IMPORTANT: It's not necessary to use a second context for this. You could just use the existing context, which would simplify some of the code -- you wouldn't need to perform two saves, for example. This implementation, though, illustrates a pattern that may sometimes be useful (where you want to maintain a separate set of edits).
         */
        
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        EDAddVC *addViewController = (EDAddVC *)[navController topViewController];
        addViewController.delegate = self;
        
        // Create a new managed object context for the new object; set its parent to the fetched results controller's context.
        NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [addingContext setParentContext:[self.fetchedResultsController managedObjectContext]];
        
        NSManagedObject *newObject = (NSManagedObject *)[NSEntityDescription insertNewObjectForEntityForName:[[NSEntityDescription entityForName:[self entityName] inManagedObjectContext:addingContext] name] inManagedObjectContext:addingContext];
        addViewController.object = newObject;
        addViewController.managedObjectContext = addingContext;
    }
    
    if ([[segue identifier] isEqualToString:@"showSelectedObject"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *selectedObject = (NSManagedObject *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        // Pass the selected book to the new view controller.
        EDDetailVC *detailViewController = (EDDetailVC *)[segue destinationViewController];
        detailViewController.object = selectedObject;


    }
}


////////////////////////////////////////////////////////////////////////
//TRIGERRED ACTION
////////////////////////////////////////////////////////////////////////

- (void) addObject {




}

////////////////////////////////////////////////////////////////////////
//ADD CONTROLLER DELEGATE
////////////////////////////////////////////////////////////////////////
/*
 Add controller's delegate method; informs the delegate that the add operation has completed, and indicates whether the user saved the new product.
 */
- (void)addViewController:(EDAddVC *)controller didFinishWithSave:(BOOL)save {
    
    if (save) {
        /*
         The new product is associated with the add controller's managed object context.
         This means that any edits that are made don't affect the application's main managed object context -- it's a way of keeping disjoint edits in a separate scratchpad. Saving changes to that context, though, only push changes to the fetched results controller's context. To save the changes to the persistent store, you have to save the fetch results controller's context as well.
         */
        NSError *error;
        NSManagedObjectContext *addingManagedObjectContext = [controller managedObjectContext];
        if (![addingManagedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        if (![[self.fetchedResultsController managedObjectContext] save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    // Dismiss the modal view to return to the main list
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *) entityName {
    return nil;
}

- (NSString *) sortDescriptor {
    return nil;
}

@end
