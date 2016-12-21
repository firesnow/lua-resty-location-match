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
            "= /test",
            "~ /test",
            "~* /test",
            "^~ /test",
            "/test",
        }
    }
};

run_tests();

__DATA__


=== TEST 1: match ~*
--- http_config eval: $::HttpConfig
--- config
    location = /test {
        content_by_lua_block {
            ngx.say("= /test")
            ngx.say(lm:match_location(ngx.var.uri, location_list));
        }
    }
    location ~ /test {
        content_by_lua_block {
            ngx.say("~ /test")
            ngx.say(lm:match_location(ngx.var.uri, location_list));
        }
    }
    location ~* /Test {
        content_by_lua_block {
            ngx.say("~* /test")
            ngx.say(lm:match_location(ngx.var.uri, location_list));
        }
    }
    location ^~ /test {
        content_by_lua_block {
            ngx.say("^~ /test")
            ngx.say(lm:match_location(ngx.var.uri, location_list));
        }
    }
--- request
GET /Test
--- no_error_log
[error]
--- response_body
~* /test
~* /test
