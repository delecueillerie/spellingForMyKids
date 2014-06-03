//
//  segueFromMenuToTabBar.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 27/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "segueFromMenuToTabBar.h"

@implementation segueFromMenuToTabBar


- (void)perform
{
    // Add your own animation code here.
    
    [[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:NO];
}
@end
