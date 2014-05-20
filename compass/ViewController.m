//
//  ViewController.m
//  compass
//
//  Created by ShaoLing on 5/1/14.
//  Copyright (c) 2014 dastone.cn. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *magLabel;
@property (weak, nonatomic) IBOutlet UILabel *dirLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager headingAvailable]) {
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
    }else {
        NSLog(@"Can not get navigation data");
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    UIDevice *device = [UIDevice currentDevice];
    
    if(newHeading.headingAccuracy > 0){
        float magneticHeading = [self heading:newHeading.magneticHeading fromOrientation:device.orientation];
        float trueHeading = [self heading:newHeading.trueHeading fromOrientation:device.orientation];
    
        self.magLabel.text = [NSString stringWithFormat:@"%.2f", magneticHeading];
        NSLog(@"magnatic heading %.2f", magneticHeading);
        self.dirLabel.text = [NSString stringWithFormat:@"%.2f", trueHeading];
        NSLog(@"true heading %.2f", trueHeading);
        
        float heading = -1.0f * M_PI * newHeading.magneticHeading / 180.0f;
        self.image.transform = CGAffineTransformMakeRotation(heading);
    }
}


- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager{
    return YES;
}

- (float)heading:(float)heading fromOrientation:(UIDeviceOrientation)orientation{
    float realHeading = heading;
    
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            realHeading = realHeading - 180.0f;
            break;
        
        case UIDeviceOrientationLandscapeLeft:
            realHeading = realHeading + 90.0f;
            break;
        
        case UIDeviceOrientationLandscapeRight:
            realHeading = realHeading - 90.0f;
            break;
            
        default:
            break;
    }
    
    if (realHeading > 360.0f) {
        realHeading -= 360;
    }else if (realHeading < 0.0f){
        realHeading += 360;
    }
    
    return realHeading;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
