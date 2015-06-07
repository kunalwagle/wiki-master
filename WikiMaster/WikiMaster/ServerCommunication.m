//
//  ServerCommunication.m
//  WikiMaster
//
//  Created by Kunal Wagle on 26/05/2015.
//  Copyright (c) 2015 WEBAPPS. All rights reserved.
//

#import "ServerCommunication.h"

@implementation ServerCommunication


+(void)addUser:(NSString*)userID {
    NSString *post = [NSString stringWithFormat:@"access_token=%@", userID];
    NSLog(post);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://146.169.47.18:3000/api/auth/facebook/token"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

+(void)getUser:(NSString*)userID {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://146.169.47.18:3000/api/users/id/%@", userID]]];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

+(void)getCategories {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://146.169.47.18:3000/api/wiki/categories"]];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}



+(void)getSubCategories:(NSString *)category {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    category = [NSString stringWithFormat:@"http://146.169.47.18:3000/api/wiki/categories/%@/subcategories", category];
    category = [category stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(category);
    [request setURL:[NSURL URLWithString:category]];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

+(void)getInfoboxes:(NSString *)category {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    category = [NSString stringWithFormat:@"http://146.169.47.18:3000/api/wiki/categories/%@/infoboxes", category];
    category = [category stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(category);
    [request setURL:[NSURL URLWithString:category]];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

+(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"FAILED");
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"FAILED" forKey:@"response"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification"
                                                        object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"User" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Categories" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Subcategories" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getTopic" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryInfoboxes" object:nil userInfo:dict];
}

+(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
}

+(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *output = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog([[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
    NSDictionary * dict =[NSDictionary dictionaryWithObject:output forKey:@"response"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification"
                                    object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"User" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Categories" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Subcategories" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getTopic" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryInfoboxes" object:nil userInfo:dict];
    @try {
        id object = [NSJSONSerialization JSONObjectWithData:[[dict objectForKey:@"response"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if ([object count]>0) {
            if ([[object objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *result = [object objectAtIndex:0];
                NSDictionary *facebook = [result objectForKey:@"facebook"];
                NSString *userid = [facebook objectForKey:@"id"];
                [[NSNotificationCenter defaultCenter] postNotificationName:userid object:nil userInfo:dict];
            } else {
                //ERROR HANDLING
            } } else {
                //ERROR HANDLING
            }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

//NSInputStream *inputStream;
//NSOutputStream *outputStream;

//- (void)initNetworkCommunication {
//    CFReadStreamRef readStream;
//    CFWriteStreamRef writeStream;
//    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"http://146.169.47.18/api/users", 3000, &readStream, &writeStream);
//    inputStream = (__bridge NSInputStream *)readStream;
//    outputStream = (__bridge NSOutputStream *)writeStream;
//    [inputStream setDelegate:self];
//    [outputStream setDelegate:self];
//    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    [inputStream open];
//    [outputStream open];
//}
//
//- (void)sendMessage:(NSString*)message {
//    NSData *data = [[NSData alloc] initWithData:[message dataUsingEncoding:NSASCIIStringEncoding]];
//    [outputStream write:[data bytes] maxLength:[data length]];
//}
//
//- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
//    
//    switch (streamEvent) {
//            
//        case NSStreamEventOpenCompleted:
//            NSLog(@"Stream opened");
//            break;
//            
//        case NSStreamEventHasBytesAvailable: {
//            NSString *output = @"";
//            if (theStream == inputStream) {
//                
//                uint8_t buffer[1024];
//                int len;
//                
//                while ([inputStream hasBytesAvailable]) {
//                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
//                    if (len > 0) {
//                        output = [output stringByAppendingString:[[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding]];
//                        
//                        if (nil != output) {
//                            NSLog(@"server said: %@", output);
//                         //   [self messageReceived:output];
//                        }
//                    }
//                }
//            }
//            NSDictionary * dict =[NSDictionary dictionaryWithObject:output forKey:@"response"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification"
//                                                                object:nil userInfo:dict];
//            break; }
//            
//        case NSStreamEventErrorOccurred:
//            NSLog(@"Can't connect to server");
//            break;
//            
//        case NSStreamEventEndEncountered:
//            [theStream close];
//            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//            break;
//            
//        default:
//            NSLog(@"Unknown event");
//    }
//}



@end
