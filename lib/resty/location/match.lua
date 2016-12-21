local string_len = string.len
local re_match = ngx.re.match

local _M = {
    _VERSION = '0.3.0'
}

function _M:match_location(uri, location_match_list)
    local match_regex = false
    local ret, regular_matched, normal_matched
    local normal_matched_len = 0
    local if_match_regular = true

    for _, regex in ipairs(location_match_list) do
        --match =
        local regex_equal = re_match(regex, [[^=( *)([\w\-\./]*)$]], "jo")
        --regex match ~
        local regex_regular = re_match(regex, [[^~( *)([\w\-\./]*)$]], "jo")
        --regex match~*
        local regex_regular_insensitive = re_match(regex, [[^~\*( *)([\w\-\./]*)$]], "jo")
        --normal match ^~
        local regex_not_regular = re_match(regex, [[^\^~( *)([\w\-\./]*)$]], "jo")

        if regex_equal then
            ret = re_match(uri, '^' .. regex_equal[2] .. "$", 'jo')
            if ret then
                match_regex = regex
                break
            end
        elseif regex_regular or regex_regular_insensitive then
            if not regular_matched then
                if regex_regular then
                    ret = re_match(uri, regex_regular[2], 'jo')
                else
                    ret = re_match(uri, regex_regular_insensitive[2], 'joi')
                end
                if ret then
                    regular_matched = regex
                end
            end
        else
            --normal match notice^~
            local normal_len
            if regex_not_regular then
                ret = re_match(uri, "^" .. regex_not_regular[2] .. "(.*)$", 'jo')
                normal_len = string_len(regex_not_regular[2])
            else
                ret = re_match(uri, "^" .. regex .. "(.*)$", 'jo')
                normal_len = string_len(regex)
            end
            if ret and normal_len > normal_matched_len then
                normal_matched = regex
                normal_matched_len = normal_len
                if_match_regular = (regex_not_regular == nil)
            end
        end
    end


    if match_regex then
        return match_regex
    end

    if not if_match_regular then
        return normal_matched
    end

    if regular_matched then
        return regular_matched
    elseif normal_matched then
        return normal_matched
    end

    return match_regex
end



return _M
