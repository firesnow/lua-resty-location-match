use Test::Nginx::Socket;
use Cwd qw(cwd);


repeat_each(2);

plan tests => repeat_each() * (3 * blocks());
my $pwd = cwd();

our $HttpConfig = qq{
    lua_package_path "$pwd/lib/?.lua;;";
    lua_package_cpath "/usr/local/openresty-debug/lualib/?.so;/usr/local/openresty/lualib/?.so;;";

    init_by_lua_block{
        lm = require "resty.location.match"
        location_list = {
            "/a",
            "/a/b",
            "/a/b/c",
        }
    }
};

run_tests();

__DATA__

=== TEST 1: match nil
--- http_config eval: $::HttpConfig
--- config
    location /a {
        content_by_lua_block {
            ngx.say("/a")
            ngx.say(lm:match_location(ngx.var.uri, location_list));
        }
    }
    location /a/b {
        content_by_lua_block {
            ngx.say("/a/b")
            ngx.say(lm:match_location(ngx.var.uri, location_list));
        }
    }
    location /a/b/c {
        content_by_lua_block {
            ngx.say("/a/b/c")
            ngx.say(lm:match_location(ngx.var.uri, location_list));
        }
    }
    location /c {
        content_by_lua_block {
            ngx.say("/c")
            ngx.say(lm:match_location(ngx.var.uri, location_list));
        }
    }
--- request
GET /c
--- no_error_log
[error]
--- response_body
/c
nil

