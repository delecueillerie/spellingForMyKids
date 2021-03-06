//
//  SPAKidVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 10/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPAKidVC.h"

//ManagedObject
#import "Kid.h"

#import "photoPickerViewController.h"
//Category
#import "UIImageView+cornerRadius.h"
@interface SPAKidVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *labelKidName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldKidName;

//@property (weak, nonatomic) IBOutlet UIPickerView *PVSchoolLevel;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewImage;
@property (weak, nonatomic) IBOutlet UIView *viewContainerCamera;
@property (strong,nonatomic) photoPicker *photoPicker;

@property (strong, nonatomic) UIImage *kidImage;
@property (strong, nonatomic) Kid *kidSelected;

@end

@implementation SPAKidVC

@synthesize kidImage = _kidImage, kidSelected = _kidSelected;

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Accessors
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
- (NSData *) dataImageCaptured {
    if (!_dataImageCaptured) _dataImageCaptured = [[NSData alloc] init];
    return _dataImageCaptured;
}

- (Kid *) kidSelected {
    if (!_kidSelected) {
        _kidSelected = (Kid *) self.objectSelected;
    }
    return _kidSelected;
}

- (void) setKidSelected:(Kid *)kidSelected {
    _kidSelected = kidSelected;
    self.objectSelected = _kidSelected;
    [[NSUserDefaults standardUserDefaults] setObject:_kidSelected.name  forKey:@"kidSelectedName"];
}

- (UIImage *) kidImage {
    if (!self.kidSelected.image) {
        self.kidSelected.image = UIImagePNGRepresentation([UIImage imageNamed:@"bonhommeVide.png"]);
    } else {
        _kidImage = [UIImage imageWithData:self.kidSelected.image];
    }
    return _kidImage;
}

- (void) setKidImage:(UIImage *)kidImage {
    _kidImage = kidImage;
    self.kidSelected.image = [[NSData alloc] initWithData:UIImagePNGRepresentation(kidImage)];
    [self.imageViewImage roundWithImage:kidImage];
}

- (void) setEditing:(BOOL)editing {
    [super setEditing:editing];
    self.textFieldKidName.hidden = !editing;
    self.viewContainerCamera.hidden = !editing;
    self.labelKidName.hidden=editing;
}







//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// LifeCycle VC
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
- (void) viewDidLoad {
    [super viewDidLoad];
    //load VC for container
    photoPickerViewController *photoPickerVC = [photoPickerViewController instantiateInitialViewControllerWithPhotoPickerDelegate:self withCamera:YES];
    [self addChildViewController:photoPickerVC];
    [photoPickerVC didMoveToParentViewController:self];
    photoPickerVC.view.frame=self.viewContainerCamera.bounds;
    [self.viewContainerCamera addSubview:photoPickerVC.view];
    
    //delegates
    self.textFieldKidName.delegate = self;
    //self.PVSchoolLevel.delegate = self;
    
    //font
    //self.labelConstName.font = [UIFont fontWithName:@"Cursivestandard" size:17.0];
    
    //Receive Notification from Keyboard
    [self registerForKeyboardNotifications];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// II - overridding
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////



- (void) refresh {
    [self.imageViewImage roundWithImage:self.kidImage];
    
    self.labelKidName.text = self.kidSelected.name;
    self.textFieldKidName.text = self.kidSelected.name;
}

- (void) loadInput {
    self.kidSelected.name = self.textFieldKidName.text;
}






//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Text Field Delegate
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////
// II - a - delegate
//////////////////////////////////////////////////////////

- (void) textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 0:
            self.kidSelected.name = textField.text;
            self.labelKidName.text = textField.text;
            break;
        
        case 1:
            break;
        default:
            break;
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {

}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// PhotoPicker Delegate
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
- (void) photoPickerDidFinishPickingImage {
    self.kidSelected.image = self.dataImageCaptured;
    self.kidImage = [UIImage imageWithData:self.dataImageCaptured];
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Keyboard management
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.textFieldKidName.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.textFieldKidName.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    /*
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
     */
}

@end
