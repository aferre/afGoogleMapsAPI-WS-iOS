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

-(id) initDefault{
    
    self = [super initDefault];
    
    if (self){
        self.useHTTPS = YES;
    }
    
    return self;
}

-(NSString *) getURLString{
    
    NSString *rootURL = [super getURLString];
    
    rootURL = [rootURL stringByAppendingFormat:GOOGLE_PLACES_API_PATH_COMPONENT];
    
    return rootURL;
}

-(NSString *) makeURLStringWithServicePrefix:(NSString *)servicePrefix{
    NSString *rootURL = [self getURLString];
    
    rootURL = [rootURL stringByAppendingFormat:@"/%@",servicePrefix];
    
    switch (format) {
        case ReturnXML:
        {
            rootURL = [rootURL stringByAppendingFormat:@"/xml?"];
        }
            break;
        default:
        {
            rootURL = [rootURL stringByAppendingFormat:@"/json?"];
        }
            break;
    }

    return rootURL;
}

-(NSURL *)finalizeURLString:(NSString *)str {
    
    //key
    str = [str stringByAppendingFormat:@"&key=%@",API_KEY];
   
    return [super finalizeURLString:str];
}
@end
