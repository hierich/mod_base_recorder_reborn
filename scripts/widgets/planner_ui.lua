local Widget = require "widgets/widget"
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local TEMPLATES = require "widgets/templates"
local Button = require "widgets/button"

local planner_ui = Class(Widget, function(self,planner,alias,imagename)

	Widget._ctor(self, "planner_ui")
	self.planner = planner
	self.baseplan_total = planner.baseplan_total
	self.root = self:AddChild(ImageButton(alias,imagename))
    self.root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.root:SetVAnchor(1) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
	self.rootx, self.rooty, self.interval = 24, -96, 48

    self.root:SetPosition(self.rootx,self.rooty,0)
    self.root:SetScale(0.8,0.8,0.8)
	self.ActiveColor = { .5,.5,1,1 }
	self.InactiveColor = { .5,.5,1,.5 }

	self.title = self:AddChild(Text(NUMBERFONT, 28, "", {0,.72,.8,1}))
	self.title:SetHAnchor(1)
	self.title:SetVAnchor(1)

	self.stat_display = 10
	self.stat_root = self:AddChild(Widget("stat_root"))
	self.stat_root:SetHAnchor(1)
	self.stat_root:SetVAnchor(1)
	self.name_root = self.stat_root:AddChild(Widget("name_root"))
	self.count_root = self.stat_root:AddChild(Widget("count_root"))
	self.name_text = {}
	self.count_text = {}

	for i=1,self.stat_display do
		self.name_text[i] = self.name_root:AddChild(Text(NUMBERFONT, 28, "", {0,.72,.8,1}))
		self.count_text[i] = self.count_root:AddChild(Text(NUMBERFONT, 28, "", {0,.72,.8,1}))
	end


    local function expand()
		for i=1,self.baseplan_total do
			self.plans[i]:Show()
		end
		self.root.image:SetTint(unpack(self.ActiveColor))
		self.stat_root:Show()
    end

	local function collapse()
		for i=1,self.baseplan_total do
			self.plans[i]:Hide()
		end
		self.root.image:SetTint(unpack(self.InactiveColor))
		self.stat_root:Hide()
	end

    self.root:SetHoverText("root")
    self.root:SetOnClick(
	function ()
		if self.toggle then
			collapse()
		else
			expand()
		end
		self.toggle = not self.toggle
	end
	)

	-- set baseplan ui
	self.highlightColor = { 1,1,1,1 }
	self.unhighlightColor = { 1,1,1,.5 }
	local function InitBaseplanUI()
		self.plans = {}
		for i=1,self.baseplan_total do
			local baseplan_ui = self:AddChild(ImageButton(alias,imagename))
			baseplan_ui:SetHAnchor(1)
			baseplan_ui:SetVAnchor(1)
			baseplan_ui:SetPosition(self.rootx+self.interval*i,self.rooty,0)
			baseplan_ui:SetScale(0.6,0.6,0.6)

			baseplan_ui:SetOnClick(
			function()
				self.planner:switch(i)
			end
			)
			table.insert(self.plans, baseplan_ui)
		end
	end

	InitBaseplanUI()
	expand()
	self.toggle=true
end)

function planner_ui:highlight(baseplan_index)
	self.plans[baseplan_index].image:SetTint(unpack(self.highlightColor))
end

function planner_ui:unhighlight(baseplan_index)
	self.plans[baseplan_index].image:SetTint(unpack(self.unhighlightColor))
end

function planner_ui:setTitle(title, baseplan_index)
	self.title:SetString(tostring(title))
	self.title:SetPosition(self.rootx+baseplan_index*self.interval,self.rooty-40)
end

function planner_ui:setStat(baseplan_stat, baseplan_index)
	-- local limit = math.min(self.stat_display, #baseplan_stat)
	local hslide = -32
	local boxTop = -168
	local boxLeft = 80
	for i=1,self.stat_display do
		if i<=#baseplan_stat then
			self.name_text[i]:SetString(tostring(baseplan_stat[i].name))
			self.count_text[i]:SetString(tostring(baseplan_stat[i].count))
		else
			self.name_text[i]:SetString("")
			self.count_text[i]:SetString("")
		end

		self.count_text[i]:SetPosition(boxLeft+self.count_text[i]:GetRegionSize()*0.5,boxTop+hslide*(i-1))
		self.name_text[i]:SetPosition(boxLeft+48+self.name_text[i]:GetRegionSize()*0.5,boxTop+hslide*(i-1))
	end

end

return planner_ui
