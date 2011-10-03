//
//  Geometry.m
//  afGMDemo
//
//  Created by adrien ferré on 02/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "Geometry.h"

@implementation Geometry

@synthesize location,locationType,viewportNE,viewportSW,boundsSW,boundsNE;

+(Geometry *) parseJsonDico:(NSDictionary *)geoDico{
    Geometry *geometry = [[[Geometry alloc] init] autorelease];
    
    double longitude = [[[geoDico objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
    double latitude = [[[geoDico objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
    
    geometry.location = CLLocationCoordinate2DMake(latitude, longitude);
    
    geometry.locationType = [afGMapsGeocodingRequest locationTypeFromString:[geoDico objectForKey:@"location_type"]];
    
    if ([[geoDico allKeys] containsObject:@"viewport"]){
        longitude = [[[[geoDico objectForKey:@"viewport"] objectForKey:@"northeast"] objectForKey:@"lng"] doubleValue];
        latitude = [[[[geoDico objectForKey:@"viewport"] objectForKey:@"northeast"] objectForKey:@"lat"] doubleValue];
        
        geometry.viewportNE = CLLocationCoordinate2DMake(latitude, longitude);
        
        longitude = [[[[geoDico objectForKey:@"viewport"] objectForKey:@"southwest"] objectForKey:@"lng"] doubleValue];
        latitude = [[[[geoDico objectForKey:@"viewport"] objectForKey:@"southwest"] objectForKey:@"lat"] doubleValue];
        
        geometry.viewportSW = CLLocationCoordinate2DMake(latitude, longitude);
    }
    
    if ([[geoDico allKeys] containsObject:@"bounds"]){
        longitude = [[[[geoDico objectForKey:@"bounds"] objectForKey:@"northeast"] objectForKey:@"lng"] doubleValue];
        latitude = [[[[geoDico objectForKey:@"bounds"] objectForKey:@"northeast"] objectForKey:@"lat"] doubleValue];
        
        geometry.boundsNE = CLLocationCoordinate2DMake(latitude, longitude);
        
        longitude = [[[[geoDico objectForKey:@"bounds"] objectForKey:@"southwest"] objectForKey:@"lng"] doubleValue];
        latitude = [[[[geoDico objectForKey:@"bounds"] objectForKey:@"southwest"] objectForKey:@"lat"] doubleValue];
        
        geometry.boundsSW = CLLocationCoordinate2DMake(latitude, longitude);
    }
    return geometry;
}

-(void)dealloc{
    
    [super dealloc];
}

@end

