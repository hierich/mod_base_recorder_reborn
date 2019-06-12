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

local record_path = "layout_record"
-- local VIRTUAL_PREFIX = "virtual_"
local VIRTUAL_PREFIX = STRINGS.VIRTUAL_PREFIX

-- local function Id2Player(id) 
-- 	local player = nil 
-- 	for k, v in pairs(AllPlayers) do 
-- 		if v.userid == id then player = v end 
-- 	end 
-- 	return player 
-- end

local function CanProject(inst)
	if inst.name == nil or inst.x == nil or inst.y == nil or inst.z == nil or inst.orient == nil then -- check attributes complete
		return false
	end

	if STRINGS.NAMES[string.upper(VIRTUAL_PREFIX..inst.name)] == nil then
		return false
	end

	return true
end

local function Project(staff, target, pos)
	-- if staff.components.owner == nil then
	-- 	return
	-- end
	-- local user_id = staff.components.owner.userid
	-- TUNING.VR_LAYOUT_RECORDS[user_id]
	local layout_record = VR_File.LoadTable(record_path)

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
				    local pt = Vector3(pos.x+inst.x, pos.y+inst.y, pos.z+inst.z)
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
		print("data")
	end	
	test_obj:Remove()

end

local function OnEnableHelper(inst, enabled)
    if enabled then
        if inst.helper == nil then
            inst.helper = CreateEntity()

            --[[Non-networked entity]]
            inst.helper.entity:SetCanSleep(false)
            inst.helper.persists = false

            inst.helper.entity:AddTransform()
            inst.helper.entity:AddAnimState()

            inst.helper:AddTag("CLASSIFIED")
            inst.helper:AddTag("NOCLICK")
            inst.helper:AddTag("placer")

            inst.helper.Transform:SetScale(PLACER_SCALE, PLACER_SCALE, PLACER_SCALE)

            inst.helper.AnimState:SetBank("firefighter_placement")
            inst.helper.AnimState:SetBuild("firefighter_placement")
            inst.helper.AnimState:PlayAnimation("idle")
            inst.helper.AnimState:SetLightOverride(1)
            inst.helper.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
            inst.helper.AnimState:SetLayer(LAYER_BACKGROUND)
            inst.helper.AnimState:SetSortOrder(1)
            inst.helper.AnimState:SetAddColour(0, .2, .5, 0)

            inst.helper.entity:SetParent(inst.entity)
        end
    elseif inst.helper ~= nil then
        inst.helper:Remove()
        inst.helper = nil
    end
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
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )

    inst:AddComponent("inspectable")
 
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(Project)
    inst.components.spellcaster.canuseonpoint =true

    MakeHauntableLaunch(inst) 


    return inst
end


return  Prefab("vr_projector", fn, assets, prefabs)