//
//  SPWordTestList.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 30/09/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPWordTestList.h"
#import "WordTest.h"
#import "Word.h"

@interface SPWordTestList ()

@end

@implementation SPWordTestList


- (NSString *) entityName {
    return @"WordTest";
}

- (NSString *) sortDescriptor {
    return @"endedAt";
}

- (NSString *) storyboardVCId {
    return @"wordTest";
}

- (NSString *) titleNavigationBar :(id) sender {
    return @"Word test list";
}

-(NSString *) sectionNameKeyPath {
    return nil;
}

/*///////////////////////////////////////////////////////////////////////
 OVERRIDE METHOD
 ///////////////////////////////////////////////////////////////////////*/


// Customize the appearance of table view cells.
- (UITableViewCell *)configureCell:(UITableViewCell *)tableViewCell withObject:(NSManagedObject *) object {
    [super configureCell:tableViewCell withObject:object];
    WordTest * wordTest = (WordTest *) object;
    tableViewCell.textLabel.text = wordTest.word.name;
    tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%i - %@ - %@ -%@",[wordTest.result intValue],[wordTest.startedAt description],[wordTest.endedAt description], wordTest.input];
    return tableViewCell;
    
}



@end
