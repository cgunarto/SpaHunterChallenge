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

- (void)setInitialViewToSelfLocation
{
    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = kLatitudeDelta;
    coordinateSpan.longitudeDelta = kLongitudeDelta;

    MKCoordinateRegion region = MKCoordinateRegionMake(self.selfCoord, coordinateSpan);
    [self.mapView setRegion:region animated:YES];
}




@end
