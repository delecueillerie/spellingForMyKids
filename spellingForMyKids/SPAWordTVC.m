//
//  SPAWordTVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 07/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPAWordTVC.h"
//ManagedObject
#import "Word.h"
//Container
#import "MIViewController.h"
#import "photoPickerViewController.h"

//Category
#import "UIImageView+cornerRadius.h"

@interface SPAWordTVC ()



@property (strong, nonatomic) Word *wordSelected;


@property (weak, nonatomic) IBOutlet UILabel *labelWordName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldWordName;

@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIView *viewContainerCamera;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewImage;

@property (strong, nonatomic) MIViewController *microphoneVC;
//@property (nonatomic) BOOL editing;
@end

@implementation SPAWordTVC

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//Lazy Instantiation & Accessors
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (Word *) wordSelected {
    if (!_wordSelected) _wordSelected = (Word *) self.objectSelected;
    return _wordSelected;
}

/*
- (void) setEditing:(BOOL)editingValue {
    _editing = editingValue;
    self.microphoneVC.editing = editingValue;
}
*/
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// III - VC Life Cycle Management
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (void) viewDidLoad {
    [super viewDidLoad];
    
    //load Container VC
    self.microphoneVC = [MIViewController instantiateInitialViewControllerWithMicrophoneDelegate:self];
    self.microphoneVC.editing = self.editing;

    [self addChildViewController:self.microphoneVC];
    [self.microphoneVC didMoveToParentViewController:self];
    self.microphoneVC.view.frame = self.viewContainer.bounds;
    [self.viewContainer addSubview:self.microphoneVC.view];

    
    
    photoPickerViewController *photoPickerVC = [photoPickerViewController instantiateInitialViewControllerWithPhotoPickerDelegate:self withCamera:YES];
    [self addChildViewController:photoPickerVC];
    [photoPickerVC didMoveToParentViewController:self];
    photoPickerVC.view.frame=self.viewContainerCamera.bounds;
    [self.viewContainerCamera addSubview:photoPickerVC.view];
    
    self.dataSoundRecorded = self.wordSelected.audio;
    [self updateUI];
}

/*
- (void) viewWillAppear:(BOOL)animated {
    self.microphoneVC.editing = self.editing;
}
 */
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// II - Override method
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////


- (void) updateUI {
    
    [super updateUI];

    self.labelWordName.text = self.wordSelected.name;
    self.textFieldWordName.text = self.wordSelected.name;
    [self.imageViewImage roundWithImage:[UIImage imageWithData:self.wordSelected.image]];

    if (self.editing) {
        self.textFieldWordName.hidden=NO;
        self.textFieldWordName.delegate = self;
        self.textFieldWordName.text = self.wordSelected.name;
        self.labelWordName.hidden=YES;
        self.viewContainerCamera.hidden = NO;
        self.microphoneVC.editing = self.editing;
        
    } else {
        self.textFieldWordName.hidden = YES;
        self.labelWordName.hidden = NO;
        self.labelWordName.text = self.wordSelected.name;
        self.viewContainerCamera.hidden = YES;
        self.microphoneVC.editing = self.editing;
        
    }
}

- (void) buttonSaveAction {
    //this method is called before the delegate method textFieldDidEndEditing
    self.wordSelected.name = self.textFieldWordName.text;
   // self.wordSelected.image = self.dataImageCaptured;
    [super buttonSaveAction];
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// II - Text Field
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////
// II - a - delegate
//////////////////////////////////////////////////////////

- (void) textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 0:
            NSLog(@"contenu du text field %@",textField.text);
            self.wordSelected.name = textField.text;
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
    self.wordSelected.image = self.dataImageCaptured;
    [self updateUI];
}
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Microphone Delegate
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
- (void) microphonePlayerDidFinishRecording {
    self.wordSelected.audio = self.dataSoundRecorded;
}




@end
