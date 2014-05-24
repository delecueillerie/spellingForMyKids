//
//  UIImageView+cornerRadius.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 12/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+resize.h"

@interface UIImageView (cornerRadius)
- (void)roundWithImage:(UIImage *) image;
- (void)rounThumbnaildWithImage:(UIImage *) image;

@end
