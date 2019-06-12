local assets = { }  
local prefabs = {   "collapse_small", }  
-- local VIRTUAL_PREFIX = "virtual_"
local VIRTUAL_PREFIX = STRINGS.VIRTUAL_PREFIX
local function MakeVirtualStruct(name, bank, build, anim)     
	local function onhammered(inst, worker)         
		inst:Remove()     
	end      

	local function CanActivate(inst, doer)         
		local recipe = GetValidRecipe(name)         
		local ret = false         
		if recipe ~= nil then              
			ret = doer.components.builder:IsBuildBuffered(name) or (doer.components.builder:CanBuild(name) and doer.components.builder:KnowsRecipe(name))                
		end         
		return ret     
	end      

	local function Activate(inst, doer)         
		local recipe = GetValidRecipe(name)         
		local skin = Profile:GetLastUsedSkinForItem(name)         
		local skin_other = ValidateRecipeSkinRequest(doer.userid, name, skin)         
		local truestruct = SpawnPrefab(name, skin, nil, doer.userid)         
		if recipe ~= nil then
			if doer.components.builder:IsBuildBuffered(name) then                 
				doer.components.builder.buffered_builds[name] = nil                 
				doer.replica.builder:SetIsBuildBuffered(name, false)             
			else                 
				local materials = doer.components.builder:GetIngredients(name)                 
				doer.components.builder:RemoveIngredients(materials, name)             
			end     

			truestruct.Transform:SetPosition(inst.Transform:GetWorldPosition())
			truestruct.Transform:SetRotation(inst.Transform:GetRotation())          	        
		end         

		onhammered(inst)     
	end      

	local function fn()         
		local inst = CreateEntity()          
		inst.entity:AddTransform()         
		inst.entity:AddAnimState()         
		inst.entity:AddNetwork()          
		inst:AddTag("structure")          
		inst.AnimState:SetBank(bank)         
		inst.AnimState:SetBuild(build)         
		inst.AnimState:PlayAnimation(anim)
		         
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

	return Prefab(VIRTUAL_PREFIX..name, fn, assets, prefabs) 
end  

return MakeVirtualStruct("firepit","firepit","firepit","idle"),     
MakeVirtualStruct("coldfirepit","coldfirepit","coldfirepit","idle"),     
MakeVirtualStruct("mushroom_light","mushroom_light","mushroom_light","idle"),     
MakeVirtualStruct("mushroom_light2","mushroom_light2","mushroom_light2","idle"),     
MakeVirtualStruct("treasurechest", "chest", "treasure_chest","closed"),     
MakeVirtualStruct("homesign", "sign_home", "sign_home","idle"),     
MakeVirtualStruct("pighouse","pig_house","pig_house","idle"),     
MakeVirtualStruct("rabbithouse","rabbithouse","rabbit_house","idle"),     
MakeVirtualStruct("birdcage","birdcage","bird_cage","idle_empty"),     
MakeVirtualStruct("wardrobe", "wardrobe", "wardrobe","closed"),          
MakeVirtualStruct("scarecrow","scarecrow","scarecrow","idle"),     
MakeVirtualStruct("winter_treestand","wintertree","wintertree_build","idle"),     
MakeVirtualStruct("endtable","stagehand","stagehand","idle"),     
MakeVirtualStruct("dragonflychest","dragonfly_chest","dragonfly_chest","closed"),     
MakeVirtualStruct("dragonflyfurnace", "dragonfly_furnace", "dragonfly_furnace","hi"),     
MakeVirtualStruct("mushroom_farm", "mushroom_farm", "mushroom_farm","idle"),    
MakeVirtualStruct("beebox", "bee_box", "bee_box","idle"),     
MakeVirtualStruct("meatrack", "meat_rack", "meat_rack","idle_empty"),     
MakeVirtualStruct("cookpot","cook_pot","cook_pot","idle_empty"),     
MakeVirtualStruct("icebox","icebox","ice_box","closed"),          
MakeVirtualStruct("tent","tent","tent","idle"),     
MakeVirtualStruct("siestahut","siesta_canopy","siesta_canopy","idle"),     
MakeVirtualStruct("saltlick","salt_lick","salt_lick","idle1"),     
MakeVirtualStruct("researchlab","researchlab","researchlab","idle"),     
MakeVirtualStruct("researchlab2","researchlab2","researchlab2","idle"),     
MakeVirtualStruct("researchlab3","researchlab3","researchlab3","idle"),     
MakeVirtualStruct("researchlab4","researchlab4","researchlab4","idle"),     
MakeVirtualStruct("cartographydesk","cartography_desk","cartography_desk","idle"),     
MakeVirtualStruct("sculptingtable","sculpting_station","sculpting_station","idle"),     
MakeVirtualStruct("lightning_rod","lightning_rod","lightning_rod","idle"),          
MakeVirtualStruct("sentryward","sentryward","sentryward","idle_full"),     
MakeVirtualStruct("moondial","moondial","moondial_build","idle_new"),     
MakeVirtualStruct("townportal","townportal","townportal","idle"),      
-- MakeVirtualStruct("firesuppressor","firefighter","firefighter","idle_off"),
MakeVirtualStruct("fast_farmplot","farmplot","farmplot","full"),
MakeVirtualStruct("trap_teeth","trap_teeth","trap_teeth","idle")     