PrefabFiles = { "virtualstruct",     "virtualwall",     "virtualplantable",     "virtualfence", }  
Assets = {      Asset( "ATLAS", "images/hud/virtualtab.xml" ),  }  
local require = GLOBAL.require 
local STRINGS = GLOBAL.STRINGS 
local RECIPETABS = GLOBAL.RECIPETABS 
local Recipe = GLOBAL.Recipe 
local Ingredient = GLOBAL.Ingredient 
local TECH = GLOBAL.TECH 
local AllRecipes = GLOBAL.AllRecipes  
local mylanguage = GetModConfigData("language") 
if mylanguage == 1 then     
	STRINGS.NAMES.VIRTUALSTRUCT_TAB = "Virtual Structure"     
	-- STRINGS.NAMES.VIRTUALITEM_TAB = "Virtual Item" 
else     
	STRINGS.NAMES.VIRTUALSTRUCT_TAB = "虚拟建筑"     
	-- STRINGS.NAMES.VIRTUALITEM_TAB = "虚拟物品" 
end  
virtualtab = AddRecipeTab(STRINGS.NAMES.VIRTUALSTRUCT_TAB, 99, "images/hud/virtualtab.xml", "virtualtab.tex") 
-- virtualitemtab = AddRecipeTab(STRINGS.NAMES.VIRTUALITEM_TAB, 100, "images/hud/virtualtab.xml", "virtualtab.tex")  
TUNING.VIRTUALALPHA = GetModConfigData("alpha")  
local color = GetModConfigData("color") 
TUNING.VIRTUALRED = color / 100 
TUNING.VIRTUALGREEN = (color/10)%10 
TUNING.VIRTUALBLUE = color%10
-- local virtual_struct_names = 
-- {
-- 	"VIRTUAL_FIREPIT",
-- 	"VIRTUAL_COLDFIREPIT",
-- 	"VIRTUAL_MUSHROOM_LIGHT",
-- 	"VIRTUAL_MUSHROOM_LIGHT2",
-- 	"VIRTUAL_TREASURECHEST",
-- 	"VIRTUAL_HOMESIGN",
-- 	"VIRTUAL_PIGHOUSE",
-- 	"VIRTUAL_RABBITHOUSE",
-- 	"VIRTUAL_BIRDCAGE",
-- 	"VIRTUAL_WARDROBE",
-- 	"",
-- 	"",
-- 	"",
-- 	"",
-- 	"",
-- 	"",
-- 	"",
-- 	"",
-- 	"",
-- 	"",
-- 	"",
-- 	"",
-- 	"",
-- 	"",
-- 	"",
-- 	"",
-- 	"",
-- 	"",
-- 	"",
-- 	"",

-- }  
STRINGS.NAMES.VIRTUALFIREPIT = STRINGS.NAMES.FIREPIT 
STRINGS.NAMES.VIRTUALCOLDFIREPIT = STRINGS.NAMES.COLDFIREPIT 
STRINGS.NAMES.VIRTUALMUSHROOM_LIGHT = STRINGS.NAMES.MUSHROOM_LIGHT 
STRINGS.NAMES.VIRTUALMUSHROOM_LIGHT2 = STRINGS.NAMES.MUSHROOM_LIGHT2 
STRINGS.NAMES.VIRTUALTREASURECHEST = STRINGS.NAMES.TREASURECHEST 
STRINGS.NAMES.VIRTUALHOMESIGN = STRINGS.NAMES.HOMESIGN 
STRINGS.NAMES.VIRTUALPIGHOUSE = STRINGS.NAMES.PIGHOUSE 
STRINGS.NAMES.VIRTUALRABBITHOUSE = STRINGS.NAMES.RABBITHOUSE 
STRINGS.NAMES.VIRTUALBIRDCAGE = STRINGS.NAMES.BIRDCAGE 
STRINGS.NAMES.VIRTUALWARDROBE = STRINGS.NAMES.WARDROBE  

STRINGS.NAMES.VIRTUALSCARECROW = STRINGS.NAMES.SCARECROW 
STRINGS.NAMES.VIRTUALWINTERTREESTAND = STRINGS.NAMES.WINTER_TREESTAND 
STRINGS.NAMES.VIRTUALENDTABLE = STRINGS.NAMES.ENDTABLE 
STRINGS.NAMES.VIRTUALDRAGONFLYCHEST = STRINGS.NAMES.DRAGONFLYCHEST 
STRINGS.NAMES.VIRTUALDRAGONFLYFURNACE = STRINGS.NAMES.DRAGONFLYFURNACE 
STRINGS.NAMES.VIRTUALMUSHROOM_FARM = STRINGS.NAMES.MUSHROOM_FARM 
STRINGS.NAMES.VIRTUALBEEBOX = STRINGS.NAMES.BEEBOX 
STRINGS.NAMES.VIRTUALMEATRACK = STRINGS.NAMES.MEATRACK 
STRINGS.NAMES.VIRTUALCOOKPOT = STRINGS.NAMES.COOKPOT 
STRINGS.NAMES.VIRTUALICEBOX = STRINGS.NAMES.ICEBOX  
 
STRINGS.NAMES.VIRTUALTENT = STRINGS.NAMES.TENT 
STRINGS.NAMES.VIRTUALSIESTAHUT = STRINGS.NAMES.SIESTAHUT 
STRINGS.NAMES.VIRTUALSALTLICK = STRINGS.NAMES.SALTLICK 
STRINGS.NAMES.VIRTUALRESEARCHLAB = STRINGS.NAMES.RESEARCHLAB 
STRINGS.NAMES.VIRTUALRESEARCHLAB2 = STRINGS.NAMES.RESEARCHLAB2 
STRINGS.NAMES.VIRTUALRESEARCHLAB3 = STRINGS.NAMES.RESEARCHLAB3 
STRINGS.NAMES.VIRTUALRESEARCHLAB4 = STRINGS.NAMES.RESEARCHLAB4 
STRINGS.NAMES.VIRTUALCARTOGRAPHYDESK = STRINGS.NAMES.CARTOGRAPHYDESK 
STRINGS.NAMES.VIRTUALSCULPTINGTABLE = STRINGS.NAMES.SCULPTINGTABLE 
STRINGS.NAMES.VIRTUALLIGHTNING_ROD = STRINGS.NAMES.LIGHTNING_ROD  
  
STRINGS.NAMES.VIRTUALFIRESUPPRESSOR = STRINGS.NAMES.FIRESUPPRESSOR 
STRINGS.NAMES.VIRTUALSENTRYWARD = STRINGS.NAMES.SENTRYWARD 
STRINGS.NAMES.VIRTUALMOONDIAL = STRINGS.NAMES.MOONDIAL 
STRINGS.NAMES.VIRTUALTOWNPORTAL = STRINGS.NAMES.TOWNPORTAL 
STRINGS.NAMES.VIRTUALFAST_FARMPLOT = STRINGS.NAMES.FAST_FARMPLOT  
for k, v in pairs(AllRecipes) do     
	if STRINGS.NAMES[string.upper("virtual"..v.name)] ~= nil then         
		AddRecipe("virtual"..v.name, {Ingredient(GLOBAL.CHARACTER_INGREDIENT.SANITY, 0)},virtualtab, TECH.NONE, v.placer,v.min_spacing, nil, nil, nil, nil, v.image)     
	end 
end  
STRINGS.NAMES.VIRTUALWALL_STONE_ITEM = STRINGS.NAMES.WALL_STONE_ITEM 
STRINGS.NAMES.VIRTUALFENCE_ITEM = STRINGS.NAMES.FENCE_ITEM 
STRINGS.NAMES.VIRTUALFENCE_GATE_ITEM = STRINGS.NAMES.FENCE_GATE_ITEM 
STRINGS.NAMES.VIRTUALDUG_GRASS = STRINGS.NAMES.DUG_GRASS 
STRINGS.NAMES.VIRTUALDUG_SAPLING = STRINGS.NAMES.DUG_SAPLING 
STRINGS.NAMES.VIRTUALDUG_BERRYBUSH = STRINGS.NAMES.DUG_BERRYBUSH 
STRINGS.NAMES.VIRTUALDUG_BERRYBUSH2 = STRINGS.NAMES.DUG_BERRYBUSH2 
STRINGS.NAMES.VIRTUALDUG_BERRYBUSH_JUICY = STRINGS.NAMES.DUG_BERRYBUSH_JUICY  
STRINGS.NAMES.VIRTUALGRASS = STRINGS.NAMES.GRASS 
STRINGS.NAMES.VIRTUALSAPLING = STRINGS.NAMES.SAPLING 
STRINGS.NAMES.VIRTUALBERRYBUSH = STRINGS.NAMES.BERRYBUSH 
STRINGS.NAMES.VIRTUALBERRYBUSH2 = STRINGS.NAMES.BERRYBUSH2 
STRINGS.NAMES.VIRTUALBERRYBUSH_JUICY = STRINGS.NAMES.BERRYBUSH_JUICY  
STRINGS.NAMES.VIRTUALWALL_STONE = STRINGS.NAMES.WALL_STONE 
STRINGS.NAMES.VIRTUALFENCE = STRINGS.NAMES.FENCE  
AddRecipe("virtualwall_stone_item", {Ingredient(GLOBAL.CHARACTER_INGREDIENT.SANITY, 0)}, virtualtab, TECH.NONE, nil,nil, nil, 50, nil, nil, "wall_stone_item.tex") 
AddRecipe("virtualfence_item", {Ingredient(GLOBAL.CHARACTER_INGREDIENT.SANITY, 0)}, virtualtab, TECH.NONE, nil,nil, nil, 50, nil, nil, "fence_item.tex") 
AddRecipe("virtualfence_gate_item", {Ingredient(GLOBAL.CHARACTER_INGREDIENT.SANITY, 0)}, virtualtab, TECH.NONE, nil,nil, nil, 50, nil, nil, "fence_gate_item.tex") 
AddRecipe("virtualdug_grass", {Ingredient(GLOBAL.CHARACTER_INGREDIENT.SANITY, 0)}, virtualtab, TECH.NONE, nil,nil, nil, 50, nil, nil, "dug_grass.tex") 
AddRecipe("virtualdug_sapling", {Ingredient(GLOBAL.CHARACTER_INGREDIENT.SANITY, 0)}, virtualtab, TECH.NONE, nil,nil, nil, 50, nil, nil, "dug_sapling.tex") 
AddRecipe("virtualdug_berrybush", {Ingredient(GLOBAL.CHARACTER_INGREDIENT.SANITY, 0)}, virtualtab, TECH.NONE, nil,nil, nil, 50, nil, nil, "dug_berrybush.tex") 
AddRecipe("virtualdug_berrybush2", {Ingredient(GLOBAL.CHARACTER_INGREDIENT.SANITY, 0)}, virtualtab, TECH.NONE, nil,nil, nil, 50, nil, nil, "dug_berrybush2.tex") 
AddRecipe("virtualdug_berrybush_juicy", {Ingredient(GLOBAL.CHARACTER_INGREDIENT.SANITY, 0)}, virtualtab, TECH.NONE, nil,nil, nil, 50, nil, nil, "dug_berrybush_juicy.tex")  

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
		local item = GLOBAL.DebugSpawn("virtualwall_stone")
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
							local item = GLOBAL.DebugSpawn("virtual"..v.type)
							if item then 
								item.Transform:SetPosition(tx, 0, tz)
								if item.prefab == "virtuallightning_rod" then
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