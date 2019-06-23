
local t = { }
t["a"] = 10
t["b"] = 2
t["c"] = 4
t["d"] = 11

local T = { } -- Result goes here

-- Store both key and value as pairs
for k, v in pairs(t) do
  T[#T + 1] = { k = k, v = v }
end

-- Sort by value
table.sort(t, function(lhs, rhs) return lhs > rhs end)

for k,v in pairs(t) do
    print(v)
end
