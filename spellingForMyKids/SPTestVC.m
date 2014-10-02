//
//  SPTestVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 16/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//


#import "Word.h"
#import "WordTest+enhanced.h"


#import "SPTestVC.h"
#import "SPTestResult.h"
//#import "config.h"

//ScrabbleKeyboard Module
//#import "config.h"
#import "SKHUDView.h"

//Category
#import "UIImageView+cornerRadius.h"

//View
#import "SKStarDustView.h"



#define scrabble @"scrabble"


@interface SPTestVC ()

//@property (strong, nonatomic) Kid *kidSelected;
//@property (strong, nonatomic) Spelling *spellingSelected;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *viewBoard;
@property (weak, nonatomic) IBOutlet UIView *viewStopwatch;
@property (weak, nonatomic) IBOutlet SKHUDView *viewHud;
@property (weak, nonatomic) IBOutlet SKCounterLabelView *viewCounter;


@property (strong, nonatomic) WordTest *wordTestSelected;
//@property (strong, nonatomic) Word *wordSelected;
//@property (strong, nonatomic) NSArray *arrayWords;
@property (strong, nonatomic) NSArray *arrayWordTests;
@property (nonatomic) NSUInteger maxWordLength; //use for define the size of the tiles
@property (strong, nonatomic) AVAudioPlayer *player;



//scrabbleKeyboard
@property (strong, nonatomic) SKGameController* gameController;
//@property (strong, nonatomic) SKBoardController *boardController;
//@property (strong, nonatomic) SKWordsData *spelling;

@end

@implementation SPTestVC

/*//////////////////////////////////////////////////////////////////////////////////////////////
 Accessors
 //////////////////////////////////////////////////////////////////////////////////////////////*/

- (void) setWordTestSelected:(WordTest *)wordTestSelected {
    _wordTestSelected = wordTestSelected;
    _wordTestSelected.startedAt = [NSDate date];
}

- (NSArray *) arrayWordTests {
    if (!_arrayWordTests) {
        self.maxWordLength = 0;
        NSMutableArray *mArrayWordTests = [[NSMutableArray alloc] initWithCapacity:[self.spellingTestSelected.spelling.words count]];
        for (Word *word in self.spellingTestSelected.spelling.words) {
            WordTest *wordTest = [NSEntityDescription insertNewObjectForEntityForName:@"WordTest" inManagedObjectContext:self.managedObjectContext];
            wordTest.word = word;
            wordTest.spellingTest = self.spellingTestSelected;
            wordTest.kid = self.spellingTestSelected.kid;
            wordTest.spelling = self.spellingTestSelected.spelling;
            [mArrayWordTests addObject:wordTest];
            
            self.maxWordLength = MAX([word.name length], self.maxWordLength); //define the maxWordLength

        }
        _arrayWordTests = mArrayWordTests;
    }
    return _arrayWordTests;
}

- (SKGameController *) gameController {
    if (!_gameController) {
        //create the game controller
        
        _gameController = [[SKGameController alloc] init];
        _gameController.delegate = self;
        _gameController.datasource = self;
        _gameController.hud = self.viewHud;
    }
    return _gameController;
}



/*//////////////////////////////////////////////////////////////////////////////////////////////
 VC LIFECYCLE
//////////////////////////////////////////////////////////////////////////////////////////////*/


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.spellingTestSelected.startedAt = [NSDate date];
    [self.gameController newQuestion];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.view layoutSubviews];
}

/*//////////////////////////////////////////////////////////////////////////////////////////////
 Triggered Action
 //////////////////////////////////////////////////////////////////////////////////////////////*/

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"testResult"]) {
        //SPTestResult *testResultViewController = (SPTestResult *) segue.destinationViewController;
        //testResultViewController.gameResult = self.gameController.gameResult;
    }
}

- (IBAction)tapImageView:(id)sender {
    NSData *audio = self.wordTestSelected.word.audio;
    if (audio) {
        NSError *error;
        self.player = [[AVAudioPlayer alloc] initWithData:audio error:&error];
        [self.player setDelegate:self];
        [self.player play];
    }
}

- (IBAction)swipeGestureImageView:(id)sender {
    [self gameInput:self.gameController.boardController.input];
    [self.gameController newQuestion];
    
}
- (IBAction)next:(id)sender {
    [self gameInput:self.gameController.boardController.input];
    [self.gameController newQuestion];
}

- (void) save {
    NSError *error;
    [self.managedObjectContext save:&error];
    NSManagedObjectContext *parentContext = [self.managedObjectContext parentContext];
    
    if (parentContext) {
        error = nil;
        [parentContext save:&error];
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////
 Utilities
 //////////////////////////////////////////////////////////////////////////////////////////////*/




/*
- (void) starDust {
    
    int startX = self.viewStopwatch.center.x;
    int endX = self.imageView.frame.origin.x;
    int startY = self.viewStopwatch.center.y;
    
    SKStarDustView* stars = [[SKStarDustView alloc] initWithFrame:CGRectMake(startX, startY, 10, 10)];
    [self.view addSubview:stars];
    [self.view sendSubviewToBack:stars];
    
    [UIView animateWithDuration:[self timeToSolve]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         stars.center = CGPointMake(endX, startY);
                     } completion:^(BOOL finished) {
                         
                         //game finished
                         [stars removeFromSuperview];
                     }];
}
*/

/*//////////////////////////////////////////////////////////////////////////////////////////////
 gameController datasource
 //////////////////////////////////////////////////////////////////////////////////////////////*/

- (NSString *) nextWord {
    
    NSString *nextWord = nil;
    NSUInteger index = 0;
    //check if first word call
    if (!self.wordTestSelected) {
        self.wordTestSelected = [self.arrayWordTests firstObject];
        nextWord =  self.wordTestSelected.word.name;
    } else {
    
        index = [self.arrayWordTests indexOfObject:self.wordTestSelected];
        index ++;
    
        if ([self.arrayWordTests count] > index) {
            self.wordTestSelected = [self.arrayWordTests objectAtIndex:index];
            nextWord = self.wordTestSelected.word.name;
            //[self updatePage];
        }
    }

    NSString * title = [NSString stringWithFormat:@"Word no %lu / %lu",(unsigned long)(index+1),(unsigned long)[self.arrayWordTests count]];
    self.navigationItem.title = title;
    [self.imageView roundWithImage:[UIImage imageWithData:self.wordTestSelected.word.image]];
    [self tapImageView:nil];

    [self save];
    return nextWord;
}

/*//////////////////////////////////////////////////////////////////////////////////////////////
 gameController delegate
 //////////////////////////////////////////////////////////////////////////////////////////////*/

-(gameType) gameType:(id)sender {
    return gameTypeSpelling;
}

- (gameKeyboardType) gameKeyboardType:(id)sender {
    return gameKeyboardTile;
}

- (gameLevel) gameLevel:(id)sender {
    return [self.spellingTestSelected.level intValue];
}

- (void) gameDidFinish {
    self.spellingTestSelected.endedAt = [NSDate date];
    [self.spellingTestSelected setSpellingTestResult];
    
    [self save];
    [self performSegueWithIdentifier:@"testResult" sender:self];
}

- (NSUInteger) timeToSolve {
    float coef;
    switch ([self.spellingTestSelected.level intValue]) {
        case spellingTestLevelEasy:
            coef = 10.0;
            break;
        case spellingTestLevelMedium:
            coef = 5;
            break;
        case spellingTestLevelHard:
            coef = 2;
            break;
        default:
            coef = 1;
            break;
    }
    return coef*[self.wordTestSelected.word.name length];
}

- (NSUInteger) maxWordLength {
    return _maxWordLength;
}

- (UIView *) gameViewContainer:(id)sender {
    return self.viewBoard;
}

- (void) gameInput:(NSString *)input {
    self.wordTestSelected.endedAt = [NSDate date];
    self.wordTestSelected.input = input;
    
    if ([self.wordTestSelected.word.name isEqualToString:input]) {
        self.wordTestSelected.result = [NSNumber numberWithInt:wordTestResultPass];
    } else {
        self.wordTestSelected.result = [NSNumber numberWithInt:wordTestResultFail];
    }

    [self save];
}


@end
