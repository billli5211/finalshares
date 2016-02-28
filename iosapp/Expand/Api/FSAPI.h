//
//  FSAPI.h
//  iosapp
//
//  Created by bill li on 2016-01-18.
//  Copyright (c) 2016年 finalshares. All rights reserved.
//

#ifndef iosapp_FSAPI_h
#define iosapp_FSAPI_h


#define FSAPI_CUSTOMIZE_CONFIG          @"http://192.168.1.11/sites/default/files/customizeConfig.json"

#define FSAPI_PREFIX                    @"http://finalshares.com/"
#define FSAPI_ARTICLE_PREFIX            @"http://finalshares.com/index.php?m=3g&a=runJson"
#define FSAPI_CATEGORY                  @"http://finalshares.com/index.php?m=3g&a=runJson" //same as FSAPI_ARTICLE_PREFIX by now
#define FSAPI_ARTICLE_LIST_BY_DATE      @"&order=postdate"
#define FSAPI_ARTICLE_LIST_BY_RECOMMEND @"&order=recommend"
#define FSAPI_ARTICLE_LIST_BY_HOT       @"&order=hot"
#define FSAPI_ARTICLE_DETAIL            @"http://finalshares.com/read-"

// afer loggin, can use api:
#define FSAPI_MSG_AND_NOTICE            @"http://finalshares.com/3g-index-runJson"
#define FSAPI_NOTICE                    @"http://finalshares.com/3g-notice-runJson"
#define FSAPI_MSG                       @"http://finalshares.com/3g-message-runJson"

// loggin
#define FSAPI_LOGIN                     @"http://finalshares.com/3g-login-dorun"
#define FSAPI_VERIFY_CODE               @"http://finalshares.com/verify-index-getJson"

#endif
