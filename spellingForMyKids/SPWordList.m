//
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 06/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPWordList.h"
#import "Word.h"
#import "SPSpellingTest.h"

//Categroy
#import "UIImageView+cornerRadius.h"

@interface SPWordList ()

@end

@implementation SPWordList

- (NSString *) entityName {
    return @"Word";
}

- (NSString *) sortDescriptor {
    return @"name";
}

- (NSString *) storyboardVCId {
    return @"AWord";
}

- (NSString *) titleNavigationBar:(id) sender {
    return @"Words list";
}


////////////////////////////////////////////////////////////////////////
//OVERRIDE METHOD
////////////////////////////////////////////////////////////////////////

// Customize the appearance of table view cells.
- (UITableViewCell *)configureCell:(UITableViewCell *)tableViewCell withObject:(NSManagedObject *) object {
    [super configureCell:tableViewCell withObject:object];
    Word * word = (Word *) object;
    tableViewCell.textLabel.text = word.name;
    [tableViewCell.imageView rounThumbnaildWithImage:[UIImage imageWithData:word.image]];
    return tableViewCell;
}

- (objectState) objectState:(id)sender {
    if ([self.parentViewController isKindOfClass:[SPSpellingTest class]]) {
        return objectStateReadOnly;
    } else {
        return [super objectState:sender];
    }
}
@end
