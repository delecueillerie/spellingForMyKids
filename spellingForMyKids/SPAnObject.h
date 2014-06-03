//
//  SPAnObject.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 12/03/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SPAnObject : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *objectSelected;
@property (nonatomic) BOOL newObject;

- (void) buttonSaveAction;


@end
