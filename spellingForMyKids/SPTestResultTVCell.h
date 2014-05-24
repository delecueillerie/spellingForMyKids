//
//  SPTestResultTVCell.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 22/05/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPTestResultTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *labelStringInput;

@property (weak, nonatomic) IBOutlet UILabel *labelWord;
@property (weak, nonatomic) IBOutlet UILabel *labelPoints;






@end
