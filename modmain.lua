PrefabFiles = 
{ 
	"virtualstruct", 
	"virtualfiresuppressor",    
	"virtualwall",     
	"virtualplantable",     
	"virtualfence",
	"virtual_trap_teeth",
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
STRINGS.VR_RECORD_PATH = "mod_config_data/vr_record"
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

	-- add virtual minetraps
	local virtual_minetrap_names = 
	{
		"trap_teeth",
	} 

	for k, v in pairs(virtual_minetrap_names) do
		STRINGS.NAMES[string.upper(VIRTUAL_PREFIX..v)] = "Virtual "..STRINGS.NAMES[string.upper(v)]
		-- not allowed to build virtual trap
		-- AddRecipe(VIRTUAL_PREFIX..v, {Ingredient(CHARACTER_INGREDIENT.SANITY, 0)}, virtualtab, TECH.NONE, structure_recipe.placer, GLOBAL.DEPLOYSPACING.LESS, nil, nil, nil, nil, structure_recipe.image)
	end

	-- add vr projector 
	STRINGS.NAMES[string.upper("vr_projector")] = "VR Projector"

	-- add vr camera
	STRINGS.NAMES[string.upper("vr_camera")] = "VR Camera"
end
-- add recipe
AddVirtualRecipe()


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




