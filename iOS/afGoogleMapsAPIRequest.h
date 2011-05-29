//
//  GoogleMapsWS.h
//  g2park
//
//  Created by adrien ferré on 20/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"

#define WS_DEBUG YES
#define GOOGLE_API_ROOT_URL_HTTP @"http://maps.googleapis.com/maps/api/"
#define GOOGLE_API_ROOT_URL_HTTPS @"https://maps.googleapis.com/maps/api/"

typedef enum ReturnFormat { 
    USE_JSON =0,
    USE_XML 
} ReturnFormat;

@interface afGoogleMapsAPIRequest : ASIHTTPRequest <ASIHTTPRequestDelegate>{
    
    BOOL useHTTPS;
    BOOL useSensor;
    ReturnFormat format;
    NSMutableString *resStr;
}

@property (nonatomic,assign) BOOL useHTTPS;
@property (nonatomic,assign) BOOL useSensor;
@property (nonatomic,assign) ReturnFormat format;
@property (nonatomic,retain) NSMutableString *resStr;

- (NSString *) getURLString;

@end
