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

local function SaveTable(data, filepath)
	if data and type(data) == "table" and filepath and type(filepath) == "string" then
		SavePersistentString(filepath, DataDumper(data, nil, true), false, nil)
		print("DATA HAS SAVED!")
	else
		print("Error type:"..type(data))
	end
end

local function CanRecord(inst)
	if inst.components.inventoryitem ~= nil then
		return false
	end
	if STRINGS.NAMES[string.upper(VIRTUAL_PREFIX..inst.prefab)] ~= nil then
		return true
	end
	return false
end

-- local AffineTransformation(pos, matrix_T)
	
-- end

local function Record(staff, target, pos)
	local x = pos.x
	local y = pos.y
	local z = pos.z
	local range = 20
    local entity_list = TheSim:FindEntities(x, y, z, range)
    local layout_record = {}
    for i, entity in pairs(entity_list) do
		if entity:IsValid() and CanRecord(entity) then
			
			local pos_in_world = Vector3(entity.Transform:GetWorldPosition())
			local pos_in_camera = Vector3(pos_in_world.x-x, pos_in_world.y-y, pos_in_world.z-z)
			local orient_in_world = entity.Transform:GetRotation()
			local orient_in_camera = orient_in_world
			local entity_record = 
			{
				name = entity.prefab,
				x = pos_in_camera.x,
				y = pos_in_camera.y,
				z = pos_in_camera.z,
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
    SaveTable(layout_record, record_path)
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
    inst.components.spellcaster:SetSpellFn(Record)
    inst.components.spellcaster.canuseonpoint =true

    MakeHauntableLaunch(inst) 


    return inst
end


return  Prefab("camera", fn, assets, prefabs)