

require "prefabutil" 
require "tuning"  
local assets = {}  
local prefabs = {"collapse_small", }  
local back = -1 
local front = 0 
local left = 1.5 
local right = -1.5  
local function onhammered(inst, worker)
	inst:Remove() 
end  

local rates = {TUNING.FARM1_GROW_BONUS,TUNING.FARM2_GROW_BONUS,TUNING.FARM3_GROW_BONUS, }  
local croppoints = {{ Vector3(0, 0, 0) },{ Vector3(0, 0, 0) },{ Vector3(0, 0, 0) }, }  
local rock_front = 1  
local decor_defs = {    [1] = { { signright = { { -1.1, 0, 0.5 } } } }, 
				    	[2] = { { stick = {{ left - 0.9, 0, back },{ right, 0, front }, }}, { stickleft = {{ 0.0, 0, back },{ left, 0, front },}},{ stickright = { { right + 0.9, 0, back }, { left - 0.3, 0, back + 0.5 }, { right + 0.3, 0, back + 0.5 },} }, { signleft = { { -1.0, 0, 0.5 } } } },
				    	[3] = { { signleft = { { -1.0, 0, 0.5 } } },{ farmrock = {{ right + 3.0, 0, rock_front + 0.2 },{ right + 3.05, 0, rock_front - 1.5 },}},{ farmrocktall = { { right + 3.07, 0, rock_front - 1.0 }, } },{ farmrockflat = { { right + 3.06, 0, rock_front - 0.4 }, } }, { farmrock = { { left - 3.05, 0, rock_front - 1.0 }, } },{ farmrocktall = { { left - 3.07, 0, rock_front - 1.5 }, } },{ farmrockflat = { { left - 3.06, 0, rock_front - 0.4 }, } }, { farmrock = {{ right + 1.1, 0, rock_front + 0.21 },{ right + 2.4, 0, rock_front + 0.25 },}}, { farmrocktall = { { right + 0.5, 0, rock_front + 0.195 }, } },{ farmrockflat = {{ right + 0.0, 0, rock_front - 0.0 },{ right + 1.8, 0, rock_front + 0.22 },}}, { farmrockflat = {{ left - 1.3, 0, back - 0.19 },}}, { farmrock = {{ left - 0.5, 0, back - 0.21 },{ left - 2.5, 0, back - 0.22 },    }}, { farmrocktall = {{ left + 0.0, 0, back - 0.15 },{ left - 3.0, 0, back - 0.20 },{ left - 1.9, 0, back - 0.205 },}}, { fencepost = {{ left - 1.0,  0, back + 0.15 },{ right + 0.8, 0, back + 0.15 },{ right + 0.3, 0, back + 0.15 },},}, { fencepostright = {{ left - 0.5,  0, back + 0.15 },{ 0,0, back + 0.15 },},},}, 
				    } 


local function RefreshDecor(inst, burnt)     
	for i = 1, #inst.decor do         
		table.remove(inst.decor):Remove()     
	end     

	local decor_table = burnt and burntdecor_defs or decor_defs     

	for i, item_info in ipairs(decor_table[inst.level]) do         
		for item_name, item_offsets in pairs(item_info) do             
			for j, offset in ipairs(item_offsets) do                 
				local item_inst = SpawnPrefab(item_name)                 
				item_inst.AnimState:SetMultColour(TUNING.VIRTUALRED,TUNING.VIRTUALGREEN,TUNING.VIRTUALBLUE,TUNING.VIRTUALALPHA)                 
				item_inst.entity:SetParent(inst.entity)                 
				item_inst.Transform:SetPosition(unpack(offset))                 
				table.insert(inst.decor, item_inst)             
			end         
		end     
	end 
end  

local function plot(level)      
	local function CanActivate(inst, doer)         
		local recipe = GetValidRecipe("fast_farmplot")         
		local ret = false         
		if recipe ~= nil then              
			ret = doer.components.builder:IsBuildBuffered("fast_farmplot") or (doer.components.builder:CanBuild("fast_farmplot") and doer.components.builder:KnowsRecipe("fast_farmplot"))         
		end         
		return ret     
	end      

	local function Activate(inst, doer)         
		local truestruct = SpawnPrefab("fast_farmplot")         
		local recipe = GetValidRecipe("fast_farmplot")         
		if recipe ~= nil then             
			if doer.components.builder:IsBuildBuffered("fast_farmplot") then                 
				doer.components.builder.buffered_builds["fast_farmplot"] = nil                 
				doer.replica.builder:SetIsBuildBuffered("fast_farmplot", false)             
			else                 
				local materials = doer.components.builder:GetIngredients("fast_farmplot")                 
				doer.components.builder:RemoveIngredients(materials, "fast_farmplot")             
			end             

			truestruct.Transform:SetPosition(inst.Transform:GetWorldPosition())             
			truestruct.Transform:SetRotation(inst.Transform:GetRotation())         
		end         

		onhammered(inst)     
	end      
	return function()         
			local inst = CreateEntity()          
			inst.entity:AddTransform()         
			inst.entity:AddAnimState()         
			inst.entity:AddSoundEmitter()         
			inst.entity:AddNetwork()          
			inst:AddTag("structure")          
			inst.AnimState:SetBank("farmplot")         
			inst.AnimState:SetBuild("farmplot")         
			inst.AnimState:PlayAnimation("full")         
			inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)         
			inst.AnimState:SetLayer(LAYER_BACKGROUND)         
			inst.AnimState:SetSortOrder(3)         
			inst.AnimState:SetMultColour(TUNING.VIRTUALRED,TUNING.VIRTUALGREEN,TUNING.VIRTUALBLUE,TUNING.VIRTUALALPHA)          
			inst.level = level          
			if not TheNet:IsDedicated() then             
				inst.decor = {}             
				RefreshDecor(inst, false)         
			end          

			inst.entity:SetPristine()          
			if not TheWorld.ismastersim then             
				return inst         
			end          

			inst:AddComponent("workable")         
			inst.components.workable:SetWorkAction(ACTIONS.HAMMER)         
			inst.components.workable:SetWorkLeft(1)         
			inst.components.workable:SetOnFinishCallback(onhammered)          
			inst:AddComponent("savedrotation")          
			inst:AddComponent("activatable")         
			inst.components.activatable.quickaction = true         
			inst.components.activatable.CanActivateFn = CanActivate         
			inst.components.activatable.OnActivate = Activate          
			return inst     
		end 
end  

local function placerdecor(level)     
	return function(inst)         
			for i, item_info in ipairs(decor_defs[level]) do             
				for item_name, item_offsets in pairs(item_info) do                 
					for j, offset in ipairs(item_offsets) do                     
						local item_inst = SpawnPrefab(item_name)                     
						item_inst:AddTag("CLASSIFIED")                     
						item_inst:AddTag("NOCLICK")                      
						item_inst:AddTag("placer")                     
						item_inst.entity:SetCanSleep(false)                     
						item_inst.entity:SetParent(inst.entity)                     
						item_inst.Transform:SetPosition(unpack(offset))                     
						item_inst.AnimState:SetLightOverride(1)                     
						inst.components.placer:LinkEntity(item_inst)                 
					end             
				end         
			end     
		end 
end  

return Prefab("virtualfast_farmplot", plot(3), assets, prefabs),     
	MakePlacer("virtualfast_farmplot_placer", "farmplot", "farmplot", "full", true, nil, nil, nil, 90, nil, placerdecor(3)) 