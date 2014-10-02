//
//  SPMenuVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 23/01/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//
#import "SPMenuVC.h"

//Model
#import "Kid+enhanced.h"
#import "SPellingTest+enhanced.h"
#import "Spelling+enhanced.h"
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
#import "SPSpellingTest.h"
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
        self.arrayOfKidsExtended = nil; //reinitialize the array when arrayOfKids change
    }
    return _arrayOfKids;
}

- (NSArray *) arrayOfKidsExtended {
    if (!_arrayOfKidsExtended) {
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.arrayOfKids];
        [mArray addObject:self.addKidObject];
        self.pageControl.numberOfPages = [mArray count];
        _arrayOfKidsExtended = mArray;
    }
    return _arrayOfKidsExtended;
}


- (void) setObjectSelected:(id)objectSelected {
    
    /*objectSelected attribute can be an Managed Object from a different Context.
     it is important to move the attribute to the right context */
    
    if ([objectSelected isKindOfClass:[Kid class]]) {
        Kid *kid = (Kid *)objectSelected;
        if (kid.managedObjectContext == self.managedObjectContext) {
            _objectSelected = kid;
        } else {
        _objectSelected = [kid kidInManagedObjectContext:self.managedObjectContext];
        }
        
        //reload the list of test
        [self.imageViewForPicture roundWithImage:[UIImage imageWithData:[[self kidSelected] image]]];
        self.navigationItem.title = [[self kidSelected] name];
        
        //UI design update
        self.viewContainer.hidden = NO;
        self.toolbar.hidden = NO;
        
        if ([self.arrayOfKids indexOfObject:_objectSelected] == NSNotFound) {
            //reload arrayOfKids if object is not present in it. A new user should be registered
            self.arrayOfKids = nil;
            self.arrayOfKidsExtended = nil;
        }

        
    } else {
        _objectSelected = objectSelected;
        
        [self.imageViewForPicture roundWithImage:[UIImage imageNamed:@"newUser"]];
        self.navigationItem.title = @"create a new kid";
        self.viewContainer.hidden = YES;
        self.toolbar.hidden = YES;
        self.pageControl.currentPage = [self.arrayOfKidsExtended indexOfObject:self.addKidObject];
    }
    
    self.pageControl.currentPage = [self.arrayOfKidsExtended indexOfObject:_objectSelected];
    [self.objectListVC.tableView reloadData];
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


- (Kid *) kidSelected {
    if ([self.objectSelected isKindOfClass:[Kid class]]) {
        return (Kid *)self.objectSelected;
    } else {
        return nil;
    }
}

- (Spelling *) spellingSelected {
    if ([self.objectListVC.objectSelected isKindOfClass:[Spelling class]]) {
        return (Spelling *)self.objectListVC.objectSelected;
    } else {
        return nil;
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
//LIFE CYCLE
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    
    [super viewDidLoad];
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
        [[NSUserDefaults standardUserDefaults] setObject:[[self kidSelected] name]  forKey:@"kidSelectedName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
    
    if ([self kidSelected]) {
        SPAKidTVC *VC = (SPAKidTVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"AKid"];
        VC.objectSelected = [self kidSelected];
        VC.delegate = self;
        
        [self.navigationController pushViewController:VC animated:YES];
    } else {
/*        NSManagedObjectContext * managedObjectContextAdd = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContextAdd setParentContext:self.managedObjectContext];*/
 
        NSManagedObject *objectNew = [NSEntityDescription insertNewObjectForEntityForName:@"Kid" inManagedObjectContext:self.managedObjectContextAdd];
        SPAKidTVC *viewControllerAnObject = [self.storyboard instantiateViewControllerWithIdentifier:@"AKid"];
        NSLog(@"object new MOC%@",[objectNew.managedObjectContext description]);
        viewControllerAnObject.objectSelected = objectNew;
        viewControllerAnObject.managedObjectContext = [objectNew managedObjectContext];
        NSLog(@"objectSelected MOC %@", [[viewControllerAnObject.objectSelected valueForKey:@"managedObjectContext"] description]);
        //viewControllerAnObject.managedObjectContext = managedObjectContextAdd;
        viewControllerAnObject.delegate = self;
        [self.navigationController pushViewController:viewControllerAnObject animated:NO];
    }
}

- (NSUInteger) indexFromArrayOfKidsExtended {
    NSUInteger index = [self.arrayOfKidsExtended indexOfObject:self.objectSelected];
    if (index == NSNotFound) {
        index = [self.arrayOfKidsExtended indexOfObject:self.addKidObject];
        if (index == NSNotFound) {
            index = 0;
        }
    }
    NSLog(@"index de l'objet%lu", index);
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
    if (nextIndex<0) nextIndex = (self.arrayOfKidsExtended.count-1);
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

- (objectState) objectState:(id)sender {
    objectState state;
    if ([sender isKindOfClass:[SPAKidTVC class]]) {
        if ([sender valueForKey:@"managedObjectContext"]==self.managedObjectContext) {
            state = objectStateRead;
        } else {
            state = objectStateEdit;
        }
    } else if (sender == self) {
        state = objectStateReadOnly;
    } else {
        state = objectStateRead;
    }
    return state;
}

/*////////////////////////////////////////////////
 objectList Delagte & DataSource
 ///////////////////////////////////////////////*/

- (UIImage *) cellImageFor:(NSManagedObject *)object {
    
    UIImage *medal = nil;
    //NSLog(@"obect description%@", [object description]);
    if ([object isKindOfClass:[Spelling class]]) {
        Spelling *spelling = (Spelling *) object;
        
        switch ([spelling spellingMedalFor:[self kidSelected]]) {
            case spellingMedalEmpty:
                medal = nil;
                break;
            
            case spellingMedalBronze:
                medal = [UIImage imageNamed:@"medal_bronze"];
                break;
                
            case spellingMedalSilver:
                medal = [UIImage imageNamed:@"medal_silver"];
                break;
                
            case spellingMedalGold:
                medal = [UIImage imageNamed:@"medal_gold"];
                break;
                
            default:
                medal =nil;
                break;
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

- (UIViewController *) viewControllerForObject:(id) object {
    if ([object isKindOfClass:[Spelling class]]) {
        
        Spelling *spellingSelected = (Spelling *) object;
        
        //create a new spellingTest object and display the VC associated to it
        SpellingTest *newSpellingTest = [SpellingTest spellingTestFor:[[self kidSelected] kidInManagedObjectContext:self.managedObjectContextAdd]
                                                             spelling:[spellingSelected spellingInManagedObjectContext:self.managedObjectContextAdd]];
        
        SPSpellingTest *spellingTestVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"spellingTest"];
        spellingTestVC.objectSelected = newSpellingTest;
        spellingTestVC.delegate = self;
        
        return spellingTestVC;
    } else {
        return nil;
    }
}


-(datasource) datasource:(id)sender {
    if (sender == self.objectListVC) {
        return datasourceArray;
    } else if ([sender isKindOfClass:[SPSpellingTest class]]) {
        return datasourceArray;
    } else {
        return datasourceFetched;
    }
}

- (NSArray *) arrayData:(id) sender {
    if ([self kidSelected]) {
        if (sender == self) {
            return nil;
        } else if ([sender isKindOfClass:[SPSpellingList class]]) {
            return [[[self kidSelected] spellings] allObjects];
        } else if ([sender isKindOfClass:[SPSpellingTest class]]) {
            return [[[self spellingSelected] words] allObjects];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
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
    if ([self kidSelected] && sender == self) {
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

@end