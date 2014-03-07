//
//  SPAWordTVC.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 07/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"

@interface SPAWordTVC : UITableViewController

@property (strong, nonatomic) Word *wordSelected;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
