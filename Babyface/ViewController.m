//
//  ViewController.m
//  Babyface
//
//  Created by Marco Klingmann on 10.01.15.
//  Copyright (c) 2015 Marco Klingmann. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "MMWormhole.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()
@property (nonatomic, strong) MMWormhole *wormhole;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:kGroupIdentifier optionalDirectory:nil];

    [self setupMoviePlayer];
    [self setupBabyCryDetection];
}

- (void)setupMoviePlayer {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Baby.mp4" withExtension:nil];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [self.moviePlayer play];

    [self.moviePlayer.view setFrame:self.view.bounds];
    [self.moviePlayer.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.moviePlayer setScalingMode:MPMovieScalingModeAspectFill];

    [self.view addSubview:self.moviePlayer.view];
}

- (void)setupBabyCryDetection {
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
            [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
            [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
            [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                    nil];
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:nil];
    self.audioRecorder.meteringEnabled = YES;
    [self.audioRecorder prepareToRecord];
    [self.audioRecorder record];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(listenToBaby) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"baby-red"];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.wormhole passMessageObject:imageData identifier:@"UpdateImage"];
    });
}

- (void)listenToBaby {
    [self.audioRecorder updateMeters];
    CGFloat power = [self.audioRecorder averagePowerForChannel:0];
    if (power>=kPowerThreshold) {
        NSLog(@"Baby is crying...");
    } else {
        NSLog(@"Baby is fine.");
    }
}

@end
