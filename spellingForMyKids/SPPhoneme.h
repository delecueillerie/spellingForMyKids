//
//  SPPhoneme.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 27/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPAnObjectWithList.h"
#import "MIViewController.h"
#import "SPObjectList.h"

@interface SPPhoneme : SPAnObjectWithList <UITextFieldDelegate, microphonePlayerDelegate>


//microphoneDelegate
@property (nonatomic, strong) NSData *dataSoundRecorded;
- (void) microphonePlayerDidFinishRecording;


@end
