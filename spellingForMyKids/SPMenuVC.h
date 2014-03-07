//
//  SPMenuVC.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 23/01/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPMenuVC : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>


@property (nonatomic, strong) NSString *inputWord;

@end
