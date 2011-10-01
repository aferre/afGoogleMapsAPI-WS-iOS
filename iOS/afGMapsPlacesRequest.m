//
//  afGMapsPlacesRequest.m
//  afGMDemo
//
//  Created by adrien ferré on 01/06/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsPlacesRequest.h"


@implementation afGMapsPlacesRequest

-(void) dealloc{
    
    [super dealloc];
}

-(NSString *)getURLString{
    
    NSString *rootURL = [super getURLString];
    
    rootURL = [rootURL stringByAppendingFormat:@"place"];
    
    return rootURL;
}

@end
