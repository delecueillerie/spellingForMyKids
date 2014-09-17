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

//Tools
#import "SPUtterance.h"

@interface SPAWordTVC ()



@property (strong, nonatomic) Word *wordSelected;


@property (weak, nonatomic) IBOutlet UILabel *labelWordName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldWordName;

@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIView *viewContainerCamera;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewImage;

@property (weak, nonatomic) IBOutlet UISlider *sliderLevel;
@property (weak, nonatomic) IBOutlet UILabel *labelLevel;

@property (weak, nonatomic) IBOutlet UIPickerView *PVSchoolLevel;


@property (weak, nonatomic) IBOutlet UITableView *tableViewSpelling;


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

- (void) setEditing:(BOOL)editing {
    [super setEditing:editing];
    
    self.textFieldWordName.hidden = !editing;
    self.labelWordName.hidden=editing;
    self.viewContainerCamera.hidden = !editing;
    self.microphoneVC.editing = self.editing;
}
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// III - VC Life Cycle Management
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (void) viewDidLoad {
    [super viewDidLoad];
    
    //Microphone
    self.microphoneVC = [MIViewController instantiateInitialViewControllerWithMicrophoneDelegate:self];
    [self addChildViewController:self.microphoneVC];
    [self.microphoneVC didMoveToParentViewController:self];
    self.microphoneVC.view.frame = self.viewContainer.bounds;
    [self.viewContainer addSubview:self.microphoneVC.view];

    
    //photoPicker
    photoPickerViewController *photoPickerVC = [photoPickerViewController instantiateInitialViewControllerWithPhotoPickerDelegate:self withCamera:YES];
    [self addChildViewController:photoPickerVC];
    [photoPickerVC didMoveToParentViewController:self];
    photoPickerVC.view.frame=self.viewContainerCamera.bounds;
    [self.viewContainerCamera addSubview:photoPickerVC.view];
    
    //delegates
    self.textFieldWordName.delegate = self;
    self.dataSoundRecorded = self.wordSelected.audio;

}


- (void) viewWillAppear:(BOOL)animated {
    [self refresh];
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//Trigerred action
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (void) refresh {
    self.labelWordName.text = self.wordSelected.name;
    self.textFieldWordName.text = self.wordSelected.name;
    [self.imageViewImage roundWithImage:[UIImage imageWithData:self.wordSelected.image]];
    [super refresh];
    //this method is called before the delegate method textFieldDidEndEditing

}

- (void) loadInput {
    self.wordSelected.name = self.textFieldWordName.text;
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Text Field delegate
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (void) textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 0:
            NSLog(@"contenu du text field %@",textField.text);
            self.wordSelected.name = textField.text;
            self.labelWordName.text = textField.text;
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
    [self.imageViewImage roundWithImage:[UIImage imageWithData:self.wordSelected.image]];

}
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Microphone Delegate
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
- (void) microphonePlayerDidFinishRecording {
    self.wordSelected.audio = self.dataSoundRecorded;
}

- (void) deleteDataSoundRecorded {
    self.wordSelected.audio = nil;
}

- (void) playOtherSound {
    SPUtterance *utterance = [[SPUtterance alloc] init];
    [utterance speechUterance:self.wordSelected.name];
}


@end
