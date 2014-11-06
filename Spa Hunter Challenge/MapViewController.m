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


@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addAnnotationWithMKMapItemArray:self.MKMapItemsArray];
}

- (void)addAnnotationWithMKMapItemArray: (NSMutableArray *)MKMapItemArray
{
    for (MKMapItem *mapItem in MKMapItemArray)
    {
         MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
         annotation.coordinate = mapItem.placemark.location.coordinate;
         annotation.title = mapItem.placemark.name;
         [self.mapView addAnnotation:annotation];
    }
}




//- (void)setInitialViewToChicago
//{
//    //set the center of the map to Madison & Clinton
//    CLLocationCoordinate2D chicago = CLLocationCoordinate2DMake(klatitudeCenter, klongitudeCenter);
//    MKCoordinateSpan coordinateSpan;
//    coordinateSpan.latitudeDelta = klatitudeDelta;
//    coordinateSpan.longitudeDelta = klongitudeDelta;
//
//    MKCoordinateRegion region = MKCoordinateRegionMake(chicago, coordinateSpan);
//    [self.mapView setRegion:region animated:YES];
//}

@end
