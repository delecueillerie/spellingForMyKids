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

- (NSPredicate *) predicate {
    if (self.editing) {
        _predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    } else {
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        for (NSManagedObject *object in self.objectList) {
            [mutableArray addObject:[object valueForKey:self.key]];
        }
        _predicate = [NSPredicate predicateWithFormat: @"%@ IN %@",self.key, mutableArray];
    }
    return _predicate;
}


- (void) setAllowsMultipleSelection:(BOOL)flag {
    _allowsMultipleSelection = flag;
    self.objectListVC.allowsMultipleSelection = flag;
}


- (void) setEditing:(BOOL)editing {
    [super setEditing:editing];
    self.allowsMultipleSelection = editing;
    //refresh FRC & TV
    self.objectListVC.fetchedResultsController = nil;
    [self.objectListVC.tableView reloadData];
    
    if (editing) {
        [self updateAccessoryForTableView];
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
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
    if (self.objectListVC.allowsMultipleSelection) {
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
    objectListVC.managedObjectContext=self.managedObjectContext;
    [self addChildViewController:objectListVC];
    [objectListVC didMoveToParentViewController:self];
    objectListVC.view.frame=view.bounds;
    [view addSubview:objectListVC.view];
    return objectListVC;
}

- (NSSet *) updatedRelationshipIn:(SPObjectList *)objectListVC {
    //retrieving the objects selected
    NSMutableArray *arrayWordsSelected = [[NSMutableArray alloc]init];
    for (NSIndexPath *indexPath in objectListVC.tableView.indexPathsForSelectedRows) {
        NSManagedObject *object = [objectListVC.fetchedResultsController objectAtIndexPath:indexPath];
        [arrayWordsSelected addObject:object];
    }
    return [NSSet setWithArray:arrayWordsSelected];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
