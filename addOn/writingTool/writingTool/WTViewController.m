//
//  WTViewController.m
//  writingTool
//
//  Created by Olivier Delecueillerie on 03/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "WTViewController.h"
#import "WTAudio.h"
#import "WTBool.h"
#import "WTImage.h"
#import "WTString.h"
#import "WTDate.h"

#define storyboardWriteTool @"writingTool_iPhone"

@interface WTViewController ()

@property (nonatomic) NSAttributeType attributeType;
@property (nonatomic, strong) NSString *viewTitle;
@property (nonatomic, strong) UIViewController *viewController;
@property (weak, nonatomic) IBOutlet UIView *container;
@property UIViewController  *currentDetailViewController;

@end

@implementation WTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINavigationItem *navigationItem = [self navigationItem];
    navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];

    self.attributeType = [self.selectedAttribute attributeType];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyboardWriteTool bundle:nil];

    if (self.attributeType == NSStringAttributeType ) {

        WTString *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"string"];
        viewController.editableField.text = [self.editedObject valueForKey:[self.selectedAttribute name]];
        viewController.editableField.placeholder = [self.attributeDictionary valueForKey:@"label"];
        [viewController.editableField becomeFirstResponder];
        self.viewController = viewController;

        [self presentDetailController:viewController];

    }

    else if ((self.attributeType == NSInteger16AttributeType) ||
             (self.attributeType == NSInteger32AttributeType) ||
             (self.attributeType == NSInteger64AttributeType) ||
             (self.attributeType == NSDecimalAttributeType) ||
             (self.attributeType == NSDoubleAttributeType) ||
             (self.attributeType == NSFloatAttributeType)
             ) {


//        NSNumber *value = (NSNumber*) [self.editedObject valueForKey:[self.attributeDescription name]];
//        self.textField.text = [value stringValue];
    }

    else if (self.attributeType == NSBooleanAttributeType) {
        WTBool *viewController = [[WTBool alloc] init];
        viewController.switchButton.on = (BOOL)[self.editedObject valueForKey:[self.selectedAttribute name]];
    }

    else if (self.attributeType == NSDateAttributeType) {
        WTDate *viewController = [[WTDate alloc] init];
        NSDate *theDate =  [self.editedObject valueForKey:[self.selectedAttribute name]];
        if (theDate) {
            viewController.datePicker.date = theDate;
        } else {
            viewController.datePicker.date = [NSDate date];
        }
    }

    else if(self.attributeType == NSBinaryDataAttributeType) {
        
        
    }

    
}


- (void)cancel {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void) save {

    // Set the action name for the undo operation.
    NSUndoManager * undoManager = [[self.editedObject managedObjectContext] undoManager];
    [undoManager setActionName:[NSString stringWithFormat:@"%@", self.selectedAttribute.name]];

    // Pass current value to the edited object, then pop.
    if (self.attributeType == NSStringAttributeType ) {
        WTString *specificVC = [[self childViewControllers] firstObject];
        [self.editedObject setValue:specificVC.editableField.text forKey:[self.selectedAttribute name]];
    }
    if (self.attributeType == NSDateAttributeType) {
        //[self.editedObject setValue:self.datePicker.date forKey:[self.selectedAttribute name]];
    }
    else {
        //[self.editedObject setValue:self.textField.text forKey:[self.attributeDescription name]];
    }
#warning yo complete (binary and bool)
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)presentDetailController:(UIViewController*)detailVC{

    //0. Remove the current Detail View Controller showed
    if(self.currentDetailViewController){
        [self removeCurrentDetailViewController];
    }

    //1. Add the detail controller as child of the container
    [self addChildViewController:detailVC];

    //2. Define the detail controller's view size
    detailVC.view.frame = [self frameForDetailController];

    //3. Add the Detail controller's view to the Container's detail view and save a reference to the detail View Controller
    [self.container addSubview:detailVC.view];
    self.currentDetailViewController = detailVC;

    //4. Complete the add flow calling the function didMoveToParentViewController
    [detailVC didMoveToParentViewController:self];

}



- (void)removeCurrentDetailViewController{

    //1. Call the willMoveToParentViewController with nil
    //   This is the last method where your detailViewController can perform some operations before neing removed
    [self.currentDetailViewController willMoveToParentViewController:nil];

    //2. Remove the DetailViewController's view from the Container
    [self.currentDetailViewController.view removeFromSuperview];

    //3. Update the hierarchy"
    //   Automatically the method didMoveToParentViewController: will be called on the detailViewController)
    [self.currentDetailViewController removeFromParentViewController];
}



- (void)swapCurrentControllerWith:(UIViewController*)viewController{

    //1. The current controller is going to be removed
    [self.currentDetailViewController willMoveToParentViewController:nil];

    //2. The new controller is a new child of the container
    [self addChildViewController:viewController];

    //3. Setup the new controller's frame depending on the animation you want to obtain
    viewController.view.frame = CGRectMake(0, 2000, viewController.view.frame.size.width, viewController.view.frame.size.height);

    //3b. Attach the new view to the views hierarchy
    [self.container addSubview:viewController.view];


    //Save the button position...we'll use it later
    //CGPoint buttonCenter = self.button.center;


/*    [UIView animateWithDuration:1.3

     //4. Animate the views to create a transition effect
                     animations:^{

                         //The new controller's view is going to take the position of the current controller's view
                         viewController.view.frame = self.currentDetailViewController.view.frame;

                         //The current controller's view will be moved outside the window
                         self.currentDetailViewController.view.frame = CGRectMake(0,
                                                                                  -2000,
                                                                                  self.currentDetailViewController.view.frame.size.width,
                                                                                  self.currentDetailViewController.view.frame.size.width);
                         //...and the same is for the button
                         self.button.center = CGPointMake(buttonCenter.x, 1000);

                     }


     //5. At the end of the animations we remove the previous view and update the hierarchy.
                     completion:^(BOOL finished) {
*/
                         //Remove the old Detail Controller view from superview
                         [self.currentDetailViewController.view removeFromSuperview];

                         //Remove the old Detail controller from the hierarchy
                         [self.currentDetailViewController removeFromParentViewController];

                         //Set the new view controller as current
                         self.currentDetailViewController = viewController;
                         [self.currentDetailViewController didMoveToParentViewController:self];
                         
                         //reset the button position
/*                         [UIView animateWithDuration:0.5 animations:^{
                             self.button.center = buttonCenter;
                         }];
                     }];
*/
}

- (CGRect)frameForDetailController{
    CGRect detailFrame = self.container.bounds;

    return detailFrame;
}














@end
