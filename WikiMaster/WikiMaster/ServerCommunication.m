//
//  ServerCommunication.m
//  WikiMaster
//
//  Created by Kunal Wagle on 26/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "ServerCommunication.h"

@implementation ServerCommunication

NSInputStream *inputStream;
NSOutputStream *outputStream;

+ (void)initNetworkCommunication: (UIViewController*) del {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 80, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    [inputStream setDelegate:del];
    [outputStream setDelegate:del];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}

+ (void)sendMessage:(NSString*)message {
    NSData *data = [[NSData alloc] initWithData:[message dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}



@end
