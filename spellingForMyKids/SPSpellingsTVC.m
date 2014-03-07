//
//  SPSpellingsTVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 11/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPSpellingsTVC.h"
#import "WTViewController.h"
#import "SPASpellingTVC.h"
#import "Spelling.h"

@interface SPSpellingsTVC ()

@end

@implementation SPSpellingsTVC

// Customize the appearance of table view cells.
- (UITableViewCell *)configureCellFrom:(UITableView *)tableView withObject:(NSManagedObject *) object atIndexPath:(NSIndexPath *) indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [object valueForKey:@"name"];
    return cell;
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"spellingSelected"]) {
        SPASpellingTVC *destinationVC = segue.destinationViewController;
        destinationVC.spellingSelected = (Spelling *) self.objectSelected;
        destinationVC.managedObjectContext = self.managedObjectContext;
    }
}


////////////////////////////////////////////////////////////////////////
//TRIGERRED ACTION
////////////////////////////////////////////////////////////////////////

- (void) addObject {
    /*  This block creates a new managed object context as a child of the root view controller's context. It then creates a new object using the child context. This means that changes made to the object remain discrete from the application's managed object context until the object's context is saved.
     The root view controller sets itself as the delegate of the add controller so that it can be informed when the user has completed the add operation -- either saving or canceling (see addViewController:didFinishWithSave:).
     IMPORTANT: It's not necessary to use a second context for this. You could just use the existing context, which would simplify some of the code -- you wouldn't need to perform two saves, for example. This implementation, though, illustrates a pattern that may sometimes be useful (where you want to maintain a separate set of edits).
     */
    // Create a new managed object context for the new object; set its parent to the fetched results controller's context.
    NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [addingContext setParentContext:self.managedObjectContext];

    Spelling *newSpelling = [NSEntityDescription insertNewObjectForEntityForName:@"Spelling" inManagedObjectContext:addingContext];

    SPASpellingTVC *newSpellingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ASpelling"];
    newSpellingVC.SpellingSelected = newSpelling;
    newSpellingVC.managedObjectContext = addingContext;
    //addViewController.delegate = self;
    [self.navigationController pushViewController:newSpellingVC animated:YES];
}

- (NSString *) entityName {
    return @"Spelling";
}

- (NSString *) sortDescriptor {
    return @"name";
}

@end
