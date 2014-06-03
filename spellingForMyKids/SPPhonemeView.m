//
//  SPPhonemeView.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 30/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPPhonemeView.h"
#import "Word.h"

@interface SPPhonemeView ()

@property (weak, nonatomic) IBOutlet UITableView *TVWord;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *labelAPI;

@end


@implementation SPPhonemeView

    

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}



- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
    {

    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
//TV datasource & delegate
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[[[self.phonemeSelected.graphems allObjects]
              objectAtIndex:section]
             words]
            count];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.phonemeSelected.graphems count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Grapheme * grapheme = [[self.phonemeSelected.graphems allObjects] objectAtIndex:indexPath.section];
    cell.textLabel.text = [[[grapheme.words allObjects] objectAtIndex:indexPath.row] valueForKey:@"name"];
    return cell;
    
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //NSLog(@"objecAtIndex %@", [[[self.phonemeSelected.graphems allObjects] objectAtIndex:section] description]);
    return [[[self.phonemeSelected.graphems allObjects] objectAtIndex:section] letters];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
