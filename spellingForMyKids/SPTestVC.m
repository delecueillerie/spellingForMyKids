//
//  SPTestVC.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 16/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "SPTestVC.h"
#import "Word.h"

@interface SPTestVC ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfWords;


@property (strong, nonatomic) Word *currentWord;
@property (strong, nonatomic) NSArray *wordsUsedForThisTest;
@property (strong, nonatomic) NSMutableDictionary *wordsTyppedIn;

@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSTimer *timerForProgressView;

@end

@implementation SPTestVC
static double delay = 10;
static double delayForProgressViewUIUpdate = 0.1;


- (NSArray *) wordsUsedForThisTest {
    if (!_wordsUsedForThisTest) _wordsUsedForThisTest = [self.choosenSpelling.words allObjects];
    return _wordsUsedForThisTest;
}


- (NSMutableDictionary *) wordsTyppedIn {
    if (!_wordsTyppedIn) _wordsTyppedIn = [[NSMutableDictionary alloc]init];
    return _wordsTyppedIn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.textField becomeFirstResponder];
    self.currentWord = [self.wordsUsedForThisTest firstObject];
    [self listenTheWord];
    [self updatePage];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(nextWord:) userInfo:nil repeats:YES];
    self.timerForProgressView = [NSTimer scheduledTimerWithTimeInterval:delayForProgressViewUIUpdate target:self selector:@selector(progressViewUIUpdate:) userInfo:nil repeats:YES];
}


- (void) updatePage {
    NSUInteger currentIndex = [self.wordsUsedForThisTest indexOfObject:self.currentWord];
    NSString * title = [NSString stringWithFormat:@"Word no %ld / %lu",(currentIndex ++),[self.wordsUsedForThisTest count]];
    self.numberOfWords.text = title;
}

- (void) saveTyppedInWord {
    NSUInteger currentIndex = [self.wordsUsedForThisTest indexOfObject:self.currentWord];
    [self.wordsTyppedIn setValue:self.textField.text forKey:[NSString stringWithFormat:@"%lu",currentIndex]];
}

- (void) progressViewUIUpdate:(NSTimer *)timer {
    double timeInterval = [self.timer.fireDate timeIntervalSinceDate:[NSDate date]];
    float progress = (delay -timeInterval)/delay;
    [self.progressView setProgress:progress animated:YES];
}

- (void) nextWord:(NSTimer *)timer {
    [self saveTyppedInWord];
    NSUInteger index = [self.wordsUsedForThisTest indexOfObject:self.currentWord];
    index ++;
    if ([self.wordsUsedForThisTest count] > index) {
        Word *nextWord = [self.wordsUsedForThisTest objectAtIndex:index];
        self.currentWord = nextWord;
        [self updatePage];
    } else {
        //Stop the timers
        [self.timer invalidate];
        [self.timerForProgressView invalidate];
        //Go to the test result
        [self displayResultViewController];
    }
}

- (void) displayResultViewController {
    UIViewController *resultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"result"];
[self presentViewController:resultViewController animated:YES completion:^{
    //code
}];
}


- (void) listenTheWord {
    NSData *audio = self.currentWord.audio;
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithData:audio error:&error];
    [self.player setDelegate:self];
    [self.player play];
}

- (IBAction)next:(UIButton *)sender {
    [self nextWord:nil];
    }

- (IBAction)listen:(UIButton *)sender {
    [self listenTheWord];
}


@end
