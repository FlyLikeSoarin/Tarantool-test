box.cfg{listen=3301}
kv = require('kv')
kv:initialize_db()

-- add, catch and map functions exposed to rest API
function tnt_post(request, key, value)
    return kv:method_post(key, value)
end

function tnt_put(request, key, value)
    return kv:method_put(key, value)
end

function tnt_get(request, key)
    return kv:method_get(key)
end

function tnt_delete(request, key)
    return kv:method_delete(key)
end
