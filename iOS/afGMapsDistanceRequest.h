//
//  afGoogleMapsDistanceWS.h
//  g2park
//
//  Created by adrien ferré on 29/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "afGoogleMapsAPIRequest.h"

#define GOOGLE_DISTANCE_API_PATH_COMPONENT @"distancematrix"

@protocol afGoogleMapsDistanceDelegate;

@interface afGMapsDistanceRequest : afGoogleMapsAPIRequest {
    
    id <afGoogleMapsDistanceDelegate> afDelegate;
}

@property (nonatomic,assign) id<afGoogleMapsDistanceDelegate> afDelegate;

+(id) distanceForStartingLatitude:(double) slat andLongitude:(double)slng
               withEndingLatitude:(double) elat andLongitude:(double)elng;

- (id) requestDistanceForStartingLatitude:(double) slat andLongitude:(double)slng
                       withEndingLatitude:(double) elat andLongitude:(double)elng;

- (NSString *) getURLString;

- (void) initDefVars;

- (NSURL *) urlDistanceForStartingLatitude:(double) slat andLongitude:(double)slng
                        withEndingLatitude:(double) elat andLongitude:(double)elng;
@end

@protocol afGoogleMapsDistanceDelegate <NSObject>

@optional

-(void) afDistanceWSStarted:(afGMapsDistanceRequest *)ws ;

-(void) afDistanceWS:(afGMapsDistanceRequest *)ws gotDistance:(NSString *) dist;

-(void) afDistanceWSFailed:(afGMapsDistanceRequest *)ws withError:(NSString *)er;

@end