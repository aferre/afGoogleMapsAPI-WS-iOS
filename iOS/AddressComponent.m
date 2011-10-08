//
//  AddressComponent.m
//  afGMDemo
//
//  Created by adrien ferré on 02/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "AddressComponent.h"

@implementation AddressComponent

@synthesize componentTypes,longName,shortName;

-(void)dealloc{
    [longName release];
    longName = nil;
    [shortName release];
    shortName = nil;
    [componentTypes release];
    componentTypes = nil;
    
    [super dealloc];
}

SYNTHESIZE_ENUM(AddressComponentType)

+ (AddressComponent *) parseJsonDico:(NSDictionary *)jsonDico{
    AddressComponent *addressComp = [[[AddressComponent alloc] init] autorelease];
    NSString *longName = [[jsonDico objectForKey:@"long_name"] copy];
    NSString *shortName = [[jsonDico objectForKey:@"short_name"] copy];
    NSArray *typesStringArray = [jsonDico objectForKey:@"types"];
    NSMutableArray *typesArray = [NSMutableArray arrayWithCapacity:[typesStringArray count]];
    
    for (NSString *type in typesStringArray){
        NSNumber *addressTypeNumber = [NSNumber numberWithInt:[AddressComponent AddressComponentTypeFromString:type]];
        [typesArray addObject:addressTypeNumber];
    }
    
    addressComp.longName = longName;
    [longName release];
    
    addressComp.shortName = shortName;
    [shortName release];
    NSArray *ar = [[NSArray alloc] initWithArray:typesArray];
    addressComp.componentTypes = ar;
    [ar release]; 
    return addressComp;
}
@end

