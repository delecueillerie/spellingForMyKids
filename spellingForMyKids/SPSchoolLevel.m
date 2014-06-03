//
//  SPSchoolLevel.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 27/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPSchoolLevel.h"

@implementation SPSchoolLevel


+ (NSArray *) arrayOfSchoolLevel {
    
    NSDictionary *level1 = @{@"level": [NSNumber numberWithInt:1], @"name":@"CP"};
    NSDictionary *level2 = @{@"level": [NSNumber numberWithInt:2], @"name":@"CE1"};
    NSDictionary *level3 = @{@"level": [NSNumber numberWithInt:3], @"name":@"CE2"};
    NSDictionary *level4 = @{@"level": [NSNumber numberWithInt:4], @"name":@"CM1"};
    NSDictionary *level5 = @{@"level": [NSNumber numberWithInt:5], @"name":@"CM2"};

    
    return @[level1, level2, level3, level4, level5];
    
    
}

+ (NSDictionary *) schoolLevelForNumber:(NSNumber *)number {
    

    for (NSDictionary *dic in [SPSchoolLevel arrayOfSchoolLevel]) {
        if ([[dic valueForKey:@"level"] isEqualToNumber:number]) {
            return dic;
        }
    }
    return nil;
}

@end