
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
local require = GLOBAL.require

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
TUNING.VRTOOL_USES = GetModConfigData("vrtool_uses")

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

----------------------------------- network functions ----------------------


-- Record event
local function onVRSaveStrDirty(inst)
	local SaveStr = inst.net_vrsavestr:value()
	if GLOBAL.type(SaveStr) == "string" then
		local save_tab = GLOBAL.VR_Serialization.Deserialize(SaveStr)
		if GLOBAL.type(save_tab) ~= "table" then
			print("net_variable vrsavestr cannot be deserialized into table")
			return nil
		end
		-- GLOBAL.VR_File.SaveTable(save_tab, STRINGS.VR_RECORD_PATH)
		inst.vr_planner:SavePlan(save_tab)
	else
		print("net_variable vrsavestr type error")
	end
end

-- project event
local function onVRLoadDirty(inst)
	local baseplan = inst.vr_planner:LoadPlan()
	-- local baseplan = GLOBAL.VR_File.LoadTable(STRINGS.VR_RECORD_PATH)
	if type(baseplan) ~= "table" then
		print("load data error")
		return
	end

	local serial_str = GLOBAL.VR_Serialization.Serialize(baseplan)
	if GLOBAL.type(serial_str) == "string" then
		-- print("serial data = "..serial_str)
		-- call master to really project
		SendModRPCToServer(MOD_RPC[modname]["MasterProject"], serial_str)
	else
		print("serial error, its type = "..GLOBAL.type(serial_str))
	end
end

-- host will spawn things
local function MasterProject(player, baseplan_str)
	local baseplan = GLOBAL.VR_Serialization.Deserialize(baseplan_str)
	if GLOBAL.type(baseplan) ~= "table" then
		print("baseplan type error, so mastersim cannot project")
		return nil
	end

	GLOBAL.VR_File.Project(player.pose, baseplan)
end
-- add project function above
AddModRPCHandler(modname, "MasterProject", MasterProject)

local planner = require("planner")
local vr_planner = planner()
local function customhppostinit(inst)
	-- Net variable that stores between 0-255; more info in netvars.lua
	-- GUID of entity, unique identifier of variable, event pushed when variable changes
	-- Event is pushed to the entity it refers to, server and client side wise

	-- tansfer saved string of baseplan
	inst.net_vrsavestr = GLOBAL.net_string(inst.GUID, "vrsavestr", "vrsavestrdirty")
	-- tell to load
	inst.net_vrload = GLOBAL.net_bool(inst.GUID, "vrload", "vrloaddirty")

	-- Dedicated server is dummy player, only players hosting or clients have the badges
	-- Only them react to the event pushed when the net variable changes
	if not GLOBAL.TheNet:IsDedicated() then
		inst:ListenForEvent("vrsavestrdirty", onVRSaveStrDirty)
		inst:ListenForEvent("vrloaddirty", onVRLoadDirty)
	end

	inst.vr_planner = vr_planner
end
-- Apply function on player entity post initialization
AddPlayerPostInit(customhppostinit)


---------------------------- add ui --------------------------
local planner_ui = require("widgets/planner_ui")

local function AddUI(self)
    if self.owner then
		self.vr_planner_ui = self:AddChild(planner_ui(vr_planner,"virtualtab"))
		vr_planner:AddUI(self.vr_planner_ui)
    end
end
AddClassPostConstruct("widgets/controls", AddUI)
