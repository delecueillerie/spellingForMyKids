//
//  EDEntitiesTVC.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 27/01/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDEntitiesTVC : UITableViewController

@property (nonatomic, strong) NSDictionary *entitiesDictionary;
//this NSManagedObjectContext instance is not used in this view but will be used in the next one, thus this property will be fetched here
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end
