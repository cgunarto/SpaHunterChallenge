//
//  Spa.h
//  Spa Hunter Challenge
//
//  Created by CHRISTINA GUNARTO on 11/5/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Spa : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *neighborhood;
@property (strong, nonatomic) CLLocation *location;
@property double latitude;
@property double longitude;
@property double distanceFromSelf;

- (instancetype) initWithMKMapItem: (MKMapItem *)mapItem;

@end
