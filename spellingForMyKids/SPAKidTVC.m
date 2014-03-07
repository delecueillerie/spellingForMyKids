//
//  SPAKidTVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 10/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPAKidTVC.h"
#import "WTViewController.h"

@interface SPAKidTVC ()
@property (weak, nonatomic) IBOutlet UILabel *kidNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *kidImage;

@end

@implementation SPAKidTVC


-(void) viewWillAppear:(BOOL)animated {
    [self updateUI];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UIStoryboard *editingStoryboard = [UIStoryboard storyboardWithName:@"writingTool_iPhone" bundle:nil];
    WTViewController *writingToolVC = [editingStoryboard instantiateInitialViewController];

    NSString *fieldLabel;
    NSString *attributesByNameKey;
    switch (indexPath.row) {
        case 0:
        {
            fieldLabel = @"Name";
            attributesByNameKey = @"name";
        }
            break;
        case 1:
        {
            fieldLabel = @"Picture";
            attributesByNameKey = @"image";

        }
            break;

        default:
            break;
    }
    writingToolVC.fieldLabel = fieldLabel;
    writingToolVC.selectedProperty= [[[self.kidSelected entity] attributesByName] valueForKey:attributesByNameKey];
    writingToolVC.editedObject = self.kidSelected;
    writingToolVC.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:writingToolVC animated:YES];
}

- (void) updateUI {
    self.kidNameLabel.text = self.kidSelected.name;
    self.kidImage.image = [UIImage imageWithData:self.kidSelected.image];
}


@end
