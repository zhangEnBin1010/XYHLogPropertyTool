

#import <JSONModel/JSONModel.h>

@class Mainmodel,Coordmodel,Windmodel,Sysmodel,Cloudsmodel;
@protocol Weathermodel;
//dictionary

@interface ResponseModel : JSONModel

@property (copy, nonatomic) NSString <Optional>*base;      //from:  
@property (strong, nonatomic) NSNumber <Optional>*id;      //from:  
@property (strong, nonatomic) NSNumber <Optional>*dt;      //from:  
@property (strong, nonatomic) Mainmodel <Optional>*main;      //from:  
@property (strong, nonatomic) Coordmodel <Optional>*coord;      //from:  
@property (strong, nonatomic) Windmodel <Optional>*wind;      //from:  
@property (strong, nonatomic) Sysmodel <Optional>*sys;      //from:  
@property (strong, nonatomic) NSArray <Weathermodel>*weather;      //from:  
@property (strong, nonatomic) NSNumber <Optional>*visibility;      //from:  
@property (strong, nonatomic) Cloudsmodel <Optional>*clouds;      //from:  
@property (strong, nonatomic) NSNumber <Optional>*cod;      //from:  
@property (copy, nonatomic) NSString <Optional>*name;      //from:  

@end

//object:  coord
//dictionary

@interface CoordModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*lon;      //from:  coord
@property (strong, nonatomic) NSNumber <Optional>*lat;      //from:  coord

@end

//object:  main
//dictionary

@interface MainModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*humidity;      //from:  main
@property (strong, nonatomic) NSNumber <Optional>*temp_max;      //from:  main
@property (strong, nonatomic) NSNumber <Optional>*temp_min;      //from:  main
@property (strong, nonatomic) NSNumber <Optional>*temp;      //from:  main
@property (strong, nonatomic) NSNumber <Optional>*pressure;      //from:  main

@end

//object:  wind
//dictionary

@interface WindModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*speed;      //from:  wind
@property (strong, nonatomic) NSNumber <Optional>*deg;      //from:  wind

@end

//object:  sys
//dictionary

@interface SysModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*id;      //from:  sys
@property (strong, nonatomic) NSNumber <Optional>*message;      //from:  sys
@property (copy, nonatomic) NSString <Optional>*country;      //from:  sys
@property (strong, nonatomic) NSNumber <Optional>*type;      //from:  sys
@property (strong, nonatomic) NSNumber <Optional>*sunset;      //from:  sys
@property (strong, nonatomic) NSNumber <Optional>*sunrise;      //from:  sys

@end

//object:  clouds
//dictionary

@interface CloudsModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*all;      //from:  clouds

@end

//object:  weather
//array
//dictionary

@interface WeatherModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*id;      //from:  weather
@property (copy, nonatomic) NSString <Optional>*main;      //from:  weather
@property (copy, nonatomic) NSString <Optional>*icon;      //from:  weather
@property (copy, nonatomic) NSString <Optional>*description;      //from:  weather

@end
