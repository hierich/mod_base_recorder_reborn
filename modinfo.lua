name = "Gorge Lights"
description = "Adds two lanterns from the Gorge. They are eternal, but not cheap and don't provide too much light. They come with a day/night cycle."
author = "bakaschwarz"
version = "1.5"

forumthread = ""

api_version = 10

dst_compatible = true
priority = -1337
dont_starve_compatible = false
reign_of_giants_compatible = false

all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
"gorge", "lantern", "light", "content"
}

configuration_options = {
    {
        name = "RECIPE", label = "Recipe", default = 1,
        options = {
            {            
                description = "Default",
                data = 1,
                hover = "1x Firefly, 3x Cutstone"
            },
            {            
                description = "Alternative",
                data = 2,
                hover = "1x Morning Star, 1x Cutstone, "
            },
            {            
                description = "Easy, basically free",
                data = 3,
                hover = "1x Electrical Doodad, 2x Cutstone"
            },
        }
    }
}