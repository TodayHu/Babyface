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
@property (nonatomic, strong) NSTimer *audioTimer;
@property(nonatomic, strong) NSTimer *movieTimer;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishedPlayingMovie:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayer];

    [self.view addSubview:self.moviePlayer.view];
    self.movieTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateBabyImage) userInfo:nil repeats:YES];
}

- (void)finishedPlayingMovie:(NSNotification *)notification {
    NSAssert([notification.object isEqual:self.moviePlayer], @"Movieplayer is not the one playing baby movie");
    MPMovieFinishReason reason = [[notification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    if (reason == MPMovieFinishReasonPlaybackEnded) {
        [self.moviePlayer play];
    }
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
    self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(listenToBaby) userInfo:nil repeats:YES];
    [self.audioTimer fire];
}

- (void)updateBabyImage {
    UIImage *image = [self.moviePlayer thumbnailImageAtTime:[self.moviePlayer currentPlaybackTime] timeOption:MPMovieTimeOptionNearestKeyFrame];
    image = [self scaledImageFromImage:image size:CGSizeMake(390/10.0, 312/10.0)];
    NSData *imageData = UIImagePNGRepresentation(image);
    [self.wormhole passMessageObject:imageData identifier:@"UpdateImage"];
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

- (UIImage *)scaledImageFromImage:(UIImage *)image size:(CGSize)size {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
