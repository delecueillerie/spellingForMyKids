//
//  SPMenuVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 23/01/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//
#import "SPMenuVC.h"


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


@property (weak, nonatomic) IBOutlet UIView *testViewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewForPicture;
//@property (weak, nonatomic) IBOutlet UILabel *labelForKidName;
@property (weak, nonatomic) IBOutlet SPKeyboardButton *buttonKeyboard;
@property (weak, nonatomic) IBOutlet SPLevelButton *buttonLevel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeRight;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;


@property (nonatomic, strong) NSArray *arrayOfKids;
//give the user the ability to create a new kid if needed (first launch, etc...)
@property (nonatomic, strong) NSArray *arrayOfKidsExtended;

@property (nonatomic, strong) NSArray *arrayOfSpellings;
@property (nonatomic,strong) id kidSelected;
@property (nonatomic,strong) Spelling *spellingSelected;
@property (nonatomic, strong) SPSpellingTestList *spellingTestListVC;


@end

@implementation SPMenuVC



/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
// ACCESSORS
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *) arrayOfKids {
    if (!_arrayOfKids || self.refreshData)  {
        NSFetchRequest *fetchRequestForKids = [NSFetchRequest fetchRequestWithEntityName:@"Kid"];
        NSError *error;
        _arrayOfKids = [self.managedObjectContext executeFetchRequest:fetchRequestForKids error:&error];
    }
    
    return _arrayOfKids;
}


- (NSArray *) arrayOfKidsExtended {
    if (!_arrayOfKidsExtended || self.refreshData) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self.arrayOfKids];
        [mutableArray addObject:[[NSObject alloc] init]];
        _arrayOfKidsExtended = mutableArray;
    }
    return _arrayOfKidsExtended;
}

- (NSArray *) arrayOfSpellings  {
    if (!_arrayOfSpellings || self.refreshData) {
        NSFetchRequest *fetchRequestForTests = [NSFetchRequest fetchRequestWithEntityName:@"Spelling"];
        NSError *error;
        _arrayOfSpellings = [self.managedObjectContext executeFetchRequest:fetchRequestForTests error:&error];
    }
    return _arrayOfSpellings;
}

- (void) setKidSelected:(id)kidSelected {
    _kidSelected = kidSelected;
    if ([kidSelected isKindOfClass:[Kid class]]) {
        Kid *kid = (Kid *) kidSelected;
        [self.imageViewForPicture roundWithImage:[UIImage imageWithData:kid.image]];
        self.navigationItem.title = kid.name;
        self.objectSelected = (NSManagedObject *) kidSelected;
        self.toolbar.hidden = NO;
        self.spellingTestListVC = (SPSpellingTestList *)[self addObjectListIdentifier:@"spellingTestList" toView:self.testViewContainer];
    } else {
        [self.imageViewForPicture roundWithImage:[UIImage imageNamed:@"newUser"]];
        self.navigationItem.title = @"create a new kid";
        self.testViewContainer.hidden = YES;
        self.toolbar.hidden = YES;
    }

    self.pageControl.currentPage = [self.arrayOfKids indexOfObject:_kidSelected];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
//LIFE CYCLE
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //default value of refresh data
    self.refreshData = NO;
    
    
    //UI design of the navigation controller
    self.navigationItem.title = @"Spelling";
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor blackColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"Cursivestandard" size:20.0], NSFontAttributeName, nil]];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    //UI design
    //self.labelForKidName.font = [UIFont fontWithName:@"Cursivestandard" size:40.0];
    

    
    
#warning if no spelling then error
    //array of kids cannot be nil. This can happen when no kid are saved yet. ( ex. First Launch, etc.)
    /*if ([self.arrayOfKids count]==0)  {
        //Go to edition part directly to fill in data
        UIViewController *destinationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AKid"];
        destinationViewController.editing = YES;
        [self.navigationController pushViewController:destinationViewController animated:NO];
    } else {
*/
    /*
    Kid *kidLastSelected = (Kid *)[[NSUserDefaults standardUserDefaults] objectForKey:@"kidSelected"];
    if (kidLastSelected) self.kidSelected = kidLastSelected;
    else self.kidSelected = (Kid *)[self.arrayOfKidsExtended firstObject];
    /*
    if (self.kidSelected) {
     
    }
    */
  //  }
}


- (void) viewWillAppear:(BOOL)animated {
    NSString *kidSelectedName = [[NSUserDefaults standardUserDefaults] objectForKey:@"kidSelectedName"];
    if (kidSelectedName) {
        for (Kid* kid in self.arrayOfKids) {
            if ([kid.name isEqualToString:kidSelectedName]) {
                self.kidSelected = kid;
            }
        }
    } else if (!self.kidSelected && self.arrayOfKids) {
        self.kidSelected = [self.arrayOfKids firstObject];
    }

    
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    // Page control properties
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    self.pageControl.numberOfPages = [self.arrayOfKidsExtended count];
    self.pageControl.hidesForSinglePage = YES;
    
}

- (void) viewDidAppear:(BOOL)animated {
    self.refreshData = NO;
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
- (IBAction)addSpellingTest:(id)sender {
    [self.spellingTestListVC addButtonAction];
    
    
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
        VC.objectSelected = (Kid *) self.kidSelected;
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        NSManagedObjectContext * managedObjectContextAdd = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContextAdd setParentContext:self.managedObjectContext];
        
        NSManagedObject *objectNew = [NSEntityDescription insertNewObjectForEntityForName:@"Kid" inManagedObjectContext:managedObjectContextAdd];
        SPAKidTVC *viewControllerAnObject = [self.storyboard instantiateViewControllerWithIdentifier:@"AKid"];
        viewControllerAnObject.objectSelected = objectNew;
        viewControllerAnObject.managedObjectContext = managedObjectContextAdd;
        viewControllerAnObject.editing = YES;
        viewControllerAnObject.newObject = YES;
        [self.navigationController pushViewController:viewControllerAnObject animated:NO];
        self.refreshData = YES;
    }

    //[self performSegueWithIdentifier:@"menu2Tab" sender:self];
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
        
        destinationVC.level = self.buttonLevel.level;
        destinationVC.keyboardType = self.buttonKeyboard.keyboardType;
    } else if ([segue.identifier isEqualToString:@"menu2Tab"]) {

    }

}


//Methods
- (void) nextKid {
    NSUInteger index = [self.arrayOfKidsExtended indexOfObject:self.kidSelected];
    NSInteger nextIndex = index +1;
    if (nextIndex>= [self.arrayOfKidsExtended count]) nextIndex = 0;

    
    self.kidSelected = [self.arrayOfKidsExtended objectAtIndex:nextIndex];
}

- (void) previousKid {
    NSUInteger index = [self.arrayOfKidsExtended indexOfObject:self.kidSelected];
    NSInteger nextIndex = index -1;
    if (nextIndex<0) nextIndex = (self.arrayOfKidsExtended.count -1);

    self.kidSelected = [self.arrayOfKidsExtended objectAtIndex:nextIndex];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
//DELEGATE
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////


- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
}
@end