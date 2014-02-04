//
//  SPTestPageVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 23/01/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//
#import "SPTestPageVC.h"
#import "DBCoreDataStack+HumanReadingEntities.h"
#import "EDEntitiesTVC.h"


#define storyboard1 @"editionTableView_iPhone"

@interface SPTestPageVC ()

@property (nonatomic, strong) DBCoreDataStack *coreDataStack;

@end

@implementation SPTestPageVC

- (DBCoreDataStack *) coreDataStack {
    if(!_coreDataStack) _coreDataStack = [[DBCoreDataStack alloc] init];
    return _coreDataStack;
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
- (IBAction)goToEditionPart:(UIButton *)sender {

    UIStoryboard *editionMenuStoryboard = [UIStoryboard storyboardWithName:storyboard1 bundle:[NSBundle mainBundle]];
    UINavigationController *navVC = [editionMenuStoryboard instantiateInitialViewController];
    EDEntitiesTVC *firstEditionVC = (EDEntitiesTVC *) [navVC.childViewControllers firstObject];
    firstEditionVC.entitiesDictionary = [self.coreDataStack entitiesDictionary];
    firstEditionVC.managedObjectContext = self.coreDataStack.managedObjectContext;

    //Be careful, pushing a UINavigation instance is not supported, thus we push firstEditionVC instead of navVC
    [self.navigationController pushViewController:firstEditionVC animated:NO];
    

}

@end
