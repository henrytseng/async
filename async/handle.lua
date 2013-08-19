-- c lib / bindings for libuv
local uv = require 'luv'

-- make handle out of uv client
local function handle(client)
   local h = {}
   h.ondata = function(cb)
      client.ondata = function(self,data)
         if cb then cb(data) end
      end
   end
   h.onend = function(cb)
      client.onend = function(self)
         if cb then cb() end
      end
   end
   h.onclose = function(cb)
      client.onclose = function(self)
         if cb then cb() end
      end
   end
   h.write = function(data,cb)
      uv.write(client, data, cb)
   end
   h.close = function(cb)
      uv.shutdown(client, function()
         uv.close(client)
         if cb then cb() end
      end)
   end
   return h
end

-- handle
return handle
