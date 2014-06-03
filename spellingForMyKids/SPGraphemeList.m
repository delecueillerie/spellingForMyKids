//
//  SPGraphemeList.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 30/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPGraphemeList.h"
#import "Grapheme.h"

@interface SPGraphemeList ()

@end

@implementation SPGraphemeList


- (NSString *) entityName {
    return @"Grapheme";
}

- (NSString *) sortDescriptor {
    return @"letters";
}

- (NSString *) storyboardVCId {
    return @"AGrapheme";
}

- (NSString *) titleNavigationBar {
    return @"Grapheme list";
}


- (UITableViewCell *)configureCell:(UITableViewCell *)tableViewCell withObject:(NSManagedObject *) object {
    tableViewCell.textLabel.text = [object valueForKey:@"letters"];
    NSLog(@"table view Cell %@", tableViewCell.textLabel.text);
    [self configureCell:tableViewCell];
    return tableViewCell;
    
}
@end
