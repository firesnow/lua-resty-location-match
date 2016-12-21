local string_len = string.len
local re_match = ngx.re.match

local _M = {
    _VERSION = '0.3.2'
}

function _M:match_location(uri, location_match_list)
    local equal_matched, uri_match, regex_matched, normal_matched
    local normal_matched_len = 0
    local if_match_regular = true

    for _, rule in ipairs(location_match_list) do
        --match =
        local match_equal = re_match(rule, [[^=( *)([\w\-\./]*)$]], "jo")
        --regex match ~
        local match_regex = re_match(rule, [[^~( *)([\w\-\./]*)$]], "jo")
        --regex match~*
        local match_regex_insensitive = re_match(rule, [[^~\*( *)([\w\-\./]*)$]], "jo")
        --normal match ^~
        local match_not_regex = re_match(rule, [[^\^~( *)([\w\-\./]*)$]], "jo")

        if match_equal then
            uri_match = re_match(uri, '^' .. match_equal[2] .. "$", 'jo')
            if uri_match then
                equal_matched = rule
                break
            end
        elseif match_regex or match_regex_insensitive then
            if not regex_matched then
                if match_regex then
                    uri_match = re_match(uri, match_regex[2], 'jo')
                else
                    uri_match = re_match(uri, match_regex_insensitive[2], 'joi')
                end
                if uri_match then
                    regex_matched = rule
                end
            end
        else
            --normal match notice^~
            local normal_len
            if match_not_regex then
                uri_match = re_match(uri, "^" .. match_not_regex[2] .. "(.*)$", 'jo')
                normal_len = string_len(match_not_regex[2])
            else
                uri_match = re_match(uri, "^" .. rule .. "(.*)$", 'jo')
                normal_len = string_len(rule)
            end
            if uri_match and normal_len > normal_matched_len then
                normal_matched = rule
                normal_matched_len = normal_len
                if_match_regular = (match_not_regex == nil)
            end
        end
    end


    if equal_matched then
        return equal_matched
    end

    if not if_match_regular then
        return normal_matched
    end

    if regex_matched then
        return regex_matched
    elseif normal_matched then
        return normal_matched
    end

    return equal_matched
end


return _M