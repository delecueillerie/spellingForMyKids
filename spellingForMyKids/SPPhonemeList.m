//
//  SPPhonemeList.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 27/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPPhonemeList.h"

@interface SPPhonemeList ()

@end

@implementation SPPhonemeList

- (NSString *) entityName {
    return @"Phoneme";
}

- (NSString *) sortDescriptor {
    return @"api";
}

- (NSString *) storyboardVCId {
    return @"APhoneme";
}

- (NSString *) titleNavigationBar {
    return @"Phoneme list";
}



- (UITableViewCell *)configureCell:(UITableViewCell *)tableViewCell withObject:(NSManagedObject *) object {
    tableViewCell.textLabel.text = [object valueForKey:@"api"];
    NSLog(@"table view Cell %@", tableViewCell.textLabel.text);
    [self configureCell:tableViewCell];
    return tableViewCell;
    
}

@end
