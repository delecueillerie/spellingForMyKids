
//  Created by Olivier Delecueillerie on 05/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol objectListDelegate <NSObject>

typedef enum selectRowAction selectRowAction;
enum selectRowAction
{
    selectionMultiple = 0,
    selectionOne = 1,
    openVC = 2
    
};

@required
- (NSPredicate *) predicate;
- (selectRowAction) rowAction;
//- (BOOL) allowsMultipleSelection;
@end

@interface SPObjectList : UITableViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate>

@property (nonatomic, strong) NSManagedObject *objectSelected;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContextAdd;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSArray *objectsSelected;

@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSString *sortDescriptor;
@property (nonatomic, strong) NSString *storyboardVCId;
@property (nonatomic, strong) NSString *titleNavigationBar;

- (void) configureCell:(UITableViewCell *) cell;
- (void) addButtonAction;
@property (nonatomic, weak) id <objectListDelegate> delegate;



@end
