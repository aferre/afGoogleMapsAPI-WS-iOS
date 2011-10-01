//
//  afGMapsPlaceReportRequest.h
//  afGMDemo
//
//  Created by adrien ferré on 01/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsPlacesRequest.h"

@protocol afGoogleMapsPlaceReportDelegate;

@interface afGMapsPlaceReportRequest : afGMapsPlacesRequest {
    id<afGoogleMapsPlaceReportDelegate>  afDelegate;
    
}

@property (nonatomic,assign) id<afGoogleMapsPlaceReportDelegate> afDelegate;

@end

@protocol afGoogleMapsPlaceReportDelegate <NSObject>
@optional

@end