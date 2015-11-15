//
//  WestPacWeatherTests.m
//  WestPacWeatherTests
//
//  Created by York Block on 11/13/15.
//  Copyright © 2015 BlockEmbedded. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Weather.h"

@interface WestPacWeatherTests : XCTestCase

@end

@implementation WestPacWeatherTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRetrieveForecastWithNilLocation {    
    Weather *forecast = [[Weather alloc] init];
    [forecast retrieveForecastForLocation:nil withCompletionBlock:^(NSError *error, NSDictionary *forecast) {
        XCTAssertNotNil(error, @"Error should be raised since location is nil.");
    }];
}

@end
