//
//  SPSchoolLevel.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 27/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPSchoolLevel : NSObject

+ (NSArray *) arrayOfSchoolLevel;

+ (NSDictionary *) schoolLevelForNumber:(NSNumber *)number;
@end
