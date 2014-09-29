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
 Object delegate
 //////////////////////////////////////////////////////////////////////*/
/*- (objectState) objectState:(id)sender {
    if (self.tabBarController) {
        return objectStateRead;
    } else {
        return objectStateTest;
    }
}
*/

- (NSString *) titleNavigationBar:(id) sender {
    return @"Spelling List";
}
/*//////////////////////////////////////////////////////////////////////
 Objectlist delegate & datasource
 //////////////////////////////////////////////////////////////////////*/

- (datasource) datasource:(id)sender {
    return datasourceFetched;
}
@end
