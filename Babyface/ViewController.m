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

@interface ViewController () {
    MMWormhole *_wormhole;
    AVAudioRecorder *_audioRecorder;
    NSTimer *_timer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.mocava.watchkit.babyface.sharedcontainer" optionalDirectory:nil];
    
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:nil];
    _audioRecorder.meteringEnabled = YES;
    [_audioRecorder prepareToRecord];
    [_audioRecorder record];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(listenToBaby) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"baby-red"];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_wormhole passMessageObject:imageData identifier:@"UpdateImage"];
    });
}

- (void)listenToBaby {
    [_audioRecorder updateMeters];
    CGFloat power = [_audioRecorder averagePowerForChannel:0];
    if (power>=-20.0) {
        NSLog(@"Baby is crying...");
    } else {
        NSLog(@"Baby is fine.");
    }
}

@end
