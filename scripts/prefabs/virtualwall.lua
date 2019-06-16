local assets = { }
local prefabs = {"collapse_small", }

-- local VIRTUAL_PREFIX = "virtual_"
local VIRTUAL_PREFIX = STRINGS.VIRTUAL_PREFIX
local function MakeWallType(data)

	local function ondeploywall(inst, pt, deployer)
		local wall = SpawnPrefab(VIRTUAL_PREFIX.."wall_"..data.name)
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
		inst.AnimState:SetBuild("wall_"..data.name)
		inst.AnimState:PlayAnimation("idle")          
		inst.entity:SetPristine()
		if not TheWorld.ismastersim then
			return inst
		end
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = "wall_"..data.name.."_item"
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
		return doer.components.inventory:Has("wall_"..data.name.."_item",1)
	end

	local function Activate(inst, doer)
		doer.components.inventory:ConsumeByName("wall_"..data.name.."_item",1)
		local x, y, z = inst.Transform:GetWorldPosition()
		local wall = SpawnPrefab("wall_"..data.name)
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
		inst.AnimState:SetBuild("wall_"..data.name)
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

	return Prefab(VIRTUAL_PREFIX.."wall_"..data.name.."_item", itemfn, assets, prefabs),
		Prefab(VIRTUAL_PREFIX.."wall_"..data.name, fn, assets, prefabs),
		MakePlacer(VIRTUAL_PREFIX.."wall_"..data.name.."_item_placer", "wall", "wall_"..data.name, "half", false, false, true, nil, nil, "eight")
end

local wallprefabs = {}

local walldata =
{
    { name = MATERIALS.STONE,    material = "stone", tags = { "stone" },             loot = "rocks",            maxloots = 2, maxhealth = TUNING.STONEWALL_HEALTH,                      buildsound = "dontstarve/common/place_structure_stone" },
    { name = MATERIALS.WOOD,     material = "wood",  tags = { "wood" },              loot = "log",              maxloots = 2, maxhealth = TUNING.WOODWALL_HEALTH,     flammable = true, buildsound = "dontstarve/common/place_structure_wood"  },
    { name = MATERIALS.HAY,      material = "straw", tags = { "grass" },             loot = "cutgrass",         maxloots = 2, maxhealth = TUNING.HAYWALL_HEALTH,      flammable = true, buildsound = "dontstarve/common/place_structure_straw" },
    { name = "ruins",            material = "stone", tags = { "stone", "ruins" },    loot = "thulecite_pieces", maxloots = 2, maxhealth = TUNING.RUINSWALL_HEALTH,                      buildsound = "dontstarve/common/place_structure_stone" },
    { name = MATERIALS.MOONROCK, material = "stone", tags = { "stone", "moonrock" }, loot = "moonrocknugget",   maxloots = 2, maxhealth = TUNING.MOONROCKWALL_HEALTH,                   buildsound = "dontstarve/common/place_structure_stone" },
}

for i, v in ipairs(walldata) do
    local item, wall, placer = MakeWallType(v)
    table.insert(wallprefabs, wall)
    table.insert(wallprefabs, item)
    table.insert(wallprefabs, placer)
end

return unpack(wallprefabs)
