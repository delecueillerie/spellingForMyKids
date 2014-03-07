//
//  SPEditTBC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 06/03/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPEditTBC.h"

@interface SPEditTBC ()

@end

@implementation SPEditTBC


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;

    UIBarButtonItem *home = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBackToTheInitialVC)];
    [self.navigationItem setLeftBarButtonItem:home];
	// Do any additional setup after loading the view.
}

- (void) goBackToTheInitialVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
