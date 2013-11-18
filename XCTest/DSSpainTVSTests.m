//
//  DSSpainTVSTests.m
//  DSSpainTVSTests
//
//  Created by Adolfo on 11/11/13.
//  Copyright (c) 2013 Desappstre Studio. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "DSSpainTVSClient.h"
#import "DSSpainTVSVideoInfo.h"

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
    [super tearDown];
}

//
//
//
- (void) testRecuperarInformacionEnlace
{
    [[DSSpainTVSClient sharedClient] recoverVideoInfo:self.enlaceExistente completionHandler:^(NSArray *info, NSError *error)
    {
        XCTAssertNotNil(info, @"Debe haber informacion relacionado con el video");
		XCTAssertNil(error, @"Si el objecto error no es nulo es que algo ha pasado.");
        
        for(DSSpainTVSVideoInfo *video in info)
        {
            NSLog(@"%@", [video debugDescription]);
            [[DSSpainTVSClient sharedClient] recoverVideoImage:video.imagen completionHandler:^(UIImage *imagen, NSError *error) {
                NSLog(@"Tamaño de la imagen: %@", [imagen description]);
            }];
        }
    }];
    
    [NSThread sleepForTimeInterval:15];
}

//
//
//
- (void) testRecuperarInformacionEnlaceFalso
{
	[[DSSpainTVSClient sharedClient]  recoverVideoInfo:self.enlaceFalso completionHandler:^(NSArray *videos, NSError *error)
	{
		XCTAssertNotNil(videos, @"Debe recuperarse un NSArray sin elementos");
		XCTAssertNil(error, @"Si el objecto error no es nulo es que algo ha pasado.");
	}];		
}
@end
