Stats = {
  __index = function(t,k)
    if Stats[k] then return Stats[k] end
    
    local b = rawget(t, "base")[k] or 0
    local o = rawget(t, "offset")[k] or 0
    
    return b + o
  end,
  
  __newindex = function(t,k,v)
    local base = rawget(t, "base")
    local offset = rawget(t, "offset")
    
    if base[k] == nil then
      base[k] = v
      offset[k] = 0
    else
      offset[k] = v - base[k]
    end
  end,

  new = function()
    return setmetatable({
      base = {},
      offset = {},
    }, Stats)
  end,
}

return Stats