//
//  WeatherView.m
//  WestPacWeather
//
//  Created by York Block on 11/14/15.
//  Copyright © 2015 BlockEmbedded. All rights reserved.
//

#import "WeatherView.h"
#import "Weather.h"

@interface WeatherView ()

@property (nonatomic, weak) IBOutlet UILabel *summaryLabel;
@property (nonatomic, weak) IBOutlet UILabel *weatherIconLabel;
@property (nonatomic, weak) IBOutlet UILabel *temperatureLabel;

@property (nonatomic) BOOL isCelcius;

@end

@implementation WeatherView

#pragma mark - Model

- (void)setForecast:(NSDictionary *)forecast {
    _forecast = forecast;
    
    if (_forecast) {
        [self updateUI];
    } else {
        [self showServiceDown];
    }
}


#pragma mark - UI updates

- (void)updateUI {
    [self updateSummaryLabel];
    [self updateWeatherIconLabel];
    [self updateTemperatureLabel];
}

- (void)updateSummaryLabel {
    [[self summaryLabel] setText:[[self forecast] valueForKeyPath:WeatherCurrentSummaryKey]];
}

- (void)updateWeatherIconLabel {
    NSString *iconValue = [[self forecast] valueForKeyPath:WeatherCurrentIconKey];
    NSString *icon = nil;
    if ([iconValue isEqualToString:WeatherIconClearDayValue]) {
        icon = @"\uf00d";
    } else if ([iconValue isEqualToString:WeatherIconClearNightValue]) {
        icon = @"\uf02e";
    } else if ([iconValue isEqualToString:WeatherIconCloudyValue]) {
        icon = @"\uf041";
    } else if ([iconValue isEqualToString:WeatherIconFogValue]) {
        icon = @"\uf014";
    } else if ([iconValue isEqualToString:WeatherIconPartlyCloudyDayValue]) {
        icon = @"\uf002";
    } else if ([iconValue isEqualToString:WeatherIconPartlyCloudyNightValue]) {
        icon = @"\uf086";
    } else if ([iconValue isEqualToString:WeatherIconRainValue]) {
        icon = @"\uf019";
    } else if ([iconValue isEqualToString:WeatherIconSleetValue]) {
        icon = @"\uf0b2";
    } else if ([iconValue isEqualToString:WeatherIconSnowValue]) {
        icon = @"\uf076";
    } else if ([iconValue isEqualToString:WeatherIconWindValue]) {
        icon = @"\uf011";
    } else {
        icon = @"--";
    }
    
    [[self weatherIconLabel] setText:icon];
}

- (void)updateTemperatureLabel {
    id temperature = [[self forecast] valueForKeyPath:WeatherCurrentTemperatureKey];
    if ([temperature isKindOfClass:[NSNumber class]]) {
        float tempFarenheit = [temperature floatValue];
        float tempCelsius = (tempFarenheit - 32) * 5.0 / 9.0;
        if ([self isCelcius]) {
            [[self temperatureLabel] setText:[NSString stringWithFormat:@"%0.2f \u2103", tempCelsius]];
        } else {
            [[self temperatureLabel] setText:[NSString stringWithFormat:@"%0.2f \u2109", tempFarenheit]];
        }
    } else if ([temperature isKindOfClass:[NSString class]] && [temperature length] > 0){
        [[self temperatureLabel] setText:[NSString stringWithFormat:@"%@ \u2109", temperature]];
    } else {
        [[self temperatureLabel] setText:@"-- \u2103"];
    }
}

- (void)showServiceDown {
    [[self summaryLabel] setText:@"Service Down"];
    [[self weatherIconLabel] setText:@"\uf075"];
    [[self temperatureLabel] setText:@"--"];
}


#pragma mark - Actions

- (IBAction)toggleTemperature:(UITapGestureRecognizer *)tap {
    [self setIsCelcius:![self isCelcius]];
    [self updateTemperatureLabel];
}


@end
