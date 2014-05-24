//
//  SPSpellingsList.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 11/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPSpellingList.h"
#import "Spelling.h"

@interface SPSpellingList ()

@end

@implementation SPSpellingList


- (NSString *) entityName {
    return @"Spelling";
}

- (NSString *) sortDescriptor {
    return @"name";
}

- (NSString *) storyboardVCId {
    return @"ASpelling";
}

- (NSString *) titleNavigationBar {
    return @"Spelling list";
}

////////////////////////////////////////////////////////////////////////
//OVERRIDE METHOD
////////////////////////////////////////////////////////////////////////

// Customize the appearance of table view cells.
- (UITableViewCell *)configureCell:(UITableViewCell *)tableViewCell withObject:(NSManagedObject *) object {
    [self configureCell:tableViewCell];
    Spelling * spelling = (Spelling *) object;
    tableViewCell.textLabel.text = spelling.name;
    return tableViewCell;
    
}

@end
