//
//  SPSpellingTestList.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 03/09/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPSpellingTestList.h"
#import "SpellingTest+enhanced.h"
#import "Spelling.h"

@interface SPSpellingTestList ()

@end

@implementation SPSpellingTestList




- (NSString *) entityName {
    return @"SpellingTest";
}

- (NSString *) sortDescriptor {
    return @"endedAt";
}

- (NSString *) storyboardVCId {
    return @"spellingTest";
}

- (NSString *) titleNavigationBar :(id) sender {
    return @"Spelling test list";
}

-(NSString *) sectionNameKeyPath {
    return @"dayAt";
}

-(BOOL) sortDescriptorAscending {
    return NO;
}
/*///////////////////////////////////////////////////////////////////////
 OVERRIDE METHOD
///////////////////////////////////////////////////////////////////////*/


// Customize the appearance of table view cells.
- (UITableViewCell *)configureCell:(UITableViewCell *)tableViewCell withObject:(NSManagedObject *) object {
    [super configureCell:tableViewCell withObject:object];
    SpellingTest * spellingTest = (SpellingTest *) object;
    tableViewCell.textLabel.text = spellingTest.spelling.name;
    tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",[spellingTest getSpellingTestResult], [spellingTest getSpellingTestLevel]];
    return tableViewCell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id object = [[[[self.fetchedResultsController sections] objectAtIndex:section] objects] firstObject];
    if ([object isKindOfClass:[SpellingTest class]]) {
        SpellingTest *test = (SpellingTest *)object;
        NSDate *date = test.endedAt;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        //[dateFormatter setDateFormat:@"yyyy-MM-dd"];
        return [dateFormatter stringFromDate:date];
    } else {
        return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
    }
}

@end
