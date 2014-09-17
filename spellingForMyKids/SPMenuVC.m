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

@property (nonatomic,strong) id kidSelected;
@property (nonatomic,strong) Spelling *spellingSelected;

@end

@implementation SPMenuVC



/*////////////////////////////////////////////////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////////////////////////////////////////////////
 ACCESSORS
 /////////////////////////////////////////////////////////////////////////////////////////////////////
 ////////////////////////////////////////////////////////////////////////////////////////////////////*/

@synthesize arrayOfKids=_arrayOfKids , objectListVC=_objectListVC, objectSelected=_objectSelected, kidSelected = _kidSelected;

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


- (void) setKidSelected:(id)kidSelected {
    _kidSelected = kidSelected;
    [self.objectListVC.tableView reloadData];
    if ([kidSelected isKindOfClass:[Kid class]]) {
        //reload the list of test
        //self.objectListVC = nil;
        Kid *kidSelected = self.kidSelected;
        [self.imageViewForPicture roundWithImage:[UIImage imageWithData:kidSelected.image]];
        self.navigationItem.title = kidSelected.name;
        self.objectSelected = (NSManagedObject *) self.kidSelected;
        
        //UI design update
        self.viewContainer.hidden = NO;
        self.toolbar.hidden = NO;
        
        if ([self.arrayOfKids indexOfObject:_kidSelected] == NSNotFound) {
            //reload arrayOfKids if object is not present in it
            self.arrayOfKids = nil;
        }
        self.pageControl.currentPage = [self.arrayOfKidsExtended indexOfObject:_kidSelected];
        
    } else {
        [self.imageViewForPicture roundWithImage:[UIImage imageNamed:@"newUser"]];
        self.navigationItem.title = @"create a new kid";
        self.viewContainer.hidden = YES;
        self.toolbar.hidden = YES;
        self.pageControl.currentPage = [self.arrayOfKidsExtended indexOfObject:self.addKidObject];
    }
}


- (Kid *) kidSelected {
    if (!_kidSelected) {
        Kid *kidSel;
        if ([self.arrayOfKids count] > 0) {
            NSString *kidSelectedName = [[NSUserDefaults standardUserDefaults] objectForKey:@"kidSelectedName"];
            if (kidSelectedName) {
                for (Kid* kid in self.arrayOfKids) {
                    if ([kid.name isEqualToString:kidSelectedName]) {
                        kidSel = kid;
                    }
                }
            } else {
                kidSel = [self.arrayOfKids firstObject];
            }
        }
        _kidSelected = kidSel;
    }
    return _kidSelected;
}

- (void) setObjectSelected:(NSManagedObject *)objectSelected {
    _objectSelected = objectSelected;
    if ([_objectSelected isKindOfClass:[Kid class]] && !(self.kidSelected == _objectSelected)) {
        self.kidSelected = (Kid *) _objectSelected;
    }
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

    [self setKidSelected:self.kidSelected];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void) viewWillDisappear:(BOOL)animated {
    if ([self.kidSelected isKindOfClass:[Kid class]]) {
        Kid *kid = (Kid *) self.kidSelected;
        [[NSUserDefaults standardUserDefaults] setObject:kid.name  forKey:@"kidSelectedName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

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
    
    if ([self.kidSelected isKindOfClass:[Kid class]]) {
        SPAKidTVC *VC = (SPAKidTVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"AKid"];
        VC.isReadOnly = NO;
        VC.objectSelected = (Kid *) self.kidSelected;
        
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"openEditionPart"]) {
        SPSpellingList *destinationVC = (SPSpellingList *)[[segue.destinationViewController childViewControllers] firstObject];
        NSLog(@"class %@", NSStringFromClass([segue.destinationViewController class])  );
        destinationVC.managedObjectContext = self.managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"test"]) {
        SPTestVC *destinationVC = (SPTestVC *)segue.destinationViewController;
        destinationVC.managedObjectContext = self.managedObjectContext;
        destinationVC.kidSelected = self.kidSelected;

        //self.spellingSelected = [self.arrayOfSpellings objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        destinationVC.spellingSelected = self.spellingSelected;

    } else if ([segue.identifier isEqualToString:@"menu2Tab"]) {

    }
}

- (NSUInteger) indexFromArrayOfKidsExtended {
    NSUInteger index = [self.arrayOfKidsExtended indexOfObject:self.kidSelected];
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
    self.kidSelected = [self.arrayOfKidsExtended objectAtIndex:nextIndex];
}

- (void) previousKid {
    NSInteger nextIndex = [self indexFromArrayOfKidsExtended] -1;
    if (nextIndex<0) nextIndex = self.arrayOfKidsExtended.count;
    self.kidSelected= [self.arrayOfKidsExtended objectAtIndex:nextIndex];
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
    if ([self.kidSelected isKindOfClass:[Kid class]]) {
        return [[self.kidSelected valueForKey:@"spellings"] allObjects];
    }
    else return nil;
}

- (void) addObjectToList:(NSManagedObject * ) object {
    if ([object isKindOfClass:[Spelling class]]) {
        Spelling *spellingNew = (Spelling *)object;
        [self.kidSelected addSpellingsObject:spellingNew];
        [self.delegate saveAndRefresh];
    }
}

- (void) removeObjectFromList:(NSManagedObject *)object {
    if ([object isKindOfClass:[Spelling class]]) {
        Spelling *spellingNew = (Spelling *)object;
        [self.kidSelected removeSpellingsObject:spellingNew];
        [super saveAndRefresh];
    }
}
- (NSPredicate *) predicate:(id) sender {
    if ([self.kidSelected isKindOfClass:[Kid class]]) {
        NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:10];
        for (Spelling *spelling in [self.kidSelected valueForKey:@"spellings"]) {
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