//
//  EDEntitiesTVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 27/01/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "EDEntitiesTVC.h"
#import "DBCoreDataStack.h"
#import "EDRootVC.h"

@interface EDEntitiesTVC ()

@property (nonatomic, strong) NSDictionary *entitySelectedDictionary;
@end

@implementation EDEntitiesTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.entitiesDictionary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    for (NSDictionary *entityDictionary in [self.entitiesDictionary allValues]) {
            if ([entityDictionary valueForKey:@"rank"] == [NSNumber numberWithInt:indexPath.row ]) {
                cell.textLabel.text =[entityDictionary valueForKey:@"label"];
                cell.detailTextLabel.text = [entityDictionary valueForKey:@"detail"];
            }
    }

    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (NSDictionary *entityDictionary in [self.entitiesDictionary allValues]) {
        if ([entityDictionary valueForKey:@"rank"] == [NSNumber numberWithInt:indexPath.row ]) {
                self.entitySelectedDictionary = entityDictionary;
            }
    }
    return indexPath;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EDRootVC *destinationVC = (EDRootVC *)[segue destinationViewController];
    destinationVC.entityDictionary = self.entitySelectedDictionary;
    destinationVC.managedObjectContext=self.managedObjectContext;
}






@end
