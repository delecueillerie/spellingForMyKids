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
//#import "Grapheme.h"

@interface SPPhoneme ()


//UI Outlet

@property (weak, nonatomic) IBOutlet SPPhonemeView *viewContainerPhonemeView;

@property (strong, nonatomic)  SPPhonemeView *viewPhoneme;


@property (strong, nonatomic) MIViewController *microphoneVC;
@property (strong, nonatomic) Phoneme *phonemeSelected;


@end

@implementation SPPhoneme

@synthesize objectList = _objectList;

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
/*
- (NSSet *) objectList {
    return self.phonemeSelected.graphems;
}
*/
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//VC Lifecycle
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

- (void) viewDidLoad {
    [super viewDidLoad];
    self.editing = NO;
    
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
    
    self.viewPhoneme.labelAPI.text = self.phonemeSelected.api;
    self.dataSoundRecorded = self.phonemeSelected.audio;
    
    
    //Microphone
    self.microphoneVC = [MIViewController instantiateInitialViewControllerWithMicrophoneDelegate:self];
    [self addChildViewController:self.microphoneVC];
    [self.microphoneVC didMoveToParentViewController:self];
    self.microphoneVC.view.frame = self.viewPhoneme.labelAPI.bounds;
    [self.viewPhoneme.labelAPI addSubview:self.microphoneVC.view];
    //[[self.imageViewMicrophone.subviews firstObject] becomeFirstResponder];
    
    
    
    /////////////////////////////////////////////////////////
    //load Grapheme List VC in container
    /////////////////////////////////////////////////////////
    //self.objectListVC = [self addObjectListIdentifier:@"graphemeList" toView:self.viewContainerGraphemeList];

    
    
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
/*- (void) microphonePlayerDidFinishRecording {
    self.phonemeSelected.audio = self.dataSoundRecorded;
}*/

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Overridding
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////


@end
