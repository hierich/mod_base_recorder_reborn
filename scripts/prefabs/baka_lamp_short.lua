require "prefabutil"

local prefabs =
{
	"collapse_small",
}

local assets =
{
    Asset("ANIM", "anim/baka_lamp_short.zip"),
	
	Asset("IMAGE", "images/inventoryimages/lamp_short.tex"),
	Asset("ATLAS", "images/inventoryimages/lamp_short.xml"),
}

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    if TheWorld.state.isday and not TheWorld:HasTag("cave") then
        inst.AnimState:PlayAnimation("idle_off")
    else
        inst.AnimState:PlayAnimation("idle")
    end
end

local function onbuilt(inst)
    if TheWorld.state.isday and not TheWorld:HasTag("cave") then
        inst.AnimState:PlayAnimation("idle_off")
    else
        inst.AnimState:PlayAnimation("idle")
    end
end

local function IsInBasement(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local entities = TheSim:FindEntities(x, y, z, 40, {"basement_part"})
    for _,v in pairs(entities) do
        if v.prefab == "basement_exit" then
            return true
        end
    end
    return false
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("structure")

	MakeObstaclePhysics(inst, .2)
	
    inst.AnimState:SetBank("baka_lamp_short")
    inst.AnimState:SetBuild("baka_lamp_short")
    inst.Light:SetRadius(3)
    inst.Light:SetIntensity(0.7)
    inst.Light:SetFalloff(0.85)
    inst.Light:SetColour(1, 1, 1)
    inst.Light:EnableClientModulation(true)
    inst.entity:SetPristine()

    inst:DoTaskInTime(1, function()
        if TheWorld.state.isday and not TheWorld:HasTag("cave") and not IsInBasement(inst) then
            inst.AnimState:PlayAnimation("idle_off")
            inst.Light:Enable(false)
        else
            inst.AnimState:PlayAnimation("idle")
            inst.Light:Enable(true)
        end
    end)
    inst:ListenForEvent("phasechanged", function(src, data)
        if data ~= "night" and data ~= "dusk" and not TheWorld:HasTag("cave") and not IsInBasement(inst) then
            inst:DoTaskInTime(2, function()
                inst.AnimState:PlayAnimation("idle_off")
                inst.Light:Enable(false)
            end)
        else
            inst:DoTaskInTime(2, function()
                inst.AnimState:PlayAnimation("idle")
                inst.Light:Enable(true)
            end)
        end
    end,TheWorld)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit) 

    inst:ListenForEvent("onbuilt", onbuilt)
    return inst
end

return Prefab("baka_lamp_short", fn, assets, prefabs),
    MakePlacer("baka_lamp_short_placer", "baka_lamp_short", "baka_lamp_short", "idle_off")