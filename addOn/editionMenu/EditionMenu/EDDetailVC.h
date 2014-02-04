//
//  EDDetailVC.h
//  EditionMenu
//
//  Created by Olivier Delecueillerie on 05/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//


@interface EDDetailVC : UITableViewController

//the object that is detailled (attributes listed) in the table view
@property (nonatomic, strong) NSManagedObject *object;
@property (nonatomic, strong) NSDictionary *entityDictionary;

@end


// These methods are used by the AddViewController, so are declared here, but they are private to these classes.

@interface EDDetailVC (Private)

- (void)setUpUndoManager;
- (void)cleanUpUndoManager;
@end
