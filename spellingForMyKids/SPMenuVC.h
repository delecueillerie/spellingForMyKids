//
//  SPMenuVC.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 23/01/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPAnObjectWithList.h"

@interface SPMenuVC : SPAnObjectWithList <UIScrollViewDelegate>

@property BOOL refreshData;
@end
