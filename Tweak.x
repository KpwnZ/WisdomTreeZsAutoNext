#import <UIKit/UIKit.h>

#define WTZANLog(log) NSLog(@"%@", [NSString stringWithFormat:@"[WTZAN]: %@", log])

@interface VideoQuestionView : UIView
-(void)close;
@end

@interface WTCourseSurveyAlertView : UIView
@end

@interface WTCVideoPlayerView : UIView
@property (readonly) CGFloat currentRate;
@property CGFloat currentVideoCurrentTime;
@property CGFloat currentVideoDuration;
@property (nonatomic, retain) UILabel *progressLabel;
-(void)constructViewClickNextVideoBtn:(id)arg1;
-(CGFloat)currentRate;
@end

@interface VideoQuestionOptionModel : NSObject
@end

%hook VideoQuestionView
-(void)didMoveToWindow {
    %orig;
    WTZANLog(@"Video question view detected, set background color and close");
    [self setBackgroundColor:[UIColor blueColor]];
    // call close function directly.
    [self close];
}

-(void)layoutSubviews{
    // I don't care the performance. I just want to close it.
    [self close];
}
%end

%hook WTCVideoPlayerView
%property (nonatomic, retain) UILabel *progressLabel;

-(void)pauseVideoImmediately {
    // do not pause.
    WTZANLog(@"Do you want to pause me?");
    return;
}

-(void)didMoveToWindow {
    %orig;
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 60, 30)];
    self.progressLabel.backgroundColor = [UIColor whiteColor];
    self.progressLabel.textColor = [UIColor blackColor];
    [self addSubview:self.progressLabel];

}

-(void)setCurrentTime:(CGFloat)currentTime {

    %orig(currentTime);
    if(self.progressLabel) {
        WTZANLog(@"Progress updated.");
        self.progressLabel.text = [NSString stringWithFormat:@"%.3f", currentTime/self.currentVideoDuration];
    }

    // again, I don't care about performance at all.
    // (Since A11 is still great.)

    if (currentTime/self.currentVideoDuration > 0.95) {
        [self constructViewClickNextVideoBtn:nil];
    }

    return;
}

-(void)updateUI {
    %orig;

    if(self.progressLabel) {
        self.progressLabel.text = [NSString stringWithFormat:@"%f", self.currentVideoCurrentTime/self.currentVideoDuration];
    }

    // I don't care about performance at all.

    if (self.currentVideoCurrentTime/self.currentVideoDuration > 0.95) {
        WTZANLog(@"Ready to play next video.");
        [self constructViewClickNextVideoBtn:nil];
    }

    return;
}
%end

%hook WTCourseSurveyAlertView
-(void)didMoveToWindow {

    // gtfo annoying survey
    WTZANLog(@"Survey alert view detected, hide it now.");

    self.hidden = YES;
    self.alpha = 0;

    [self.superview setHidden:YES];
    [self.superview setAlpha:0];
}
%end
