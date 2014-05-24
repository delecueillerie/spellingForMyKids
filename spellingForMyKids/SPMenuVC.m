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

#import "DBCoreDataStack.h"
//Controller
#import "SPTestVC.h"
#import "SPSpellingList.h"
#import "SPAKidTVC.h"
//View
#import "SPKeyboardButton.h"
#import "SPLevelButton.h"

@interface SPMenuVC ()


@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewForPicture;
@property (weak, nonatomic) IBOutlet UILabel *labelForKidName;
@property (weak, nonatomic) IBOutlet SPKeyboardButton *buttonKeyboard;
@property (weak, nonatomic) IBOutlet SPLevelButton *buttonLevel;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeRight;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSArray *arrayOfKids;
@property (nonatomic, strong) NSArray *arrayOfSpellings;
@property (nonatomic,strong) Kid *kidSelected;
@property (nonatomic,strong) Spelling *spellingSelected;

@end

@implementation SPMenuVC

- (NSManagedObjectContext *) managedObjectContext {
    if (!_managedObjectContext) _managedObjectContext = [DBCoreDataStack sharedInstance].managedObjectContext;
    return _managedObjectContext;
}

- (NSArray *) arrayOfKids {
    if (!_arrayOfKids)  {
        NSFetchRequest *fetchRequestForKids = [NSFetchRequest fetchRequestWithEntityName:@"Kid"];
        NSError *error;
        _arrayOfKids = [self.managedObjectContext executeFetchRequest:fetchRequestForKids error:&error];
    }
    return _arrayOfKids;
}

- (NSArray *) arrayOfSpellings {
    if (!_arrayOfSpellings) {
        NSFetchRequest *fetchRequestForTests = [NSFetchRequest fetchRequestWithEntityName:@"Spelling"];
        NSError *error;
        _arrayOfSpellings = [self.managedObjectContext executeFetchRequest:fetchRequestForTests error:&error];
    }
    return _arrayOfSpellings;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //UI design of the navigation controller
    self.navigationItem.title = @"Spelling";
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor blackColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"Cursivestandard" size:20.0], NSFontAttributeName, nil]];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    //UI design
    self.labelForKidName.font = [UIFont fontWithName:@"Cursivestandard" size:40.0];
    
    
    //Initialization of the pickerView data for row
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;

  
#warning if no spelling then error
    //array of kids cannot be nil. This can happen when no kid are saved yet. ( ex. First Launch, etc.)
    if ([self.arrayOfKids count]==0)  {
        //Go to edition part directly to fill in data
        UIViewController *destinationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AKid"];
        destinationViewController.editing = YES;
        [self.navigationController pushViewController:destinationViewController animated:NO];
    } else {

        Kid *kidLastSelected = (Kid *)[[NSUserDefaults standardUserDefaults] objectForKey:@"kidSelected"];
        if (kidLastSelected) self.kidSelected = kidLastSelected;
        else self.kidSelected = (Kid *)[self.arrayOfKids firstObject];
        [self refreshUI];
    }
}


- (void) refresh {
    self.arrayOfKids = nil;
    self.arrayOfSpellings = nil;
}

- (void) refreshUI {
    [self.imageViewForPicture roundWithImage:[UIImage imageWithData:self.kidSelected.image]];
    self.labelForKidName.text = self.kidSelected.name;
}

- (void) viewWillAppear:(BOOL)animated {
    [self refresh];
    [self.pickerView reloadAllComponents];
}

//UIGestureRecognizer
- (IBAction)swipeRightOnPicture:(UISwipeGestureRecognizer *)sender {
    [self previousKid];
}

- (IBAction)swipeLeftOnPicture:(UISwipeGestureRecognizer *)sender {
    [self nextKid];
}
- (IBAction)tapOnPicture:(UITapGestureRecognizer *)sender {
    SPAKidTVC *VC = (SPAKidTVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"AKid"];
    VC.objectSelected = self.kidSelected;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)buttonNext:(id)sender {
    [self nextKid];
}

- (IBAction)buttonPrevious:(id)sender {
    [self previousKid];
}

//UIPickerView Delegate
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.arrayOfSpellings objectAtIndex:row] valueForKey:@"name"];
}



- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}


//UIPickerViewDataSource
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return ([self.arrayOfSpellings count]);
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"openEditionPart"]) {


    }
    else if ([segue.identifier isEqualToString:@"test"]) {
        SPTestVC *destinationVC = (SPTestVC *)segue.destinationViewController;
        destinationVC.managedObjectContext = self.managedObjectContext;
        destinationVC.kidSelected = self.kidSelected;

        self.spellingSelected = [self.arrayOfSpellings objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        destinationVC.spellingSelected = self.spellingSelected;
        
        destinationVC.level = self.buttonLevel.level;
        destinationVC.keyboardType = self.buttonKeyboard.keyboardType;
    }

}


//Methods
- (void) nextKid {
    NSUInteger index = [self.arrayOfKids indexOfObject:self.kidSelected];
    NSInteger nextIndex = index +1;
    if (nextIndex>= [self.arrayOfKids count]) nextIndex = 0;

    self.kidSelected = (Kid *)[self.arrayOfKids objectAtIndex:nextIndex];
    [self refreshUI];
}

- (void) previousKid {
    NSUInteger index = [self.arrayOfKids indexOfObject:self.kidSelected];
    NSInteger nextIndex = index -1;
    if (nextIndex<0) nextIndex = (self.arrayOfKids.count -1);

    self.kidSelected = (Kid *)[self.arrayOfKids objectAtIndex:nextIndex];
    [self refreshUI];
}
@end