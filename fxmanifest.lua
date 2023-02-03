--[[
─────────────────────────────────────────────────────────────────

	Vicpol Interaction Menu Created Ethan6#0001
	Current Version: v0.1 2023 
	
		!!! Change vaules in the 'config.lua' !!!
	DO NOT EDIT THIS IF YOU DON'T KNOW WHAT YOU ARE DOING

─────────────────────────────────────────────────────────────────
]]



fx_version 'cerulean'
games {'gta5'}

--DO NOT REMOVE THESE
title 'Vicpol Interaction'
description 'Vicpol Multi Purpose Interaction Menu'
author 'Ethan6#0001'
version 'v0.1' 

disableIcons 'false' -- default 'false'
safetyToggleKey '7' -- default '7' (L)
switchFiringModeKey '311' -- default '311' (K)

files { 
    "config.ini",
    "Newtonsoft.Json.dll",
    "GasStations.json",
    'PoliceFunctions-API.dll',
    'NativeUI.dll',
}

client_scripts {
    'dependencies/NativeUI.lua',
    'client.lua',
    'config.lua',
    'functions.lua',
    'menu.lua',
    "frfuel.net.dll",
    'FiringModeClient.net.dll',
    'Slash commands.net.dll',
    'disableddispatchclient.lua',
    'Removecopsclient.lua',
}


server_scripts {
    'config.lua',
    'server.lua',
    'functions.lua',
}

exports {
    'IsOndutyVICPOL',
    'IsOndutyFrv',
}
