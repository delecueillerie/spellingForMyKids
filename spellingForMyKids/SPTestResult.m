//
//  SPTestResult.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 06/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPTestResult.h"
#import "SPTestResultTVCell.h"
#import "SKDictWordResult.h"

//#import "Word.h"

@interface SPTestResult ()

@end

@implementation SPTestResult


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Navigation bar
    self.navigationItem.title = @"Résultat";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(performSegue)];
    self.navigationItem.hidesBackButton = YES;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//Table View
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////
#pragma mark - Table view data source
/////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    
    // Return the number of rows in the section.
    return [self.gameResult count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPTestResultTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *dictionaryWordResult = [self.gameResult objectAtIndex:indexPath.row];
    
    // Configure the cell...
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[dictionaryWordResult valueForKey:stringInputKey]];
    cell.labelPoints.text = [[dictionaryWordResult valueForKey:pointsKey] stringValue];
    
    if ([[dictionaryWordResult objectForKey:passKey] boolValue]) {
        cell.imageViewThumbnail.image = [UIImage imageNamed:@"iconsResultGood.png"];
        cell.labelWord.hidden = YES;
        
    } else {
        cell.imageViewThumbnail.image = [UIImage imageNamed:@"iconsResultWrong.png"];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        cell.labelWord.hidden = NO;
        cell.labelWord.text = [dictionaryWordResult valueForKey:wordAskedKey];
    }
    
    cell.labelStringInput.attributedText = attributeString;
    
    return cell;
}


/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//Segue
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"menu"]) {
        
    }
}

- (void) performSegue {
    [self performSegueWithIdentifier:@"menu" sender:self];
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
