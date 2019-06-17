------------------- io util--------------------------------
GLOBAL.VR_File =
{

	SaveTable =
	function(data, filepath)
		if data and type(data) == "table" and filepath and type(filepath) == "string" then
			GLOBAL.SavePersistentString(filepath, GLOBAL.DataDumper(data, nil, true), false, nil)
			print("DATA HAS SAVED!")
		else
			print("Error type:"..type(data))
		end
	end
	,

 	LoadTable =
 	function(filepath)
		local data = nil
		GLOBAL.TheSim:GetPersistentString(filepath,
			function(load_success, str)
				if load_success == true then
					local success, loaddata = GLOBAL.RunInSandboxSafe(str)
					if success and string.len(str) > 0 then
						data = loaddata
					else
						print ("[Virtual Reality] Could not load "..filepath)
					end
				else
					print ("[Virtual Reality] Can not find "..filepath)
				end
			end
		)
		return data
	end
	,
}

------------------- serialization utils --------------------------------
-- safe deserialize
local function deserialize(str)
	local data = nil
	local success, loaddata = GLOBAL.RunInSandboxSafe("return "..str)
	if success and string.len(str) > 0 then
		data = loaddata
	else
		print ("[Virtual Reality] Could not deserialize passed string")
	end
	return data
end

local Fake_table = {}
function Fake_table.val_to_str ( v )
  if "string" == GLOBAL.type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" ==  GLOBAL.type( v ) and Fake_table.serialize( v ) or
      GLOBAL.tostring( v )
  end
end

function Fake_table.key_to_str ( k )
  if "string" == GLOBAL.type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. Fake_table.val_to_str( k ) .. "]"
  end
end

function Fake_table.serialize( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, Fake_table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        Fake_table.key_to_str( k ) .. "=" .. Fake_table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

GLOBAL.VR_Serialization =
{
	Serialize =
	function(tab)
		if GLOBAL.type(tab) ~= "table" then
			print("VR serialize input is not table")
			return nil
		end
		local str = Fake_table.serialize(tab)
		if GLOBAL.type(str) ~= "string" then
			print("VR serialize table error")
			return nil
		end
		return str
	end
	,

	Deserialize =
	function(str)
		if GLOBAL.type(str) ~= "string" then
			print("VR deserialize input is not string")
			return nil
		end
		local tab = deserialize(str)
		if GLOBAL.type(tab) ~= "table" then
			print("VR deserialize error")
			return nil
		end
		return tab
	end
	,
}

-------------------- round func for beautiful alignment----------------
local function round(value)
  value = GLOBAL.tonumber(value) or 0
  return math.floor(value + 0.5)
end

function GLOBAL.vrRound(value)
  value = GLOBAL.tonumber(value) or 0
  local unit = 0.5
  return round(value/unit)*unit
end

-------------------- used for split string to array, not used now----------------------

-- split string to number
local function Split(str,reps)
	local resultStrList = {}
	string.gsub(str,'[^'..reps..']+',function ( w )
		table.insert(resultStrList,w)
	end)
	return resultStrList
end

function GLOBAL.vrSplit(str)
    local str_tab = Split(str, ",")
	local num_tab = {}
	local length = 0
	for i,v in ipairs(str_tab) do
		if GLOBAL.tonumber(v) == nil then
			print("VR split string error")
			return nil, length
		end
		table.insert(num_tab, GLOBAL.tonumber(v))
		length = length + 1

	end
	return num_tab, length
end


function GLOBAL.vrConcatenate(...)
	local str = ""
	for i,v in ipairs({...}) do
		if GLOBAL.tostring(v) == nil then
			print("parameter's type error")
			return nil
		end

		if i==1 then
			str = GLOBAL.tostring(v)
		else
			str = str..","..GLOBAL.tostring(v)
		end
	end
	return str
end
