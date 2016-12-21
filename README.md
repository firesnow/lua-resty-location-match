# lua-resty-location-match
Determine which location the request entered

## Overview
```
http {
    init_by_lua_block{
        lm = require "resty.location.match"
        location_list = {
            "/",
            "= /test1",
            "~ /test2",
            "~* /test3",
            "^~ /test4",
            "/test5",
        }
    }

    server {
        listen  80;

        location / {
            content_by_lua_block {
                ngx.say('／')
                ngx.say(lm:match_location(ngx.var.uri, location_list));
            }
        }

        location = /test1 {
            content_by_lua_block {
                ngx.say('= /test1')
                ngx.say(lm:match_location(ngx.var.uri, location_list));
            }
        }

        location ~* /test3 {
            content_by_lua_block {
                ngx.say('~* /test3')
                ngx.say(lm:match_location(ngx.var.uri, location_list));
            }
        }

        location ^~ /test4 {
            content_by_lua_block {
                ngx.say('^~ /test4')
                ngx.say(lm:match_location(ngx.var.uri, location_list));
            }
        }

        location /test5 {
            content_by_lua_block {
                ngx.say('/test5')
                ngx.say(lm:match_location(ngx.var.uri, location_list));
            }
        }

    }
}
```

## Methods

### match_location
```syntax: match_location = match_location(uri,location_list)```

Get match location from location list as Nginx rules.

**Notice:** Make sure that `location_list` is kept in the same order as location appears in the Nginx's conf.
## Copyright and License

This module is licensed under the BSD license.

Copyright (c) 2016-2017, firesnow zhangce5413@gmail.com

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

