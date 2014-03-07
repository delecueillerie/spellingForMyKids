//
//  SPEditWordVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 06/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPEditWordVC.h"

#define writingToolStoryboardForIPhoneName @"writingTool_iPhone"
#define stringVCId  @"string"
#define dateVCId    @"date"
#define boolVCId    @"bool"
#define audioVCId   @"audio"
#define imageVCId   @"image"

@interface SPEditWordVC ()


@property (strong, nonatomic) UIViewController *stringEditVC;
@property (strong, nonatomic) UIViewController *audioEditVC;
@property (strong, nonatomic) UIViewController *imageEditVC;

@property (strong, nonatomic) NSArray *currentEditVCs;

@property (weak, nonatomic) IBOutlet UIView *stringViewContainer;
@property (weak, nonatomic) IBOutlet UIView *audioViewContainer;
@property (weak, nonatomic) IBOutlet UIView *imageViewContainer;
@end

@implementation SPEditWordVC

- (void) viewDidLoad {

    UIStoryboard *writingToolStoryboard = [UIStoryboard storyboardWithName:writingToolStoryboardForIPhoneName bundle:nil];
    self.stringEditVC = [writingToolStoryboard instantiateViewControllerWithIdentifier:stringVCId];
    self.audioEditVC = [writingToolStoryboard instantiateViewControllerWithIdentifier:audioVCId];
    self.imageEditVC = [writingToolStoryboard instantiateViewControllerWithIdentifier:imageVCId];

    [self presentEditController];
}

- (void)presentEditController {

    //0. Remove the current Detail View Controller showed
    if(self.childViewControllers){
        [self removeChildViewControllers];
    }

    //1. Add the edit view controller as child of the container
    [self addChildViewController:self.stringEditVC];
    [self addChildViewController:self.imageEditVC];
    [self addChildViewController:self.audioEditVC];

    //2. Define the detail controller's view size
    self.stringEditVC.view.frame = [self frameForEmbeddedVIewControllerUsingView:self.stringViewContainer];
    self.audioEditVC.view.frame = [self frameForEmbeddedVIewControllerUsingView:self.audioViewContainer];
    self.imageEditVC.view.frame = [self frameForEmbeddedVIewControllerUsingView:self.imageViewContainer];

    //3. Add the Detail controller's view to the Container's detail view and save a reference to the detail View Controller
    [self.stringViewContainer addSubview:self.stringEditVC.view];
    [self.audioViewContainer addSubview:self.audioEditVC.view];
    [self.imageViewContainer addSubview:self.imageEditVC.view];

    //4. Complete the add flow calling the function didMoveToParentViewController
    [self.stringEditVC didMoveToParentViewController:self];
    [self.audioEditVC didMoveToParentViewController:self];
    [self.imageEditVC didMoveToParentViewController:self];
}



- (void)removeChildViewControllers{

    for (UIViewController *viewController in self.childViewControllers) {

        //1. Call the willMoveToParentViewController with nil
        //   This is the last method where your detailViewController can perform some operations before neing removed
        [viewController willMoveToParentViewController:nil];

        //2. Remove the DetailViewController's view from the Container
        [viewController.view removeFromSuperview];

        //3. Update the hierarchy"
        //   Automatically the method didMoveToParentViewController: will be called on the detailViewController)
        [viewController removeFromParentViewController];

    }
}


/*
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


    [UIView animateWithDuration:1.3

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
    //Remove the old Detail Controller view from superview
    [self.currentDetailViewController.view removeFromSuperview];

    //Remove the old Detail controller from the hierarchy
    [self.currentDetailViewController removeFromParentViewController];

    //Set the new view controller as current
    self.currentDetailViewController = viewController;
    [self.currentDetailViewController didMoveToParentViewController:self];

    //reset the button position
                    [UIView animateWithDuration:0.5 animations:^{
     self.button.center = buttonCenter;
     }];
     }];
}
*/

- (CGRect)frameForEmbeddedVIewControllerUsingView: (UIView *) container {
    CGRect frame = container.bounds;
    return frame;
}




@end
