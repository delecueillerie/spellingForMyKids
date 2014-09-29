
//  Created by Olivier Delecueillerie on 05/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SPAnObject.h"

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
- (UIImage *) cellImageFor:(NSManagedObject *) object;
- (id) objectDidSelected;
- (UIViewController *) viewControllerForObject:(id)object;
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
- (void) addObjectToList:(NSManagedObject *) object;
- (void) removeObjectFromList:(NSManagedObject *) object;
- (NSPredicate *) predicate:(id) sender;

@optional
- (NSManagedObjectContext *) managedObjectContext;
@end


@interface SPObjectList : UITableViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, objectListDelegate, objectListDataSource, objectDelegate>

@property (nonatomic, strong) id objectSelected;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContextAdd;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSArray *objectsSelected;

@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSString *sortDescriptor;
@property (nonatomic, strong) NSString *storyboardVCId;

- (UITableViewCell *)configureCell:(UITableViewCell *)tableViewCell withObject:(NSManagedObject *) object;
- (void) configureCell:(UITableViewCell *) cell withFont:(UIFont *)font withColor:(UIColor *)color;

//method used in selector, thus these method must be public
- (void) addButtonAction;
- (void) doneButtonAction;
- (void) cancelButtonAction;

@property (nonatomic, weak) id <objectListDelegate> delegate;
@property (nonatomic, weak) id <objectListDataSource> dataSource;



@end
