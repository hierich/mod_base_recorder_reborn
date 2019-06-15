local assets=
{
    Asset("ANIM", "anim/vr_camera.zip"),
    Asset("ANIM", "anim/swap_vr_camera.zip"),

    Asset("ATLAS", "images/inventoryimages/vr_camera.xml"),
    Asset("IMAGE", "images/inventoryimages/vr_camera.tex"),
}

local prefabs =
{
}

-- print("execute order")
local record_path = STRINGS.VR_RECORD_PATH
-- local VIRTUAL_PREFIX = "virtual_"
local VIRTUAL_PREFIX = STRINGS.VIRTUAL_PREFIX
-- local function SaveTable(data, filepath)
-- 	if data and type(data) == "table" and filepath and type(filepath) == "string" then
-- 		SavePersistentString(filepath, DataDumper(data, nil, true), false, nil)
-- 		print("DATA HAS SAVED!")
-- 	else
-- 		print("Error type:"..type(data))
-- 	end
-- end

-- local function LoadTable(filepath)
-- 	local data = nil
-- 	TheSim:GetPersistentString(filepath,
-- 		function(load_success, str)
-- 			if load_success == true then
-- 				local success, loaddata = RunInSandboxSafe(str)
-- 				if success and string.len(str) > 0 then
-- 					data = savedata
-- 				else
-- 					print ("[Virtual Reality] Could not load "..filepath)
-- 				end
-- 			else
-- 				print ("[Virtual Reality] Can not find "..filepath)
-- 			end
-- 		end
-- 	)
-- 	return data
-- end
------------------------------------ setting ------------------------------------


-- local vr_camera = Recipe("vr_camera", {Ingredient("ice", 10), Ingredient("deerclops_eyeball", 1), Ingredient("rocks", 8)}, RECIPETABS[STRINGS.NAMES.VIRTUAL_TAB], TECH.NONE)
-- print("add recipe")
-- vr_camera.atlas = "images/inventoryimages/vr_camera.xml"
------------------------------------ entity ------------------------------------
local function CanRecord(inst)
	if inst.components.inventoryitem ~= nil and not inst:HasTag("trap") then
		return false
	end

    if inst.prefab == nil then
        return false
    end

	if STRINGS.NAMES[string.upper(VIRTUAL_PREFIX..inst.prefab)] ~= nil then
		return true
	end
	return false
end

-- local AffineTransformation(pos, matrix_T)

-- end
local scale = 1.4
local function Record(pos)
	local x = pos.x
	local y = pos.y
	local z = pos.z
	local range = 20*scale
    local entity_list = TheSim:FindEntities(x, y, z, range)
    local baseplan = {title = "",}
    local layout_record = {}
    baseplan.layout_record = layout_record
    for i, entity in pairs(entity_list) do
		if entity:IsValid() and CanRecord(entity) then

			local pos_in_world = Vector3(entity.Transform:GetWorldPosition())
			local pos_in_camera = Vector3(pos_in_world.x-x, pos_in_world.y-y, pos_in_world.z-z)
			local orient_in_world = entity.Transform:GetRotation()
			local orient_in_camera = orient_in_world
			local entity_record =
			{
				name = entity.prefab,
				x = vrRound(pos_in_camera.x),
				y = vrRound(pos_in_camera.y),
				z = vrRound(pos_in_camera.z),
				orient = orient_in_camera,
			}
			-- entity_record.name = entity.prefab
			-- entity_record.pos = pos_in_camera
			-- entity_record.orient = orient_in_world
			-- local pos_in_camera = Vector3(pos_in_world.x-x, pos_in_world.y-y, pos_in_world.z-z)


      table.insert(layout_record, entity_record)
      print("Record "..entity.prefab)
		end
    end

    VR_File.SaveTable(baseplan, record_path)
end


local function ondeploy(inst, pt, deployer)
    local x,y,z = pt:Get()
    pt.x = math.floor(x)+0.5
    pt.y = 0
    pt.z = math.floor(z)+0.5
    inst.AnimState:PlayAnimation("work")
    inst.Transform:SetPosition(pt:Get())
    Record(pt)
    -- local sign = SpawnPrefab("wall_stone")
    -- sign.Transform:SetPosition(x+20,y,z)
end

local function fn(colour)

    local function OnEquip(inst, owner)
        --owner.AnimState:OverrideSymbol("swap_object", "swap_wands", "purplestaff")
        owner.AnimState:OverrideSymbol("swap_object", "swap_vr_camera", "swap_vr_camera")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")

    end

    local function OnUnequip(inst, owner)
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")

    end

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    anim:SetBank("vr_camera")
    anim:SetBuild("vr_camera")
    anim:PlayAnimation("idle")

    if not TheWorld.ismastersim then
      return inst
    end

    inst.entity:SetPristine()

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "vr_camera"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/vr_camera.xml"

    -- inst:AddComponent("equippable")
    -- inst.components.equippable:SetOnEquip( OnEquip )
    -- inst.components.equippable:SetOnUnequip( OnUnequip )

    -- inst:AddComponent("inspectable")

    -- inst:AddComponent("spellcaster")
    -- inst.components.spellcaster:SetSpellFn(Record)
    -- inst.components.spellcaster.canuseonpoint =true

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)

    -- MakeHauntableLaunch(inst)


    return inst
end

local PLACER_SCALE = 1.75*scale

local function placer_postinit_fn(inst)

    local placer2 = CreateEntity()

    placer2.entity:SetCanSleep(false)
    placer2.persists = false

    placer2.entity:AddTransform()
    placer2.entity:AddAnimState()

    placer2:AddTag("CLASSIFIED")
    placer2:AddTag("NOCLICK")
    placer2:AddTag("placer")

    local s = 1 / PLACER_SCALE
    placer2.Transform:SetScale(s, s, s)

    placer2.AnimState:SetBank("vr_camera")
    placer2.AnimState:SetBuild("vr_camera")
    placer2.AnimState:PlayAnimation("idle")
    placer2.AnimState:SetLightOverride(1)

    placer2.entity:SetParent(inst.entity)

    inst.components.placer:LinkEntity(placer2)
end

return  Prefab("vr_camera", fn, assets, prefabs),
    MakePlacer("vr_camera_placer", "firefighter_placement", "firefighter_placement", "idle", true, nil, nil, PLACER_SCALE, nil, nil, placer_postinit_fn)
