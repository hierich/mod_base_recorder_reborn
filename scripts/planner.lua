local baseplan = require "baseplan"
local planner = Class(function(self)
    self.baseplan_total = 4
    self.baseplan_index = 1
    self.baseplans = {}
    local function init()
        for i=1,self.baseplan_total do
            table.insert(self.baseplans,baseplan(i))
        end
    end
    init()
    self.planner_ui = nil

end)
function planner:AddUI(planner_ui)
    self.planner_ui = planner_ui
    self:switch(1)
end
function planner:switch(baseplan_index)
    -- if baseplan_index == self.baseplan_index then
    --     return
    -- end
    self.baseplan_index = baseplan_index

    -- handle ui
    for i=1,self.baseplan_total do
        if i == self.baseplan_index then
            self:highlight(i)
        else
            self:unhighlight(i)
        end
    end
    -- local title = self.baseplans[self.baseplan_index]:GetTitle()
    -- self:setTitle(title)
    local baseplan_stat = self.baseplans[self.baseplan_index]:GetStat()
    self:setStat(baseplan_stat)
end

function planner:highlight(baseplan_index)
    self.planner_ui:highlight(baseplan_index)
end

function planner:unhighlight(baseplan_index)
    self.planner_ui:unhighlight(baseplan_index)
end

function planner:setTitle(title)
    self.planner_ui:setTitle(title, self.baseplan_index)
end

function planner:setStat(baseplan_stat)
    self.planner_ui:setStat(baseplan_stat, self.baseplan_index)
end
function planner:LoadPlan()
    return self.baseplans[self.baseplan_index]:GetContent()
end

function planner:SavePlan(_baseplan)
    self.baseplans[self.baseplan_index]:save(_baseplan)
    self:switch(self.baseplan_index)
end

return planner
