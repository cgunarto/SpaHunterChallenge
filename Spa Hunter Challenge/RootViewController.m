//
//  ViewController.m
//  Spa Hunter Challenge
//
//  Created by CHRISTINA GUNARTO on 11/5/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "RootViewController.h"
#import "Spa.h"
#import <CoreLocation/CoreLocation.h>

@import MapKit;

@interface RootViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>
@property CLLocationManager *manager;
@property (weak, nonatomic) IBOutlet UIButton *findBlissButton;
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (strong, nonatomic) NSMutableArray *spaArray;
@property (strong, nonatomic) NSMutableArray *nearbySpaArray; //within 10KM

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager = [[CLLocationManager alloc]init];
    [self.manager requestWhenInUseAuthorization];
    self.manager.delegate = self;
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

    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"Spa";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1,1));

    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
     {
         NSArray *mapItemsArray = response.mapItems;

         for (MKMapItem *mapItem in mapItemsArray)
         {
             Spa *spa = [[Spa alloc] initWithMKMapItem:mapItem];
             [self.spaArray addObject:spa];

             //finding distance of MapItem from self
             CLLocation *mapItemLocation = mapItem.placemark.location;
             CLLocationDistance distanceFromSelf = [mapItemLocation distanceFromLocation: self.manager.location];
             double distanceInKm = distanceFromSelf / 1000;

             spa.distanceFromSelf = distanceInKm;

             if (spa.distanceFromSelf < 10)
             {
                 [self.nearbySpaArray addObject:spa];
             }

         }
//         NSLog (@"You should go to %@, it is %.2f km away", mapItem.name, distanceInKm);
//         [self getDirectionsTo:mapItem];
         [self.resultsTableView reloadData];
     }];
}

- (void)getDirectionsTo:(MKMapItem *)destinationItem
{
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = destinationItem;

    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];

    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, id error)
     {
         NSArray *routes = response.routes;
         MKRoute *route = routes.firstObject;

         int x = 1;
         NSMutableString *directionsString = [NSMutableString string];

         for (MKRouteStep *step in route.steps)
         {
             [directionsString appendFormat:@"%d: %@\n", x, step.instructions];
             x++;

             NSLog (@"%@", step.instructions);
         }
         self.textView.text = directionsString;
     }];
}




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

    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.spaArray.count;
}

- (void) showFourNearestPlaces
{

}



@end
