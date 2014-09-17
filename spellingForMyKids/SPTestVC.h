//
//  SPTestVC.h
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 16/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Kid.h"
#import "Spelling.h"
#import "SKGameController.h"



@interface SPTestVC : UIViewController <AVAudioPlayerDelegate, UIGestureRecognizerDelegate, gameDelegate, gameDatasource>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Kid *kidSelected;
@property (strong, nonatomic) Spelling *spellingSelected;


@property (nonatomic) NSUInteger level;
@property (nonatomic, strong) NSString *keyboardType;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//gameProtocolDelegate
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (NSString *) nextWord;
- (NSUInteger) timeToSolve;
- (NSUInteger) maxWordLength;
- (void) scoreBoardWithGameResult:(NSArray *)gameResult;
- (void)starDust;

@end
