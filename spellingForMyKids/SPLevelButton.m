//
//  SPLevelButton.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 15/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPLevelButton.h"

@implementation SPLevelButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
 
        self.level = 2;
        [self addTarget:self action:@selector(nextLevel) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

- (void) nextLevel {
    if (self.level <3) {
        self.level =self.level +1;
    } else self.level = 1;
}

- (void) setLevel:(NSUInteger)level {
    _level = level;
    [self setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level%lu",(unsigned long)self.level]] forState:UIControlStateNormal];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
@end