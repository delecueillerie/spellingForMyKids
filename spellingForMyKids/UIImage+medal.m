//
//  UIImage+medal.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 02/10/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "UIImage+medal.h"

@implementation UIImage (medal)


+(UIImage *) medalFor:(spellingTestMedal)spellingTestMedal {
    UIImage *medal;
    switch (spellingTestMedal) {
        case spellingTestMedalEmpty:
            medal = [UIImage imageNamed:@"medal_nil"];
            break;
        
        case spellingTestMedalBronze:
            medal = [UIImage imageNamed:@"medal_bronze"];
            break;
        
        case spellingTestMedalSilver:
            medal = [UIImage imageNamed:@"medal_silver"];
            break;
        
        case spellingTestMedalGold:
            medal = [UIImage imageNamed:@"medal_gold"];
            break;
        
        default:
            medal =nil;
            break;
    }
    return medal;
}

@end
