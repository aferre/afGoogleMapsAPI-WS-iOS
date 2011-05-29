//
//  GoogleMapsWS.m
//  g2park
//
//  Created by adrien ferré on 20/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGoogleMapsAPIRequest.h"

@implementation afGoogleMapsAPIRequest

@synthesize useHTTPS,format,useSensor,resStr;

- (NSString *) getURLString{
    NSMutableString *str = [NSMutableString string];
    
    if (useHTTPS){
        [str appendString:GOOGLE_API_ROOT_URL_HTTPS];
    }
    else{
        [str appendString:GOOGLE_API_ROOT_URL_HTTP];    
    }
    
    return str;
}

-(void) release{
    [resStr release];
    [super release];
}
@end