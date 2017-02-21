//
//  ViewController.m
//  MyLocationDemo
//
//  Created by Milan Shah on 10/22/14.
//  Copyright (c) 2014 Milan Shah. All rights reserved.
//

#import "ViewController.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ViewController ()

@end

@implementation ViewController {
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    locationManager = [[CLLocationManager alloc]init];
    geocoder = [[CLGeocoder alloc]init];
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getCurrentLocation:(id)sender {
    
    
    locationManager.delegate = self;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];

    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    
}

#pragma mark
#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError:, %@", error);
    UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [myAlert show];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%@",[newLocation description]);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"didUpdateLocations,: %@",locations);
    
    CLLocation *currentLocation;
    
    if (currentLocation != nil) {
        self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
    }
    
    //Stop Location Manager
    [locationManager stopUpdatingLocation];
    
    //Reverse Geocoding
    
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemark:, %@, error: %@",placemarks,error);
        
        if (error == nil && [placemarks count]> 0) {
            placemark = [placemarks lastObject];
            
            self.addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@",placemark.subThoroughfare, placemark.thoroughfare,placemark.postalCode, placemark.locality,placemark.administrativeArea,placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    }];
 
}
 



/*
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation
                                                                          *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil) {
        self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f",
                                    currentLocation.coordinate.longitude];
        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", 
                                   currentLocation.coordinate.latitude];

    }

        
    //Stop Location Manager
    [locationManager stopUpdatingLocation];
 
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
    NSLog(@"Found placemark:, %@, error: %@",placemarks,error);
    
    if (error == nil && [placemarks count]> 0) {
        placemark = [placemarks lastObject];
        
        self.addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@",placemark.subThoroughfare,      placemark.thoroughfare,placemark.postalCode, placemark.locality,placemark.administrativeArea,placemark.country];
    } else {
        NSLog(@"%@", error.debugDescription);
    }
}];

}

 */


@end
