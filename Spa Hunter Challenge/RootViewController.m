//
//  ViewController.m
//  Spa Hunter Challenge
//
//  Created by CHRISTINA GUNARTO on 11/5/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "RootViewController.h"
#import "Spa.h"
#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@import MapKit;

@interface RootViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate>
@property CLLocationManager *manager;
@property (weak, nonatomic) IBOutlet UIButton *findBlissButton;
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (strong, nonatomic) NSMutableArray *spaArray;
@property (strong, nonatomic) NSMutableArray *nearbySpaArray; //within 10KM
@property (strong, nonatomic) NSArray *MKMapItemsArray;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property double walkingTime;
@property double totalWalkingTime;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager = [[CLLocationManager alloc]init];
    [self.manager requestWhenInUseAuthorization];
    self.manager.delegate = self;
    self.tabBarController.delegate = self;
    self.walkingTime = 0;
    self.totalWalkingTime = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.resultsTableView reloadData];
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

- (IBAction)onBlissButtonPressed:(UIButton *)sender
{
    NSLog(@"Location Found. START: %s",__PRETTY_FUNCTION__);
    [self.manager startUpdatingLocation];
}

- (IBAction)onNearbyButtonPressed:(UIButton *)sender
{
    //show nearby locations less than 10km away
    self.spaArray = [self.nearbySpaArray mutableCopy];
    [self.resultsTableView reloadData];
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


- (void)findSpaNear:(CLLocation *)location
{

    self.spaArray = [@[]mutableCopy];
    self.nearbySpaArray = [@[]mutableCopy];

    self.totalWalkingTime = 0;

    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"Spa";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.1,0.1));

    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
     {
         self.MKMapItemsArray = response.mapItems;

         for (MKMapItem *mapItem in self.MKMapItemsArray)
         {
             Spa *spa = [[Spa alloc] initWithMKMapItem:mapItem];

             //finding distance of MapItem from self
             CLLocation *mapItemLocation = mapItem.placemark.location;
             CLLocationDistance distanceFromSelf = [mapItemLocation distanceFromLocation: self.manager.location];
             double distanceInKm = distanceFromSelf / 1000;

             spa.distanceFromSelf = distanceInKm;

             if (spa.distanceFromSelf < 10)
             {
                 [self.nearbySpaArray addObject:spa];
             }

             MKDirectionsRequest *request = [MKDirectionsRequest new];
             request.source = [MKMapItem mapItemForCurrentLocation];
             request.destination = mapItem;
             request.transportType = MKDirectionsTransportTypeWalking;

             MKDirections *directions = [[MKDirections alloc]initWithRequest:request];

             [directions calculateETAWithCompletionHandler:^(MKETAResponse *response, NSError *error)
              {
                  NSTimeInterval estimatedTravelTimeInSeconds = response.expectedTravelTime;
                  self.walkingTime = estimatedTravelTimeInSeconds / (double)60;
                  NSLog(@"Estimated travel time to %@ is %f minutes",spa.name, self.walkingTime);
                  [self countTotalWalkingTime: self.walkingTime];
              }];

             [self.spaArray addObject:spa];
         }
//         NSLog (@"You should go to %@, it is %.2f km away", mapItem.name, distanceInKm);
//         [self getDirectionsTo:mapItem];
         [self.resultsTableView reloadData];
     }];

}

- (void)countTotalWalkingTime:(double) travelTime
{
    self.totalWalkingTime = travelTime + self.totalWalkingTime + 50;
    self.minutesLabel.text = [NSString stringWithFormat:@"%.2f",self.totalWalkingTime];
}

//- (void)getWalkingTimeTo:(MKMapItem *)destinationItem
//{
//    MKDirectionsRequest *request = [MKDirectionsRequest new];
//    request.source = [MKMapItem mapItemForCurrentLocation];
//    request.destination = destinationItem;
//    request.transportType = MKDirectionsTransportTypeWalking;
//
//    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
//    self.walkingTime = 0;
//
//    [directions calculateETAWithCompletionHandler:^(MKETAResponse *response, NSError *error)
//    {
//        NSTimeInterval estimatedTravelTimeInSeconds = response.expectedTravelTime;
//       self.walkingTime = estimatedTravelTimeInSeconds / 60;
//        NSLog(@"Direction to map item is %f", self.walkingTime);
//    }];
//
//}


#pragma mark Table View Custom Methods

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell" forIndexPath:indexPath];
    Spa *spa = self.spaArray[indexPath.row];
    cell.textLabel.text = spa.name;

    //setting the distance
    double distanceInKm = spa.distanceFromSelf;
    NSString *distanceString = [NSString stringWithFormat:@"%.2f km away", distanceInKm];
    cell.detailTextLabel.text = distanceString;
    cell.imageView.image = [UIImage imageNamed:@"greenmark"];

    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.spaArray.count;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //   MapViewController *mapVC = (MapViewController *) [tabBarController.viewControllers objectAtIndex:1];
    MapViewController *mapVC = (MapViewController *)viewController;
    mapVC.MKMapItemsArray = self.MKMapItemsArray;
//    mapVC.selfCoord = self.manager.location.coordinate;
    mapVC.selfLocation  = self.manager.location;
    NSLog(@"selected %lu",(unsigned long)tabBarController.selectedIndex);
}



@end
