//
//  SPASpellingTVC.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 11/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Spelling.h"

@interface SPASpellingTVC : UITableViewController

@property (strong, nonatomic) Spelling *spellingSelected;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
