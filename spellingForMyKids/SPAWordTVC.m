//
//  SPAWordTVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 07/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPAWordTVC.h"
#import "WTViewController.h"

@interface SPAWordTVC ()
@property (weak, nonatomic) IBOutlet UIImageView *soundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;

@end

@implementation SPAWordTVC

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
            fieldLabel = @"Title";
            attributesByNameKey = @"name";
        }
            break;
        case 1:
        {
            fieldLabel = @"Sound";
            attributesByNameKey = @"audio";

        }
            break;

        case 2:
        {
            fieldLabel = @"Image";
            attributesByNameKey = @"image";
        }
        default:
            break;
    }
    writingToolVC.fieldLabel = fieldLabel;
    writingToolVC.selectedProperty = [[[self.wordSelected entity] attributesByName] valueForKey:attributesByNameKey];
    writingToolVC.editedObject = self.wordSelected;
    writingToolVC.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:writingToolVC animated:YES];
}

- (void) updateUI {
    self.wordLabel.text = self.wordSelected.name;
    if (self.wordSelected.audio) {
        self.soundImageView.image = [UIImage imageNamed:@"oscillation.png"];
    } else self.soundImageView.image = nil;

    self.imageImageView.image = [UIImage imageWithData:self.wordSelected.image];
}


@end
