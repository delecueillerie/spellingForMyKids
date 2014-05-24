//
//  UIImageView+cornerRadius.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 12/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "UIImageView+cornerRadius.h"
#import "UIImage+resize.h"

@implementation UIImageView (cornerRadius)


- (void)roundWithImage:(UIImage *) image {
    //resize image to small square
    CGFloat lenght;
    if (self.bounds.size.width > self.bounds.size.height) lenght=self.bounds.size.height;
        else lenght = self.bounds.size.width;
    UIImage *thumbnail = [image squareImageScaledToSize: CGSizeMake(lenght,lenght)];
    
    self.image = thumbnail;
    //create the circle with radius
    self.layer.cornerRadius = (lenght/2);
    self.clipsToBounds = YES;
}

- (void)rounThumbnaildWithImage:(UIImage *) image {
    //resize image to small square
    CGFloat lenght = 40.0;
    UIImage *thumbnail = [image squareImageScaledToSize: CGSizeMake(lenght,lenght)];
    
    self.image = thumbnail;
    //create the circle with radius
    self.layer.cornerRadius = (lenght/2);
    self.clipsToBounds = YES;
}

@end
