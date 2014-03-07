//
//  polaroidAnimatedView.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 21/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "polaroidView.h"

@interface polaroidAnimatedView : UIView <UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSArray *dataForPolaroid;

+ (id) polaroidAnimatedViewWithData:(NSArray *)data atIndex:(NSInteger)index inFrame:(CGRect) frame;

@end
