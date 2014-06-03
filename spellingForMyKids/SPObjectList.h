
//  Created by Olivier Delecueillerie on 05/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol objectListDelegate <NSObject>

@required
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic) BOOL allowsMultipleSelection;
@optional
//@property (nonatomic, strong) NSArray *objectList;
@end

@interface SPObjectList : UITableViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, objectListDelegate>

@property (nonatomic, strong) NSManagedObject *objectSelected;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSArray *objectsSelected;

@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSString *sortDescriptor;
@property (nonatomic, strong) NSString *storyboardVCId;
@property (nonatomic, strong) NSString *titleNavigationBar;

- (void) configureCell:(UITableViewCell *) cell;

//objectListDelegate protocol
@property (nonatomic, strong) id <objectListDelegate> delegate;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic) BOOL allowsMultipleSelection;
@end
