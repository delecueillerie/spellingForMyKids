//
//  wordCell.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 06/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *wordName;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end
