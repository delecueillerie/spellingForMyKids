//
//  SPMenuVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 23/01/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//
#import "SPMenuVC.h"
#import "DBCoreDataStack.h"

#import "SPTestVC.h"
//#import "polaroidAnimatedView.h"
#import "polaroidView.h"
#import "polaroidCollectionViewCell.h"

@interface SPMenuVC ()


@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewForPicture;
@property (weak, nonatomic) IBOutlet UILabel *labelForKidName;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeRight;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSArray *arrayOfKids;
@property (nonatomic, strong) NSArray *arrayOfSpellings;
@property (nonatomic,strong) Kid *kidSelected;
@property (nonatomic,strong) Spelling *spellingSelected;
@property (nonatomic, strong) NSString *labelForPickerView;




@property (strong, nonatomic) NSArray *dataForPolaroidViews ;
//@property (strong, nonatomic) polaroidAnimatedView *polaroidView;
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

- (NSArray *) dataForPolaroidViews {
    if (!_dataForPolaroidViews) {
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        for (Kid *kid in self.arrayOfKids) {
            UIImage *image = [[UIImage alloc] init];
            if (kid.image) image = [UIImage imageWithData:kid.image];
            [mutableArray addObject:@{@"image": image , @"label" : kid.name}];
        }
        _dataForPolaroidViews = [NSArray arrayWithArray:mutableArray];
    }
    return _dataForPolaroidViews;
}


- (void)viewDidLoad
{
    [super viewDidLoad];


    //Initialization of the pickerView data for row
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;

    //array of kids cannot be nil. This can happen when no kid are saved yet.
    if ([self.arrayOfKids count]==0)  {
        //Go to edition part directly to fill in data
        UIViewController *destinationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"edition"];
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
    self.dataForPolaroidViews = nil;

}

- (void) refreshUI {
    self.imageViewForPicture.image = [UIImage imageWithData:self.kidSelected.image];
    self.labelForKidName.text = self.kidSelected.name;
}

- (void) viewWillAppear:(BOOL)animated {
    [self refresh];
    [self.pickerView reloadAllComponents];
    self.navigationController.navigationBarHidden = YES;

}

//UIGestureRecognizer
- (IBAction)swipeRightOnPicture:(UISwipeGestureRecognizer *)sender {
    [self previousKid];
}

- (IBAction)swipeLeftOnPicture:(UISwipeGestureRecognizer *)sender {
    [self nextKid];
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


- (IBAction)goToEditionPart:(UIButton *)sender {

    /*UIStoryboard *editionMenuStoryboard = [UIStoryboard storyboardWithName:storyboard1 bundle:[NSBundle mainBundle]];
    UINavigationController *navVC = [editionMenuStoryboard instantiateInitialViewController];
    EDEntitiesTVC *firstEditionVC = (EDEntitiesTVC *) [navVC.childViewControllers firstObject];
    firstEditionVC.entitiesDictionary = [self.coreDataStack entitiesDictionary];
    firstEditionVC.managedObjectContext = self.coreDataStack.managedObjectContext;

    //Be careful, pushing a UINavigation instance is not supported, thus we push firstEditionVC instead of navVC
    [self.navigationController pushViewController:firstEditionVC animated:NO];
    */

}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"openEditionPart"]) {
        /*UITabBarController *destinationVC = (UITabBarController *) [segue destinationViewController];

        EDRootVC *selectedVC = (EDRootVC *) destinationVC.selectedViewController;
        selectedVC.managedObjectContext = self.coreDataStack.managedObjectContext;*/
    }
    else if ([segue.identifier isEqualToString:@"test"]) {
        SPTestVC *destinationVC = (SPTestVC *)segue.destinationViewController;
        destinationVC.managedObjectContext = self.managedObjectContext;
        destinationVC.testedKid = self.kidSelected;

        self.spellingSelected = [self.arrayOfSpellings objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        destinationVC.choosenSpelling = self.spellingSelected;
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