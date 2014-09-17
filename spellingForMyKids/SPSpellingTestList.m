//
//  SPSpellingTestList.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 03/09/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPSpellingTestList.h"
#import "SpellingTest.h"
#import "Spelling.h"

@interface SPSpellingTestList ()

@end

@implementation SPSpellingTestList




- (NSString *) entityName {
    return @"SpellingTest";
}

- (NSString *) sortDescriptor {
    return @"points";
}

- (NSString *) storyboardVCId {
    return @"spellingTest";
}

- (NSString *) titleNavigationBar :(id) sender {
    return @"Spelling test list";
}

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//OVERRIDE METHOD
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////


// Customize the appearance of table view cells.
- (UITableViewCell *)configureCell:(UITableViewCell *)tableViewCell withObject:(NSManagedObject *) object {
    [self configureCell:tableViewCell];
    SpellingTest * spellingTest = (SpellingTest *) object;
    tableViewCell.textLabel.text = spellingTest.spelling.name;
    return tableViewCell;
    
}






@end
