//
//  SPAKidTVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 10/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPAKidTVC.h"
#import "SPSchoolLevel.h"

//ManagedObject
#import "Kid.h"
#import "photoPickerViewController.h"
//Category
#import "UIImageView+cornerRadius.h"
@interface SPAKidTVC ()

@property (weak, nonatomic) IBOutlet UILabel *labelKidName;
@property (weak, nonatomic) IBOutlet UITextField *textFielKidName;
@property (weak, nonatomic) IBOutlet UILabel *labelConstName;

//@property (weak, nonatomic) IBOutlet UIPickerView *PVSchoolLevel;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UITextField *activeField;


@property (weak, nonatomic) IBOutlet UIView *viewContainerCamera;
@property (strong,nonatomic) photoPicker *photoPicker;

@property (strong, nonatomic) Kid *kidSelected;
@property (strong, nonatomic) UIImage *kidImage;

@end

@implementation SPAKidTVC

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
        NSLog(@"NSMan&gedObjectContext %@", [self.kidSelected.managedObjectContext description]);
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
    self.textFielKidName.hidden = !editing;
    self.viewContainerCamera.hidden = !editing;
    self.labelKidName.hidden=editing;
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// II - overridding
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
    self.textFielKidName.delegate = self;
    //self.PVSchoolLevel.delegate = self;

    //font
    self.labelConstName.font = [UIFont fontWithName:@"Cursivestandard" size:17.0];
}


- (void) refresh {
    [self.imageViewImage roundWithImage:self.kidImage];
    
    self.labelKidName.text = self.kidSelected.name;
    self.textFielKidName.text = self.kidSelected.name;
}

- (void) loadInput {
    self.kidSelected.name = self.textFielKidName.text;
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
    self.activeField = nil;
    switch (textField.tag) {
        case 0:
            self.kidSelected.name = textField.text;
            self.labelKidName.text = textField.text;
            break;
        
        case 1:
            self.kidSelected.age = [NSNumber numberWithInt:[textField.text intValue]];
        default:
            break;
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField ;
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
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

/*
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Pickerview delegate & datasource
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[SPSchoolLevel arrayOfSchoolLevel] count];
}

- (NSAttributedString *) pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *dicLevel = [[SPSchoolLevel arrayOfSchoolLevel] objectAtIndex:row];
    
    NSDictionary *dicAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor blackColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Cursivestandard" size:20.0], NSFontAttributeName, nil];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[dicLevel valueForKey:@"name"] attributes:dicAttributes];
    
    return attributedString;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *dicLevel = [[SPSchoolLevel arrayOfSchoolLevel] objectAtIndex:row];
    return [dicLevel valueForKey:@"name"];
}
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.kidSchoolLevel = [[SPSchoolLevel arrayOfSchoolLevel] objectAtIndex:row];
}
*/
@end
