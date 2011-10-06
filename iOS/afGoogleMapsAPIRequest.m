//
//  GoogleMapsWS.m
//  g2park
//
//  Created by adrien ferré on 20/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGoogleMapsAPIRequest.h"

@implementation afGoogleMapsAPIRequest

@synthesize useHTTPS,format,useSensor,region,language,jsonResult;

#pragma mark ------------------------------------------
#pragma mark ------ INIT
#pragma mark ------------------------------------------

- (id) initDefault{
    self = [super initWithURL:[NSURL URLWithString:@"http://www.google.fr"]];
    
    if (self){
        useSensor = NO;
        useHTTPS = NO;
        format = ReturnJSON;
        region = ccTLD_DEFAULT;
        language = LangDEFAULT;
    }
    return self;
}

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
#pragma mark ------------------------------------------
#pragma mark ------ Helpers
#pragma mark ------------------------------------------

+(NSString *) travelMode:(TravelMode) travelMode{
    switch (travelMode) {
        case TravelModeDriving:
            return @"driving";
            break;
        case TravelModeWalking:
            return @"walking";
            break;
        case TravelModeBicycling:
            return @"bicycling";
            break;
        default:
            return @"driving";
            break;
    }
    return @"driving";
}

+(NSString *) avoidMode:(AvoidMode) avoidMode{
    switch (avoidMode) {
        case AvoidModeHighway:
            return @"highways";
            break;
        case AvoidModeTolls:
            return @"tolls";
            break;
        default:
            return @"";
            break;
    }
    return @"";
}

#pragma mark ------------------------------------------
#pragma mark ------ Language and region support
#pragma mark ------------------------------------------

+(NSString *) regionCode:(RC) rc{
    
    switch (rc) {
            
        case ccTLD_Ascension_Island:{
            return @"ac";
        }break;
        case ccTLD_Andorra:
        {
            return @"ad";
        }break;
        case ccTLD_United_Arab_Emirates:{
            return @"ae";
        }break;
        case ccTLD_Afghanistan:{
            return @"af";
        }break;
        case ccTLD_Antigua_and_Barbuda:{
            return @"ag";
        }break;
        case ccTLD_Anguilla:{
            return @"ai";
        }break;
        case ccTLD_Albania:{
            return @"al";
        }break;
        case ccTLD_Armenia:{
            return @"am";
        }break;
        case ccTLD_Netherlands_Antilles:{
            return @"an";
        }break;
        case ccTLD_Angola:{
            return @"ao";
        }break;
        case ccTLD_Antarctica:{
            return @"aq";
        }break;
        case ccTLD_Argentina:{
            return @"ar";
        }break;
        case ccTLD_American_Samoa:{
            return @"as";
        }break;
        case ccTLD_Austria:{
            return @"at";
        }break;
        case ccTLD_Australia:{
            return @"au";
        }break;
        case ccTLD_Aruba:{
            return @"aw";
        }break;
        case ccTLD_Aland:{
            return @"ax";
        }break;
        case ccTLD_Azerbaijan:{
            return @"az";
        }break;
        case ccTLD_Bosnia_and_Herzegovina:{
            return @"ba";
        }break;
        case ccTLD_Barbados:{
            return @"bb";
        }break;
        case ccTLD_Bangladesh:{
            return @"bd";
        }break;
        case ccTLD_Belgium:{
            return @"be";
        }break;
        case ccTLD_Burkina_Faso:{
            return @"bf";
        }break;
        case ccTLD_Bulgaria:{
            return @"bg";
        }break;
        case ccTLD_Bahrain:{
            return @"bh";
        }break;
        case ccTLD_Burundi:{
            return @"bi";
        }break;
        case ccTLD_Benin:{
            return @"bj";
        }break;
        case ccTLD_Bermuda:{
            return @"bm";
        }break;
        case ccTLD_Brunei_Darussalam:{
            return @"bn";
        }break;
        case ccTLD_Bolivia:{
            return @"bo";
        }break;
        case ccTLD_Brazil:{
            return @"br";
        }break;
        case ccTLD_Bahamas:{
            return @"bs";
        }break;
        case ccTLD_Bhutan:{
            return @"bt";
        }break;
        case ccTLD_Bouvet_Island:{
            return @"bv";
        }break;
        case ccTLD_Botswana:{
            return @"bw";
        }break;
        case ccTLD_Belarus:{
            return @"by";
        }break;
        case ccTLD_Belize:{
            return @"bz";
        }break;
        case ccTLD_Canada:{
            return @"ca";
        }break;
        case ccTLD_Cocos_Islands:{
            return @"cc";
        }break;
        case ccTLD_Democratic_Republic_of_the_Congo:{
            return @"cd";
        }break;
        case ccTLD_Central_African_Republic:{
            return @"cf";
        }break;
        case ccTLD_Republic_of_the_Congo:{
            return @"cg";
        }break;
        case ccTLD_Switzerland:{
            return @"ch";
        }break;
        case ccTLD_Cote_d_Ivoire:{
            return @"ci";
        }break;
        case ccTLD_Cook_Islands:{
            return @"ck";
        }break;
        case ccTLD_Chile:{
            return @"cl";
        }break;
        case ccTLD_Cameroon:{
            return @"cm";
        }break;
        case ccTLD_People_s_Republic_of_China:{
            return @"cn";
        }break;
        case ccTLD_Colombia:{
            return @"co";
        }break;
        case ccTLD_Costa_Rica:{
            return @"cr";
        }break;
        case ccTLD_Czechoslovakia:{
            return @"cs";
        }break;
        case ccTLD_Cuba:{
            return @"cu";
        }break;
        case ccTLD_Cape_Verde:{
            return @"cv";
        }break;
        case ccTLD_Christmas_Island:{
            return @"cx";
        }break;
        case ccTLD_Cyprus:{
            return @"cy";
        }break;
        case ccTLD_Czech_Republic:{
            return @"cz";
        }break;
        case ccTLD_Germany:{
            return @"de";
        }break;
        case ccTLD_Djibouti:{
            return @"dj";
        }break;
        case ccTLD_Denmark:{
            return @"dk";
        }break;
        case ccTLD_Dominica:{
            return @"dm";
        }break;
        case ccTLD_Dominican_Republic:{
            return @"do";
        }break;
        case ccTLD_Algeria:{
            return @"dz";
        }break;
        case ccTLD_Ecuador:{
            return @"ec";
        }break;
        case ccTLD_Estonia:{
            return @"ee";
        }break;
        case ccTLD_Egypt:{
            return @"eg";
        }break;
        case ccTLD_Eritrea:{
            return @"er";
        }break;
        case ccTLD_Spain:{
            return @"es";
        }break;
        case ccTLD_Ethiopia:{
            return @"et";
        }break;
        case ccTLD_European_Union:{
            return @"eu";
        }break;
        case ccTLD_Finland:{
            return @"fi";
        }break;
        case ccTLD_Fiji:{
            return @"fj";
        }break;
        case ccTLD_Falkland_Islands:{
            return @"fk";
        }break;
        case ccTLD_Federated_States_of_Micronesia:{
            return @"fm";
        }break;
        case ccTLD_Faroe_Islands:{
            return @"fo";
        }break;
        case ccTLD_France:{
            return @"fr";
        }break;
        case ccTLD_Gabon:{
            return @"ga";
        }break;
        case ccTLD_United_Kingdom:{
            return @"gb";
        }break;
        case ccTLD_Grenada:{
            return @"gd";
        }break;
        case ccTLD_Georgia:{
            return @"ge";
        }break;
        case ccTLD_French_Guiana:{
            return @"gf";
        }break;
        case ccTLD_Guernsey:{
            return @"gg";
        }break;
        case ccTLD_Ghana:{
            return @"gh";
        }break;
        case ccTLD_Gibraltar:{
            return @"gi";
        }break;
        case ccTLD_Greenland:{
            return @"gl";
        }break;
        case ccTLD_The_Gambia:{
            return @"gm";
        }break;
        case ccTLD_Guinea:{
            return @"gn";
        }break;
        case ccTLD_Guadeloupe:{
            return @"gp";
        }break;
        case ccTLD_Equatorial_Guinea:{
            return @"gq";
        }break;
        case ccTLD_Greece:{
            return @"gr";
        }break;
        case ccTLD_South_Georgia_and_the_South_Sandwich_Islands:{
            return @"gs";
        }break;
        case ccTLD_Guatemala:{
            return @"gt";
        }break;
        case ccTLD_Guam:{
            return @"gu";
        }break;
        case ccTLD_Guinea_Bissau:{
            return @"gw";
        }break;
        case ccTLD_Guyana:{
            return @"gy";
        }break;
        case ccTLD_Hong_Kong:{
            return @"hk";
        }break;
        case ccTLD_Heard_Island_and_McDonald_Islands:{
            return @"hm";
        }break;
        case ccTLD_Honduras:{
            return @"hn";
        }break;
        case ccTLD_Croatia:{
            return @"hr";
        }break;
        case ccTLD_Haiti:{
            return @"ht";
        }break;
        case ccTLD_Hungary:{
            return @"hu";
        }break;
        case ccTLD_Indonesia:{
            return @"id";
        }break;
        case ccTLD_Ireland:{
            return @"ie";
        }break;
        case ccTLD_Israel:{
            return @"il";
        }break;
        case ccTLD_Isle_of_Man:{
            return @"im";
        }break;
        case ccTLD_India:{
            return @"in";
        }break;
        case ccTLD_British_Indian_Ocean_Territory:{
            return @"io";
        }break;
        case ccTLD_Iraq:{
            return @"iq";
        }break;
        case ccTLD_Iran:{
            return @"ir";
        }break;
        case ccTLD_Iceland:{
            return @"is";
        }break;
        case ccTLD_Italy:{
            return @"it";
        }break;
        case ccTLD_Jersey:{
            return @"je";
        }break;
        case ccTLD_Jamaica:{
            return @"jm";
        }break;
        case ccTLD_Jordan:{
            return @"jo";
        }break;
        case ccTLD_Japan:{
            return @"jp";
        }break;
        case ccTLD_Kenya:{
            return @"ke";
        }break;
        case ccTLD_Kyrgyzstan:{
            return @"kg";
        }break;
        case ccTLD_Cambodia:{
            return @"kh";
        }break;
        case ccTLD_Kiribati:{
            return @"ki";
        }break;
        case ccTLD_Comoros:{
            return @"km";
        }break;
        case ccTLD_Saint_Kitts_and_Nevis:{
            return @"kn";
        }break;
        case ccTLD_Democratic_People_s_Republic_of_Korea:{
            return @"kp";
        }break;
        case ccTLD_Republic_of_Korea:{
            return @"kr";
        }break;
        case ccTLD_Kuwait:{
            return @"kw";
        }break;
        case ccTLD_Cayman_Islands:{
            return @"ky";
        }break;
        case ccTLD_Kazakhstan:{
            return @"kz";
        }break;
        case ccTLD_Laos:{
            return @"la";
        }break;
        case ccTLD_Lebanon:{
            return @"lb";
        }break;
        case ccTLD_Saint_Lucia:{
            return @"lc";
        }break;
        case ccTLD_Liechtenstein:{
            return @"li";
        }break;
        case ccTLD_Sri_Lanka:{
            return @"lk";
        }break;
        case ccTLD_Liberia:{
            return @"lr";
        }break;
        case ccTLD_Lesotho:{
            return @"ls";
        }break;
        case ccTLD_Lithuania:{
            return @"lt";
        }break;
        case ccTLD_Luxembourg:{
            return @"lu";
        }break;
        case ccTLD_Latvia:{
            return @"lv";
        }break;
        case ccTLD_Libya:{
            return @"ly";
        }break;
        case ccTLD_Morocco:{
            return @"ma";
        }break;
        case ccTLD_Monaco:{
            return @"mc";
        }break;
        case ccTLD_Moldova:{
            return @"md";
        }break;
        case ccTLD_Montenegro:{
            return @"me";
        }break;
        case ccTLD_Madagascar:{
            return @"mg";
        }break;
        case ccTLD_Marshall_Islands:{
            return @"mh";
        }break;
        case ccTLD_Republic_of_Macedonia:{
            return @"mk";
        }break;
        case ccTLD_Mali:{
            return @"ml";
        }break;
        case ccTLD_Myanmar:{
            return @"mm";
        }break;
        case ccTLD_Mongolia:{
            return @"mn";
        }break;
        case ccTLD_Macau:{
            return @"mo";
        }break;
        case ccTLD_Northern_Mariana_Islands:{
            return @"mp";
        }break;
        case ccTLD_Martinique:{
            return @"mq";
        }break;
        case ccTLD_Mauritania:{
            return @"mr";
        }break;
        case ccTLD_Montserrat:{
            return @"ms";
        }break;
        case ccTLD_Malta:{
            return @"mt";
        }break;
        case ccTLD_Mauritius:{
            return @"mu";
        }break;
        case ccTLD_Maldives:{
            return @"mv";
        }break;
        case ccTLD_Malawi:{
            return @"mw";
        }break;
        case ccTLD_Mexico:{
            return @"mx";
        }break;
        case ccTLD_Malaysia:{
            return @"my";
        }break;
        case ccTLD_Mozambique:{
            return @"mz";
        }break;
        case ccTLD_Namibia:{
            return @"na";
        }break;
        case ccTLD_New_Caledonia:{
            return @"nc";
        }break;
        case ccTLD_Niger:{
            return @"ne";
        }break;
        case ccTLD_Norfolk_Island:{
            return @"nf";
        }break;
        case ccTLD_Nigeria:{
            return @"ng";
        }break;
        case ccTLD_Nicaragua:{
            return @"ni";
        }break;
        case ccTLD_Netherlands:{
            return @"nl";
        }break;
        case ccTLD_Norway:{
            return @"no";
        }break;
        case ccTLD_Nepal:{
            return @"np";
        }break;
        case ccTLD_Nauru:{
            return @"nr";
        }break;
        case ccTLD_Niue:{
            return @"nu";
        }break;
        case ccTLD_New_Zealand:{
            return @"nz";
        }break;
        case ccTLD_Oman:{
            return @"om";
        }break;
        case ccTLD_Panama:{
            return @"pa";
        }break;
        case ccTLD_Peru:{
            return @"pe";
        }break;
        case ccTLD_French_Polynesia:{
            return @"pf";
        }break;
        case ccTLD_Papua_New_Guinea:{
            return @"pg";
        }break;
        case ccTLD_Philippines:{
            return @"ph";
        }break;
        case ccTLD_Pakistan:{
            return @"pk";
        }break;
        case ccTLD_Poland:{
            return @"pl";
        }break;
        case ccTLD_Saint_Pierre_and_Miquelon:{
            return @"pm";
        }break;
        case ccTLD_Pitcairn_Islands:{
            return @"pn";
        }break;
        case ccTLD_Puerto_Rico:{
            return @"pr";
        }break;
        case ccTLD_Palestinian_territories:{
            return @"ps";
        }break;
        case ccTLD_Portugal:{
            return @"pt";
        }break;
        case ccTLD_Palau:{
            return @"pw";
        }break;
        case ccTLD_Paraguay:{
            return @"py";
        }break;
        case ccTLD_Qatar:{
            return @"qa";
        }break;
        case ccTLD_Reunion:{
            return @"re";
        }break;
        case ccTLD_Romania:{
            return @"ro";
        }break;
        case ccTLD_Serbia:{
            return @"rs";
        }break;
        case ccTLD_Russia:{
            return @"ru";
        }break;
        case ccTLD_Rwanda:{
            return @"rw";
        }break;
        case ccTLD_Saudi_Arabia:{
            return @"sa";
        }break;
        case ccTLD_Solomon_Islands:{
            return @"sb";
        }break;
        case ccTLD_Seychelles:{
            return @"sc";
        }break;
        case ccTLD_Sudan:{
            return @"sd";
        }break;
        case ccTLD_Sweden:{
            return @"se";
        }break;
        case ccTLD_Singapore:{
            return @"sg";
        }break;
        case ccTLD_Saint_Helena:{
            return @"sh";
        }break;
        case ccTLD_Slovenia:{
            return @"si";
        }break;
        case ccTLD_Svalbard_and_Jan_Mayen_Islands:{
            return @"sj";
        }break;
        case ccTLD_Slovakia:{
            return @"sk";
        }break;
        case ccTLD_Sierra_Leone:{
            return @"sl";
        }break;
        case ccTLD_San_Marino:{
            return @"sm";
        }break;
        case ccTLD_Senegal:{
            return @"sn";
        }break;
        case ccTLD_Somalia:{
            return @"so";
        }break;
        case ccTLD_Suriname:{
            return @"sr";
        }break;
        case ccTLD_Sao_Tome_and_Principe:{
            return @"st";
        }break;
        case ccTLD_Soviet_Union:{
            return @"su";
        }break;
        case ccTLD_El_Salvador:{
            return @"sv";
        }break;
        case ccTLD_Syria:{
            return @"sy";
        }break;
        case ccTLD_Swaziland:{
            return @"sz";
        }break;
        case ccTLD_Turks_and_Caicos_Islands:{
            return @"tc";
        }break;
        case ccTLD_Chad:{
            return @"td";
        }break;
        case ccTLD_French_Souther_and_Antarctic_Lands:{
            return @"tf";
        }break;
        case ccTLD_Togo:{
            return @"tg";
        }break;
        case ccTLD_Thailand:{
            return @"th";
        }break;
        case ccTLD_Tajikistan:{
            return @"tj";
        }break;
        case ccTLD_Tokelau:{
            return @"tk";
        }break;
        case ccTLD_East_Timor:{
            return @"tl";
        }break;
        case ccTLD_Turkmenistan:{
            return @"tm";
        }break;
        case ccTLD_Tunisia:{
            return @"tn";
        }break;
        case ccTLD_Tonga:{
            return @"to";
        }break;
        case ccTLD_Turkey:{
            return @"tr";
        }break;
        case ccTLD_Trinidad_and_Tobago:{
            return @"tt";
        }break;
        case ccTLD_Tuvalu:{
            return @"tv";
        }break;
        case ccTLD_Taiwan:{
            return @"tw";
        }break;
        case ccTLD_Tanzania:{
            return @"tz";
        }break;
        case ccTLD_Ukraine:{
            return @"ua";
        }break;
        case ccTLD_Uganda:{
            return @"ug";
        }break;
        case ccTLD_United_States_of_America:{
            return @"uk";
        }break;
        case ccTLD_Uruguay:{
            return @"uy";
        }break;
        case ccTLD_Uzbekistan:{
            return @"uz";
        }break;
        case ccTLD_Vatican_City:{
            return @"va";
        }break;
        case ccTLD_Saint_Vincent_and_the_Grenadines:{
            return @"vc";
        }break;
        case ccTLD_Venezuela:{
            return @"ve";
        }break;
        case ccTLD_British_Virgin_Islands:{
            return @"vg";
        }break;
        case ccTLD_U_S_Virgin_Islands:{
            return @"vi";
        }break;
        case ccTLD_Vietnam:{
            return @"vn";
        }break;
        case ccTLD_Vanuatu:{
            return @"vu";
        }break;
        case ccTLD_Wallis_and_Futuna:{
            return @"wf";
        }break;
        case ccTLD_Samoa:{
            return @"ws";
        }break;
        case ccTLD_Yemen:{
            return @"ye";
        }break;
        case ccTLD_Mayotte:{
            return @"yt";
        }break;
        case ccTLD_South_Africa:{
            return @"za";
        }break;
        case ccTLD_Zambia:{
            return @"zm";
        }break;
        case ccTLD_Zimbabwe:{
            return @"zw";
        }break;
    }
    return @"";
}

+(NSString *) languageCode:(Language) ln{
    switch (ln) {
        case LangDEFAULT:
        {
            return @"en";
        }
            break;
        case LangARABIC:
        {
            return @"ar";
        }
            break;
        case LangBASQUE:
        {
            return @"eu";
        }
            break;
        case LangBULGARIAN:
        {
            return @"bg";
        }
            break;
        case  LangBENGALI:
        {
            return @"bn";
        }
            break;
        case  LangCATALAN:
        {
            return @"ca";
        }
            break;
        case LangCZECH:
        {
            return @"cs";
        }
            break;
        case LangDANISH:
        {
            return @"da";
        }
            break;
        case  LangGERMAN:
        {
            return @"de";
        }
            break;
        case  LangGREEK:
        {
            return @"el";
        }
            break;
        case LangENGLISH:
        {
            return @"en";
        }
            break;
        case LangENGLISH_AUSTRALIAN:
        {
            return @"en-AU";
        }
            break;
        case LangENGLISH_GREAT_BRITAIN:
        {
            return @"en-GB";
        }
            break;
        case LangSPANISH:
        {
            return @"es";
        }
            break;
        case LangFARSI:
        {
            return @"fa";
        }
            break;
        case LangFINNISH:
        {
            return @"fi";
        }
            break;
        case LangFILIPINO:
        {
            return @"fil";
        }
            break;
        case LangFRENCH:
        {
            return @"fr";
        }
            break;
        case 
        LangGALICIAN:
        {
            return @"gl";
        }
            break;
        case 
        LangGUJARATI:
        {
            return @"gu";
        }
            break;
        case 
        LangHINDI:
        {
            return @"hi";
        }
            break;
        case 
        LangCROATIAN:
        {
            return @"hr";
        }
            break;
        case 
        LangHUNGARIAN:
        {
            return @"hu";
        }
            break;
        case 
        LangINDONESIAN:
        {
            return @"id";
        }
            break;
        case 
        LangITALIAN:
        {
            return @"it";
        }
            break;
        case 
        LangHEBREW:
        {
            return @"iw";
        }
            break;
        case 
        LangJAPANESE:
        {
            return @"ja";
        }
            break;
        case 
        LangKANNADA:
        {
            return @"kn";
        }
            break;
        case 
        LangKOREAN:
        {
            return @"ko";
        }
            break;
        case 
        LangLITHUANIAN:
        {
            return @"lt";
        }
            break;
        case 
        LangLATVIAN:
        {
            return @"lv";
        }
            break;
        case 
        LangMALAYALAM:
        {
            return @"ml";
        }
            break;
        case 
        LangMARATHI:
        {
            return @"mr";
        }
            break;
        case 
        LangDUTCH:
        {
            return @"nl";
        }
            break;
        case 
        LangNORWEGIAN:
        {
            return @"no";
        }
            break;
        case 
        LangPOLISH:
        {
            return @"pl";
        }
            break;
        case 
        LangPORTUGUESE:
        {
            return @"pt";
        }
            break;
        case 
        LangPORTUGUESE_BRAZIL:
        {
            return @"pt-BR";
        }
            break;
        case 
        LangPORTUGUESE_PORTUGAL:
        {
            return @"pt-PT";
        }
            break;
        case 
        LangROMANIAN:
        {
            return @"ro";
        }
            break;
        case 
        LangRUSSIAN:
        {
            return @"ru";
        }
            break;
        case 
        LangSLOVAK:
        {
            return @"sk";
        }
            break;
        case 
        LangSLOVENIAN:
        {
            return @"sl";
        }
            break;
        case 
        LangSERBIAN:
        {
            return @"sr";
        }
            break;
        case 
        LangSWEDISH:
        {
            return @"sv";
        }
            break;
        case 
        LangTAGALOG:
        {
            return @"tl";
        }
            break;
        case 
        LangTAMIL:
        {
            return @"ta";
        }
            break;
        case 
        LangTELUGU:
        {
            return @"te";
        }
            break;
        case LangTHAI:
        {
            return @"th";
        }
            break;
        case LangTURKISH:
        {
            return @"tr";
        }
            break;
        case LangUKRAINIAN:
        {
            return @"uk";
        }
            break;
        case LangVIETNAMESE:
        {
            return @"vi";
        }
            break;
        case LangCHINESE_SIMPLIFIED:
        {
            return @"zh-CN";
        }
            break;
        case LangCHINESE_TRADITIONAL:
        {
            return @"zh-TW";
        }
            break;
            
    }
    return @"";
}

-(NSString *) makeURLStringWithServicePrefix:(NSString *)servicePrefix{
    
    NSString *rootURL = [self getURLString];
    
    rootURL = [rootURL stringByAppendingFormat:@"%@",servicePrefix];
    
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

-(NSURL *) finalizeURLString:(NSString *)str{
    
    //sensor
    if (useSensor) 
        str = [str stringByAppendingFormat:@"&sensor=true"];
    else
        str = [str stringByAppendingFormat:@"&sensor=false"];
    
    NSString * finalURL = [str stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    finalURL = [finalURL stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSLog(@"URL is %@",finalURL);
    
    return [NSURL URLWithString:finalURL];
}

-(NSError *)errorForService:(NSString *)serviceName type:(NSString *)errorType status:(NSString *)status{
    //json error
    if ([errorType isEqualToString:@"JSON"]){
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:
                                                                      NSLocalizedString(@"GoogleMaps %@ API returned no content",@""),serviceName]
                                                              forKey:NSLocalizedDescriptionKey];
        NSString *dom = [NSString stringWithFormat:@"GoogleMaps %@ API",serviceName];
        return [NSError errorWithDomain:dom code:CUSTOM_ERROR_NUMBER userInfo:errorInfo];
    }
    else if ([errorType isEqualToString:@"GM"]){
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:
                                                                      NSLocalizedString(@"GoogleMaps %@ API returned status code %@",@""),serviceName,
                                                                      status]
                                                              forKey:NSLocalizedDescriptionKey];
        NSString *dom = [NSString stringWithFormat:@"GoogleMaps %@ API",serviceName];
        return [NSError errorWithDomain:dom code:CUSTOM_ERROR_NUMBER userInfo:errorInfo];
    }
    return nil;
}


-(void) dealloc{
    
    if (jsonResult != nil){
        [jsonResult release];
        jsonResult = nil;
    }
    
    [super dealloc];
}

@end

