-- require "prefabutil"
-- local VIRTUAL_PREFIX = "virtual_"
local VIRTUAL_PREFIX = STRINGS.VIRTUAL_PREFIX
local function make_virtual_plantable(data)     
	-- local assets ={Asset("ANIM", "anim/"..data.name..".zip"),}      
	-- if data.build ~= nil then         
	-- 	table.insert(assets, Asset("ANIM", "anim/"..data.build..".zip"))     
	-- end
	local assets = {}      

	local function ondrop(inst)         
		inst:Remove()     
	end      

	local function ondeploy(inst, pt, deployer)         
		local tree = SpawnPrefab(VIRTUAL_PREFIX..data.name)         
		if tree ~= nil then             
			tree.Transform:SetPosition(pt:Get())             
			inst.components.stackable:Get():Remove()             
			if deployer ~= nil and deployer.SoundEmitter ~= nil then                 
				deployer.SoundEmitter:PlaySound("dontstarve/common/plant")             
			end         
		end     
	end

	local function itemfn()         
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

    local function onhammered(inst, worker)         
		inst:Remove()     
	end      

	local function CanActivate(inst, doer)                  
		local ret = false         
            
		ret = doer.components.inventory:Has("dug_"..data.name,1)                
		return ret     
	end      

	local function Activate(inst, doer)                  
		local truestruct = SpawnPrefab(data.name)         
		doer.components.inventory:ConsumeByName("dug_"..data.name, 1)             
		truestruct.Transform:SetPosition(inst.Transform:GetWorldPosition())             
		truestruct.components.pickable:OnTransplant()	        		         
		onhammered(inst)     
	end 

	local function fn()         
		local inst = CreateEntity()          
		inst.entity:AddTransform()         
		inst.entity:AddAnimState()         
		inst.entity:AddNetwork()          
		inst:AddTag("structure")          
		inst.AnimState:SetBank(data.bank)         
		inst.AnimState:SetBuild(data.build)         
		inst.AnimState:PlayAnimation(data.anim)
		         
		inst.AnimState:SetMultColour(TUNING.VIRTUALRED,TUNING.VIRTUALGREEN,TUNING.VIRTUALBLUE,TUNING.VIRTUALALPHA)          
		inst.entity:SetPristine()          

		if not TheWorld.ismastersim then             
			return inst         
		end          

		inst:AddComponent("workable")         
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)         
		inst.components.workable:SetWorkLeft(1)         
		inst.components.workable:SetOnFinishCallback(onhammered)         
		inst:AddComponent("activatable")         
		inst.components.activatable.quickaction = true         
		inst.components.activatable.CanActivateFn = CanActivate         
		inst.components.activatable.OnActivate = Activate   

		return inst     
	end      


	return Prefab(VIRTUAL_PREFIX..data.name, fn, assets),
		Prefab(VIRTUAL_PREFIX.."dug_"..data.name, itemfn, assets),
		MakePlacer(VIRTUAL_PREFIX.."dug_"..data.name.."_placer", data.bank or data.name, data.build or data.name, data.anim or "idle")
	
end  

local plantables = 
{
	{name = "berrybush", bank = "berrybush", build = "berrybush", anim = "idle",},
	{name = "berrybush2", bank = "berrybush2", build = "berrybush2", anim = "idle",},
	{name = "berrybush_juicy", bank = "berrybush_juicy", build = "berrybush_juicy", anim = "idle",},
	{name = "sapling", bank = "sapling", build = "sapling", anim = "idle", mediumspacing = true,},     
	{name = "grass", bank = "grass", build = "grass1", anim = "idle", mediumspacing = true,},     
	{name = "marsh_bush", bank = "marsh_bush", build = "marsh_bush", anim = "idle", mediumspacing = true,}, 
}  

local prefabs = {} 

for i, v in ipairs(plantables) do
	local plant, dug_plant, placer = make_virtual_plantable(v)
	table.insert(prefabs, plant)     
	table.insert(prefabs, dug_plant)
	table.insert(prefabs, placer) 
end  


return unpack(prefabs) 