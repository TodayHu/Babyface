//
//  ViewController.h
//  Babyface
//
//  Created by Marco Klingmann on 10.01.15.
//  Copyright (c) 2015 Marco Klingmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMWormhole.h"
#import <AVFoundation/AVFoundation.h>



static NSString *const kGroupIdentifier = @"group.com.mocava.watchkit.babyface.sharedcontainer";

static const double kPowerThreshold = -10.0;

@interface ViewController : UIViewController <AVAudioPlayerDelegate>  {
    
}

@end

