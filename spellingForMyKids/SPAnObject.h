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
- (void) setObjectSelected:(NSManagedObject *) objectSelected;

typedef enum objectMode objectMode;
enum objectMode
{
    objectModeRead = 0,
    objectModeTest = 1,
};

- (objectMode) objectMode:(id) sender;


@optional

@end

@interface SPAnObject : UIViewController <objectDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObject *objectSelected;
//specific state of the object
@property (nonatomic) BOOL isNewObject; //should be deleted if canceled action
@property (nonatomic) BOOL isReadOnly; //no edit button displayed∫

@property (nonatomic, weak) id<objectDelegate> delegate;

- (void) saveAndRefresh;
- (void) saveAndPop;
- (void) save;
- (void) loadInput;
- (void) refresh;
- (NSManagedObject *) objectSelected;

@end
