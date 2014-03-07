//
//  polaroidAnimatedView.m
//  spellingForMyKids
//
//  Created by Olivier Delecueillerie on 21/02/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "polaroidAnimatedView.h"
#define kTransitionDuration	0.5

@interface polaroidAnimatedView()


@property (strong, nonatomic) polaroidView *currentPolaroid;

@property (nonatomic)  NSInteger currentIndex;
@end


@implementation polaroidAnimatedView

- (void) setCurrentIndex:(NSInteger)currentIndex {
    if (currentIndex <0) //cannot understand why modulo do not respond has should do for negative number ...
        _currentIndex = [self.dataForPolaroid count] + currentIndex;
    else
        _currentIndex = currentIndex % [self.dataForPolaroid count];
}

- (polaroidView *) currentPolaroid {
    if (!_currentPolaroid) _currentPolaroid = [self viewAtIndex:self.currentIndex];
    return _currentPolaroid;
}

+ (id) polaroidAnimatedViewWithData:(NSArray *)data atIndex:(NSInteger)index inFrame:(CGRect) frame {


    polaroidAnimatedView *pola = [[polaroidAnimatedView alloc] initWithFrame:frame];
    pola.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    pola.contentMode = UIViewContentModeScaleAspectFit;

    pola.dataForPolaroid = data;
    pola.currentIndex = index;
    [pola addSubview:pola.currentPolaroid];

//Gesture Recognizer management
    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:pola action:@selector(rightSwipe)];
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:pola action:@selector(leftSwipe)];
    recognizerRight.direction = UISwipeGestureRecognizerDirectionLeft;

    //recognizerRight.delegate = pola;
    [pola addGestureRecognizer:recognizerRight];
    [pola addGestureRecognizer:recognizerLeft];

    return pola;
}


- (polaroidView *) viewAtIndex:(NSInteger) index {

    NSDictionary *dico = (NSDictionary *)[self.dataForPolaroid objectAtIndex:index];
    polaroidView *view = [polaroidView polaroidViewImage:[dico objectForKey:@"image"] label:[dico valueForKey:@"label"] inFrame:self.bounds];
    return view;
}
- (void)leftSwipe {
    self.currentIndex = (self.currentIndex + 1);
    [self animation:[self viewAtIndex:self.currentIndex]];
}


- (void)rightSwipe {
    self.currentIndex = (self.currentIndex -1);
    [self animation:[self viewAtIndex:self.currentIndex]];

}


- (void) animation :(UIView *) viewToDisplay {
    [UIView transitionFromView:self.currentPolaroid toView:viewToDisplay duration:kTransitionDuration options:UIViewAnimationOptionTransitionCurlUp completion:^(BOOL finished) {
        if (finished) {
            [self.currentPolaroid removeFromSuperview];
            self.currentPolaroid = (polaroidView *)viewToDisplay;
        }
    }];
}



@end
