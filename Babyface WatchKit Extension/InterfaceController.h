//
//  InterfaceController.h
//  Babyface WatchKit Extension
//
//  Created by Marco Klingmann on 10.01.15.
//  Copyright (c) 2015 Marco Klingmann. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceGroup *mainGroup;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *buttonGroup;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *alarmLabel;
- (IBAction)playSoundItemPressed;
- (IBAction)savePhotoItemPressed;

@end
