//
//  mtlURLRequest.h
//  Delight
//
//  Created by Elie Zananiri on 12-01-19.
//  Copyright 2012 silentlyCrashing::net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

//--------------------------------------------------------------
//--------------------------------------------------------------
@interface mtlURLRequest : NSObject
{
    NSInteger numRetries;
    
    ASIHTTPRequest *httpRequest;
    
    SEL requestSuccessSelector;
    SEL requestFailedSelector;
}

@property (unsafe_unretained) NSInteger numRetries;
@property (strong, nonatomic) ASIHTTPRequest *httpRequest;

@property (unsafe_unretained, nonatomic) id delegate;
@property (unsafe_unretained) SEL requestSuccessSelector;
@property (unsafe_unretained) SEL requestFailedSelector;

- (NSString *)buildRequestURL;
- (NSString *)buildJSONData;
- (void)process;

- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;

@end
