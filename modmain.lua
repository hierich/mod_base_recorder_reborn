PrefabFiles = 
{ 
	"virtualstruct",     
	"virtualwall",     
	"virtualplantable",     
	"virtualfence",
	"vr_camera",
	"vr_projector", 
}  
Assets = {      Asset( "ATLAS", "images/hud/virtualtab.xml" ),  }  

local STRINGS = GLOBAL.STRINGS 
local RECIPETABS = GLOBAL.RECIPETABS 
local Recipe = GLOBAL.Recipe 
local Ingredient = GLOBAL.Ingredient 
local TECH = GLOBAL.TECH 
local AllRecipes = GLOBAL.AllRecipes
local CHARACTER_INGREDIENT = GLOBAL.CHARACTER_INGREDIENT
local TUNING = GLOBAL.TUNING

local mylanguage = GetModConfigData("language") 
if mylanguage == 1 then     
	STRINGS.NAMES.VIRTUALSTRUCT_TAB = "Virtual Structure"     
	-- STRINGS.NAMES.VIRTUALITEM_TAB = "Virtual Item" 
else     
	STRINGS.NAMES.VIRTUALSTRUCT_TAB = "虚拟建筑"     
	-- STRINGS.NAMES.VIRTUALITEM_TAB = "虚拟物品" 
end  

-- the prefix is just for this mod
STRINGS.VIRTUAL_PREFIX = "virtual_"
local VIRTUAL_PREFIX = STRINGS.VIRTUAL_PREFIX

virtualtab = AddRecipeTab(STRINGS.NAMES.VIRTUALSTRUCT_TAB, 99, "images/hud/virtualtab.xml", "virtualtab.tex") 
-- virtualitemtab = AddRecipeTab(STRINGS.NAMES.VIRTUALITEM_TAB, 100, "images/hud/virtualtab.xml", "virtualtab.tex")  
TUNING.VIRTUALALPHA = GetModConfigData("alpha")  
local color = GetModConfigData("color") 
TUNING.VIRTUALRED = color / 100 
TUNING.VIRTUALGREEN = (color/10)%10 
TUNING.VIRTUALBLUE = color%10


local function AddVirtualRecipe()
	-- add virtual recipes one by one

	-- add virtual structure
	local virtual_structure_names = 
	{
		"firepit",
		"coldfirepit",
		"mushroom_light",
		"mushroom_light2",
		"treasurechest",
		"homesign",
		"pighouse",
		"rabbithouse",
		"birdcage",
		"wardrobe",
		"scarecrow",
		"winter_treestand",
		"endtable",
		"dragonflychest",
		"dragonflyfurnace",
		"mushroom_farm",
		"beebox",
		"meatrack",
		"cookpot",
		"icebox",
		"tent",
		"siestahut",
		"saltlick",
		"researchlab",
		"researchlab2",
		"researchlab3",
		"researchlab4",
		"sculptingtable",
		"lightning_rod",
		"firesuppressor",
		"sentryward",
		"moondial",
		"townportal",
		"fast_farmplot",
	}

	for k, v in pairs(virtual_structure_names) do
		STRINGS.NAMES[string.upper(VIRTUAL_PREFIX..v)] = "Virtual "..STRINGS.NAMES[string.upper(v)]
		print(v)
		local structure_recipe = AllRecipes[v]
		if structure_recipe ~= nil then
			AddRecipe(VIRTUAL_PREFIX..v, {Ingredient(CHARACTER_INGREDIENT.SANITY, 0)}, virtualtab, TECH.NONE, structure_recipe.placer, structure_recipe.min_spacing, nil, nil, nil, nil, structure_recipe.image) 
		end
	end

	-- add virtual plantable
	local virtual_plantable_names = 
	{
		"grass",
		"sapling",
		"berrybush",
		"berrybush2",
		"berrybush_juicy",
		"marsh_bush",
	} 

	for k, v in pairs(virtual_plantable_names) do
		STRINGS.NAMES[string.upper(VIRTUAL_PREFIX..v)] = "Virtual "..STRINGS.NAMES[string.upper(v)]
		
		local dug_v = "dug_"..v
		STRINGS.NAMES[string.upper(VIRTUAL_PREFIX..dug_v)] = "Virtual "..STRINGS.NAMES[string.upper(dug_v)]
		AddRecipe(VIRTUAL_PREFIX..dug_v, {Ingredient(CHARACTER_INGREDIENT.SANITY, 0)}, virtualtab, TECH.NONE, nil,nil, nil, 50, nil, nil, dug_v..".tex")
	end 

	-- add virtual wall, fence, gate
	local MATERIALS = GLOBAL.MATERIALS
	local virtual_wall_names = 
	{
		"wall_"..MATERIALS.STONE,
		"wall_"..MATERIALS.WOOD,
		"wall_"..MATERIALS.HAY,
		"wall_ruins",
		"wall_"..MATERIALS.MOONROCK,
		"fence",
		"fence_gate",
	}
	for k, v in pairs(virtual_wall_names) do
		STRINGS.NAMES[string.upper(VIRTUAL_PREFIX..v)] = "Virtual "..STRINGS.NAMES[string.upper(v)]
		
		local v_item = v.."_item"
		STRINGS.NAMES[string.upper(VIRTUAL_PREFIX..v_item)] = "Virtual "..STRINGS.NAMES[string.upper(v_item)]
		AddRecipe(VIRTUAL_PREFIX..v_item, {Ingredient(CHARACTER_INGREDIENT.SANITY, 0)}, virtualtab, TECH.NONE, nil,nil, nil, 50, nil, nil, v_item..".tex")
	end

	-- add vr projector 
	STRINGS.NAMES[string.upper("vr_projector")] = "VR Projector"

	-- add vr camera
	STRINGS.NAMES[string.upper("vr_camera")] = "VR Camera"
end
-- add recipe
AddVirtualRecipe()



local require = GLOBAL.require
local SpawnPrefab = GLOBAL.SpawnPrefab  
if GetModConfigData("chestwithsign") == 1 then
	local function HasImage(item)
		return item.prefab == "minisign" and item.components.drawable and item.components.drawable:GetImage() ~= nil
	end
	local function onget(inst, data)
		if GLOBAL.FindEntity(inst, 0.5, HasImage, { "sign" }) ~= nil then return end
		local item = data.item
		if item.prefab == "minisign_drawn" then
			inst.havetag = true
			local ent = SpawnPrefab("minisign")
			if item.components and item.components.drawable then
				ent.components.drawable:OnDrawn(item.components.drawable:GetImage())
				ent._imagename:set(item._imagename:value())
				local toremove = inst.components.container:RemoveItem(item)
				if toremove then
					toremove:Remove()
					toremove = nil
				end
				inst.components.container:Close()
				ent.Transform:SetPosition(inst.Transform:GetWorldPosition())
			end
		end
	end      
	AddPrefabPostInit("treasurechest", function(inst)         inst:ListenForEvent("itemget",onget)     end)
	AddPrefabPostInit("dragonflychest", function(inst)         inst:ListenForEvent("itemget",onget)     end)
	AddPrefabPostInit("icebox", function(inst)         inst:ListenForEvent("itemget",onget)     end)
	AddPrefabPostInit("minisign_drawn", function(inst) inst:AddTag("icebox_valid") end)
end
local wall_x = { 15.5, 5.5, 5.5, 5.5, 12.5, 5.5, 5.5, 5.5, 5.5, 5.5, 6.5, 7.5, 8.5, 9.5, 10.5, 12.5, 14.5, 15.5, 16.5, 18.5, 17.5, 17.5, 16.5, 15.5, 14.5, 5.5, 16.5, 15.5, 17.5, 18.5, 19.5, 20.5, 21.5, 22.5, 22.5, 22.5, 22.5, 22.5, 22.5, 10.5, 10.5, 12.5, 13.5, 12.5, 10.5, 10.5, 10.5, 10.5, 14.5, 13.5, 15.5, 15.5, 11.5, 11.5, 12.5, 12.5, 13.5, 13.5, 12.5, 14.5, 9.5, 14.5, 9.5, 15.5, 15.5, 16.5, 16.5, 17.5, 18.5, 10.5, 9.5, 9.5, 9.5, 9.5, 10.5, 11.5, 8.5, 7.5, 5.5, 6.5, 12.5, 13.5, 14.5, 5.5, 15.5, 4.5, 11.5, 16.5, 17.5, 18.5, 18.5, 18.5, 18.5, 18.5, 18.5, 18.5, 18.5, 19.5, 19.5, 19.5, 19.5, 19.5, 20.5, 6.5, 19.5, 7.5, 21.5, 8.5, 22.5, 7.5, 22.5, 8.5, 22.5, 9.5, 10.5, 11.5, 22.5, 22.5, 22.5, 11.5, 13.5, 14.5, 21.5, 7.5, 10.5, 8.5, 9.5, 10.5, 11.5, 12.5, 15.5, 17.5, 18.5, 19.5, 6.5, 20.5, 20.5, 21.5, 22.5, 18.5, 22.5, 19.5, 13.5, 22.5, 17.5, 5.5, 16.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 20.5, 22.5}
local wall_z = { 14.5, -13.5, -14.5, -15.5, 14.5, -16.5, -19.5, -20.5, -21.5, -22.5, -22.5, -22.5, -22.5, -22.5, -22.5, -22.5, 4.5, 4.5, 3.5, 4.5, 2.5, -0.5, 0.5, 1.5, 2.5, -9.5, -22.5, -22.5, -22.5, -22.5, -22.5, -22.5, -22.5, -22.5, -21.5, -20.5, -19.5, -16.5, -15.5, -8.5, -9.5, -1.5, -0.5, -2.5, -2.5, -3.5, -4.5, -5.5, -3.5, -3.5, -2.5, -1.5, -6.5, -8.5, -6.5, -8.5, -8.5, -6.5, 2.5, -8.5, 2.5, -6.5, 3.5, -6.5, -8.5, -8.5, -6.5, -8.5, -7.5, -6.5, 14.5, 0.5, 1.5, -0.5, -1.5, -9.5, 14.5, 14.5, 13.5, 14.5, -9.5, -9.5, -9.5, 7.5, -9.5, -10.5, 14.5, -9.5, -9.5, -9.5, -8.5, -6.5, -5.5, -4.5, -3.5, -2.5, -1.5, -0.5, 0.5, 1.5, 2.5, 3.5, 4.5, -10.5, 4.5, -9.5, 5.5, -10.5, 6.5, -11.5, 7.5, -12.5, 8.5, -13.5, -13.5, -13.5, 11.5, 12.5, 13.5, -22.5, -13.5, -13.5, 14.5, 4.5, 14.5, 4.5, 4.5, 4.5, 4.5, 4.5, -13.5, -13.5, -13.5, -13.5, 5.5, -12.5, -10.5, -11.5, -12.5, 14.5, -13.5, 14.5, 4.5, -14.5, 14.5, -11.5, 14.5, -12.5, 12.5, 14.5, 11.5, 8.5, 6.5, 14.5, 14.5}
local function MakeWall(basex, basez)
	for i=1, 155, 1 do
		local item = GLOBAL.DebugSpawn("virtual_wall_stone")
		item.Transform:SetPosition(basex+wall_x[i], 0, basez+wall_z[i])
	end
end
if GLOBAL.TheNet and GLOBAL.TheNet:GetIsServer() then
	local NetworkingSay = GLOBAL.Networking_Say
	GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, ...)
		NetworkingSay(guid, userid, name, prefab, message, colour, whisper, ...)
		if whisper and string.sub(message,1,13) == "#base" or string.sub(message,1,13) == "#base_cave" then
			local player
			for i, v in ipairs(GLOBAL.AllPlayers) do
				if v.userid == userid then
					player = v
				end
			end
			if player ~= nil and player.userid == userid then
				local x, y, z = player.Transform:GetWorldPosition()
				x = math.floor(x/4)*4
				y = 0
				z = math.floor(z/4)*4
				local basemap
				local delta
				if string.sub(message,1,13) == "#base" then
					basemap = require "xzbase"
					delta = 24
				else
					basemap = require "xzbase_cave"
					delta = 16
				end
				for i,j in pairs(basemap.layers) do
					if j.type == "objectgroup" then
						local tx,tz
						for k,v in pairs(j.objects) do
							tx = v.x/16 - delta + x
							tz = v.y/16 - delta + z
							local item = GLOBAL.DebugSpawn("virtual_"..v.type)
							if item then 
								item.Transform:SetPosition(tx, 0, tz)
								if item.prefab == "virtual_lightning_rod" then
									MakeWall(tx,tz)
								end
							else
								print("virtual "..v.type.." not existed")
							end
						end
					end
				end
			end
		end
	end
end

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




