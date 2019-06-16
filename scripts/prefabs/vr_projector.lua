local assets=
{
    Asset("ANIM", "anim/vr_projector.zip"),
    Asset("ANIM", "anim/swap_vr_projector.zip"),

    Asset("ATLAS", "images/inventoryimages/vr_projector.xml"),
    Asset("IMAGE", "images/inventoryimages/vr_projector.tex"),
}

local prefabs =
{
}

local record_path = STRINGS.VR_RECORD_PATH
-- local VIRTUAL_PREFIX = "virtual_"
local VIRTUAL_PREFIX = STRINGS.VIRTUAL_PREFIX

-- local function Id2Player(id)
-- 	local player = nil
-- 	for k, v in pairs(AllPlayers) do
-- 		if v.userid == id then player = v end
-- 	end
-- 	return player
-- end

------------------------------------ setting ------------------------------------
-- recipe
-- local vr_projector = Recipe("vr_projector", {Ingredient("charcoal", 4), Ingredient("deerclops_eyeball", 1), Ingredient("transistor", 2)}, RECIPETABS[STRINGS.NAMES.VIRTUAL_TAB], TECH.NONE)
-- vr_projector.atlas = "images/inventoryimages/vr_projector.xml"
------------------------------------ entity ------------------------------------
local function CanProject(inst)
	if inst.name == nil or inst.x == nil or inst.y == nil or inst.z == nil or inst.orient == nil then -- check attributes complete
		return false
	end

	if STRINGS.NAMES[string.upper(VIRTUAL_PREFIX..inst.name)] == nil then
		return false
	end

	return true
end

local function Project(pos)
	-- if staff.components.owner == nil then
	-- 	return
	-- end
	-- local user_id = staff.components.owner.userid
	-- TUNING.VR_LAYOUT_RECORDS[user_id]
	local baseplan = VR_File.LoadTable(record_path)
    if type(baseplan) ~= "table" then
        print("load data error")
        return 
    end
    local title = nil
    local layout_record = nil
    if baseplan.title == nil then
        print("title missed")
        title = "missed"
        layout_record = baseplan
    else
        title = baseplan.title
        layout_record = baseplan.layout_record
    end



	-- use a stone wall item to test if this place can be depolyed
	local test_obj = SpawnPrefab("wall_stone_item")
	if test_obj == nil then
		print("Cannot generate the test object")
		return nil
	end
	if type(layout_record) == "table" then

		for k,inst in pairs(layout_record) do
			if CanProject(inst) then
				local virtual_thing = SpawnPrefab(VIRTUAL_PREFIX..inst.name)
	        	if virtual_thing then
				    local pt = Vector3(vrRound(pos.x+inst.x), pos.y+inst.y, pos.z+inst.z)
				    local oreint = inst.orient
				    local test = test_obj.components.deployable:CanDeploy(pt)
				    -- local test = true
				    if test then
				    	virtual_thing.Transform:SetPosition(pt:Get())
		            	virtual_thing.Transform:SetRotation(oreint)
		            else
		            	virtual_thing:Remove()
		            end

		        else
		        	print("[VR] cannot spawn prefab")
	        	end
	        else
	        	print("[VR] this prefab is not allowed to projected")
	        end
		end

	else
		print("[VR] load data error")
	end
	test_obj:Remove()

end


local function ondeploy(inst, pt, deployer)
    local x,y,z = pt:Get()
    pt.x = math.floor(x)+0.5
    pt.y = 0
    pt.z = math.floor(z)+0.5
    inst.AnimState:PlayAnimation("work")
    inst.Transform:SetPosition(pt.x,pt.y,pt.z)
    Project(pt)
end

local function fn(colour)

    local function OnEquip(inst, owner)
        --owner.AnimState:OverrideSymbol("swap_object", "swap_wands", "purplestaff")
        owner.AnimState:OverrideSymbol("swap_object", "swap_vr_projector", "swap_vr_projector")
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

    anim:SetBank("vr_projector")
    anim:SetBuild("vr_projector")
    anim:PlayAnimation("idle")

    if not TheWorld.ismastersim then
      return inst
    end

    inst.entity:SetPristine()

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "vr_projector"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/vr_projector.xml"

    -- inst:AddComponent("equippable")
    -- inst.components.equippable:SetOnEquip( OnEquip )
    -- inst.components.equippable:SetOnUnequip( OnUnequip )

    -- inst:AddComponent("inspectable")

    -- inst:AddComponent("spellcaster")
    -- inst.components.spellcaster:SetSpellFn(Project)
    -- inst.components.spellcaster.canuseonpoint =true

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
    -- MakeHauntableLaunch(inst)


    return inst
end

local PLACER_SCALE = 1.75

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

    placer2.AnimState:SetBank("vr_projector")
    placer2.AnimState:SetBuild("vr_projector")
    placer2.AnimState:PlayAnimation("idle")
    placer2.AnimState:SetLightOverride(1)

    placer2.entity:SetParent(inst.entity)

    inst.components.placer:LinkEntity(placer2)
end

return  Prefab("vr_projector", fn, assets, prefabs),
    MakePlacer("vr_projector_placer", "firefighter_placement", "firefighter_placement", "idle", true, nil, nil, PLACER_SCALE, nil, nil, placer_postinit_fn)
