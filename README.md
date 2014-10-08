DVSwitch
========

Flexible and customizable control based on UISwitch and UISegmentedControl written in Objective-C.

<img src="http://i.imgur.com/FH1CQRX.png">


DVSwitch was inspired by UISwitch and UISegmentedControl. The goals of this code are:

* Easily customizable control with nice animations
* Beautiful font color inversion effect - label color changes per pixel
* Supporting pan or swipe interactions
* Requires very little setup - images are not needed

Usage
-----

    DVSwitch *switcher = [[DVSwitch alloc] initWithStringsArray:@[@"First", @"Second"]];
    switcher.frame = CGRectMake(20, 300, self.view.frame.size.width - 40, 34);
    [self.view addSubview:switcher];
    [switcher setPressedHandler:^(NSUInteger index) {
        
        NSLog(@"Did switch to index: %lu", (unsigned long)index);
        
    }];
    [self.view addSubview:switcher];
    


Customizable properties:

* `UIColor *backgroundColor` - color of the controls background
* `UIColor *sliderColor` - color of slider
* `UIColor *labelTextColorInsideSlider` - color of text when slider hovers over it
* `UIColor *labelTextColorOutsideSlider` - color of text when outside of slider
* `UIFont *font` - font used in control
* `CGFloat cornerRadius` - corner radius of control and corner radius of slider
* `CGFLoat sliderOffset` - pixel offset in points between the slider and the edge of control

When the user taps or slides the control, handler block is getting called with the index of element which was triggered. To set it use the following method:<br />
    `- (void)setPressedHandler:(void (^)(NSUInteger index))handler;`

--

Source code contains example project with few different types of switch.

Requirements:
-----
iOS 7.0 and Xcode 6.0

The control might work on earlier versions, but this was not tested.

Support
-----
We will welcome any feedback or pull requests to the project.


Version: 1.0.0<br>
License: [MIT](http://opensource.org/licenses/MIT)

--
