//
//  ViewController.m
//  NSURLConnection
//
//  Created by aaron on 14-5-29.
//  Copyright (c) 2014年 The Technology Studio. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
  //  [self fetchAppleHtml];
//    [self fetchYahooData];
    [self fetchYahooData2_GCD];
}

//asynchronousRequest connection
-(void)fetchAppleHtml{
    NSString *urlString = @"http://www.apple.com";
    NSURL *url = [NSURL URLWithString:urlString];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f]; //maximal timeout is 30s
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError == nil) {
            NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePath = [documentsDir stringByAppendingPathComponent:@"apple.html"];
            [data writeToFile:filePath atomically:YES];
            NSLog(@"Successfully saved the file to %@",filePath);
            NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"HTML = %@",html);
        }else if ([data length] == 0 && connectionError == nil){
            NSLog(@"Nothing was downloaded.");
        }else if (connectionError != nil){
            NSLog(@"Error happened = %@",connectionError);
        }
    }];
}


//synchronousRequest connection
-(void)fetchYahooData{
    NSLog(@"We are here...");
    NSString *urlString = @"http://www.yahoo.com";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSLog(@"Firing synchronous url connection...");
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if ([data length] > 0 && error == nil) {
        NSLog(@"%lu bytes of data was returned.",(unsigned long)[data length]);
    }else if([data length] == 0 && error == nil){
        NSLog(@"No data was return.");
    }else if (error != nil){
        NSLog(@"Error happened = %@",error);
    }
    NSLog(@"We are done.");
    
}
/*
 |
 | as we know, it will chock main thread when we call sendSynchronousRequest on main thread,,,,change below
 |
 v
*/
//call sendSynchronousRequest on GCD pool
-(void)fetchYahooData2_GCD{
    NSLog(@"We are here...");
    NSString *urlString = @"http://www.yahoo.com";
    NSLog(@"Firing synchronous url connection...");
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^{
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        if ([data length] > 0 && error == nil) {
            NSLog(@"%lu bytes of data was returned.",(unsigned long)[data length]);
        }else if ([data length] == 0 && error == nil){
            NSLog(@"No data was returned.");
        }else if (error != nil){
            NSLog(@"Error happened = %@",error);
        }
    });
    NSLog(@"We are done.");

}









@end
