//
//  SPTestVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 16/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPTestVC.h"
#import "Word.h"
#import "SPTestResult.h"
#import "config.h"

//ScrabbleKeyboard Module
#import "config.h"
#import "SKHUDView.h"
#import "SKWordsData.h"

//Category
#import "UIImageView+cornerRadius.h"

//View
#import "SKStarDustView.h"



#define scrabble @"scrabble"


@interface SPTestVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *viewBoard;
@property (weak, nonatomic) IBOutlet UIView *viewStopwatch;
@property (weak, nonatomic) IBOutlet SKHUDView *viewHud;
@property (weak, nonatomic) IBOutlet SKCounterLabelView *viewCounter;

@property (strong, nonatomic) Word *wordSelected;
@property (strong, nonatomic) NSArray *arrayWords;
@property (strong, nonatomic) AVAudioPlayer *player;

//scrabbleKeyboard
@property (strong, nonatomic) SKGameController* gameController;
//@property (strong, nonatomic) SKBoardController *boardController;
@property (strong, nonatomic) SKWordsData *spelling;

@end

@implementation SPTestVC


- (NSArray *) arrayWords {
    if (!_arrayWords) _arrayWords = [self.spellingSelected.words allObjects];
    return _arrayWords;
}

- (SKWordsData *) spelling {
    if (!_spelling) {
        _spelling = [[SKWordsData alloc] init];
        _spelling.pointsPerTile = 20;
        _spelling.timeToSolve = 10;
        NSMutableArray *arrayOfWordName = [[NSMutableArray alloc] init];
        for (Word *word in self.arrayWords) {
            [arrayOfWordName addObject:word.name];
        }
        _spelling.words = arrayOfWordName;
    }
    return _spelling;
}

- (SKGameController *) gameController {
    if (!_gameController) {
        //create the game controller
        
        _gameController = [[SKGameController alloc] init];
        _gameController.delegate = self;
        _gameController.datasource = self;
        _gameController.spelling = self.spelling;
        _gameController.hud = self.viewHud;
    }
    return _gameController;
}

- (NSUInteger) level {
    if (!_level) _level = 1;
    return _level;
}
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
//VC LIFECYCLE
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////


- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.hidesBackButton = YES;
    [self.gameController newQuestion];

}



- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear");
    [self updatePage];
    [self.view layoutSubviews];
    
}


/*
- (void) keyboardWillShow:(NSNotification *) notification {
    NSDictionary* userInfo = [notification userInfo];
    CGRect keyboardFrameInWindowsCoordinates;
    [[userInfo objectForKey:UIKeyboardDidShowNotification] getValue:&keyboardFrameInWindowsCoordinates];
    CGRect keyboardFrameInViewCoordinates = [self.view convertRect:keyboardFrameInWindowsCoordinates fromView:nil];
    self.viewBoard.frame = keyboardFrameInViewCoordinates;
}
*/

- (void) updatePage {
    NSUInteger currentIndex = [self.arrayWords indexOfObject:self.wordSelected];
    NSString * title = [NSString stringWithFormat:@"Word no %lu / %lu",(unsigned long)(currentIndex+1),(unsigned long)[self.arrayWords count]];
    self.navigationItem.title = title;
    [self.imageView roundWithImage:[UIImage imageWithData:self.wordSelected.image]];
    [self tapImageView:nil];
   }


- (NSString *) nextWord {
    
    NSString *nextWord = nil;
    
    if (!self.wordSelected) {
        self.wordSelected = [self.arrayWords firstObject];
        return self.wordSelected.name;
    }

    NSUInteger index = [self.arrayWords indexOfObject:self.wordSelected];
    index ++;
    
    if ([self.arrayWords count] > index) {
        self.wordSelected = [self.arrayWords objectAtIndex:index];
        nextWord = self.wordSelected.name;
        [self updatePage];
    }
    return nextWord;
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"testResult"]) {
        SPTestResult *testResultViewController = (SPTestResult *) segue.destinationViewController;
        testResultViewController.gameResult = self.gameController.gameResult;
    }
}

- (IBAction)tapImageView:(id)sender {
    NSData *audio = self.wordSelected.audio;
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithData:audio error:&error];
    [self.player setDelegate:self];
    [self.player play];
}
- (IBAction)swipeGestureImageView:(id)sender {
    [self.gameController newQuestion];
}


- (void) starDust {
    
    int startX = self.viewStopwatch.center.x;
    int endX = self.imageView.frame.origin.x;
    int startY = self.viewStopwatch.center.y;
    
    SKStarDustView* stars = [[SKStarDustView alloc] initWithFrame:CGRectMake(startX, startY, 10, 10)];
    [self.view addSubview:stars];
    [self.view sendSubviewToBack:stars];
    
    [UIView animateWithDuration:self.spelling.timeToSolve
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         stars.center = CGPointMake(endX, startY);
                     } completion:^(BOOL finished) {
                         
                         //game finished
                         [stars removeFromSuperview];
                     }];
}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
//Game controller Delegate and Datasource
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
- (void) scoreBoardWithGameResult:(NSArray *)gameResult {
    [self performSegueWithIdentifier:@"testResult" sender:self];
}

- (NSUInteger) timeToSolve {
    return self.spelling.timeToSolve;
}

- (NSUInteger) maxWordLength {
    NSUInteger max = 0;
    for (NSString *word in self.spelling.words) {
        max = MAX(max, [word length]);
    }
    return max;
}

- (UIView *) gameViewContainer:(id)sender {
    return self.viewBoard;
}

- (gameKeyboardType) gameKeyboardType:(id)sender {
    return gameKeyboardTile;
}
@end
