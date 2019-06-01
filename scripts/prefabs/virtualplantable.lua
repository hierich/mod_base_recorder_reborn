require "prefabutil"  
local function make_virtualitem(data)     
	-- local assets ={Asset("ANIM", "anim/"..data.name..".zip"),}      
	-- if data.build ~= nil then         
	-- 	table.insert(assets, Asset("ANIM", "anim/"..data.build..".zip"))     
	-- end
	local assets = {}      

	local function ondrop(inst)         
		inst:Remove()     
	end      

	local function ondeploy(inst, pt, deployer)         
		local tree = SpawnPrefab("virtual"..data.name)         
		if tree ~= nil then             
			tree.Transform:SetPosition(pt:Get())             
			inst.components.stackable:Get():Remove()             
			if deployer ~= nil and deployer.SoundEmitter ~= nil then                 
				deployer.SoundEmitter:PlaySound("dontstarve/common/plant")             
			end         
		end     
	end      

     

	local function fn()         
		local inst = CreateEntity()          
		inst.entity:AddTransform()         
		inst.entity:AddAnimState()         
		inst.entity:AddNetwork()          
		MakeInventoryPhysics(inst)          
		
		inst.AnimState:SetBank(data.bank or data.name)         
		inst.AnimState:SetBuild(data.build or data.name)         
		inst.AnimState:PlayAnimation("dropped")

		inst.entity:SetPristine()          
		if not TheWorld.ismastersim then             
			return inst         
		end          
		inst:AddComponent("stackable")         
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM          
		inst:AddComponent("inventoryitem")         
        inst.components.inventoryitem.imagename = "dug_"..data.name
		         
		inst.components.inventoryitem:SetOnDroppedFn(ondrop)          
		inst:AddComponent("deployable")
		
		         
		inst.components.deployable.ondeploy = ondeploy        
		inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)         
		if data.mediumspacing then             
			inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)         
		end
		return inst     
	end      


	return Prefab("virtualdug_"..data.name, fn, assets)
	
end  

local plantables = 
{
	{name = "berrybush",anim = "dead",},
	{name = "berrybush2",anim = "dead",inspectoverride = "dug_berrybush",},
	{name = "berrybush_juicy",anim = "dead",inspectoverride = "dug_berrybush",},
	{name = "sapling",mediumspacing = true     },     
	{name = "grass",build = "grass1",mediumspacing = true     },     
	{name = "marsh_bush",mediumspacing = true     }, 
}  

local prefabs = {} 

for i, v in ipairs(plantables) do     
	table.insert(prefabs, make_virtualitem(v))     
	table.insert(prefabs, MakePlacer("virtualdug_"..v.name.."_placer", v.bank or v.name, v.build or v.name, v.anim or "idle")) 
end  


return unpack(prefabs) 