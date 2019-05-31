local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
require "prefabutil"

Assets = {
    Asset("IMAGE", "images/inventoryimages/lamp_post.tex"),
	Asset("ATLAS", "images/inventoryimages/lamp_post.xml"),
	Asset("IMAGE", "images/inventoryimages/lamp_short.tex"),
	Asset("ATLAS", "images/inventoryimages/lamp_short.xml"),
}

PrefabFiles =
{
    "baka_lamp_post",
    "baka_lamp_short"
}

local recipe = GetModConfigData("RECIPE")
STRINGS.NAMES.BAKA_LAMP_POST = "Streetlight"
STRINGS.NAMES.BAKA_LAMP_SHORT = "Streetlight"

if recipe == 1 then
    STRINGS.RECIPE_DESC.BAKA_LAMP_POST = "Powered by insects!"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.BAKA_LAMP_POST = "They can't escape now."
    STRINGS.RECIPE_DESC.BAKA_LAMP_SHORT = "Powered by insects!"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.BAKA_LAMP_SHORT = "They can't escape now."
elseif recipe == 2 then
    STRINGS.RECIPE_DESC.BAKA_LAMP_POST = "That's one way to use it."
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.BAKA_LAMP_POST = "Civilization. A piece of home..."
    STRINGS.RECIPE_DESC.BAKA_LAMP_SHORT = "That's one way to use it."
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.BAKA_LAMP_SHORT = "Civilization. A piece of home..."
else
    STRINGS.RECIPE_DESC.BAKA_LAMP_POST = "Almost free!"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.BAKA_LAMP_POST = "Darkness stands no chance."
    STRINGS.RECIPE_DESC.BAKA_LAMP_SHORT = "Almost free!"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.BAKA_LAMP_SHORT = "Darkness stands no chance."
end


if recipe == 1 then
    AddRecipe("baka_lamp_post", {Ingredient("fireflies",1), Ingredient("cutstone", 3)}, GLOBAL.RECIPETABS.LIGHT, GLOBAL.TECH.SCIENCE_TWO, 
            "baka_lamp_post_placer",
            1, 
            nil, nil, nil, 
            "images/inventoryimages/lamp_post.xml", 
            "lamp_post.tex") 
    AddRecipe("baka_lamp_short", {Ingredient("fireflies",1), Ingredient("cutstone", 3)}, GLOBAL.RECIPETABS.LIGHT, GLOBAL.TECH.SCIENCE_TWO, 
            "baka_lamp_short_placer",
            1, 
            nil, nil, nil, 
            "images/inventoryimages/lamp_short.xml", 
            "lamp_short.tex")
elseif recipe == 2 then
    AddRecipe("baka_lamp_post", {Ingredient("nightstick",1), Ingredient("cutstone", 1)}, GLOBAL.RECIPETABS.LIGHT, GLOBAL.TECH.SCIENCE_TWO, 
            "baka_lamp_post_placer",
            1, 
            nil, nil, nil, 
            "images/inventoryimages/lamp_post.xml", 
            "lamp_post.tex") 
    AddRecipe("baka_lamp_short", {Ingredient("nightstick",1), Ingredient("cutstone", 1)}, GLOBAL.RECIPETABS.LIGHT, GLOBAL.TECH.SCIENCE_TWO, 
            "baka_lamp_short_placer",
            1, 
            nil, nil, nil, 
            "images/inventoryimages/lamp_short.xml", 
            "lamp_short.tex")
else
    AddRecipe("baka_lamp_post", {Ingredient("transistor",1), Ingredient("cutstone", 2)}, GLOBAL.RECIPETABS.LIGHT, GLOBAL.TECH.SCIENCE_TWO, 
            "baka_lamp_post_placer",
            1, 
            nil, nil, nil, 
            "images/inventoryimages/lamp_post.xml", 
            "lamp_post.tex") 
    AddRecipe("baka_lamp_short", {Ingredient("transistor",1), Ingredient("cutstone", 2)}, GLOBAL.RECIPETABS.LIGHT, GLOBAL.TECH.SCIENCE_TWO, 
            "baka_lamp_short_placer",
            1, 
            nil, nil, nil, 
            "images/inventoryimages/lamp_short.xml", 
            "lamp_short.tex")
end