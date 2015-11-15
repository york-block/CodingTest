//
//  Weather.m
//  WestPacWeather
//
//  Created by York Block on 11/14/15.
//  Copyright © 2015 BlockEmbedded. All rights reserved.
//

#import "Weather.h"

NSString * const WeatherCurrentSummaryKey = @"currently.summary";
NSString * const WeatherCurrentIconKey = @"currently.icon";
NSString * const WeatherCurrentTemperatureKey = @"currently.temperature";

NSString * const WeatherIconClearDayValue = @"clear-day";
NSString * const WeatherIconClearNightValue = @"clear-night";
NSString * const WeatherIconRainValue = @"rain";
NSString * const WeatherIconSnowValue = @"snow";
NSString * const WeatherIconSleetValue = @"sleet";
NSString * const WeatherIconWindValue = @"wind";
NSString * const WeatherIconFogValue = @"fog";
NSString * const WeatherIconCloudyValue = @"cloudy";
NSString * const WeatherIconPartlyCloudyDayValue = @"partly-cloudy-day";
NSString * const WeatherIconPartlyCloudyNightValue = @"partly-cloudy-night";

static NSString * const ForecastURL = @"https://api.forecast.io/forecast";
static NSString * const ForecastAPIKey = @"88508f0f321c3826c655bbedee8a9cd8";

@interface Weather ()

@property (nonatomic, strong) NSDictionary *forecast;

@end

@implementation Weather

- (void)retrieveForecastForLocation:(CLLocation *)location withCompletionBlock:(void (^)(NSError *error, NSDictionary *forecast))completionBlock {
    if (!location) {
        NSError *error = [NSError errorWithDomain:@"Location nil" code:100 userInfo:@{NSLocalizedDescriptionKey: @"Location cannot be nil"}];
        completionBlock(error, nil);
        return;
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[self urlForForecastInLocation:location]
            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
            completionBlock(error, nil);
        } else {
            NSError *error;
            [self setForecast:[NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingAllowFragments
                                                                error:&error]];
            if (error) {
                NSLog(@"Error: %@", [error localizedDescription]);
                completionBlock(error, nil);
            } else {
                NSLog(@"%@ %@ %@", [[self forecast] valueForKeyPath:@"currently.summary"], [[self forecast]  valueForKeyPath:@"currently.icon"], [[self forecast]  valueForKeyPath:@"currently.temperature"]);
                completionBlock(nil, [self forecast] );
            }
        }
    }] resume];
}

- (NSURL *)urlForForecastInLocation:(CLLocation *)location {
    NSString *loc = [NSString stringWithFormat:@"%f,%f", [location coordinate].latitude, [location coordinate].longitude];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", ForecastURL, ForecastAPIKey, loc]];
    NSLog(@"%@", [NSString stringWithFormat:@"%@/%@/%@", ForecastURL, ForecastAPIKey, loc]);

    return url;
}

@end
