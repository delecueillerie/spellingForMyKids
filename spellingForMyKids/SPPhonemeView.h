//
//  SPPhonemeView.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 30/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Phoneme.h"
#import "Grapheme.h"

@interface SPPhonemeView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) Phoneme *phonemeSelected;

@end
