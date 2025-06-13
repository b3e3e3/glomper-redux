function math.Sign(x)
   if x<0 then
     return -1
   elseif x>0 then
     return 1
   else
     return 0
   end
end


function math.Clamp(n, low, high) return math.min(math.max(n, low), high) end



Util = {}
return Util