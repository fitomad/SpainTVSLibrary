//
//  DSSpainTVSTests.m
//  DSSpainTVSTests
//
//  Created by Adolfo on 11/11/13.
//  Copyright (c) 2013 Desappstre Studio. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DSSpainTVSClient.h"

@interface DSSpainTVSTests : XCTestCase
//
@property (nonatomic) NSString *enlaceExistente;
//
@property (nonatomic) NSString *enlaceFalso;
@end

@implementation DSSpainTVSTests

- (void)setUp
{
    [super setUp];
    
    self.enlaceExistente = @"http://www.mitele.es/viajes/callejeros-viajeros/temporada-3/programa-109/";
    self.enlaceFalso = @"http://www.mitele.es/viajes/callejeros-viajeros/temporada-999/programa-999/";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

//
//
//
- (void) testRecuperarInformacionEnlace
{
	[[DSSpainTVSClient sharedClient]  recoverVideoInfo:self.enlaceExistente completationHandler:^(NSArray *videos, NSError *error)
	{
		XCTAssertNotNil(videos, @"Debe haber información relacionado con el vídeo");
		XCTAssertNil(error, @"Si el objecto error no es nulo es que algo ha pasado.");
	}];
}

//
//
//
- (void) testRecuperarInformacionEnlaceFalso
{
	[[DSSpainTVSClient sharedClient]  recoverVideoInfo:self.enlaceFalso completationHandler:^(NSArray *videos, NSError *error)
	{
		XCTAssertNotNil(videos, @"Debe recuperarse un NSArray sin elementos");
		XCTAssertNil(error, @"Si el objecto error no es nulo es que algo ha pasado.");
	}];		
}
@end
