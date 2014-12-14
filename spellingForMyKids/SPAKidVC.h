//
//  SPAKidVC.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 10/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPAnObject.h"
#import "photoPicker.h"

@interface SPAKidVC : SPAnObject <UITextFieldDelegate, photoPickerDelegate>
@property (nonatomic, strong) NSData * dataImageCaptured;
@end
