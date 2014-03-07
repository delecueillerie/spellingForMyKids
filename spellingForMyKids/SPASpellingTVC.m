//
//  SPASpellingTVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 11/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPASpellingTVC.h"
#import "WTViewController.h"
#import "Word.h"
//Table View Cell class
#import "SPSpellingSection1.h"

@interface SPASpellingTVC ()


@end

@implementation SPASpellingTVC


-(void) viewWillAppear:(BOOL)animated {
    [self updateUI];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRow =0;
    if (section ==0) {
        numberOfRow = 2;
    } else if (section == 1) {
        if ([self.spellingSelected.words count]>0) {
            numberOfRow = [self.spellingSelected.words count];
        } else {
            numberOfRow = 1;
        }
            }
    return numberOfRow;
}

//Manage the title of the sections
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    switch (section) {

        case 0:
            title = @"Description of the spelling";
            break;

        case 1:
            title = @"Words listing";
            break;

        default:
            break;
    }

    return title;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    switch (section) {
        case 1:
        {
            // create the parent view that will hold header Label
            UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 44.0)];
            customView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
            // create the button object
            [customView addSubview:[self buttonAddWithSelector:@selector(ActionEventForButton:)]];
            return customView;


        }
            break;

        default:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
            label.text = [self tableView : self.tableView titleForHeaderInSection:section];
            return label;
        }
            break;
    }
}

- (void) ActionEventForButton:(id) sender {
    NSLog(@"hello");
}




- (UIButton *) buttonAddWithSelector:(SEL) selector {
    UIButton *buttonAdd = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonAdd.opaque = NO;
    buttonAdd.frame = CGRectMake(10.0, 0.0, 100.0, 30.0);
    buttonAdd.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    //buttonAdd.backgroundColor = [UIColor clearColor];

    [buttonAdd setTitle:@"Add" forState:UIControlStateNormal];
    [buttonAdd addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];

    return buttonAdd;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifierSection1 = @"section1";
    static NSString *cellIdentifierSection2 = @"section2";

    SPSpellingSection1 *cellSection1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifierSection1];
    UITableViewCell *cellSection2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifierSection2];
    UITableViewCell *returnedCell;
    switch (indexPath.section) {

        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cellSection1.spellingLabel.text = @"Name";
                    cellSection1.spellingValue.text = self.spellingSelected.name;
                    returnedCell = cellSection1;
                }
                break;

                case 1:
                {
                    cellSection1.spellingLabel.text = @"Explanation";
                    cellSection1.spellingValue.text = self.spellingSelected.explication;
                    returnedCell = cellSection1;
                }
                break;

                default:
                break;
            }
        }
        break;

        case 1:
        {
            if ([self.spellingSelected.words count]>0) {
                NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                Word *includedWord = [[self.spellingSelected.words sortedArrayUsingDescriptors:@[sortByName]] objectAtIndex:indexPath.row];
                cellSection2.textLabel.text = includedWord.name;
                returnedCell = cellSection2;
            } else {
                cellSection2.textLabel.text = @"Choose words for this spelling";
                returnedCell = cellSection2;
            }
        }
        break;
    }
    return returnedCell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UIStoryboard *editingStoryboard = [UIStoryboard storyboardWithName:@"writingTool" bundle:nil];
    WTViewController *writingToolVC = [editingStoryboard instantiateInitialViewController];

    switch (indexPath.section) {
        case 0:
        /*This is the first section. This section contains the name and the explanation of the speeling*/
        {
            switch (indexPath.row) {
                case 0:
                {
                    writingToolVC.fieldLabel = @"Title";
                    writingToolVC.selectedProperty  = [[[self.spellingSelected entity] attributesByName] valueForKey:@"name"];
                    break;
                }

                case 1:
                {
                    writingToolVC.fieldLabel = @"Explanation";
                    writingToolVC.selectedProperty  = [[[self.spellingSelected entity] attributesByName] valueForKey:@"explication"];
                    break;
                }

                default:
                    break;
            }
        break;
        }
        case 1:
        //this section contains the list of words of the spelling
        {
            if ([self.spellingSelected.words count]>0) {
                writingToolVC.fieldLabel = @"Words list";
                writingToolVC.selectedProperty  = [[[self.spellingSelected entity] relationshipsByName] valueForKey:@"words"];
                break;

            } else {
                writingToolVC.fieldLabel = @"Words list";
                writingToolVC.selectedProperty  = [[[self.spellingSelected entity] relationshipsByName] valueForKey:@"words"];
                break;
            }
        break;
        }
    }


    writingToolVC.editedObject = self.spellingSelected;
    writingToolVC.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:writingToolVC animated:YES];
}

- (void) updateUI {
    [self.tableView reloadData];
}


@end
