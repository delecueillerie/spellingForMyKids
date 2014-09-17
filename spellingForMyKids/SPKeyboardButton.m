//
//  SPKeyboardButton.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 15/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPKeyboardButton.h"
#import "config.h"

@implementation SPKeyboardButton

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.keyboardType = scrabble;
        [self addTarget:self action:@selector(otherKeyboard) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void) setKeyboardType:(NSString *)keyboardType {
    _keyboardType = keyboardType;
    if ([keyboardType isEqualToString:scrabble]) {
        [self setImage:[UIImage imageNamed:@"keyboardScrabble.png"] forState:UIControlStateNormal];
    } else {
        [self setImage:[UIImage imageNamed:@"keyboardStandard.png"] forState:UIControlStateNormal];
    }
}

- (void) otherKeyboard {
    if ([self.keyboardType isEqualToString:scrabble]) {
        self.keyboardType = keyboard;
    } else {
        self.keyboardType = scrabble;
    }
}

@end
