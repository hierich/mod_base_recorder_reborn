local Widget = require "widgets/widget"
local Text = require "widgets/text"
local TextButton = require "widgets/textbutton"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local TEMPLATES = require "widgets/templates"
local Button = require "widgets/button"



local baseplan_ui = Class(Widget, function(self,owner,imagename,baseplan_index)

	Widget._ctor(self, "baseplan_ui")
	self.owner = owner
	self.baseplan_index = baseplan_index
	self.baseplan_ui = self:AddChild(ImageButton("images/hud/"..imagename..".xml",imagename..".tex"))
    self.avatar:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
    self.avatar:SetVAnchor(1) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
    self.avatar:SetPosition(140,-120,0) -- 设置ancientmac widget相对原点的偏移量，70，-50表明向右70，向下50，第三个参数无意义。
    self.avatar:SetScale(0.6,0.6,0.6)


    self.plans = {}

    local function fn()
		print("clicked")
    end
	local function selected()
		print("select "..tostring(plan_num))
	end

    self.avatar:SetHoverText("baseplan")
    self.avatar:SetOnClick(fn)

end)



return BasePlanChild
