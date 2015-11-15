//
//  Weather.h
//  WestPacWeather
//
//  Created by York Block on 11/14/15.
//  Copyright © 2015 BlockEmbedded. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString * const WeatherCurrentSummaryKey;
extern NSString * const WeatherCurrentIconKey;
extern NSString * const WeatherCurrentTemperatureKey;

extern NSString * const WeatherIconClearDayValue;
extern NSString * const WeatherIconClearNightValue;
extern NSString * const WeatherIconRainValue;
extern NSString * const WeatherIconSnowValue;
extern NSString * const WeatherIconSleetValue;
extern NSString * const WeatherIconWindValue;
extern NSString * const WeatherIconFogValue;
extern NSString * const WeatherIconCloudyValue;
extern NSString * const WeatherIconPartlyCloudyDayValue;
extern NSString * const WeatherIconPartlyCloudyNightValue;

@interface Weather : NSObject

- (void)retrieveForecastForLocation:(CLLocation *)location withCompletionBlock:(void (^)(NSError *error, NSDictionary *forecast))completionBlock;

@end
