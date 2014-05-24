//
//  SPAKidTVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 10/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPAKidTVC.h"
//ManagedObject
#import "Kid.h"
#import "photoPickerViewController.h"
//Category
#import "UIImageView+cornerRadius.h"
@interface SPAKidTVC ()

//row 0
@property (weak, nonatomic) IBOutlet UILabel *labelKidName;
@property (weak, nonatomic) IBOutlet UITextField *textFielKidName;

//row 1
@property (weak, nonatomic) IBOutlet UIImageView *imageViewImage;

@property (weak, nonatomic) IBOutlet UIView *viewContainerCamera;
@property (strong,nonatomic) photoPicker *photoPicker;

@property (strong, nonatomic) Kid *kidSelected;

@end

@implementation SPAKidTVC

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// I - Lazy Instantiation
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
- (NSData *) dataImageCaptured {
    if (!_dataImageCaptured) _dataImageCaptured = [[NSData alloc] init];
    return _dataImageCaptured;
}

- (Kid *) kidSelected {
    if (!_kidSelected) _kidSelected = (Kid *) self.objectSelected;
    return _kidSelected;
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

    
    [self updateUI];
}


- (void) buttonSaveAction {
    self.kidSelected.name = self.textFielKidName.text;
    //self.kidSelected.image = self.dataImageCaptured;
    
    [super buttonSaveAction];
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// I -
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (void) updateUI {
    
    [super updateUI];
    
    self.labelKidName.text = self.kidSelected.name;
    self.textFielKidName.text = self.kidSelected.name;
    if (!self.kidSelected.image) {
        [self.imageViewImage roundWithImage:[UIImage imageNamed:@"bonhommeVide.png"]];
    } else {
        [self.imageViewImage roundWithImage:[UIImage imageWithData:self.kidSelected.image]];
    }


    if (self.editing) {
        self.textFielKidName.hidden=NO;
        self.textFielKidName.delegate = self;
        self.labelKidName.hidden=YES;
        self.viewContainerCamera.hidden = NO;

    } else {
        self.textFielKidName.hidden = YES;
        self.labelKidName.hidden = NO;
        self.viewContainerCamera.hidden = YES;
    }
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
            break;
        default:
            break;
    }
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// PhotoPicker Delegate
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
- (void) photoPickerDidFinishPickingImage {
    self.kidSelected.image = self.dataImageCaptured;
    [self updateUI];
}


@end
