--[[
─────────────────────────────────────────────────────────────────

	Vicpol Interaction Menu Created Ethan6#0001
	Current Version: v0.1 2023 
	
		!!! Change vaules in the 'config.lua' !!!
	DO NOT EDIT THIS IF YOU DON'T KNOW WHAT YOU ARE DOING

─────────────────────────────────────────────────────────────────
]]




RegisterServerEvent('InteractionMenu:GlobalChat')
AddEventHandler('InteractionMenu:GlobalChat', function(Color, Prefix, Message)
	TriggerClientEvent('chatMessage', -1, Prefix, Color, Message)
end)

RegisterServerEvent('InteractionMenu:CuffNear')
AddEventHandler('InteractionMenu:CuffNear', function(ID)
	if ID == -1 or ID == '-1' then
		if source ~= '' then
			print('^1[#' .. source .. '] ' .. GetPlayerName(source) .. '  -  attempted to cuff all players^7')
			DropPlayer(source, '\n[InteractionMenu] Attempting to cuff all players')
		else
			print('^1Someone attempted to cuff all players^7')
		end

		return
	end

	if ID ~= false then
		TriggerClientEvent('InteractionMenu:Cuff', ID)
	end
end)

RegisterServerEvent('InteractionMenu:DragNear')
AddEventHandler('InteractionMenu:DragNear', function(ID)
	if ID == -1 or ID == '-1' then
		if source ~= '' then
			print('^1[#' .. source .. '] ' .. GetPlayerName(source) .. '  -  attempted to drag all players^7')
			DropPlayer(source, '\n[InteractionMenu] Attempting to drag all players')
		else
			print('^1Someone attempted to drag all players^7')
		end

		return
	end
	
	if ID ~= false and ID ~= source then
		TriggerClientEvent('InteractionMenu:Drag', ID, source)
	end
end)

RegisterServerEvent('InteractionMenu:SeatNear')
AddEventHandler('InteractionMenu:SeatNear', function(ID, Vehicle)
    TriggerClientEvent('InteractionMenu:Seat', ID, Vehicle)
end)

RegisterServerEvent('InteractionMenu:UnseatNear')
AddEventHandler('InteractionMenu:UnseatNear', function(ID, Vehicle)
    TriggerClientEvent('InteractionMenu:Unseat', ID, Vehicle)
end)

RegisterServerEvent('InteractionMenu:Jail')
AddEventHandler('InteractionMenu:Jail', function(ID, Time)
	if ID == -1 or ID == '-1' then
		if source ~= '' then
			print('^1[#' .. source .. '] ' .. GetPlayerName(source) .. '  -  attempted to jail all players^7')
			DropPlayer(source, '\n[InteractionMenu] Attempting to jail all players')
		else
			print('^1Someone attempted to jail all players^7')
		end

		return
	end
	
	TriggerClientEvent('InteractionMenu:JailPlayer', ID, Time)
	TriggerClientEvent('chatMessage', -1, 'Judge', {86, 96, 252}, GetPlayerName(ID) .. ' has been Jailed for ' .. Time .. ' months(s)')
end)

RegisterServerEvent('InteractionMenu:Unjail')
AddEventHandler('InteractionMenu:Unjail', function(ID)
	TriggerClientEvent('InteractionMenu:UnjailPlayer', ID)
end)

RegisterServerEvent('InteractionMenu:Backup')
AddEventHandler('InteractionMenu:Backup', function(Code, StreetName, Coords)
	TriggerClientEvent('InteractionMenu:CallBackup', -1, Code, StreetName, Coords)
end)

RegisterServerEvent('InteractionMenu:Ads')
AddEventHandler('InteractionMenu:Ads', function(Text, Name, Loc, File)
	TriggerClientEvent('InteractionMenu:SyncAds', -1, Text, Name, Loc, File, source)
end)

BACList = {}
RegisterServerEvent('InteractionMenu:BACSet')
AddEventHandler('InteractionMenu:BACSet', function(BACLevel)
	BACList[source] = BACLevel
end)

RegisterServerEvent('InteractionMenu:BACTest')
AddEventHandler('InteractionMenu:BACTest', function(ID)
	local BACLevel = BACList[ID]
	TriggerClientEvent('InteractionMenu:BACResult', source, BACLevel)
end)

Inventories = {}
RegisterServerEvent('InteractionMenu:InventorySet')
AddEventHandler('InteractionMenu:InventorySet', function(Items)
	Inventories[source] = Items
end)

RegisterServerEvent('InteractionMenu:InventorySearch')
AddEventHandler('InteractionMenu:InventorySearch', function(ID)
	local Inventory = Inventories[ID]

	TriggerClientEvent('InteractionMenu:InventoryResult', source, Inventory)
end)

RegisterServerEvent('InteractionMenu:Hospitalize')
AddEventHandler('InteractionMenu:Hospitalize', function(ID, Time, Location)
	if ID == -1 or ID == '-1' then
		if source ~= '' then
			print('^1[#' .. source .. '] ' .. GetPlayerName(source) .. '  -  attempted to hospitalize all players^7')
			DropPlayer(source, '\n[InteractionMenu] Attempting to hospitalize all players')
		else
			print('^1Someone attempted to hospitalize all players^7')
		end

		return
	end

	TriggerClientEvent('InteractionMenu:HospitalizePlayer', ID, Time, Location)
	TriggerClientEvent('chatMessage', -1, 'Doctor', {86, 96, 252}, GetPlayerName(ID) .. ' has been Hospitalized for ' .. Time .. ' months(s)')
end)

RegisterServerEvent('InteractionMenu:Unhospitalize')
AddEventHandler('InteractionMenu:Unhospitalize', function(ID)
	TriggerClientEvent('InteractionMenu:UnhospitalizePlayer', ID)
end)

RegisterServerEvent('InteractionMenu:VICPOLPerms')
AddEventHandler('InteractionMenu:VICPOLPerms', function()
    if IsPlayerAceAllowed(source, 'em_intmenu.VICPOL') then
		TriggerClientEvent('InteractionMenu:VICPOLPermsResult', source, true)
	else
		TriggerClientEvent('InteractionMenu:VICPOLPermsResult', source, false)
	end
end)

RegisterServerEvent('InteractionMenu:FrvPerms')
AddEventHandler('InteractionMenu:FrvPerms', function()
    if IsPlayerAceAllowed(source, 'em_intmenu.Frv') then
		TriggerClientEvent('InteractionMenu:FrvPermsResult', source, true)
	else
		TriggerClientEvent('InteractionMenu:FrvPermsResult', source, false)
	end
end)

RegisterServerEvent('InteractionMenu:UnjailPerms')
AddEventHandler('InteractionMenu:UnjailPerms', function()
    if IsPlayerAceAllowed(source, 'em_intmenu.unjail') then
		TriggerClientEvent('InteractionMenu:UnjailPermsResult', source, true)
	else
		TriggerClientEvent('InteractionMenu:UnjailPermsResult', source, false)
	end
end)

RegisterServerEvent('InteractionMenu:UnhospitalPerms')
AddEventHandler('InteractionMenu:UnhospitalPerms', function()
    if IsPlayerAceAllowed(source, 'em_intmenu.unhospital') then
		TriggerClientEvent('InteractionMenu:UnhospitalPermsResult', source, true)
	else
		TriggerClientEvent('InteractionMenu:UnhospitalPermsResult', source, false)
	end
end)


print
[[^3
    ______   _____      _____
   |   ___| |     \    /     |
   |  |___  |  |\  \  /  /|  |
   |   ___| |  | \  \/  / |  |
   |  |___  |  |  \    /  |  |
   |______| |__|   \__/   |__|^7
    Vicpol InteractionMenu
	  Created By Ethan6#0001
]]

