f = io.open("policy.txt")
data = f:read("*all")
vars = {}
string.gsub(data,"{[A-Z_]*}",function (s) vars[s] = true end)
for k,v in pairs(vars) do print(k) end
