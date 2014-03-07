//
//  SPKidsTVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 10/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPKidsTVC.h"
#import "WTViewController.h"
#import "SPAKidTVC.h"
#import "Kid.h"

@interface SPKidsTVC ()

@end

@implementation SPKidsTVC

// Customize the appearance of table view cells.
- (UITableViewCell *)configureCellFrom:(UITableView *)tableView withObject:(NSManagedObject *) object atIndexPath:(NSIndexPath *) indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [object valueForKey:@"name"];
    return cell;
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"kidSelected"]) {
        SPAKidTVC *destinationVC = segue.destinationViewController;
        destinationVC.kidSelected = (Kid *) self.objectSelected;
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

    Kid *newKid = [NSEntityDescription insertNewObjectForEntityForName:@"Kid" inManagedObjectContext:addingContext];

    SPAKidTVC *newKidVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AKid"];
    newKidVC.kidSelected = newKid;
    newKidVC.managedObjectContext = addingContext;
    //addViewController.delegate = self;
    [self.navigationController pushViewController:newKidVC animated:YES];
}

- (NSString *) entityName {
    return @"Kid";
}

- (NSString *) sortDescriptor {
    return @"name";
}

@end
