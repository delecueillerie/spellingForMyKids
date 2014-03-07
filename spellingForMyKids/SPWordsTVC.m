//
//  wordsVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 06/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPWordsTVC.h"
#import "wordCell.h"
#import "SPAWordTVC.h"

@interface SPWordsTVC ()

@end

@implementation SPWordsTVC

// Customize the appearance of table view cells.
- (UITableViewCell *)configureCellFrom:(UITableView *)tableView withObject:(NSManagedObject *) object atIndexPath:(NSIndexPath *) indexPath {
    static NSString *CellIdentifier = @"Cell";
    wordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.wordName.text = [object valueForKey:@"name"];
    return cell;
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"wordSelected"]) {

        SPAWordTVC *destinationVC = segue.destinationViewController;
        destinationVC.wordSelected = (Word *) self.objectSelected;
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

    Word *newWord = [NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:addingContext];

    SPAWordTVC *newWordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AWord"];
    newWordVC.wordSelected = newWord;
    newWordVC.managedObjectContext = addingContext;
    //addViewController.delegate = self;

    [self.navigationController pushViewController:newWordVC animated:YES];

}

- (NSString *) entityName {
    return @"Word";
}

- (NSString *) sortDescriptor {
    return @"name";
}
@end
