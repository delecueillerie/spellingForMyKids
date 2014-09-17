//
//  SPAnObjectWithList.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 30/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPAnObjectWithList.h"
#import "SPObjectList.h"

@interface SPAnObjectWithList ()


@end

@implementation SPAnObjectWithList




/*////////////////////////////////////////////////////////////////////
 Accessors
 ///////////////////////////////////////////////////////////////////*/
- (void) setEditing:(BOOL)editing {
    [super setEditing:editing];
    self.objectListVC.tableView.editing = editing;
}

/*////////////////////////////////////////////////////////////////////
 Life cycle management
 ///////////////////////////////////////////////////////////////////*/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Trigerred action
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
- (void) updateAccessoryForTableView {
    //We select rows that represent the objectsSelected
    if (!([self.objectListVC.delegate rowSelected:self] == rowSelectedOpenVC)) {
        for (id object in self.objectList) {
            NSIndexPath *indexPath = [self.objectListVC.fetchedResultsController indexPathForObject:object];
            if (indexPath) {
                [self.objectListVC.tableView selectRowAtIndexPath:indexPath  animated:NO scrollPosition:UITableViewScrollPositionNone];
                [self.objectListVC.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
}

- (SPObjectList *) addObjectListIdentifier: (NSString *) identifier toView:(UIView *) view {
    //load VC for container
    SPObjectList *objectListVC = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    objectListVC.delegate = self;
    objectListVC.dataSource = self;
    objectListVC.managedObjectContext=self.managedObjectContext;
    [self addChildViewController:objectListVC];
    [objectListVC didMoveToParentViewController:self];
    objectListVC.view.frame=view.bounds;
    [view addSubview:objectListVC.view];
    return objectListVC;
}


/*/////////////////////////////////////////////////////////////////////////////////////
 ObjectList delegate & datasource
 ////////////////////////////////////////////////////////////////////////////////////*/

- (datasource) datasource:(id)sender {
    return datasourceArray;
}

- (NSPredicate *) predicate:(id)sender {
    return [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
}

- (NSString *) titleNavigationBar:(id) sender {
    return @"default nav title";
}
//- (void) objectAddedFromList:(NSManagedObject *)object;

- (NSArray *) arrayData:(id) sender {
    return nil;
}

- (void) addObjectToList:(NSManagedObject * ) object {
    
}

- (void) removeObjectFromList:(NSManagedObject *)object {
    
}

- (rowSelected) rowSelected:(id)sender {
    //default value
    return rowSelectedUnique;
}

@end
