//
//  XMMRSSEntry.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 25/02/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMMRSSEntry.h"

@implementation XMMRSSEntry

- (NSString*)description {
    NSMutableString *output = [NSMutableString new];
    [output appendString:[NSString stringWithFormat: @"title: %@ \n", self.title]];
    [output appendString:[NSString stringWithFormat: @"link: %@ \n", self.link]];
    [output appendString:[NSString stringWithFormat: @"comment: %@ \n", self.comments]];
    [output appendString:[NSString stringWithFormat: @"pubDate: %@ \n", self.pubDate]];
    [output appendString:[NSString stringWithFormat: @"guid: %@ \n", self.guid]];
    [output appendString:[NSString stringWithFormat: @"descriptionOfRSS: %@ \n", self.descriptionOfContent]];
    [output appendString:[NSString stringWithFormat: @"content: %@ \n", self.content]];
    [output appendString:[NSString stringWithFormat: @"wfw: %@ \n", self.wfw]];
    [output appendString:[NSString stringWithFormat: @"slash: %@ \n", self.slash]];
    return output;
}

@end
