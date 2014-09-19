//
//  SPMenuVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 23/01/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//
#import "SPMenuVC.h"

//Model
#import "Kid.h"
#import "SPellingTest+mode.h"
//Category
#import "UIImageView+cornerRadius.h"
#import "Kid+newKid.h"
#import "DBCoreDataStack.h"
//Controller
#import "SPTestVC.h"
#import "SPSpellingList.h"
#import "SPSpellingTestList.h"
#import "SPKidList.h"
#import "SPAKidTVC.h"
//View
#import "SPKeyboardButton.h"
#import "SPLevelButton.h"

@interface SPMenuVC ()

@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewForPicture;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (nonatomic, strong) NSArray *arrayOfKids;
@property (nonatomic, strong) NSObject *addKidObject;
@property (nonatomic, strong) NSArray *arrayOfKidsExtended; //give the user the ability to create a new kid if needed (first launch, etc...) with a Add action at the end of the array
@property (nonatomic, strong) NSArray *arrayOfSpellings;

@property (nonatomic,strong) Spelling *spellingSelected;

@end

@implementation SPMenuVC



/*////////////////////////////////////////////////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////////////////////////////////////////////////
 ACCESSORS
 /////////////////////////////////////////////////////////////////////////////////////////////////////
 ////////////////////////////////////////////////////////////////////////////////////////////////////*/

@synthesize arrayOfKids=_arrayOfKids , objectListVC=_objectListVC, objectSelected=_objectSelected, managedObjectContext=_managedObjectContext;

- (NSManagedObjectContext *) managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [DBCoreDataStack sharedInstanceFor:data].managedObjectContext;
    }
    return _managedObjectContext;
}


- (NSObject *) addKidObject {
    if (!_addKidObject) {
        _addKidObject = [[NSObject alloc] init];
    }
    return _addKidObject;
}

- (NSArray *) arrayOfKids {
    if (!_arrayOfKids)  {
        NSFetchRequest *fetchRequestForKids = [NSFetchRequest fetchRequestWithEntityName:@"Kid"];
        NSError *error;
        _arrayOfKids = [self.managedObjectContext executeFetchRequest:fetchRequestForKids error:&error];
    }
    return _arrayOfKids;
}

- (NSArray *) arrayOfKidsExtended {
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.arrayOfKids];
    [mArray addObject:self.addKidObject];
    self.pageControl.numberOfPages = [mArray count];
    _arrayOfKidsExtended = mArray;
    return _arrayOfKidsExtended;
}


- (void) setObjectSelected:(id)objectSelected {
    [super setObjectSelected:objectSelected];

    [self.objectListVC.tableView reloadData];
    if ([objectSelected isKindOfClass:[Kid class]]) {
        //reload the list of test
        //self.objectListVC = nil;
        Kid *kidSelected = (Kid *)objectSelected;
        [self.imageViewForPicture roundWithImage:[UIImage imageWithData:kidSelected.image]];
        self.navigationItem.title = kidSelected.name;
        
        //UI design update
        self.viewContainer.hidden = NO;
        self.toolbar.hidden = NO;
        
        if ([self.arrayOfKids indexOfObject:objectSelected] == NSNotFound) {
            //reload arrayOfKids if object is not present in it. A new user should be registered
            self.arrayOfKids = nil;
        }
        self.pageControl.currentPage = [self.arrayOfKidsExtended indexOfObject:objectSelected];
        
    } else {
        [self.imageViewForPicture roundWithImage:[UIImage imageNamed:@"newUser"]];
        self.navigationItem.title = @"create a new kid";
        self.viewContainer.hidden = YES;
        self.toolbar.hidden = YES;
        self.pageControl.currentPage = [self.arrayOfKidsExtended indexOfObject:self.addKidObject];
    }
}


- (id) objectSelected {
    if (!_objectSelected) {
        Kid *kidSelected;
        if ([self.arrayOfKids count] > 0) {
            NSString *kidSelectedName = [[NSUserDefaults standardUserDefaults] objectForKey:@"kidSelectedName"];
            if (kidSelectedName) {
                for (Kid* kid in self.arrayOfKids) {
                    if ([kid.name isEqualToString:kidSelectedName]) {
                        kidSelected = kid;
                    }
                }
            } else {
                kidSelected = [self.arrayOfKids firstObject];
            }
        }
        _objectSelected = kidSelected;
    }
    return _objectSelected;
}


- (SPObjectList *) objectListVC {
    if (!_objectListVC) {
        _objectListVC = (SPSpellingList *)[self addObjectListIdentifier:@"spellingList" toView:self.viewContainer];
        _objectListVC.delegate = self;
        _objectListVC.dataSource = self;
    }
    return _objectListVC;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
//LIFE CYCLE
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isReadOnly = YES;
    //UI design of the navigation controller
    self.navigationItem.title = @"Spelling";
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor blackColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"Cursivestandard" size:20.0], NSFontAttributeName, nil]];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    //Page control properties
    self.pageControl.hidesForSinglePage = YES;

    [self setObjectSelected:self.objectSelected];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void) viewWillDisappear:(BOOL)animated {
    if ([self.objectSelected isKindOfClass:[Kid class]]) {
        Kid *kid = (Kid *) self.objectSelected;
        [[NSUserDefaults standardUserDefaults] setObject:kid.name  forKey:@"kidSelectedName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
//LIFE CYCLE
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////


/*////////////////////////////////////////////////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////////////////////////////////////////////////
 // Triggered Actions
 /////////////////////////////////////////////////////////////////////////////////////////////////////
 ////////////////////////////////////////////////////////////////////////////////////////////////////*/
- (IBAction)addSpelling:(id)sender {
    SPSpellingList *spellingList = [self.storyboard instantiateViewControllerWithIdentifier:@"spellingList"];
    spellingList.delegate = self;
    spellingList.dataSource = self;
    [self.navigationController pushViewController:spellingList animated:YES];
}

//UIGestureRecognizer
- (IBAction)swipeRightOnPicture:(UISwipeGestureRecognizer *)sender {
    [self previousKid];
}

- (IBAction)swipeLeftOnPicture:(UISwipeGestureRecognizer *)sender {
    [self nextKid];
}
- (IBAction)tapOnPicture:(UITapGestureRecognizer *)sender {
    
    if ([self.objectSelected isKindOfClass:[Kid class]]) {
        SPAKidTVC *VC = (SPAKidTVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"AKid"];
        VC.isReadOnly = NO;
        VC.objectSelected = (Kid *) self.objectSelected;
        
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        NSManagedObjectContext * managedObjectContextAdd = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContextAdd setParentContext:self.managedObjectContext];
        
        NSManagedObject *objectNew = [NSEntityDescription insertNewObjectForEntityForName:@"Kid" inManagedObjectContext:managedObjectContextAdd];
        SPAKidTVC *viewControllerAnObject = [self.storyboard instantiateViewControllerWithIdentifier:@"AKid"];
        viewControllerAnObject.objectSelected = objectNew;
        //viewControllerAnObject.managedObjectContext = managedObjectContextAdd;
        viewControllerAnObject.editing = YES;
        viewControllerAnObject.isReadOnly = NO;
        viewControllerAnObject.isNewObject = YES;
        viewControllerAnObject.delegate = self;
        [self.navigationController pushViewController:viewControllerAnObject animated:NO];
    }
}

- (IBAction)buttonNext:(id)sender {
    [self nextKid];
}

- (IBAction)buttonPrevious:(id)sender {
    [self previousKid];
}


- (NSUInteger) indexFromArrayOfKidsExtended {
    NSUInteger index = [self.arrayOfKidsExtended indexOfObject:self.objectSelected];
    if (index == NSNotFound) {
        index = [self.arrayOfKidsExtended indexOfObject:self.addKidObject];
        if (index == NSNotFound) {
            index = 0;
        }
    }
    return index;
}

//Methods
- (void) nextKid {
    NSInteger nextIndex = [self indexFromArrayOfKidsExtended] +1;
    if (nextIndex>= [self.arrayOfKidsExtended count]) nextIndex = 0;
    self.objectSelected = [self.arrayOfKidsExtended objectAtIndex:nextIndex];
}

- (void) previousKid {
    NSInteger nextIndex = [self indexFromArrayOfKidsExtended] -1;
    if (nextIndex<0) nextIndex = self.arrayOfKidsExtended.count;
    self.objectSelected= [self.arrayOfKidsExtended objectAtIndex:nextIndex];
}

/*////////////////////////////////////////////////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////////////////////////////////////////////////
 DELEGATES
 /////////////////////////////////////////////////////////////////////////////////////////////////////
 ////////////////////////////////////////////////////////////////////////////////////////////////////*/

/*////////////////////////////////////////////////
 object Delegtae
 ///////////////////////////////////////////////*/

- (objectMode) objectMode:(id)sender {
    return objectModeTest;
}

/*////////////////////////////////////////////////
 objectList Delagte & DataSource
 ///////////////////////////////////////////////*/

- (UIImage *) cellImageFor:(NSManagedObject *)object {
    
    UIImage *medal;
    //NSLog(@"obect description%@", [object description]);
    if ([object isKindOfClass:[Spelling class]]) {
        
        NSSet *setSpellingTest = (NSSet *)[self.objectSelected valueForKey:@"spellingTests"];
        [setSpellingTest filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"points == 0"]];
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"endedAt" ascending:YES]];

        NSArray *arraySorted = [[setSpellingTest allObjects] sortedArrayUsingDescriptors:sortDescriptors];
        SpellingTest *lastTest = [arraySorted lastObject];
        
        if ([lastTest.mode intValue] == easy) {
            medal = [UIImage imageNamed:@"medal_bronze"];
        } else if ([lastTest.mode intValue] == medium) {
            medal = [UIImage imageNamed:@"medal_silver"];
        } else if ([lastTest.mode intValue]== hard) {
            medal = [UIImage imageNamed:@"medal_gold"];
        }
    }
    return medal;
}

- (rowSelected) rowSelected:(id)sender {
    if (sender == self.objectListVC) {
        return rowSelectedOpenVC;
    } else {
        return rowSelectedUniqueAndPop;
    }
}

- (NSString *) titleNavigationBar:(id) sender {
    return @"title AAAA";
}

-(datasource) datasource:(id)sender {
    if (sender == self.objectListVC) {
        return datasourceArray;
    } else {
        return datasourceFetched;
    }
}

- (NSArray *) arrayData:(id) sender {
    if ([self.objectSelected isKindOfClass:[Kid class]]) {
        return [[self.objectSelected valueForKey:@"spellings"] allObjects];
    }
    else return nil;
}

- (void) addObjectToList:(NSManagedObject * ) object {
    if ([object isKindOfClass:[Spelling class]]) {
        Spelling *spellingNew = (Spelling *)object;
        [self.objectSelected addSpellingsObject:spellingNew];
        [self.delegate saveAndRefresh];
    }
}

- (void) removeObjectFromList:(NSManagedObject *)object {
    if ([object isKindOfClass:[Spelling class]]) {
        Spelling *spellingNew = (Spelling *)object;
        [self.objectSelected removeSpellingsObject:spellingNew];
        [super saveAndRefresh];
    }
}
- (NSPredicate *) predicate:(id) sender {
    if ([self.objectSelected isKindOfClass:[Kid class]]) {
        NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:10];
        for (Spelling *spelling in [self.objectSelected valueForKey:@"spellings"]) {
            [mArray addObject:spelling.name];
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"!name IN %@", mArray];
        return predicate;
    } else {
        return nil;
    }
}

/*////////////////////////////////////////////////
 scrollView Delegate
 ///////////////////////////////////////////////*/
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
}
@end