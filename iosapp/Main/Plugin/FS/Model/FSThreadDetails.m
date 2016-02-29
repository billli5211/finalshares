//
//  OSCPostDetails.m
//  iosapp
//
//  Created by chenhaoxiang on 11/3/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "FSThreadDetails.h"
#import "Utils.h"


@implementation FSThreadDetails



- (NSString *)html
{
    if (!_html) {
        NSDictionary *data = @{
                               @"title": [_title escapeHTML],
                               @"authorID": @(_authorID),
                               @"authorName": _author,
                               @"timeInterval": [_pubDate timeAgoSinceNow],
                               @"content": _body,
                               @"tags": [Utils generateTags:_tags],
                               };
        
        _html = [Utils HTMLWithData:data usingTemplate:@"article"];
    }
    
    return _html;
}

@end
