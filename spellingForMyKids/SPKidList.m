//
//
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 10/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPKidList.h"
#import "Kid.h"
//Category
#import "UIImageView+cornerRadius.h"
@interface SPKidList ()

@end

@implementation SPKidList

////////////////////////////////////////////////////////////////////////
//ACCESSOR
////////////////////////////////////////////////////////////////////////

- (NSString *) entityName {
    return @"Kid";
}

- (NSString *) sortDescriptor {
    return @"name";
}

- (NSString *) storyboardVCId {
    return @"AKid";
}

- (NSString *) titleNavigationBar {
    return @"Kids list";
}

////////////////////////////////////////////////////////////////////////
//OVERRIDE METHOD
////////////////////////////////////////////////////////////////////////

// Customize the appearance of table view cells.
- (UITableViewCell *)configureCell:(UITableViewCell *)tableViewCell withObject:(NSManagedObject *) object {
    [self configureCell:tableViewCell];
    Kid * kid = (Kid *) object;
    tableViewCell.textLabel.text = kid.name;
    [tableViewCell.imageView rounThumbnaildWithImage:[UIImage imageWithData:kid.image]];
    return tableViewCell;

}

@end
