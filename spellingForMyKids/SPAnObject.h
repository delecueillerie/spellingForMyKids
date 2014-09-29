//
//  SPAnObject.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 12/03/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol objectDelegate <NSObject>

- (void) saveAndRefresh;
- (void) saveAndPop;
- (void) loadInput;
- (void) refresh;
- (void) setObjectSelected:(id) objectSelected;

@optional

typedef enum objectState
{
    objectStateRead = 0,
    objectStateTest = 1,
    objectStateEdit = 2,
    objectStateReadOnly = 3,
} objectState;

- (objectState) objectState:(id)sender;
@end

@interface SPAnObject : UIViewController <objectDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContextAdd;
@property (nonatomic, strong) id objectSelected;

@property (nonatomic, weak) id<objectDelegate> delegate;

- (void) saveAndRefresh;
- (void) saveAndPop;
- (void) save;
- (void) loadInput;
- (void) refresh;

@end
