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
	
    [self fetchAppleHtml];
}

-(void)fetchAppleHtml{
    NSString *urlString = @"http://www.apple.com";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
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

@end
