//
//  Place.m
//  afGMDemo
//
//  Created by adrien ferré on 02/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "Place.h"

@implementation Place

@synthesize theid,reference,iconURL,geometry,types,vicinity,name;

+(Place *)parseJsonDico:(NSDictionary *)jsonDico{
    
    Place *p = [[[Place alloc]init]autorelease];
    
    p.theid = [[jsonDico objectForKey:@"id"] copy];
    p.reference = [[jsonDico    objectForKey:@"reference"] copy];
    p.iconURL = [[NSURL alloc] initWithString:[jsonDico objectForKey:@"icon"]];
    p.geometry = [Geometry parseJsonDico:[jsonDico objectForKey:@"geomtery"]];
    p.vicinity = [[jsonDico objectForKey:@"vicinity"] copy];
    p.name = [[jsonDico objectForKey:@"name"] copy];
    p.types = [[jsonDico objectForKey:@"types"] copy];
    return p;
}
@end
