//
//  MapViewController.m
//  Spa Hunter Challenge
//
//  Created by CHRISTINA GUNARTO on 11/5/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define kLatitudeDelta 0.1
#define kLongitudeDelta 0.1
#define kLatitudeDeltaAnnotation 0.01
#define kLongitudeDeltaAnnotation 0.01

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addAnnotationWithMKMapItemArray:self.MKMapItemsArray];
    [self setInitialViewToSelfLocation];
}

- (void)addAnnotationWithMKMapItemArray: (NSArray *)MKMapItemArray
{
    for (MKMapItem *mapItem in MKMapItemArray)
    {
         MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
         annotation.coordinate = mapItem.placemark.location.coordinate;
         annotation.title = mapItem.placemark.name;
         [self.mapView addAnnotation:annotation];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //MKPinAnnotationView instead of MKAnnotation -- be careful
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView =[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.pinColor = MKPinAnnotationColorPurple;
    pin.image = [UIImage imageNamed:@"greenmark"];
    return pin;
}



- (void)setInitialViewToSelfLocation
{
    CLLocationCoordinate2D center = self.selfLocation.coordinate;
    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = kLatitudeDelta;
    coordinateSpan.longitudeDelta = kLongitudeDelta;

    MKCoordinateRegion region = MKCoordinateRegionMake(center, coordinateSpan);
    [self.mapView setRegion:region animated:YES];
}




@end
