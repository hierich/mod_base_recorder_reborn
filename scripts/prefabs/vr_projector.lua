local assets=
{ 
    Asset("ANIM", "anim/cleanupwand.zip"),
    Asset("ANIM", "anim/swap_cleanupwand.zip"), 

    Asset("ATLAS", "images/inventoryimages/cleanupwand.xml"),
    Asset("IMAGE", "images/inventoryimages/cleanupwand.tex"),
}

local prefabs = 
{		
}

local record_path = "layout_record"
local VIRTUAL_PREFIX = "virtual_"


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

	if STRINGS.NAMES[string.upper(VIRTUAL_PREFIX..inst.name)] ~= nil then
		return true
	end

	return false
end

local function Project(staff, target, pos)
	-- if staff.components.owner == nil then
	-- 	return
	-- end
	-- local user_id = staff.components.owner.userid
	-- TUNING.VR_LAYOUT_RECORDS[user_id]
	local layout_record = VR_File.LoadTable(record_path)
	if type(layout_record) == "table" then
		for k,inst in pairs(layout_record) do
			if CanProject(inst) then
				local virtual_thing = SpawnPrefab(VIRTUAL_PREFIX..inst.name)
	        	if virtual_thing then
				    local pt = Vector3(pos.x+inst.x, pos.y+inst.y, pos.z+inst.z)
				    local oreint = inst.orient
		            virtual_thing.Transform:SetPosition(pt:Get())
		            virtual_thing.Transform:SetRotation(oreint)
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

end

local function fn(colour)

    local function OnEquip(inst, owner) 
        --owner.AnimState:OverrideSymbol("swap_object", "swap_wands", "purplestaff")
        owner.AnimState:OverrideSymbol("swap_object", "swap_cleanupwand", "wand")
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
    
    anim:SetBank("cleanupwand")
    anim:SetBuild("cleanupwand")
    anim:PlayAnimation("idle")

    if not TheWorld.ismastersim then   
      return inst  
    end   
    
    inst.entity:SetPristine()

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "cleanupwand"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/cleanupwand.xml"
    
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