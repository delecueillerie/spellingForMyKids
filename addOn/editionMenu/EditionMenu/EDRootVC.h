//
//  EDRootVC.h
//  EditionMenu
//
//  Created by Olivier Delecueillerie on 05/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EDAddVC.h"

@interface EDRootVC : UITableViewController <NSFetchedResultsControllerDelegate, AddViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *entityDictionary;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
