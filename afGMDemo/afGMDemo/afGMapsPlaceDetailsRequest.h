//
//  afGMapsPlaceDetailsRequest.h
//  afGMDemo
//
//  Created by adrien ferré on 01/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsPlacesRequest.h"

@protocol afGoogleMapsPlaceDetailsDelegate;

@interface afGMapsPlaceDetailsRequest : afGMapsPlacesRequest

@property (nonatomic,assign) id<afGoogleMapsPlaceDetailsDelegate> afDelegate;

@end

@protocol afGoogleMapsPlaceDetailsDelegate <NSObject>
@optional

@end