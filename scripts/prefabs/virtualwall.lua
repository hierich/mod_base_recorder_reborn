local assets = { }  
local prefabs = {"collapse_small", }
 
local VIRTUAL_PREFIX = "virtual_"    
local function ondeploywall(inst, pt, deployer)         
	local wall = SpawnPrefab(VIRTUAL_PREFIX.."wall_stone")          
	if wall ~= nil then              
		local x = math.floor(pt.x) + .5             
		local z = math.floor(pt.z) + .5             
		wall.Physics:SetCollides(false)             
		wall.Physics:Teleport(x, 0, z)         
	end     
end      

local function ondrop(inst)         
	inst:Remove()     
end      

local function itemfn()         
	local inst = CreateEntity()          
	inst.entity:AddTransform()         
	inst.entity:AddAnimState()         
	inst.entity:AddNetwork()          
	MakeInventoryPhysics(inst)          
	inst:AddTag("wallbuilder")          
	inst.AnimState:SetBank("wall")         
	inst.AnimState:SetBuild("wall_stone")         
	inst.AnimState:PlayAnimation("idle")          
	inst.entity:SetPristine()          
	if not TheWorld.ismastersim then             
		return inst         
	end          
	inst:AddComponent("inventoryitem")         
	inst.components.inventoryitem.atlasname = "images/inventoryimages.xml"         
	inst.components.inventoryitem.imagename = "wall_stone_item"         
	inst.components.inventoryitem:SetOnDroppedFn(ondrop)          
	inst:AddComponent("stackable")         
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM          
	inst:AddComponent("deployable")         
	inst.components.deployable.ondeploy = ondeploywall         
	inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)          
	MakeHauntableLaunch(inst)          
	return inst     
end      

local function onhammered(inst, worker)         
	inst:Remove()     
end      

local function CanActivate(inst, doer)         
	return doer.components.inventory:Has("wall_stone_item",1)     
end      

local function Activate(inst, doer)         
	doer.components.inventory:ConsumeByName("wall_stone_item",1)         
	local x, y, z = inst.Transform:GetWorldPosition()        
	local wall = SpawnPrefab("wall_stone")          
	wall.Physics:SetCollides(false)         
	wall.Physics:Teleport(x, 0, z)         
	wall.Physics:SetCollides(true)         
	onhammered(inst)     
end      

local function fn()         
	local inst = CreateEntity()          
	inst.entity:AddTransform()         
	inst.entity:AddAnimState()         
	inst.entity:AddSoundEmitter()         
	inst.entity:AddNetwork()          
	inst.Transform:SetEightFaced()          
	MakeObstaclePhysics(inst, .5)         
	inst.Physics:SetCollides(false)         
	inst.Physics:SetDontRemoveOnSleep(true)          
	inst:AddTag("wall")         
	inst:AddTag("noauradamage")         
	inst:AddTag("nointerpolate")          
	inst.AnimState:SetBank("wall")         
	inst.AnimState:SetBuild("wall_stone")         
	inst.AnimState:PlayAnimation("half")         
	inst.AnimState:SetMultColour(TUNING.VIRTUALRED,TUNING.VIRTUALGREEN,TUNING.VIRTUALBLUE,TUNING.VIRTUALALPHA)          
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

return Prefab(VIRTUAL_PREFIX.."wall_stone_item", itemfn, assets, prefabs),
	Prefab(VIRTUAL_PREFIX.."wall_stone", fn, assets, prefabs),     
	MakePlacer(VIRTUAL_PREFIX.."wall_stone_item_placer", "wall", "wall_stone", "half", false, false, true, nil, nil, "eight")