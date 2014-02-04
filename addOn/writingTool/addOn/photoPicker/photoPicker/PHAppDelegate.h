//
//  PHAppDelegate.h
//  photoPicker
//
//  Created by Olivier Delecueillerie on 07/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHCameraVC.h"

@interface PHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PHCameraVC *viewController;

@end
