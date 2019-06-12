local assets = { }  
local prefabs = {  "firesuppressor_glow", }  
local PLACER_SCALE = 1.55  
local VIRTUAL_PREFIX = STRINGS.VIRTUAL_PREFIX
local function OnEnableHelper(inst, enabled)     
	if enabled then         
		if inst.helper == nil then             
			inst.helper = CreateEntity()              
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

local function oninit(inst)     
	inst._glow.Follower:FollowSymbol(inst.GUID, "swap_glow", 0, 0, 0) 
end  

local function onhammered(inst, worker)     
	inst:Remove() 
end      

local function CanActivate(inst, doer)         
	local recipe = GetValidRecipe("firesuppressor")         
	local ret = false         
	if recipe ~= nil then              
		ret = doer.components.builder:IsBuildBuffered("firesuppressor") or (doer.components.builder:CanBuild("firesuppressor") and doer.components.builder:KnowsRecipe("firesuppressor"))         
	end         
	return ret     
end      

local function Activate(inst, doer)         
	local truestruct = SpawnPrefab("firesuppressor")         
	local recipe = GetValidRecipe("firesuppressor")         
	if doer.components.builder:IsBuildBuffered("firesuppressor") then             
		doer.components.builder.buffered_builds["firesuppressor"] = nil             
		doer.replica.builder:SetIsBuildBuffered("firesuppressor", false)         
	else             
		local materials = doer.components.builder:GetIngredients("firesuppressor")             
		doer.components.builder:RemoveIngredients(materials, "firesuppressor")         
	end         

	truestruct.Transform:SetPosition(inst.Transform:GetWorldPosition())          
	onhammered(inst)     

end  

local function fn()     
	local inst = CreateEntity()      
	inst.entity:AddTransform()     
	inst.entity:AddAnimState()     
	inst.entity:AddSoundEmitter()     
	inst.entity:AddLight()     
	inst.entity:AddNetwork()      
	inst.AnimState:SetBank("firefighter")     
	inst.AnimState:SetBuild("firefighter")     
	inst.AnimState:PlayAnimation("idle_off")     
	inst.AnimState:OverrideSymbol("swap_meter", "firefighter_meter", "10")     
	inst.AnimState:SetMultColour(TUNING.VIRTUALRED,TUNING.VIRTUALGREEN,TUNING.VIRTUALBLUE,TUNING.VIRTUALALPHA)      
	inst:AddTag("structure")      
	if not TheNet:IsDedicated() then         
		inst:AddComponent("deployhelper")         
		inst.components.deployhelper.onenablehelper = OnEnableHelper     
	end      
	inst.entity:SetPristine()      
	if not TheWorld.ismastersim then         
		return inst     
	end      

	inst._glow = SpawnPrefab("firesuppressor_glow")     
	inst:DoTaskInTime(0, oninit)      
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

return Prefab(VIRTUAL_PREFIX.."firesuppressor", fn, assets, prefabs)