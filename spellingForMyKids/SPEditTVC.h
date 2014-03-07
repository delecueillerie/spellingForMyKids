//
//  SPEditTVC.h
//  EditionMenu
//
//  Created by Olivier Delecueillerie on 05/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EDAddVC.h"

@interface SPEditTVC : UITableViewController <NSFetchedResultsControllerDelegate, AddViewControllerDelegate, UITableViewDelegate>

@property (nonatomic, strong) NSManagedObject *objectSelected;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
