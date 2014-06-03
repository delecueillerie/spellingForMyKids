//
//  SPPhoneme.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 27/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPPhoneme.h"
#import "Phoneme.h"
#import "SPPhonemeView.h"
#import "SPGraphemeList.h"
//#import "Grapheme.h"

@interface SPPhoneme ()


//UI Outlet
@property (weak, nonatomic) IBOutlet UITextField *textFieldAPI;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewMicrophone;
@property (weak, nonatomic) IBOutlet UIView *viewMicrophone;
@property (weak, nonatomic) IBOutlet UIView *viewContainerGraphemeList;
@property (weak, nonatomic) IBOutlet SPPhonemeView *viewContainerPhonemeView;

@property (strong, nonatomic)  SPPhonemeView *viewPhoneme;


@property (strong, nonatomic) MIViewController *microphoneVC;
@property (strong, nonatomic) Phoneme *phonemeSelected;


@end

@implementation SPPhoneme

@synthesize objectList = _objectList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//Lazy Instantiation & Accessors
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (Phoneme *) phonemeSelected {
    if (!_phonemeSelected) _phonemeSelected = (Phoneme *) self.objectSelected;
    return _phonemeSelected;
}

- (void) setEditing:(BOOL)editing {
    [super setEditing:editing];
    [self updateHiddenViewWhenEditing:editing];
    
}

- (NSString *) key {
    return @"letters";
}

- (NSSet *) objectList {
    return self.phonemeSelected.graphems;
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//VC Lifecycle
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (void) viewDidLoad {
    [super viewDidLoad];
    
    //Microphone
    self.microphoneVC = [MIViewController instantiateInitialViewControllerWithMicrophoneDelegate:self];
    [self addChildViewController:self.microphoneVC];
    [self.microphoneVC didMoveToParentViewController:self];
    self.microphoneVC.view.frame = self.viewMicrophone.bounds;
    [self.viewMicrophone addSubview:self.microphoneVC.view];
    //[[self.imageViewMicrophone.subviews firstObject] becomeFirstResponder];
    
    self.textFieldAPI.delegate = self;

    
    
    /////////////////////////////////////////////////////////
    //load Grapheme List VC in container
    /////////////////////////////////////////////////////////
    self.objectListVC = [self addObjectListIdentifier:@"graphemeList" toView:self.viewContainerGraphemeList];

    /////////////////////////////////////////////////////////
    //load phoneme view
    /////////////////////////////////////////////////////////
    // Instantiate the nib content.
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"SPPhonemeView" owner:nil options:nil];
    
    // Find the view among nib contents (not too hard assuming there is only one view in it).
    self.viewPhoneme = [nibContents lastObject];
    self.viewPhoneme.phonemeSelected = self.phonemeSelected;
    self.viewPhoneme.frame = self.viewContainerPhonemeView.bounds;
    [self.viewContainerPhonemeView addSubview:self.viewPhoneme];
    
    self.textFieldAPI.text = self.phonemeSelected.api;
    self.dataSoundRecorded = self.phonemeSelected.audio;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Triggered VC
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
- (void) updateHiddenViewWhenEditing:(BOOL) editing {
    self.microphoneVC.editing = self.editing;

}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Microphone Delegate
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
- (void) microphonePlayerDidFinishRecording {
    self.phonemeSelected.audio = self.dataSoundRecorded;
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Text Field delegate
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (void) textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.textFieldAPI) {
        self.phonemeSelected.api = textField.text;
    }
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Overridding
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (void) buttonSaveAction {
    self.phonemeSelected.api = self.textFieldAPI.text;
    self.phonemeSelected.graphems = [self updatedRelationshipIn:self.objectListVC];
    [super buttonSaveAction];
}
@end
