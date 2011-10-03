//
//  Geometry.h
//  afGMDemo
//
//  Created by adrien ferré on 02/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "afGoogleMapsAPIRequest.h"

@interface Geometry : NSObject {
    LocationType locationType;
    CLLocationCoordinate2D location;
    CLLocationCoordinate2D viewportSW;
    CLLocationCoordinate2D viewportNE;
    CLLocationCoordinate2D boundsSW;
    CLLocationCoordinate2D boundsNE;
}

@property (nonatomic,assign) CLLocationCoordinate2D location;
@property (nonatomic,assign) CLLocationCoordinate2D viewportSW;
@property (nonatomic,assign) CLLocationCoordinate2D viewportNE;
@property (nonatomic,assign) CLLocationCoordinate2D boundsSW;
@property (nonatomic,assign) CLLocationCoordinate2D boundsNE;
@property (nonatomic,assign) LocationType locationType;
+ (Geometry *) parseJsonDico:(NSDictionary *)jsonDico;
@end