//
//  WeatherViewController.m
//  WestPacWeather
//
//  Created by York Block on 11/14/15.
//  Copyright © 2015 BlockEmbedded. All rights reserved.
//

#import "WeatherViewController.h"
#import "Weather.h"
#import "WeatherView.h"

@interface WeatherViewController () <CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet WeatherView *weatherView;
@property (nonatomic, strong) Weather *weather;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) BOOL isLocationLoaded;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation WeatherViewController

#pragma mark - Model

- (Weather *)weather {
    if (!_weather) {
        _weather = [[Weather alloc] init];
    }
    
    return _weather;
}


#pragma mark - Main Selector

- (void)loadForecastWithLocation:(CLLocation *)location {
    __weak typeof(self) weakSelf = self;
    [[self weather] retrieveForecastForLocation:location withCompletionBlock:^(NSError *error, NSDictionary *forecast) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[weakSelf weatherView] setForecast:forecast];
            [[weakSelf spinner] stopAnimating];
            [[weakSelf weatherView] setHidden:NO];
        });
    }];
}


#pragma mark - Our Location

- (void)queryLocation:(NSNotification *)notification {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        NSLog(@"Enable corelocation first");
        return;
    } else {
        [[self spinner] setHidden:NO];
        [[self spinner] startAnimating];
        
        [self setIsLocationLoaded:NO];
        [[self locationManager] requestLocation];
    }
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
    }
    
    return _locationManager;
}

#pragma mark CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Update location %@", locations);
    CLLocation *location = [locations lastObject];
    if ([self isLocationLoaded] == NO) {
        [self setIsLocationLoaded:YES];
        [self loadForecastWithLocation:location];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Status:%d", status);
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [[self locationManager] requestWhenInUseAuthorization];
            break;
            
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            [self showDisableLocationAlert];
            break;
            
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
    [self setIsLocationLoaded:NO];
    [self loadForecastWithLocation:nil];
}


#pragma mark - NSNotification Center

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryLocation:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cleanBeforeAppResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cleanBeforeAppTerminates:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)cleanBeforeAppResignActive:(NSNotification *)notification {
    [[self weatherView] setHidden:YES];
}

- (void)cleanBeforeAppTerminates:(NSNotification *)notification {
    [self removeNotifications];
}


#pragma mark - Controller lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma  mark - Helpers

- (void)showDisableLocationAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Weather"
                                                                   message:@"Please enable location."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
