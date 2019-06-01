name = "Construction Planning" 
description = "可以预先建造虚拟建筑进行规划\n"..
	"可选择语言、颜色和透明度\n按U输入#base或#base_cave可放置预设基地布局\n"..
	"You can make virtual structure for future plan.\n"..
	"Push U and write #base or #base_cave to build a base template.\n"..
	"You can choose your language, color and alpha." 
author = "宵征" 
version = "1.7"   
forumthread = ""  
api_version = 10  
dst_compatible = true  
dont_starve_compatible = false 
reign_of_giants_compatible = false  
all_clients_require_mod = true   
icon_atlas = "modicon.xml" 
icon = "modicon.tex"  
server_filter_tags = {     "virtual structure", }  
configuration_options = {
{     
	name = "language",
	label = "语言language",
	options =
	{
		{description = "English", data = 1},
		{description = "中文", data = 2},
	},
	default = 2,
}, 
{   
	name = "alpha",
	label = "不透明度alpha",
	options =
	{
		{description = "0.125", data = 0.125},
		{description = "0.25", data = 0.25},
		{description = "0.375", data = 0.375},
		{description = "0.5", data = 0.5},
		{description = "0.625", data = 0.625},
		{description = "0.75", data = 0.75},
		{description = "1", data = 1},
	},
	default = 0.5,
},
{
	name = "color",
	label = "颜色color",
	options =
	{
		{description = "无White", data = 111},
		{description = "黑Black", data = 000},
		{description = "红Red", data = 100},
		{description = "绿Green", data = 010},
		{description = "蓝Blue", data = 001},
		{description = "黄Yellow", data = 110},
		{description = "紫Purple", data = 101},
		{description = "青Cyan", data = 011},
	},
	default = 0.5,
},
{
	name = "chestwithsign",
	label = "宝箱自动插牌\ndeploy minisign automatically",
	hover = "向宝箱放入画好的迷你标识会自动插好",
	options =
	{
		{description = "开启On", data = 1},
		{description = "关闭Off", data = 0},
	},
	default = 0,
},
}