//
//  ViewController.m
//  Babyface
//
//  Created by Marco Klingmann on 10.01.15.
//  Copyright (c) 2015 Marco Klingmann. All rights reserved.
//

#import "ViewController.h"
#import "MMWormhole.h"

@interface ViewController () {
    MMWormhole *_wormhole;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.mocava.watchkit.babyface.sharedcontainer" optionalDirectory:nil];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"baby-red"];
    NSString *msg = [NSString stringWithFormat:@"Image is %@", image];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Image" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_wormhole passMessageObject:imageData identifier:@"UpdateImage"];
    });
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
