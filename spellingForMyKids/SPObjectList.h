
//  Created by Olivier Delecueillerie on 05/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol objectListDelegate <NSObject>

typedef enum rowSelected rowSelected;
enum rowSelected
{
    rowSelectedMultiple = 0,
    rowSelectedUnique = 1,
    rowSelectedOpenVC = 2,
    rowSelectedUniqueAndPop = 3
};

- (rowSelected) rowSelected:(id) sender;

@optional
- (NSString *) titleNavigationBar:(id) sender;
//- (void) objectAddedFromList:(NSManagedObject *)object;
@end


@protocol objectListDataSource <NSObject>

typedef enum datasource datasource;
enum datasource
{
    datasourceFetched=0,
    datasourceArray = 1
};

- (datasource) datasource:(id) sender;
- (NSArray *) arrayData:(id) sender;
//- (void) updateArrayData:(NSArray *)arrayUpdatedData;
- (void) addObjectToList:(NSManagedObject *) object;
- (void) removeObjectFromList:(NSManagedObject *) object;
- (NSPredicate *) predicate:(id) sender;
- (NSManagedObjectContext *) managedObjectContext;
//@property (strong, nonatomic) NSManagedObject *objectAddedFromList;
@end


@interface SPObjectList : UITableViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, objectListDelegate, objectListDataSource>

@property (nonatomic, strong) NSManagedObject *objectSelected;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContextAdd;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSArray *objectsSelected;

@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSString *sortDescriptor;
@property (nonatomic, strong) NSString *storyboardVCId;
//@property (nonatomic, strong) NSString *titleNavigationBar;

- (void) configureCell:(UITableViewCell *) cell;

//method used in selector, thus these method must be public
- (void) addButtonAction;
- (void) doneButtonAction;
- (void) cancelButtonAction;

@property (nonatomic, weak) id <objectListDelegate> delegate;
@property (nonatomic, weak) id <objectListDataSource> dataSource;



@end
