local baseplan = Class(function(self, baseplan_index)
    self.baseplan_index = baseplan_index
    self.baseplan_path = "baseplan"..tostring(self.baseplan_index)
    self.baseplan_title = self.missed_tilte
    self.baseplan_content = self.missed_content
    self.baseplan_stat = self.missed_stat
    self.missed_tilte = "empty"
    self.missed_content = {}
    self.missed_stat = {{count = "empty", name = "",}}
    self:load()
end)

function baseplan:StorePlan(_baseplan)
    if type(_baseplan) ~= "table" then
        self.baseplan_title = self.missed_tilte
        self.baseplan_content = self.missed_content
        print("empty baseplan")
        return nil
    end
    local tilte, layout_record = nil, nil
    if _baseplan.layout_record == nil then
        tilte = self.missed_tilte
        layout_record = _baseplan
    else
        tilte = tostring(_baseplan.title)
        layout_record = _baseplan.layout_record
    end

    if type(tilte) ~= "string" then
        self.baseplan_title = self.missed_tilte
    else
        self.baseplan_title = tilte
    end

    if type(layout_record) ~= "table" then
        self.baseplan_content = self.missed_content
    else
        self.baseplan_content = layout_record
    end

    -- summary number of structures
    local baseplan_stat = {}
    for i,v in ipairs(self.baseplan_content) do
        if v.name then
            if baseplan_stat[v.name] == nil then
                baseplan_stat[v.name] = 1
            else
                baseplan_stat[v.name] = baseplan_stat[v.name]+1
            end
        end
    end


    -- Sort by count descend

    local T = { } -- Result goes here

    for k, v in pairs(baseplan_stat) do
      T[#T + 1] = { name = k, count = v }
    end

    -- Sort by value
    table.sort(T, function(lhs, rhs) return lhs.count > rhs.count end)

    if #T == 0 then
        self.baseplan_stat = self.missed_stat
    else
        self.baseplan_stat = T
    end

end

function baseplan:load()
    local path = self.baseplan_path
    local _baseplan = VR_File.LoadTable(path)
    self:StorePlan(_baseplan)
end

function baseplan:save(_baseplan)
    self:StorePlan(_baseplan)
    local path = self.baseplan_path
    local save_plan =
    {
        title = self.baseplan_title,
        layout_record = self.baseplan_content,
    }
    VR_File.SaveTable(save_plan,path)
end

function baseplan:GetContent()
    return self.baseplan_content or self.missed_content
end

function baseplan:GetTitle()
    return self.baseplan_title or self.missed_tilte
end

function baseplan:GetStat()
    return self.baseplan_stat or self.missed_stat
end
return baseplan
