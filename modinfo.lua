name = "Base Recorder Reborn" 
description = "可以预先建造虚拟建筑进行规划\n"..
	"用照相机和投影仪来记录，投影你的基地\n"..
	"可选择颜色和透明度\n"..
	"You can make virtual structure for future plan.\n"..
	"Use the camera and the projector to record, project your base.\n"..
	"You can choose color and alpha." 
author = "Heinrich" 
version = "1.1"   
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
	default = 1,
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
}