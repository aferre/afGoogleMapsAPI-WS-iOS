//
//  GoogleMapsWS.h
//  g2park
//
//  Created by adrien ferré on 20/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SBJsonPublic.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define WS_DEBUG YES
#define GOOGLE_API_ROOT_URL_HTTP @"http://maps.googleapis.com/maps/api/"
#define GOOGLE_API_ROOT_URL_HTTPS @"https://maps.googleapis.com/maps/api/"

#define CUSTOM_ERROR_NUMBER 666

typedef enum UnitsSystem { 
    UnitsDefault = 0,
    UnitsMetric,
    UnitsImperial
} UnitsSystem;

typedef enum AvoidMode { 
    AvoidModeHighway = 0,
    AvoidModeTolls,
    AvoidModeNone
} AvoidMode;

typedef enum TravelMode { 
    TravelModeDriving = 0,
    TravelModeWalking,
    TravelModeBicycling,
    TravelModeDefault
} TravelMode;

typedef enum ReturnFormat { 
    ReturnJSON=0,
    ReturnXML
} ReturnFormat;

// See http://en.wikipedia.org/wiki/List_of_Internet_top-level_domains#Country_code_top-level_domains
typedef enum RC{
    ccTLD_Ascension_Island = 0,
    ccTLD_DEFAULT,
    ccTLD_Andorra,
    ccTLD_United_Arab_Emirates,
    ccTLD_Afghanistan,
    ccTLD_Antigua_and_Barbuda,
    ccTLD_Anguilla,
    ccTLD_Albania,
    ccTLD_Armenia,
    ccTLD_Netherlands_Antilles,
    ccTLD_Angola,
    ccTLD_Antarctica,
    ccTLD_Argentina,
    ccTLD_American_Samoa,
    ccTLD_Austria,
    ccTLD_Australia,
    ccTLD_Aruba,
    ccTLD_Aland,
    ccTLD_Azerbaijan,
    ccTLD_Bosnia_and_Herzegovina,
    ccTLD_Barbados,
    ccTLD_Bangladesh,
    ccTLD_Belgium,
    ccTLD_Burkina_Faso,
    ccTLD_Bulgaria,
    ccTLD_Bahrain,
    ccTLD_Burundi,
    ccTLD_Benin,
    ccTLD_Bermuda,
    ccTLD_Brunei_Darussalam,
    ccTLD_Bolivia,
    ccTLD_Brazil,
    ccTLD_Bahamas,
    ccTLD_Bhutan,
    ccTLD_Bouvet_Island,
    ccTLD_Botswana,
    ccTLD_Belarus,
    ccTLD_Belize,
    ccTLD_Canada,
    ccTLD_Cocos_Islands,
    ccTLD_Democratic_Republic_of_the_Congo,
    ccTLD_Central_African_Republic,
    ccTLD_Republic_of_the_Congo,
    ccTLD_Switzerland,
    ccTLD_Cote_d_Ivoire,
    ccTLD_Cook_Islands,
    ccTLD_Chile,
    ccTLD_Cameroon,
    ccTLD_People_s_Republic_of_China,
    ccTLD_Colombia,
    ccTLD_Costa_Rica,
    ccTLD_Czechoslovakia,
    ccTLD_Cuba,
    ccTLD_Cape_Verde,
    ccTLD_Christmas_Island,
    ccTLD_Cyprus,
    ccTLD_Czech_Republic,
    ccTLD_Germany,
    ccTLD_Djibouti,
    ccTLD_Denmark,
    ccTLD_Dominica,
    ccTLD_Dominican_Republic,
    ccTLD_Algeria,
    ccTLD_Ecuador,
    ccTLD_Estonia,
    ccTLD_Egypt,
    ccTLD_Eritrea,
    ccTLD_Spain,
    ccTLD_Ethiopia,
    ccTLD_European_Union,
    ccTLD_Finland,
    ccTLD_Fiji,
    ccTLD_Falkland_Islands,
    ccTLD_Federated_States_of_Micronesia,
    ccTLD_Faroe_Islands,
    ccTLD_France,
    ccTLD_Gabon,
    ccTLD_United_Kingdom,
    ccTLD_Grenada,
    ccTLD_Georgia,
    ccTLD_French_Guiana,
    ccTLD_Guernsey,
    ccTLD_Ghana,
    ccTLD_Gibraltar,
    ccTLD_Greenland,
    ccTLD_The_Gambia,
    ccTLD_Guinea,
    ccTLD_Guadeloupe,
    ccTLD_Equatorial_Guinea,
    ccTLD_Greece,
    ccTLD_South_Georgia_and_the_South_Sandwich_Islands,
    ccTLD_Guatemala,
    ccTLD_Guam,
    ccTLD_Guinea_Bissau,
    ccTLD_Guyana,
    ccTLD_Hong_Kong,
    ccTLD_Heard_Island_and_McDonald_Islands,
    ccTLD_Honduras,
    ccTLD_Croatia,
    ccTLD_Haiti,
    ccTLD_Hungary,
    ccTLD_Indonesia,
    ccTLD_Ireland,
    ccTLD_Israel,
    ccTLD_Isle_of_Man,
    ccTLD_India,
    ccTLD_British_Indian_Ocean_Territory,
    ccTLD_Iraq,
    ccTLD_Iran,
    ccTLD_Iceland,
    ccTLD_Italy,
    ccTLD_Jersey,
    ccTLD_Jamaica,
    ccTLD_Jordan,
    ccTLD_Japan,
    ccTLD_Kenya,
    ccTLD_Kyrgyzstan,
    ccTLD_Cambodia,
    ccTLD_Kiribati,
    ccTLD_Comoros,
    ccTLD_Saint_Kitts_and_Nevis,
    ccTLD_Democratic_People_s_Republic_of_Korea,
    ccTLD_Republic_of_Korea,
    ccTLD_Kuwait,
    ccTLD_Cayman_Islands,
    ccTLD_Kazakhstan,
    ccTLD_Laos,
    ccTLD_Lebanon,
    ccTLD_Saint_Lucia,
    ccTLD_Liechtenstein,
    ccTLD_Sri_Lanka,
    ccTLD_Liberia,
    ccTLD_Lesotho,
    ccTLD_Lithuania,
    ccTLD_Luxembourg,
    ccTLD_Latvia,
    ccTLD_Libya,
    ccTLD_Morocco,
    ccTLD_Monaco,
    ccTLD_Moldova,
    ccTLD_Montenegro,
    ccTLD_Madagascar,
    ccTLD_Marshall_Islands,
    ccTLD_Republic_of_Macedonia,
    ccTLD_Mali,
    ccTLD_Myanmar,
    ccTLD_Mongolia,
    ccTLD_Macau,
    ccTLD_Northern_Mariana_Islands,
    ccTLD_Martinique,
    ccTLD_Mauritania,
    ccTLD_Montserrat,
    ccTLD_Malta,
    ccTLD_Mauritius,
    ccTLD_Maldives,
    ccTLD_Malawi,
    ccTLD_Mexico,
    ccTLD_Malaysia,
    ccTLD_Mozambique,
    ccTLD_Namibia,
    ccTLD_New_Caledonia,
    ccTLD_Niger,
    ccTLD_Norfolk_Island,
    ccTLD_Nigeria,
    ccTLD_Nicaragua,
    ccTLD_Netherlands,
    ccTLD_Norway,
    ccTLD_Nepal,
    ccTLD_Nauru,
    ccTLD_Niue,
    ccTLD_New_Zealand,
    ccTLD_Oman,
    ccTLD_Panama,
    ccTLD_Peru,
    ccTLD_French_Polynesia,
    ccTLD_Papua_New_Guinea,
    ccTLD_Philippines,
    ccTLD_Pakistan,
    ccTLD_Poland,
    ccTLD_Saint_Pierre_and_Miquelon,
    ccTLD_Pitcairn_Islands,
    ccTLD_Puerto_Rico,
    ccTLD_Palestinian_territories,
    ccTLD_Portugal,
    ccTLD_Palau,
    ccTLD_Paraguay,
    ccTLD_Qatar,
    ccTLD_Reunion,
    ccTLD_Romania,
    ccTLD_Serbia,
    ccTLD_Russia,
    ccTLD_Rwanda,
    ccTLD_Saudi_Arabia,
    ccTLD_Solomon_Islands,
    ccTLD_Seychelles,
    ccTLD_Sudan,
    ccTLD_Sweden,
    ccTLD_Singapore,
    ccTLD_Saint_Helena,
    ccTLD_Slovenia,
    ccTLD_Svalbard_and_Jan_Mayen_Islands,
    ccTLD_Slovakia,
    ccTLD_Sierra_Leone,
    ccTLD_San_Marino,
    ccTLD_Senegal,
    ccTLD_Somalia,
    ccTLD_Suriname,
    ccTLD_Sao_Tome_and_Principe,
    ccTLD_Soviet_Union,
    ccTLD_El_Salvador,
    ccTLD_Syria,
    ccTLD_Swaziland,
    ccTLD_Turks_and_Caicos_Islands,
    ccTLD_Chad,
    ccTLD_French_Souther_and_Antarctic_Lands,
    ccTLD_Togo,
    ccTLD_Thailand,
    ccTLD_Tajikistan,
    ccTLD_Tokelau,
    ccTLD_East_Timor,
    ccTLD_Turkmenistan,
    ccTLD_Tunisia,
    ccTLD_Tonga,
    ccTLD_Turkey,
    ccTLD_Trinidad_and_Tobago,
    ccTLD_Tuvalu,
    ccTLD_Taiwan,
    ccTLD_Tanzania,
    ccTLD_Ukraine,
    ccTLD_Uganda,
    ccTLD_United_States_of_America,
    ccTLD_Uruguay,
    ccTLD_Uzbekistan,
    ccTLD_Vatican_City,
    ccTLD_Saint_Vincent_and_the_Grenadines,
    ccTLD_Venezuela,
    ccTLD_British_Virgin_Islands,
    ccTLD_U_S_Virgin_Islands,
    ccTLD_Vietnam,
    ccTLD_Vanuatu,
    ccTLD_Wallis_and_Futuna,
    ccTLD_Samoa,
    ccTLD_Yemen,
    ccTLD_Mayotte,
    ccTLD_South_Africa,
    ccTLD_Zambia,
    ccTLD_Zimbabwe   
}RC;

// See http://code.google.com/intl/fr-FR/apis/maps/faq.html#languagesupport
typedef enum Language { 
    LangDEFAULT = 0,
    LangARABIC,
    LangBASQUE,
    LangBULGARIAN,
    LangBENGALI,
    LangCATALAN,
    LangCZECH,
    LangDANISH,
    LangGERMAN,
    LangGREEK,
    LangENGLISH,
    LangENGLISH_AUSTRALIAN,
    LangENGLISH_GREAT_BRITAIN,
    LangSPANISH,
    LangFARSI,
    LangFINNISH,
    LangFILIPINO,
    LangFRENCH,
    LangGALICIAN,
    LangGUJARATI,
    LangHINDI,
    LangCROATIAN,
    LangHUNGARIAN,
    LangINDONESIAN,
    LangITALIAN,
    LangHEBREW,
    LangJAPANESE,
    LangKANNADA,
    LangKOREAN,
    LangLITHUANIAN,
    LangLATVIAN,
    LangMALAYALAM,
    LangMARATHI,
    LangDUTCH,
    LangNORWEGIAN,
    LangPOLISH,
    LangPORTUGUESE,
    LangPORTUGUESE_BRAZIL,
    LangPORTUGUESE_PORTUGAL,
    LangROMANIAN,
    LangRUSSIAN,
    LangSLOVAK,
    LangSLOVENIAN,
    LangSERBIAN,
    LangSWEDISH,
    LangTAGALOG,
    LangTAMIL,
    LangTELUGU,
    LangTHAI,
    LangTURKISH,
    LangUKRAINIAN,
    LangVIETNAMESE,
    LangCHINESE_SIMPLIFIED,
    LangCHINESE_TRADITIONAL
} Language;

typedef enum LocationType { 
    LocationTypeRooftop = 0,
    LocationTypeRangeInterpolated,
    LocationTypeGeometricCenter,
    LocationTypeApproximate
} LocationType;

@interface afGoogleMapsAPIRequest : ASIHTTPRequest <ASIHTTPRequestDelegate>{
    
    BOOL useHTTPS;
    
    BOOL useSensor;
    
    ReturnFormat format;
    
    Language language;
    
    RC region;
    
    NSDictionary *jsonResult;
}

@property (nonatomic,retain) NSDictionary *jsonResult;
@property (nonatomic,assign) BOOL useHTTPS;
@property (nonatomic,assign) BOOL useSensor;
@property (nonatomic,assign) ReturnFormat format;
@property (nonatomic,assign) RC region;
@property (nonatomic,assign) Language language;

+(NSString *)languageCode:(Language) ln;

+(NSString *)regionCode:(RC) rc;

+(NSString *) travelMode:(TravelMode) travelMode;

+(NSString *) avoidMode:(AvoidMode) avoidMode;

- (NSString *) getURLString;

- (NSURL *) finalizeURLString:(NSString *)str;

- (NSString *) makeURLStringWithServicePrefix:(NSString *)servicePrefix;

-(id) initDefault;

@end
