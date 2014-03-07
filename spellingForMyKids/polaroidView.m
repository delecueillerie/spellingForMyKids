//
//  polaroidView.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 20/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "polaroidView.h"


@interface polaroidView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation polaroidView




+ (id)polaroidViewImage:(UIImage *)image label:(NSString *) label inFrame:(CGRect) frame
{
    polaroidView *polaView = [[[NSBundle mainBundle] loadNibNamed:@"polaroidView" owner:nil options:nil] lastObject];

    // make sure customView is not nil or the wrong class!
    if ([polaView isKindOfClass:[polaroidView class]]) {
        polaView.imageView.image = image;
        polaView.label.text = label;
        polaView.frame = frame;
        return polaView;
    }
    else
        return nil;
}


@end
