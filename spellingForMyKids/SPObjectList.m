//
//  EDRootVC.m
//  EditionMenu
//
//  Created by Olivier Delecueillerie on 05/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "SPObjectList.h"
#import "DBCoreDataStack.h"

//VC
#import "SPAnObject.h"

//Delegates
#import "SPKidList.h"
#import "SPWordList.h"
#import "SPSpellingList.h"

@interface SPObjectList ()

@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

@property (strong, nonatomic) NSArray *objects;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContextAdd;

@property (strong, nonatomic) NSIndexPath *indexPathLastSelectedRow;

@end

@implementation SPObjectList


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Lazy Instantiation & accessors
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (NSManagedObjectContext *) managedObjectContext {
    if (!_managedObjectContext) _managedObjectContext = [DBCoreDataStack sharedInstance].managedObjectContext;
    return _managedObjectContext;
}

- (NSManagedObjectContext *) managedObjectContextAdd {
    if (!_managedObjectContextAdd) {
        _managedObjectContextAdd = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContextAdd setParentContext:self.managedObjectContext];
    }
    return _managedObjectContextAdd;
}

- (NSArray *) objects {
    if (!_objects) _objects = [self.fetchedResultsController fetchedObjects];
    return _objects;
}


- (id) delegate {
    if (!_delegate) {
        _delegate = self;
        //By default this TVC show detail view when a row is selected
        self.allowsMultipleSelection = NO;
    }
    
    return _delegate;
}

- (NSManagedObject *) objectSelected {
    _objectSelected = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    return _objectSelected;
}

- (void) setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    _allowsMultipleSelection = allowsMultipleSelection;
    self.tableView.allowsMultipleSelection = allowsMultipleSelection;
}

////////////////////////////////////////////////////////////////////////
//LIFE CYCLE
////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //Configure view : selection enbled VS show detail
    self.tableView.allowsMultipleSelection = self.delegate.allowsMultipleSelection;
    self.tableView.backgroundColor = nil;
    self.tableView.tintColor = [UIColor whiteColor];
}


- (void) viewWillAppear:(BOOL)animated {
    // Set up the buttons in navigationBar
    self.tabBarController.navigationItem.title=self.titleNavigationBar;
    if (self.allowsMultipleSelection) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonAction)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction)];
    }
    else {
        //BECAREFULL this VC in not ont the top of navigation controller stack, it is the tab bar that is on the top!! thus customize navigation item of the tab bar
        self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction)];
    }
}

- (void)viewDidUnload {
    // Release any properties that are loaded in viewDidLoad or can be recreated lazily.
    self.fetchedResultsController = nil;
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// II - Table view
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////
// II - a - delegate
//////////////////////////////////////////////////////////

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate.allowsMultipleSelection) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        //we push a detail view controller. Check subclasses for overwritten method
        //new setter used  self.objectSelected = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self detailVCToPushWithObject:self.objectSelected];
    }

}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.allowsMultipleSelection) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
}
/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell.backgroundColor = [UIColor clearColor];
}
 */
////////////////////////////////////////////////////////////////////////
// II - b - datasource
////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;

    }
    else {
        return [[self.fetchedResultsController sections] count];
    }
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];

    }
    else {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)configureCell:(UITableViewCell *)tableViewCell withObject:(NSManagedObject *) object {
    tableViewCell.textLabel.text = [object valueForKey:@"name"];
    [self configureCell:tableViewCell];
    return tableViewCell;

}

- (void) configureCell:(UITableViewCell *) cell {
    cell.textLabel.font = [UIFont fontWithName:@"Cursivestandard" size:20];
    cell.textLabel.textColor = [UIColor blackColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSManagedObject *object;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        object = [self.searchResults objectAtIndex:indexPath.row];
    }
    else {
       object= [self.fetchedResultsController objectAtIndexPath:indexPath];
    }

    // Configure the cell.
    //check which table view, the main one or the table view from the search bar controller
    if (tableView == self.tableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    return [self configureCell:cell withObject:object];
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
////////////////////////////////////////////////////////////////////////
//Fetched results controller
////////////////////////////////////////////////////////////////////////
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
    NSLog(@"entity %@", self.entityName);
    [fetchRequest setEntity:[NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext]];
    
    // Create the sort descriptors array.
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:self.sortDescriptor ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    //predicate
    fetchRequest.predicate = self.delegate.predicate;
    
    // Create and initialize the fetch results controller.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    NSError *error;
    if (![_fetchedResultsController performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

//////////////////////////////////////////////////////////
// delegate
//////////////////////////////////////////////////////////
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//Trigerred actions
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

- (void) doneButtonAction {

}

- (void) addButtonAction {

    NSManagedObject *objectNew = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContextAdd];
    SPAnObject *viewControllerAnObject = [self.storyboard instantiateViewControllerWithIdentifier:self.storyboardVCId];
    viewControllerAnObject.objectSelected = objectNew;
    viewControllerAnObject.editing = YES;
    viewControllerAnObject.newObject = YES;
    [self.navigationController pushViewController:viewControllerAnObject animated:NO];
}
- (void) cancelButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) detailVCToPushWithObject:(id)object {
    SPAnObject *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:self.storyboardVCId];
    detailVC.objectSelected = self.objectSelected;
    [self.navigationController pushViewController:detailVC animated:YES];
}

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//V - Search controller
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchText];
    self.searchResults = [self.objects filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];

    return YES;
}

@end
