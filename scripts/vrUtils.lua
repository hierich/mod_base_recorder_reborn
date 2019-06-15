-- io util
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

-- round func for beautiful alignment
local function round(value)
  value = GLOBAL.tonumber(value) or 0
  return math.floor(value + 0.5)
end

function GLOBAL.vrRound(value)
  value = GLOBAL.tonumber(value) or 0
  local unit = 0.5
  return round(value/unit)*unit
end
