local log = require('log')

local kv = {
  initialize_db = function(self)
    box.once('create_kv_table', function()
      kv_table = box.schema.create_space('kv_table')
      kv_table:format{
        {name = 'key', type = 'string'},
        {name = 'value', type = 'string'}
      }
      kv_table:create_index('primary', {type = 'hash', parts = {'key'}})
    end)
  end,

  method_post = function(self, key, value)
    if next(box.space.kv_table:select(key)) == nil then
      -- Ok 200
      box.space.kv_table:insert({key, value})
      return {status = 200}
    else
      -- Error 409. Object already exists
      return {status = 409}
    end
  end,

  method_put = function(self, key, value)
    if next(box.space.kv_table:select(key)) == nil then
      -- Error 404. Object not found
      return {status = 404}
    else
      -- Ok 200
      box.space.kv_table:update(key, {{'=', 'value', value}})
      return {status = 200}
    end
  end,

  method_get = function(self, key)
    query = box.space.kv_table:select(key)
    if next(query) == nil then
      -- Error 404. Object not found
      return {status = 404}
    else
      -- Ok 200
      return {status = 200, value = query[1]['value']}
    end
  end,

  method_delete = function(self, key)
    if next(box.space.kv_table:select(key)) == nil then
      -- Error 404. Object not found
      return {status = 404}
    else
      -- Ok 200
      box.space.kv_table:delete(key)
      return {status = 200}
    end
  end,
}

return kv
