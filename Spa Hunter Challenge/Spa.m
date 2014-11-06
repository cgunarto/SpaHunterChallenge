//
//  Spa.m
//  Spa Hunter Challenge
//
//  Created by CHRISTINA GUNARTO on 11/5/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "Spa.h"

@implementation Spa

- (instancetype)initWithMKMapItem: (MKMapItem *)mapItem
{
    self = [super init];

    self.name = mapItem.placemark.name;
    self.address = mapItem.placemark.thoroughfare;
    self.city = mapItem.placemark.locality;
    self.neighborhood = mapItem.placemark.subLocality;
    self.location = mapItem.placemark.location;

    return self;
}


@end



//@property (nonatomic, readonly, copy) NSString *name; // eg. Apple Inc.
//@property (nonatomic, readonly, copy) NSString *thoroughfare; // street address, eg. 1 Infinite Loop
//@property (nonatomic, readonly, copy) NSString *subThoroughfare; // eg. 1
//@property (nonatomic, readonly, copy) NSString *locality; // city, eg. Cupertino
//@property (nonatomic, readonly, copy) NSString *subLocality; // neighborhood, common name, eg. Mission District
//@property (nonatomic, readonly, copy) NSString *administrativeArea; // state, eg. CA
//@property (nonatomic, readonly, copy) NSString *subAdministrativeArea; // county, eg. Santa Clara
//@property (nonatomic, readonly, copy) NSString *postalCode; // zip code, eg. 95014
//@property (nonatomic, readonly, copy) NSString *ISOcountryCode; // eg. US
//@property (nonatomic, readonly, copy) NSString *country; // eg. United States
//@property (nonatomic, readonly, copy) NSString *inlandWater; // eg. Lake Tahoe
//@property (nonatomic, readonly, copy) NSString *ocean; // eg. Pacific Ocean
//@property (nonatomic, readonly, copy) NSArray *areasOfInterest; // eg. Golden Gate Park