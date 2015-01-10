//
//  InterfaceController.m
//  Babyface WatchKit Extension
//
//  Created by Marco Klingmann on 10.01.15.
//  Copyright (c) 2015 Marco Klingmann. All rights reserved.
//

#import "InterfaceController.h"
#import "MMWormhole.h"
#import "BabyState.h"

@interface InterfaceController()
@property (nonatomic, strong) MMWormhole *wormhole;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.mocava.watchkit.babyface.sharedcontainer" optionalDirectory:nil];
    
    [self.wormhole listenForMessageWithIdentifier:@"UpdateImage" listener:^(id messageObject) {
        UIImage *image = [UIImage imageWithData:messageObject];
        [self.mainGroup setBackgroundImage:image];
    }];
    
    [self.wormhole listenForMessageWithIdentifier:@"BabyStateUpdate" listener:^(id messageObject) {
        BabyState state = [messageObject unsignedIntegerValue];
        BOOL hideDialog = (state==BabyStateSilent);
        [self.buttonGroup setHidden:hideDialog];
        [self.alarmLabel setHidden:hideDialog];
    }];

    [self.alarmLabel setHidden:YES];
    [self.buttonGroup setHidden:YES];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)updateImage:(UIImage*)image {
    
}

@end



