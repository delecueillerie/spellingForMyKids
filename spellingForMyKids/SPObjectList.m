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
#import "SPAnObjectWithList.h"

//Delegates
#import "SPKidList.h"
#import "SPWordList.h"
#import "SPSpellingList.h"

@interface SPObjectList ()

@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (strong, nonatomic) NSArray *searchResults;

@property (strong, nonatomic) NSIndexPath *indexPathLastSelectedRow;

@end

@implementation SPObjectList


/*/////////////////////////////////////////////////////////
 //////////////////////////////////////////////////////////
 Accessors
 //////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////*/

- (NSManagedObjectContext *) managedObjectContext {
    if (!_managedObjectContext) {
        if ([self.dataSource managedObjectContext]) {
            _managedObjectContext = [self.dataSource managedObjectContext];
        } else {
            _managedObjectContext = [DBCoreDataStack sharedInstanceFor:data].managedObjectContext;
        }
    }
    return _managedObjectContext;
}

- (NSManagedObjectContext *) managedObjectContextAdd {
    if (!_managedObjectContextAdd) {
        _managedObjectContextAdd = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContextAdd setParentContext:self.managedObjectContext];
    }
    return _managedObjectContextAdd;
}


- (NSManagedObject *) objectSelected {
    if ([self.dataSource arrayData: self]) {
        _objectSelected = [[self.dataSource arrayData:self] objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    } else {
        _objectSelected = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    }
    return _objectSelected;
}
/*
- (void) setEditing:(BOOL)editing {
    [super setEditing:editing];
    //self.objects = nil;
}*/

////////////////////////////////////////////////////////////////////////
//LIFE CYCLE
////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //set up color
    self.tableView.backgroundColor = nil;
    self.tableView.tintColor = [UIColor whiteColor];
}


- (void) viewWillAppear:(BOOL)animated {
    //set up the bar button items
    [self setUpBarButtonItems];
    
    if ([self.dataSource datasource:self]==datasourceFetched) {
        if ([[self.fetchedResultsController fetchedObjects] count]>6) {
            self.searchDisplayController.searchBar.hidden = NO;
        } else {
            self.searchDisplayController.searchBar.hidden = YES;
        }
    } else {
        self.searchDisplayController.searchBar.hidden = YES;
    }
}

- (void)viewDidUnload {
    // Release any properties that are loaded in viewDidLoad or can be recreated lazily.
    self.fetchedResultsController = nil;
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// UI
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (void) setUpBarButtonItems {
    // Set up the buttons in navigationBar
    
    //1st check to get the good navigation item
    //don't forget that tab bar controller is front of the the VC
    UINavigationItem *currentNavigationItem;
    if (self.tabBarController) {
        currentNavigationItem = self.tabBarController.navigationItem;
    } else {
        currentNavigationItem = self.navigationItem;
    }
    
    if ([self.delegate respondsToSelector:@selector(titleNavigationBar:)]) {
        currentNavigationItem.title=[self.delegate titleNavigationBar: self];
    } else {
        currentNavigationItem.title=@"title 2 complete";
    }


    if (!self.delegate) {
        currentNavigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction)];
        currentNavigationItem.leftBarButtonItem = nil;
    } else if (([self.delegate rowSelected:self] == rowSelectedUnique) ||
               ([self.delegate rowSelected:self] == rowSelectedMultiple)) {
        currentNavigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonAction)];
        currentNavigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction)];
    } else if ([self.delegate rowSelected:self] == rowSelectedOpenVC) {
        currentNavigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction)];
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_delegate) {
        [self detailVCToPushWithObject:self.objectSelected];
        
    } else if ([self.delegate rowSelected:self] == rowSelectedMultiple ||
               [self.delegate rowSelected:self] == rowSelectedUnique) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    } else if ([self.delegate rowSelected:self] == rowSelectedOpenVC) {
        [self detailVCToPushWithObject:self.objectSelected];
        
    } else if ([self.delegate rowSelected:self] == rowSelectedUniqueAndPop) {
        NSManagedObject *object;
        object= [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.dataSource addObjectToList:object];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
/*    if ([self.delegate rowSelected] == rowSelectedOpenVC) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }*/
}

/*
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing == NO) {
        return UITableViewCellEditingStyleNone;
    } else if (indexPath.row == 0) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}*/

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
    } else {
        datasource datasourceType = [self.dataSource datasource:self];
        if (datasourceType==datasourceArray) {
            return 1;
        } else {
            return [[self.fetchedResultsController sections] count];
        }
    }
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];

    } else {
        datasource datasourceType = [self.dataSource datasource:self];
        if (datasourceType==datasourceArray) {
            return [[self.dataSource arrayData:self] count];
        } else {
            id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
            return [sectionInfo numberOfObjects];
        }
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)configureCell:(UITableViewCell *)tableViewCell withObject:(NSManagedObject *) object {
    //tableViewCell.textLabel.text = [object valueForKey:@"name"];
    [self configureCell:tableViewCell withFont:[UIFont fontWithName:@"Cursivestandard" size:20] withColor:[UIColor blackColor]];
    return tableViewCell;

}

- (void) configureCell:(UITableViewCell *) cell withFont:(UIFont *) font withColor:(UIColor*) color {
    cell.textLabel.font = font;
    cell.textLabel.textColor = color ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSManagedObject *object;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        object = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        datasource datasourceType = [self.dataSource datasource:self];
        switch (datasourceType) {
            case datasourceArray:
            {
                NSArray *arrayData = [self.dataSource arrayData:self];
                if ([arrayData count] > 0) {
                    object = [arrayData objectAtIndex:indexPath.row];
                }

            }
                break;
            case datasourceFetched:
            {
                object= [self.fetchedResultsController objectAtIndexPath:indexPath];

            }
                
            default:
                break;
        }
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
    
    //if (editingStyle == UITableViewCellEditingStyleDelete) {
    datasource datasourceType = [self.dataSource datasource:self];
    if (datasourceType == datasourceArray) {
        [self.dataSource removeObjectFromList:[[self.dataSource arrayData:self] objectAtIndex:indexPath.row]];

    } else if (datasourceType == datasourceFetched) {
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
    fetchRequest.predicate = [self.dataSource predicate:self];
    
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
    

    NSLog(@"fetched Objects count %lu",(unsigned long)[[_fetchedResultsController fetchedObjects] count]);
    
    return _fetchedResultsController;
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
    SPAnObject *viewControllerAnObject = [self.storyboard instantiateViewControllerWithIdentifier:[self storyboardVCId]];
    viewControllerAnObject.objectSelected = objectNew;
    viewControllerAnObject.editing = YES;
    viewControllerAnObject.isNewObject = YES;
    [self.navigationController pushViewController:viewControllerAnObject animated:NO];
}
- (void) cancelButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) detailVCToPushWithObject:(id)object {
    SPAnObject *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:self.storyboardVCId];
    detailVC.delegate = nil;
    detailVC.editing = NO;
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
    self.searchResults = [[self.fetchedResultsController fetchedObjects] filteredArrayUsingPredicate:resultPredicate];
}


/*///////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//Delegate
////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////*/

- (NSPredicate *) predicate:(id)sender {
    return [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
}

- (rowSelected) rowSelected:(id)sender {
    return rowSelectedOpenVC;
}

- (datasource) datasource:(id)sender {
    return datasourceFetched;
}


- (NSArray *) arrayData:(id)sender {
    return nil;
}

- (void) addObjectToList:(NSManagedObject *)object {
    
}

- (void) removeObjectFromList:(NSManagedObject *)object {
    
}
/*/////////////////////////////////////////////////////////
 Delegate search
 /////////////////////////////////////////////////////////*/

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    return YES;
}

@end
