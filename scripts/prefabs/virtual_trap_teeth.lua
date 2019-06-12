local assets = { }  
local prefabs = {   "collapse_small", }  
-- local VIRTUAL_PREFIX = "virtual_"
local VIRTUAL_PREFIX = STRINGS.VIRTUAL_PREFIX
local function MakeVirtualStruct(name, bank, build, anim)     
    local function onhammered(inst, worker)         
        inst:Remove()     
    end      

    local function CanActivate(inst, doer)                  
        local ret = false         
            
        ret = doer.components.inventory:Has(name,1)                
        return ret     
    end      

    local function Activate(inst, doer)                  
        local truestruct = SpawnPrefab(name)         
        doer.components.inventory:ConsumeByName(name, 1)             
        truestruct.Transform:SetPosition(inst.Transform:GetWorldPosition())                                         
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

return MakeVirtualStruct("trap_teeth","trap_teeth","trap_teeth","idle")     