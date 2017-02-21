//
//  ViewController.m
//  TesteSip
//
//  Created by Elis Nunes Ficos on 04/10/15.
//  Copyright (c) 2015 TesteSip. All rights reserved.
//

#import "ViewController.h"

#import <pjsip-ios/pjsip-ios.h>

#define PJ_CONFIG_IPHONE 1

@interface ViewController ()<DXIPJSipManagerDelegate>

@property (strong, nonatomic) DXIPJSipManager *dXIPJSipManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.dXIPJSipManager = [DXIPJSipManager getInstance];
    [self.dXIPJSipManager setDelegate:self];
    
    [self.dXIPJSipManager registerToSipServerAndDoAgentLogin];
}

- (void)onRegisterToSipServerAndLogAgentDidFinish
{
    NSLog(@"Status: %@",self.dXIPJSipManager.sipState);
}

@end
