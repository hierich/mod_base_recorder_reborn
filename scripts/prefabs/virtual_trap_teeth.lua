local assets = { }  
local prefabs = {   "collapse_small", }  
-- local VIRTUAL_PREFIX = "virtual_"
local VIRTUAL_PREFIX = STRINGS.VIRTUAL_PREFIX
local function MakeVirtualTrap(name, bank, build)     
    local function ondeploy(inst, pt, deployer)         
        local trap = SpawnPrefab(VIRTUAL_PREFIX..name)          
        if trap ~= nil then                           
            trap.Transform:SetPosition(pt:Get())       
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
          
        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("inactive")

        inst:AddTag("trap")         
        inst.entity:SetPristine()          
        if not TheWorld.ismastersim then             
            return inst         
        end          
        inst:AddComponent("inventoryitem")                  
        inst.components.inventoryitem.imagename = name 

        inst.components.inventoryitem:SetOnDroppedFn(ondrop)

        inst:AddComponent("stackable")         
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM 

        inst:AddComponent("deployable")         
        inst.components.deployable.ondeploy = ondeploy  
        inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)     
        inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)          

        return inst     
    end      

    local function onhammered(inst, worker)         
        inst:Remove()     
    end      

    local function CanActivate(inst, doer)         
        return doer.components.inventory:Has(name,1)     
    end      

    local function Activate(inst, doer)         
        doer.components.inventory:ConsumeByName(name,1)         
        local x, y, z = inst.Transform:GetWorldPosition()        
        local truetrap = SpawnPrefab(name)
        if truetrap ~= nil then                   
            truetrap.components.mine:Reset()
            truetrap.Physics:Stop()
            truetrap.Physics:Teleport(x, 0, z)
            onhammered(inst) 
        end        
             
    end      

    local function fn()         
        local inst = CreateEntity()          
        inst.entity:AddTransform()         
        inst.entity:AddAnimState()         
        inst.entity:AddSoundEmitter()         
        inst.entity:AddNetwork()          
          
                 
        inst.AnimState:SetBank(bank)         
        inst.AnimState:SetBuild(build)         
        inst.AnimState:PlayAnimation("reset")         
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

    return Prefab(VIRTUAL_PREFIX..name.."_item", itemfn, assets, prefabs),
        Prefab(VIRTUAL_PREFIX..name, fn, assets, prefabs),     
        MakePlacer(VIRTUAL_PREFIX..name.."_item_placer", bank, build, "idle") 
end  

local traps = 
{
    {name = "trap_teeth", bank = "trap_teeth", build = "trap_teeth",}
}

local trapprefabs = {}
for i, v in ipairs(traps) do
    local item, trap, placer = MakeVirtualTrap(v.name, v.bank, v.build)
    table.insert(trapprefabs, trap)
    table.insert(trapprefabs, item)
    table.insert(trapprefabs, placer)
end
return unpack(trapprefabs)     