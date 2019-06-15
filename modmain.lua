
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
Assets =
{
	Asset( "ATLAS", "images/hud/virtualtab.xml" ),
	-- Asset("ATLAS", "images/inventoryimages/vr_projector.xml"),
 --    Asset("IMAGE", "images/inventoryimages/vr_projector.tex"),
    -- Asset("ATLAS", "images/inventoryimages/vr_camera.xml"),
 --    Asset("IMAGE", "images/inventoryimages/vr_camera.tex"),
}

local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local AllRecipes = GLOBAL.AllRecipes
local CHARACTER_INGREDIENT = GLOBAL.CHARACTER_INGREDIENT
local TUNING = GLOBAL.TUNING


-----------------------config---------------------------

local mylanguage = GetModConfigData("language")

-- if mylanguage == 1 then
-- 	STRINGS.NAMES.VIRTUAL_TAB = "Virtual"
-- 	-- STRINGS.NAMES.VIRTUALITEM_TAB = "Virtual Item"
-- else
-- 	STRINGS.NAMES.VIRTUAL_TAB = "虚拟造物"
-- 	-- STRINGS.NAMES.VIRTUALITEM_TAB = "虚拟物品"
-- end

-- the prefix is just for this mod



TUNING.VIRTUALALPHA = GetModConfigData("alpha")
local color = GetModConfigData("color")
TUNING.VIRTUALRED = color / 100
TUNING.VIRTUALGREEN = (color/10)%10
TUNING.VIRTUALBLUE = color%10


STRINGS.VIRTUAL_PREFIX = "virtual_"
local VIRTUAL_PREFIX = STRINGS.VIRTUAL_PREFIX
STRINGS.VR_RECORD_PATH = "mod_config_data/vr_record"
STRINGS.NAMES.VIRTUAL_TAB = "Virtual"

-------------------------util--------------------------
modimport("scripts/vrUtils.lua")


-------------------------addd recipe----------------------
local function AddVirtualRecipe()
	local virtualtab = AddRecipeTab(STRINGS.NAMES.VIRTUAL_TAB, 99, "images/hud/virtualtab.xml", "virtualtab.tex")
	print("add virtual tab")

	-- add virtual recipes one by one

	-- add vr projector
	STRINGS.NAMES[string.upper("vr_projector")] = "VR Projector"
	local vr_projector = AddRecipe("vr_projector", {Ingredient("charcoal", 4), Ingredient("deerclops_eyeball", 1), Ingredient("transistor", 2)}, virtualtab, TECH.NONE)
	vr_projector.atlas = "images/inventoryimages/vr_projector.xml"
	-- add vr camera
	STRINGS.NAMES[string.upper("vr_camera")] = "VR Camera"
	local vr_camera = AddRecipe("vr_camera", {Ingredient("ice", 10), Ingredient("deerclops_eyeball", 1), Ingredient("rocks", 8)}, virtualtab, TECH.NONE)
	vr_camera.atlas = "images/inventoryimages/vr_camera.xml"

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
		STRINGS.NAMES[string.upper(VIRTUAL_PREFIX..v.."_item")] = "Virtual "..STRINGS.NAMES[string.upper(v)]
		AddRecipe(VIRTUAL_PREFIX..v.."_item", {Ingredient(CHARACTER_INGREDIENT.SANITY, 0)}, virtualtab, TECH.NONE, nil,nil, nil, 50, nil, nil, v..".tex")
	end

end
-- add recipe
AddVirtualRecipe()
