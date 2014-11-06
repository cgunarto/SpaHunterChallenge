//
//  ViewController.m
//  Spa Hunter Challenge
//
//  Created by CHRISTINA GUNARTO on 11/5/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "RootViewController.h"
#import "Spa.h"
#import "SpaMKMapItem.h"
#import <CoreLocation/CoreLocation.h>

@import MapKit;

@interface RootViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>
@property CLLocationManager *manager;
@property (weak, nonatomic) IBOutlet UIButton *findBlissButton;
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (strong, nonatomic) NSArray *arrayOfSpas;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager = [[CLLocationManager alloc]init];
    [self.manager requestWhenInUseAuthorization];
    self.manager.delegate = self;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations)
    {
        // blue circle around a pin, we're not going to
        if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000)
        {
            NSLog (@"Location found...");
            [self reverseGeoCode:location];
            [self.manager stopUpdatingLocation];
            break;
        }
    }
}

- (void)findSpaNear:(CLLocation *)location
{
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"spa";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1,1));

    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
     {
         NSArray *mapItems = response.mapItems;
         MKMapItem *mapItem = mapItems.firstObject;

         CLLocation *mapItemLocation = mapItem.placemark.location;
         CLLocationDistance distanceFromSelf = [mapItemLocation distanceFromLocation: self.manager.location];
         double distanceInKm = distanceFromSelf / 1000;

         NSLog (@"You should go to %@, it is %.2f km away", mapItem.name, distanceInKm);
//         [self getDirectionsTo:mapItem];
     }];
}

- (IBAction)onBlissButtonPressed:(UIButton *)sender
{
    NSLog(@"Location Found. START: %s",__PRETTY_FUNCTION__);
    [self.manager startUpdatingLocation];
}

- (void)reverseGeoCode:(CLLocation *)location
{
    CLGeocoder *geocoder = [CLGeocoder new];

    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, id error)
     {
         CLPlacemark *placemark = placemarks.firstObject;
         NSString *address = [NSString stringWithFormat: @"%@ %@\n %@",
                              placemark.subThoroughfare,
                              placemark.thoroughfare,
                              placemark.locality];
         NSLog(@"Found you! %@",address);
         [self findSpaNear:placemark.location];
         
     }];
}

#pragma mark Table View Custom Methods

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}




@end
