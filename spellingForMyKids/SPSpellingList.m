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




////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//OVERRIDE METHOD
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
- (NSString *) entityName {
    return @"Spelling";
}

- (NSString *) sortDescriptor {
    return @"name";
}

- (NSString *) storyboardVCId {
    return @"ASpelling";
}

- (NSString *) titleNavigationBar:(id) sender {
    return @"Spelling list";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)configureCell:(UITableViewCell *)tableViewCell withObject:(NSManagedObject *) object {
    [super configureCell:tableViewCell withObject:object];
    Spelling * spelling = (Spelling *) object;
    tableViewCell.textLabel.text = spelling.name;
    
    if ([self.delegate respondsToSelector:@selector(cellImageFor:)] && object) {
        tableViewCell.imageView.image = [self.delegate cellImageFor:object];
    }
    
    return tableViewCell;
}


/*//////////////////////////////////////////////////////////////////////
 ////////////////////////////////////////////////////////////////////////
 Delegate
 ////////////////////////////////////////////////////////////////////////
 //////////////////////////////////////////////////////////////////////*/


/*//////////////////////////////////////////////////////////////////////
 Objectlist delegate & datasource
 //////////////////////////////////////////////////////////////////////*/

- (datasource) datasource:(id)sender {
    return datasourceFetched;
}
@end
