//
//  ViewController.m
//  DVSwitcherExample
//
//  Created by Dmitry Volevodz on 08.10.14.
//  Copyright (c) 2014 Dmitry Volevodz. All rights reserved.
//

#import "ViewController.h"
#import "DVSwitch.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // first switch
    
    NSInteger margin = 20;
    
    self.switcher = [[DVSwitch alloc] initWithStringsArray:@[@"First", @"Second"]];
    self.switcher.frame = CGRectMake(margin, margin * 2, self.view.frame.size.width - margin * 2, 30);
    [self.view addSubview:self.switcher];
    [self.switcher setPressedHandler:^(NSUInteger index) {
       
        NSLog(@"Did press position on first switch at index: %lu", (unsigned long)index);
        
    }];
    
    // second switch
    
    DVSwitch *secondSwitch = [DVSwitch switchWithStringsArray:@[@"1", @"2", @"3", @"4", @"5"]];
    secondSwitch.frame = CGRectMake(margin, 100, self.view.frame.size.width - margin * 2, 34);
    secondSwitch.backgroundColor = [UIColor greenColor];
    secondSwitch.sliderColor = [UIColor redColor];
    secondSwitch.labelTextColorInsideSlider = [UIColor blueColor];
    secondSwitch.labelTextColorOutsideSlider = [UIColor yellowColor];
    secondSwitch.cornerRadius = 0;
    [self.view addSubview:secondSwitch];
    
    // third Switch
    
    DVSwitch *third = [DVSwitch switchWithStringsArray:@[@"Hello", @"Dear", @"World"]];
    third.frame = CGRectMake(margin, 160, self.view.frame.size.width - margin * 2, 48);
    third.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:26];
    third.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    third.sliderColor = [UIColor colorWithRed:51/255.0 green:102/255.0 blue:153/255.0 alpha:1.0];
    [self.view addSubview:third];
    
    // fourth switch
    
    DVSwitch *fourth = [DVSwitch switchWithStringsArray:@[@"Apples", @"Oranges"]];
    fourth.frame = CGRectMake(10, 230, self.view.frame.size.width / 2 - margin, 20);
    fourth.sliderOffset = 2.0;
    fourth.cornerRadius = 10;
    fourth.font = [UIFont fontWithName:@"Baskerville-Italic" size:14];
    fourth.backgroundColor = [UIColor colorWithRed:200/255.0 green:65/255.0 blue:39/255.0 alpha:1.0];
    fourth.sliderColor = [UIColor colorWithRed:103/255.0 green:197/255.0 blue:194/255.0 alpha:1.0];
    [self.view addSubview:fourth];
    
    // fifth switch
    
    DVSwitch *fifth = [DVSwitch switchWithStringsArray:@[@"Wow", @"Such good"]];
    fifth.frame = CGRectMake(self.view.frame.size.width / 2 + 10, 230, self.view.frame.size.width / 2 - 40, 20);
    fifth.sliderOffset = 1.0;
    fifth.cornerRadius = 10;
    fifth.font = [UIFont fontWithName:@"Baskerville-Italic" size:18];
    fifth.labelTextColorOutsideSlider = [UIColor colorWithRed:255/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
    fifth.labelTextColorInsideSlider = [UIColor colorWithRed:255 green:255 blue:102 alpha:1.0];
    fifth.backgroundColor = [UIColor colorWithRed:255/255.0 green:204/255.0 blue:0/255.0 alpha:1.0];
    fifth.sliderColor = [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    [self.view addSubview:fifth];
}



@end
