//
//  SPAKidTVC.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 10/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kid.h"

@interface SPAKidTVC : UITableViewController

@property (strong, nonatomic) Kid *kidSelected;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
