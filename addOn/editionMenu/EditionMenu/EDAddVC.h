//
//  EDAddVC.h
//  EditionMenu
//
//  Created by Olivier Delecueillerie on 05/11/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "EDDetailVC.h"

@protocol AddViewControllerDelegate;

@interface EDAddVC : EDDetailVC

@property (nonatomic, weak) id <AddViewControllerDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end


@protocol AddViewControllerDelegate
- (void)addViewController:(EDAddVC *)controller didFinishWithSave:(BOOL)save;
@end