--[[
─────────────────────────────────────────────────────────────────

	Vicpol Interaction Menu Created Ethan6#0001
	Current Version: v0.1 2023 
	
		!!! Change vaules in the 'config.lua' !!!
	DO NOT EDIT THIS IF YOU DON'T KNOW WHAT YOU ARE DOING

─────────────────────────────────────────────────────────────────
]]



local MenuOri = 0
if Config.MenuOrientation == 0 then
    MenuOri = 0
elseif Config.MenuOrientation == 1 then
    MenuOri = 1320
else
    MenuOri = 0
end


_MenuPool = NativeUI.CreatePool()
MainMenu = NativeUI.CreateMenu()





function Menu()
    local MenuTitle = ''
    if Config.MenuTitle == 0 then
        MenuTitle = 'Vicpol Interaction Menu'
    elseif Config.MenuTitle == 1 then
        MenuTitle = GetPlayerName(source)
    elseif Config.MenuTitle == 2 then
        MenuTitle = Config.MenuTitleCustom
    else
        MenuTitle = 'Vicpol Interaction Menu'
    end



	_MenuPool:Remove()
	_MenuPool = NativeUI.CreatePool()
	MainMenu = NativeUI.CreateMenu(MenuTitle, GetResourceMetadata(GetCurrentResourceName(), 'title', 0) .. ' ~y~' .. GetResourceMetadata(GetCurrentResourceName(), 'version', 0), MenuOri)
	_MenuPool:Add(MainMenu)
	MainMenu:SetMenuWidthOffset(Config.MenuWidth)
	collectgarbage()
	
	MainMenu:SetMenuWidthOffset(Config.MenuWidth)	
	_MenuPool:ControlDisablingEnabled(false)
	_MenuPool:MouseControlsEnabled(false)





    if VICPOLRestrict() then
        local VICPOLMenu = _MenuPool:AddSubMenu(MainMenu, 'VICPOL Toolbox', 'Law Enforcement Related Menu', true)
        VICPOLMenu:SetMenuWidthOffset(Config.MenuWidth)
            local VICPOLActions = _MenuPool:AddSubMenu(VICPOLMenu, 'Actions', '', true)
            VICPOLActions:SetMenuWidthOffset(Config.MenuWidth)
                local Cuff = NativeUI.CreateItem('Cuff', 'Cuff/Uncuff the closest player')
                local Drag = NativeUI.CreateItem('Drag', 'Drag/Undrag the closest player')
                local Seat = NativeUI.CreateItem('Seat', 'Place a player in the closest vehicle')
                local Unseat = NativeUI.CreateItem('Unseat', 'Remove a player from the closest vehicle')
                local Radar = NativeUI.CreateItem('Radar', 'Toggle the radar menu')
                local Inventory = NativeUI.CreateItem('Inventory', 'Search the closest player\'s inventory')
                local BAC = NativeUI.CreateItem('BAC', 'Test the BAC level of the closest player')
                local Jail = NativeUI.CreateItem('Jail', 'Jail a player')
                local Unjail = NativeUI.CreateItem('Unjail', 'Unjail a player')
                SpikeLengths = {1, 2, 3, 4, 5}
                local Spikes = NativeUI.CreateListItem('Deploy Spikes', SpikeLengths, 1, 'Places spike strips on the ground')
                local DelSpikes = NativeUI.CreateItem('Remove Spikes', 'Remove spike strips placed on the ground')
                local Shield = NativeUI.CreateItem('Toggle Shield', 'Toggle the bulletproof shield')
                local CarbineRifle = NativeUI.CreateItem('Toggle Carbine', 'Toggle your carbine rifle')
                local Shotgun = NativeUI.CreateItem('Toggle Shotgun', 'Toggle your pump shotgun')
                PropsList = {}
                for _, Prop in pairs(Config.Props) do
                    table.insert(PropsList, Prop.name)
                end
                local Props = NativeUI.CreateListItem('Spawn Props', PropsList, 1, 'Spawn props on the ground')
                local RemoveProps = NativeUI.CreateItem('Remove Props', 'Remove the closest prop')
                VICPOLActions:AddItem(Cuff)
                VICPOLActions:AddItem(Drag)
                VICPOLActions:AddItem(Seat)
                VICPOLActions:AddItem(Unseat)
                if Config.Radar ~= 0 then
                    VICPOLActions:AddItem(Radar)
                end
                VICPOLActions:AddItem(Inventory)
                VICPOLActions:AddItem(BAC)
				if Config.VICPOLJail then
                    VICPOLActions:AddItem(Jail)
                    if UnjailAllowed then
                        VICPOLActions:AddItem(Unjail)
                    end
				end
                VICPOLActions:AddItem(Spikes)
                VICPOLActions:AddItem(DelSpikes)
                VICPOLActions:AddItem(Shield)
                if Config.UnrackWeapons == 1 or Config.UnrackWeapons == 2 then
                    VICPOLActions:AddItem(CarbineRifle)
                    VICPOLActions:AddItem(Shotgun)
                end
                if Config.DisplayProps then
                    VICPOLActions:AddItem(Props)
                    VICPOLActions:AddItem(RemoveProps)
                end
                Cuff.Activated = function(ParentMenu, SelectedItem)
                    local player = GetClosestPlayer()
                    if player ~= false then
                        TriggerServerEvent('InteractionMenu:CuffNear', player)
                    end
                end
                Drag.Activated = function(ParentMenu, SelectedItem)
                    local player = GetClosestPlayer()
                    if player ~= false then
                        TriggerServerEvent('InteractionMenu:DragNear', player)
                    end
                end
                Seat.Activated = function(ParentMenu, SelectedItem)
                    local Veh = GetVehiclePedIsIn(Ped, true)

                    local player = GetClosestPlayer()
                    if player ~= false then
                        TriggerServerEvent('InteractionMenu:SeatNear', player, Veh)
                    end
                end
                Unseat.Activated = function(ParentMenu, SelectedItem)
                    if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                        Notify('~o~You need to be outside of the vehicle')
                        return
                    end

                    local player = GetClosestPlayer()
                    if player ~= false then
                        TriggerServerEvent('InteractionMenu:UnseatNear', player)
                    end
                end
                Radar.Activated = function(ParentMenu, SelectedItem)
                    ToggleRadar()
                end
                Inventory.Activated = function(ParentMenu, SelectedItem)
                    local player = GetClosestPlayer()
                    if player ~= false then
                        Notify('~b~Searching ...')
                        TriggerServerEvent('InteractionMenu:InventorySearch', player)
                    end
                end
                BAC.Activated = function(ParentMenu, SelectedItem)
                    local player = GetClosestPlayer()
                    if player ~= false then
                        Notify('~b~Testing ...')
                        TriggerServerEvent('InteractionMenu:BACTest', player)
                    end
                end
                Jail.Activated = function(ParentMenu, SelectedItem)
                    local PlayerID = tonumber(KeyboardInput('Player ID:', 10))
                    if PlayerID == nil then
                        Notify('~r~Please enter a player ID')
                        return
                    end

                    local JailTime = tonumber(KeyboardInput('Time: (Seconds) - Max Time: ' .. Config.MaxJailTime .. ' | Default Time: 30', string.len(Config.MaxJailTime)))
                    if JailTime == nil then
                        JailTime = 30
                    end
                    if JailTime > Config.MaxJailTime then
                        Notify('~y~Exceeded Max Time\nMax Time: ' .. Config.MaxJailTime .. ' seconds')
                        JailTime = Config.MaxJailTime
                    end

                    Notify('Player Jailed for ~b~' .. JailTime .. ' seconds')
                    TriggerServerEvent('InteractionMenu:Jail', PlayerID, JailTime)
                end
                Unjail.Activated = function(ParentMenu, SelectedItem)
                    local PlayerID = tonumber(KeyboardInput('Player ID:', 10))
                    if PlayerID == nil then
                        Notify('~r~Please enter a player ID')
                        return
                    end

                    TriggerServerEvent('InteractionMenu:Unjail', PlayerID)
                end
                DelSpikes.Activated = function(ParentMenu, SelectedItem)
                    TriggerEvent('InteractionMenu:Spikes-DeleteSpikes')
                end
                Shield.Activated = function(ParentMenu, SelectedItem)
                    if ShieldActive then
                        DisableShield()
                    else
                        EnableShield()
                    end
                end
                CarbineRifle.Activated = function(ParentMenu, SelectedItem)
                    if (GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) == 18) then
                        CarbineEquipped = not CarbineEquipped
                        ShotgunEquipped = false
                    elseif (GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 18) then
                        Notify('~r~You Must be in a Police Vehicle to rack/unrack your Carbine Rifle')
                        return
                    end
                
                    if CarbineEquipped then
                        Notify('~g~Carbine Rifle Equipped')
                        GiveWeapon('weapon_carbinerifle')
                        AddWeaponComponent('weapon_carbinerifle', 'component_at_ar_flsh')
                        AddWeaponComponent('weapon_carbinerifle', 'component_at_ar_afgrip')
                    else 
                        Notify('~y~Carbine Rifle Unequipped')
                        RemoveWeaponFromPed(GetPlayerPed(-1), 'weapon_carbinerifle')
                    end
                end
                Shotgun.Activated = function(ParentMenu, SelectedItem)
                    if (GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) == 18) then
                        ShotgunEquipped = not ShotgunEquipped
                        CarbineEquipped = false
                    elseif (GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 18) then
                        Notify('~r~You Must be in a Police Vehicle to rack/unrack your Shotgun')
                        return
                    end
                    
                    if ShotgunEquipped then
                        Notify('~g~Shotgun Equipped')
                        GiveWeapon('weapon_pumpshotgun')
                        AddWeaponComponent('weapon_pumpshotgun', 'component_at_ar_flsh')
                    else
                        Notify('~y~Shotgun Unequipped')
                        RemoveWeaponFromPed(GetPlayerPed(-1), 'weapon_pumpshotgun')
                    end
                end
                VICPOLActions.OnListSelect = function(sender, item, index)
                    if item == Spikes then
                        TriggerEvent('InteractionMenu:Spikes-SpawnSpikes', tonumber(index))
                    elseif item == Props then
                        for _, Prop in pairs(Config.Props) do
                            if Prop.name == item:IndexToItem(index) then
                                SpawnProp(Prop.spawncode, Prop.name)
                            end
                        end
                    end
                end
                RemoveProps.Activated = function(ParentMenu, SelectedItem)
                    for _, Prop in pairs(Config.Props) do
                        DeleteProp(Prop.spawncode)
                    end
                end

            if Config.DisplayBackup then
                local VICPOLBackup = _MenuPool:AddSubMenu(VICPOLMenu, 'Backup', '', true)
                VICPOLBackup:SetMenuWidthOffset(Config.MenuWidth)
                    --[[
                        Priority 1 Backup  | No Lights or Siren
                        Priority 2 Backup  | Only Lights
                        Priority 3 Backup  | Lights and Siren
                    ]]
                    local BK1 = NativeUI.CreateItem('Priority 1', 'Call Priority 1 Backup to your location')
                    local BK2 = NativeUI.CreateItem('Priority 2', 'Call Priority 2 Backup to your location')
                    local BK3 = NativeUI.CreateItem('Priority 3', 'Call Priority 3 Backup to your location')
                    local BK99 = NativeUI.CreateItem('Not used')
                    local PanicBTN = NativeUI.CreateItem('~r~Panic Button', 'Officer Panic Button respond SIGNAL 1')
                    VICPOLBackup:AddItem(BK1)
                    VICPOLBackup:AddItem(BK2)
                    VICPOLBackup:AddItem(BK3)
                    VICPOLBackup:AddItem(BK99)
                    VICPOLBackup:AddItem(PanicBTN)
                    BK1.Activated = function(ParentMenu, SelectedItem)
                        local Coords = GetEntityCoords(GetPlayerPed(-1))
                        local Street1, Street2 = GetStreetNameAtCoord(Coords.x, Coords.y, Coords.z)
                        local StreetName = GetStreetNameFromHashKey(Street1)

                        TriggerServerEvent('InteractionMenu:Backup', 1, StreetName, Coords)
                    end
                    BK2.Activated = function(ParentMenu, SelectedItem)
                        local Coords = GetEntityCoords(GetPlayerPed(-1))
                        local Street1, Street2 = GetStreetNameAtCoord(Coords.x, Coords.y, Coords.z)
                        local StreetName = GetStreetNameFromHashKey(Street1)

                        TriggerServerEvent('InteractionMenu:Backup', 2, StreetName, Coords)
                    end
                    BK3.Activated = function(ParentMenu, SelectedItem)
                        local Coords = GetEntityCoords(GetPlayerPed(-1))
                        local Street1, Street2 = GetStreetNameAtCoord(Coords.x, Coords.y, Coords.z)
                        local StreetName = GetStreetNameFromHashKey(Street1)

                        TriggerServerEvent('InteractionMenu:Backup', 3, StreetName, Coords)
                    end
                    BK99.Activated = function(ParentMenu, SelectedItem)
                        local Coords = GetEntityCoords(GetPlayerPed(-1))
                        local Street1, Street2 = GetStreetNameAtCoord(Coords.x, Coords.y, Coords.z)
                        local StreetName = GetStreetNameFromHashKey(Street1)

                        TriggerServerEvent('InteractionMenu:Backup', 99, StreetName, Coords)
                    end
                    PanicBTN.Activated = function(ParentMenu, SelectedItem)
                        local Coords = GetEntityCoords(GetPlayerPed(-1))
                        local Street1, Street2 = GetStreetNameAtCoord(Coords.x, Coords.y, Coords.z)
                        local StreetName = GetStreetNameFromHashKey(Street1)

                        TriggerServerEvent('InteractionMenu:Backup', 'panic', StreetName, Coords)
                    end
            end

            if Config.ShowStations then
                local VICPOLStation = _MenuPool:AddSubMenu(VICPOLMenu, 'Stations', '', true)
                VICPOLStation:SetMenuWidthOffset(Config.MenuWidth)
                    for _, Station in pairs(Config.VICPOLStations) do
                        local StationCategory = _MenuPool:AddSubMenu(VICPOLStation, Station.name, '', true)
                        StationCategory:SetMenuWidthOffset(Config.MenuWidth)
                            local SetWaypoint = NativeUI.CreateItem('Set Waypoint', 'Set a waypoint to the station')
                            local Teleport = NativeUI.CreateItem('Teleport', 'Teleport to the station')
                            StationCategory:AddItem(SetWaypoint)
                            if Config.AllowStationTeleport then
                                StationCategory:AddItem(Teleport)
                            end
                            SetWaypoint.Activated = function(ParentMenu, SelectedItem)
                                SetNewWaypoint(Station.coords.x, Station.coords.y)
                            end
                            Teleport.Activated = function(ParentMenu, SelectedItem)
                                SetEntityCoords(PlayerPedId(), Station.coords.x, Station.coords.y, Station.coords.z)
                                SetEntityHeading(PlayerPedId(), Station.coords.h)
                            end
                    end
            end

            if Config.DisplayVICPOLUniforms or Config.DisplayVICPOLLoadouts then
                local VICPOLLoadouts = _MenuPool:AddSubMenu(VICPOLMenu, 'Loadouts', '', true)
                VICPOLLoadouts:SetMenuWidthOffset(Config.MenuWidth)
                    UniformsList = {}
                    for _, Uniform in pairs(Config.VICPOLUniforms) do
                        table.insert(UniformsList, Uniform.name)
                    end
                    
                    LoadoutsList = {}
                    for Name, Loadout in pairs(Config.VICPOLLoadouts) do
                        table.insert(LoadoutsList, Name)
                    end

                    local Uniforms = NativeUI.CreateListItem('Uniforms', UniformsList, 1, 'Spawn VICPOL uniforms')
                    local Loadouts = NativeUI.CreateListItem('Loadouts', LoadoutsList, 1, 'Spawn VICPOL weapon loadouts')
                    if Config.DisplayVICPOLUniforms then
                        VICPOLLoadouts:AddItem(Uniforms)
                    end
                    if Config.DisplayVICPOLLoadouts then
                        VICPOLLoadouts:AddItem(Loadouts)
                    end
                    VICPOLLoadouts.OnListSelect = function(sender, item, index)
                        if item == Uniforms then
                            for _, Uniform in pairs(Config.VICPOLUniforms) do
                                if Uniform.name == item:IndexToItem(index) then
                                    LoadPed(Uniform.spawncode)
                                    Notify('~b~Uniform Spawned: ~g~' .. Uniform.name)
                                end
                            end
                        end



                        if item == Loadouts then
                            for Name, Loadout in pairs(Config.VICPOLLoadouts) do
                                if Name == item:IndexToItem(index) then
                                    SetEntityHealth(GetPlayerPed(-1), 200)
                                    RemoveAllPedWeapons(GetPlayerPed(-1), true)
                                    AddArmourToPed(GetPlayerPed(-1), 100)

                                    for _, Weapon in pairs(Loadout) do
                                        GiveWeapon(Weapon.weapon)
                                                                
                                        for _, Component in pairs(Weapon.components) do
                                            AddWeaponComponent(Weapon.weapon, Component)
                                        end
                                    end

                                    Notify('~b~Loadout Spawned: ~g~' .. Name)
                                end
                            end
                        end
                    end
            end

            if Config.ShowVICPOLVehicles then
                local VICPOLVehicles = _MenuPool:AddSubMenu(VICPOLMenu, 'Vehicles', '', true)
                VICPOLVehicles:SetMenuWidthOffset(Config.MenuWidth)
                
                for Name, Category in pairs(Config.VICPOLVehiclesCategories) do
                    local VICPOLCategory = _MenuPool:AddSubMenu(VICPOLVehicles, Name, '', true)
                    VICPOLCategory:SetMenuWidthOffset(Config.MenuWidth)
                    for _, Vehicle in pairs(Category) do
                        local VICPOLVehicle = NativeUI.CreateItem(Vehicle.name, '')
                        VICPOLCategory:AddItem(VICPOLVehicle)
                        if Config.ShowVICPOLSpawnCode then
                            VICPOLVehicle:RightLabel(Vehicle.spawncode)
                        end
                        VICPOLVehicle.Activated = function(ParentMenu, SelectedItem)
                            SpawnVehicle(Vehicle.spawncode, Vehicle.name, Vehicle.livery, Vehicle.extras)
                        end
                    end
                end
            end

            if Config.DisplayTrafficManager then
                local VICPOLTrafficManager = _MenuPool:AddSubMenu(VICPOLMenu, 'Traffic Manager', '', true)
                VICPOLTrafficManager:SetMenuWidthOffset(Config.MenuWidth)
        
                    TMSize = 10.0
                    TMSpeed = 0.0
                    RaduiesNames = {}
                    Raduies = {
                        {name = '10m', size = 10.0},
                        {name = '20m', size = 20.0},
                        {name = '30m', size = 30.0},
                        {name = '40m', size = 40.0},
                        {name = '50m', size = 50.0},
                        {name = '60m', size = 60.0},
                        {name = '70m', size = 70.0},
                        {name = '80m', size = 80.0},
                        {name = '90m', size = 90.0},
                        {name = '100m', size = 100.0},
                    }
                    SpeedsNames = {}
                    Speeds = {
                        {name = '0 mph', speed = 0.0},
                        {name = '5 mph', speed = 5.0},
                        {name = '10 mph', speed = 10.0},
                        {name = '15 mph', speed = 15.0},
                        {name = '20 mph', speed = 20.0},
                        {name = '25 mph', speed = 25.0},
                        {name = '30 mph', speed = 30.0},
                        {name = '40 mph', speed = 40.0},
                        {name = '50 mph', speed = 50.0},
                    }

                    for _, RaduisInfo in pairs(Raduies) do
                        table.insert(RaduiesNames, RaduisInfo.name)
                    end
                    for _, SpeedsInfo in pairs(Speeds) do
                        table.insert(SpeedsNames, SpeedsInfo.name)
                    end
    
                    local Radius = NativeUI.CreateListItem('Radius', RaduiesNames, 1, '')
                    local Speed = NativeUI.CreateListItem('Speed', SpeedsNames, 1, '')
                    local TMCreate = NativeUI.CreateItem('Create Speed Zone', '')
                    local TMDelete = NativeUI.CreateItem('Delete Speed Zone', '')
                    VICPOLTrafficManager:AddItem(Radius)
                    VICPOLTrafficManager:AddItem(Speed)
                    VICPOLTrafficManager:AddItem(TMCreate)
                    VICPOLTrafficManager:AddItem(TMDelete)
                    Radius.OnListChanged = function(sender, item, index)
                        TMSize = Raduies[index].size
                    end
                    Speed.OnListChanged = function(sender, item, index)
                        TMSpeed = Speeds[index].speed
                    end
                    TMCreate.Activated = function(ParentMenu, SelectedItem)
                        if Zone == nil then
                            Zone = AddSpeedZoneForCoord(GetEntityCoords(PlayerPedId()), TMSize, TMSpeed, false)
                            Area = AddBlipForRadius(GetEntityCoords(PlayerPedId()), TMSize)
                            SetBlipAlpha(Area, 100)
                            Notify('~g~Speed Zone Created')
                        else
                            Notify('~y~You already have a Speed Zone created')
                        end
                    end
                    TMDelete.Activated = function(ParentMenu, SelectedItem)
                        if Zone ~= nil then
                            RemoveSpeedZone(Zone)
                            RemoveBlip(Area)
                            Zone = nil
                            Notify('~r~Speed Zone Deleted')
                        else
                            Notify('~y~You don\'t have a Speed Zone')
                        end
                    end
            end
    end




    if FrvRestrict() then
        local FrvMenu = _MenuPool:AddSubMenu(MainMenu, 'FRV Toolbox', 'FRV Related Menu', true)
        FrvMenu:SetMenuWidthOffset(Config.MenuWidth)
            local FrvActions = _MenuPool:AddSubMenu(FrvMenu, 'Actions', '', true)
            FrvActions:SetMenuWidthOffset(Config.MenuWidth)
                local Drag = NativeUI.CreateItem('Drag', 'Drag/Undrag the closest player')
                local Seat = NativeUI.CreateItem('Seat', 'Place a player in the closest vehicle')
                local Unseat = NativeUI.CreateItem('Unseat', 'Remove a player from the closest vehicle')
                FrvActions:AddItem(Drag)
                FrvActions:AddItem(Seat)
                FrvActions:AddItem(Unseat)
                Drag.Activated = function(ParentMenu, SelectedItem)
                    local player = GetClosestPlayer()
                    if player ~= false then
                        TriggerServerEvent('InteractionMenu:DragNear', player)
                    end
                end
                Seat.Activated = function(ParentMenu, SelectedItem)
                    local player = GetClosestPlayer()
                    if player ~= false then
                        TriggerServerEvent('InteractionMenu:SeatNear', player, Veh)
                    end
                end
                Unseat.Activated = function(ParentMenu, SelectedItem)
                    if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                        Notify('~o~You need to be outside of the vehicle')
                        return
                    end

                    local player = GetClosestPlayer()
                    if player ~= false then
                        TriggerServerEvent('InteractionMenu:UnseatNear', player)
                    end
                end
				if Config.FrvHospital then
                    local HospitalLocations = _MenuPool:AddSubMenu(FrvActions, 'Hospitalize', '', true)
                    HospitalLocations:SetMenuWidthOffset(Config.MenuWidth)
                        for HospitalName, HospitalInfo in pairs(Config.HospitalLocation) do
                            local Hospitalize = NativeUI.CreateItem(HospitalName, 'Hospitalize a player')
                            HospitalLocations:AddItem(Hospitalize)
                            Hospitalize.Activated = function(ParentMenu, SelectedItem)
                                local PlayerID = tonumber(KeyboardInput('Player ID:', 10))
                                if PlayerID == nil then
                                    Notify('~r~Please enter a player ID')
                                    return
                                end

                                local HospitalTime = tonumber(KeyboardInput('Time: (Seconds) - Max Time: ' .. Config.MaxHospitalTime .. ' | Default Time: 30', 3))
                                if HospitalTime == nil then
                                    HospitalTime = 30
                                end
                                if HospitalTime > Config.MaxHospitalTime then
                                    Notify('~y~Exceeded Max Time\nMax Time: ' .. Config.MaxHospitalTime .. ' seconds')
                                    HospitalTime = Config.MaxHospitalTime
                                end

                                Notify('Player Hospitalized for ~b~' .. HospitalTime .. ' seconds')
                                TriggerServerEvent('InteractionMenu:Hospitalize', PlayerID, HospitalTime, HospitalInfo)
                            end
                        end
                    local Unhospitalize = NativeUI.CreateItem('Unhospitalize', 'Unhospitalize a player')
                    if UnhospitalAllowed then
                        FrvActions:AddItem(Unhospitalize)
                    end
                    Unhospitalize.Activated = function(ParentMenu, SelectedItem)
                        local PlayerID = tonumber(KeyboardInput('Player ID:', 10))
                        if PlayerID == nil then
                            Notify('~r~Please enter a player ID')
                            return
                        end

                        TriggerServerEvent('InteractionMenu:Unhospitalize', PlayerID)
                    end
                end
                PropsList = {}
                for _, Prop in pairs(Config.Props) do
                    table.insert(PropsList, Prop.name)
                end
                local Props = NativeUI.CreateListItem('Spawn Props', PropsList, 1, 'Spawn props on the ground')
                local RemoveProps = NativeUI.CreateItem('Remove Props', 'Remove the closest prop')
                FrvActions:AddItem(Props)
                FrvActions:AddItem(RemoveProps)
                FrvActions.OnListSelect = function(sender, item, index)
                    if item == Props then
                        for _, Prop in pairs(Config.Props) do
                            if Prop.name == item:IndexToItem(index) then
                                SpawnProp(Prop.spawncode, Prop.name)
                            end
                        end
                    end
                end
                RemoveProps.Activated = function(ParentMenu, SelectedItem)
                    for _, Prop in pairs(Config.Props) do
                        DeleteProp(Prop.spawncode)
                    end
                end

            if Config.ShowStations then
                local FrvEMSStation = _MenuPool:AddSubMenu(FrvMenu, 'Stations', '', true)
                FrvEMSStation:SetMenuWidthOffset(Config.MenuWidth)
                    local FrvStation = _MenuPool:AddSubMenu(FrvEMSStation, 'Frv Stations', '', true)
                    FrvStation:SetMenuWidthOffset(Config.MenuWidth)
                        for _, Station in pairs(Config.FrvStations) do
                            local StationCategory = _MenuPool:AddSubMenu(FrvStation, Station.name, '', true)
                            StationCategory:SetMenuWidthOffset(Config.MenuWidth)
                                local SetWaypoint = NativeUI.CreateItem('Set Waypoint', 'Set a waypoint to the station')
                                local Teleport = NativeUI.CreateItem('Teleport', 'Teleport to the station')
                                StationCategory:AddItem(SetWaypoint)
                                if Config.AllowStationTeleport then
                                    StationCategory:AddItem(Teleport)
                                end
                                SetWaypoint.Activated = function(ParentMenu, SelectedItem)
                                    SetNewWaypoint(Station.coords.x, Station.coords.y)
                                end
                                Teleport.Activated = function(ParentMenu, SelectedItem)
                                    SetEntityCoords(PlayerPedId(), Station.coords.x, Station.coords.y, Station.coords.z)
                                    SetEntityHeading(PlayerPedId(), Station.coords.h)
                                end
                        end

                    local EMSStation = _MenuPool:AddSubMenu(FrvEMSStation, 'Hospitals', '', true)
                    EMSStation:SetMenuWidthOffset(Config.MenuWidth)
                        for _, Station in pairs(Config.HospitalStations) do
                            local StationCategory = _MenuPool:AddSubMenu(EMSStation, Station.name, '', true)
                            StationCategory:SetMenuWidthOffset(Config.MenuWidth)
                                local SetWaypoint = NativeUI.CreateItem('Set Waypoint', 'Set a waypoint to the hospital')
                                local Teleport = NativeUI.CreateItem('Teleport', 'Teleport to the hospital')
                                StationCategory:AddItem(SetWaypoint)
                                if Config.AllowStationTeleport then
                                    StationCategory:AddItem(Teleport)
                                end
                                SetWaypoint.Activated = function(ParentMenu, SelectedItem)
                                    SetNewWaypoint(Station.coords.x, Station.coords.y)
                                end
                                Teleport.Activated = function(ParentMenu, SelectedItem)
                                    SetEntityCoords(PlayerPedId(), Station.coords.x, Station.coords.y, Station.coords.z)
                                    SetEntityHeading(PlayerPedId(), Station.coords.h)
                                end
                        end
            end

            if Config.DisplayFrvUniforms or Config.DisplayFrvLoadouts then
                local FrvLoadouts = _MenuPool:AddSubMenu(FrvMenu, 'Loadouts', '', true)
                FrvLoadouts:SetMenuWidthOffset(Config.MenuWidth)
                    UniformsList = {}
                    for _, Uniform in pairs(Config.FrvUniforms) do
                        table.insert(UniformsList, Uniform.name)
                    end
                        
                    LoadoutsList = {
                        'Clear',
                        'Standard',
                    }
                    local Uniforms = NativeUI.CreateListItem('Uniforms', UniformsList, 1, 'Spawn Frv uniforms')
                    local Loadouts = NativeUI.CreateListItem('Loadouts', LoadoutsList, 1, 'Spawns Frv weapon loadouts')
                    if Config.DisplayFrvUniforms then
                        FrvLoadouts:AddItem(Uniforms)
                    end
                    if Config.DisplayFrvLoadouts then
                        FrvLoadouts:AddItem(Loadouts)
                    end
                    FrvLoadouts.OnListSelect = function(sender, item, index)
                        if item == Uniforms then
                            for _, Uniform in pairs(Config.FrvUniforms) do
                                if Uniform.name == item:IndexToItem(index) then
                                    LoadPed(Uniform.spawncode)
                                    Notify('~b~Uniform Spawned: ~g~' .. Uniform.name)
                                end
                            end
                        end
            
            
            
                        if item == Loadouts then
                            local SelectedLoadout = item:IndexToItem(index)
                            if SelectedLoadout == 'Clear' then
                                SetEntityHealth(GetPlayerPed(-1), 200)
                                RemoveAllPedWeapons(GetPlayerPed(-1), true)
                                Notify('~r~All Weapons Cleared!')
                            elseif SelectedLoadout == 'Standard' then
                                SetEntityHealth(GetPlayerPed(-1), 200)
                                RemoveAllPedWeapons(GetPlayerPed(-1), true)
                                AddArmourToPed(GetPlayerPed(-1), 100)
                                GiveWeapon('weapon_flashlight')
                                GiveWeapon('weapon_Frvextinguisher')
                                GiveWeapon('weapon_flare')
                                GiveWeapon('weapon_stungun')
                                Notify('~b~Loadout Spawned: ~g~' .. SelectedLoadout)
                            end
                        end
                    end
            end
            
            if Config.ShowFrvVehicles then
                local FrvVehicles = _MenuPool:AddSubMenu(FrvMenu, 'Vehicles', '', true)
                FrvVehicles:SetMenuWidthOffset(Config.MenuWidth)
                
                for _, Vehicle in pairs(Config.FrvVehicles) do
                    local FrvVehicle = NativeUI.CreateItem(Vehicle.name, '')
                    FrvVehicles:AddItem(FrvVehicle)
                    if Config.ShowFrvSpawnCode then
                        FrvVehicle:RightLabel(Vehicle.spawncode)
                    end
                    FrvVehicle.Activated = function(ParentMenu, SelectedItem)
                        SpawnVehicle(Vehicle.spawncode, Vehicle.name, Vehicle.livery, Vehicle.extras)
                    end
                end
            end
    end




    if CivRestrict() then
        local CivMenu = _MenuPool:AddSubMenu(MainMenu, 'Civ Toolbox', 'Civilian Related Menu', true)
        CivMenu:SetMenuWidthOffset(Config.MenuWidth)
            local CivActions = _MenuPool:AddSubMenu(CivMenu, 'Actions', '', true)
            CivActions:SetMenuWidthOffset(Config.MenuWidth)
                local HU = NativeUI.CreateItem('Hands Up', 'Put your hands up')
                local HUK = NativeUI.CreateItem('Hand Up & Kneel', 'Put your hands up and kneel on the ground')
                local Inventory = NativeUI.CreateItem('Inventory', 'Set your inventory')
                local BAC = NativeUI.CreateItem('BAC', 'Set your BAC level')
                local DropWeapon = NativeUI.CreateItem('Drop Weapon', 'Drop your current weapon on the ground')
                CivActions:AddItem(HU)
                CivActions:AddItem(HUK)
                CivActions:AddItem(Inventory)
                CivActions:AddItem(BAC)
                CivActions:AddItem(DropWeapon)
                HU.Activated = function(ParentMenu, SelectedItem)
                    local Ped = PlayerPedId()
                    if DoesEntityExist(Ped) and not HandCuffed then
                        Citizen.CreateThread(function()
                            LoadAnimation('random@mugging3')
                            if IsEntityPlayingAnim(Ped, 'random@mugging3', 'handsup_standing_base', 3) or HandCuffed then
                                ClearPedSecondaryTask(Ped)
                                SetEnableHandcuffs(Ped, false)
                            elseif not IsEntityPlayingAnim(Ped, 'random@mugging3', 'handsup_standing_base', 3) or not HandCuffed then
                                TaskPlayAnim(Ped, 'random@mugging3', 'handsup_standing_base', 8.0, -8, -1, 49, 0, 0, 0, 0)
                                SetEnableHandcuffs(Ped, true)
                            end
                        end)
                    end
                end
                HUK.Activated = function(ParentMenu, SelectedItem)
                    local Ped = PlayerPedId()
                    if (DoesEntityExist(Ped) and not IsEntityDead(Ped)) and not HandCuffed then
                        Citizen.CreateThread(function()
                            LoadAnimation('random@arrests')
                            if (IsEntityPlayingAnim(Ped, 'random@arrests', 'kneeling_arrest_idle', 3)) then
                                TaskPlayAnim(Ped, 'random@arrests', 'kneeling_arrest_get_up', 8.0, 1.0, -1, 128, 0, 0, 0, 0)
                            else
                                TaskPlayAnim(Ped, 'random@arrests', 'idle_2_hands_up', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                                Wait (4000)
                                TaskPlayAnim(Ped, 'random@arrests', 'kneeling_arrest_idle', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            end
                        end)
                    end
                end
                Inventory.Activated = function(ParentMenu, SelectedItem)
                    local Items = KeyboardInput('Items:', 75)
                    if Items == nil or Items == '' then
                        Notify('~r~No Items Provided!')
                        return
                    end

                    TriggerServerEvent('InteractionMenu:InventorySet', Items)
                    Notify('~g~Inventory Set!')
                end
                BAC.Activated = function(ParentMenu, SelectedItem)
                    local BACLevel = KeyboardInput('BAC Level - Legal Limit: 0.08', 5)
                    if BACLevel == nil or BACLevel == '' then
                        Notify('~r~No BAC Level Provided!')
                        return
                    end

                    TriggerServerEvent('InteractionMenu:BACSet', tonumber(BACLevel))
                    if tonumber(BACLevel) < 0.08 then
                        Notify('~b~BAC Level Set: ~g~' .. tostring(BACLevel))
                    else
                        Notify('~b~BAC Level Set: ~r~' .. tostring(BACLevel))
                    end
                end
                DropWeapon.Activated = function(ParentMenu, SelectedItem)
                    local CurrentWeapon = GetSelectedPedWeapon(PlayerPedId())
                    SetCurrentPedWeapon(PlayerPedId(), 'weapon_unarmed', true)
                    SetPedDropsInventoryWeapon(GetPlayerPed(-1), CurrentWeapon, -2.0, 0.0, 0.5, 30)
                    Notify('~r~Weapon Dropped!')
                end
            if Config.ShowCivAdverts then
                local CivAdverts = _MenuPool:AddSubMenu(CivMenu, 'Adverts', '', true)
                CivAdverts:SetMenuWidthOffset(Config.MenuWidth)
                    for _, Ad in pairs(Config.CivAdverts) do
                        local Advert  = NativeUI.CreateItem(Ad.name, 'Send an advert for ' .. Ad.name)
                        CivAdverts:AddItem(Advert)
                        Advert.Activated = function(ParentMenu, SelectedItem)
                            local Message = KeyboardInput('Message:', 128)
                            if Message == nil or Message == '' then
                                Notify('~r~No Advert Message Provided!')
                                return
                            end
                
                            TriggerServerEvent('InteractionMenu:Ads', Message, Ad.name, Ad.loc, Ad.file)
                        end
                    end
            end
            if Config.ShowCivVehicles then
                local CivVehicles = _MenuPool:AddSubMenu(CivMenu, 'Vehicles', '', true)
                CivVehicles:SetMenuWidthOffset(Config.MenuWidth)
                
                for _, Vehicle in pairs(Config.CivVehicles) do
                    local CivVehicle = NativeUI.CreateItem(Vehicle.name, '')
                    CivVehicles:AddItem(CivVehicle)
                    if Config.ShowCivSpawnCode then
                        CivVehicle:RightLabel(Vehicle.spawncode)
                    end
                    CivVehicle.Activated = function(ParentMenu, SelectedItem)
                        SpawnVehicle(Vehicle.spawncode, Vehicle.name)
                    end
                end
            end
    end





    if VehicleRestrict() then
        local VehicleMenu = _MenuPool:AddSubMenu(MainMenu, 'Vehicle', 'Vehicle Related Menu', true)
        VehicleMenu:SetMenuWidthOffset(Config.MenuWidth)
            local Seats = {-1, 0, 1, 2}
            local Windows = {'Front', 'Rear', 'All'}
            local Doors = {'Driver', 'Passenger', 'Rear Right', 'Rear Left', 'Hood', 'Trunk', 'All'}
            local Engine = NativeUI.CreateItem('Toggle Engine', 'Toggle your vehicle\'s engine')
            local ILights = NativeUI.CreateItem('Toggle Interior Light', 'Toggle your vehicle\'s interior light')
            local Seat = NativeUI.CreateSliderItem('Change Seats', Seats, 1, 'Switch to a different seat')
            local Window = NativeUI.CreateListItem('Windows', Windows, 1, 'Open/Close your vehicle\'s windows')
            local Door = NativeUI.CreateListItem('Doors', Doors, 1, 'Open/Close your vehicle\'s doors')
            local FixVeh = NativeUI.CreateItem('Repair Vehicle', 'Repair your current vehicle')
            local CleanVeh = NativeUI.CreateItem('Clean Vehicle', 'Clean your current vehicle')
            local DelVeh = NativeUI.CreateItem('~r~Delete Vehicle', 'Delete your current vehicle')
            VehicleMenu:AddItem(Engine)
            VehicleMenu:AddItem(ILights)
            VehicleMenu:AddItem(Seat)
            VehicleMenu:AddItem(Window)
            VehicleMenu:AddItem(Door)
            if Config.VehicVICPOLptions then
                VehicleMenu:AddItem(FixVeh)
                VehicleMenu:AddItem(CleanVeh)
                VehicleMenu:AddItem(DelVeh)
            end
            Engine.Activated = function(ParentMenu, SelectedItem)
                local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if Vehicle ~= nil and Vehicle ~= 0 and GetPedInVehicleSeat(Vehicle, 0) then
                    SetVehicleEngineOn(Vehicle, (not GetIsVehicleEngineRunning(Vehicle)), false, true)
                    Notify('~g~Engine Toggled!')
                else
                    Notify('~r~You\'re not in a Vehicle!')
                end
            end
            ILights.Activated = function(ParentMenu, SelectedItem)
                local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

                if IsPedInVehicle(PlayerPedId(), Vehicle, false) then
                    if IsVehicleInteriorLightOn(Vehicle) then
                        SetVehicleInteriorlight(Vehicle, false)
                    else
                        SetVehicleInteriorlight(Vehicle, true)
                    end
                else
                    Notify('~r~You\'re not in a Vehicle!')
                end
            end
            VehicleMenu.OnSliderChange = function(sender, item, index)
                if item == Seat then
                    VehicleSeat = item:IndexToItem(index)
                    local Veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
                    SetPedIntoVehicle(PlayerPedId(), Veh, VehicleSeat)
                end
            end
            VehicleMenu.OnListSelect = function(sender, item, index)
                local Ped = GetPlayerPed(-1)
                local Veh = GetVehiclePedIsIn(Ped, false)

                if item == Window then
                    VehicleWindow = item:IndexToItem(index)
                    if VehicleWindow == 'Front' then
                        if IsPedInAnyVehicle(Ped, false) then
                            if (GetPedInVehicleSeat(Veh, -1) == Ped) then 
                                SetEntityAsMissionEntity(Veh, true, true)
                                if (WindowFrontRolled) then
                                    RollDownWindow(Veh, 0)
                                    RollDownWindow(Veh, 1)
                                    WindowFrontRolled = false
                                else
                                    RollUpWindow(Veh, 0)
                                    RollUpWindow(Veh, 1)
                                    WindowFrontRolled = true
                                end
                            end
                        end
                    elseif VehicleWindow == 'Rear' then
                        if IsPedInAnyVehicle(Ped, false) then
                            if (GetPedInVehicleSeat(Veh, -1) == Ped) then 
                                SetEntityAsMissionEntity(Veh, true, true)
                                if (WindowFrontRolled) then
                                    RollDownWindow(Veh, 2)
                                    RollDownWindow(Veh, 3)
                                    WindowFrontRolled = false
                                else
                                    RollUpWindow(Veh, 2)
                                    RollUpWindow(Veh, 3)
                                    WindowFrontRolled = true
                                end
                            end
                        end
                    elseif VehicleWindow == 'All' then
                        if IsPedInAnyVehicle(Ped, false) then
                            if (GetPedInVehicleSeat(Veh, -1) == Ped) then 
                                SetEntityAsMissionEntity(Veh, true, true)
                                if (WindowFrontRolled) then
                                    RollDownWindow(Veh, 0)
                                    RollDownWindow(Veh, 1)
                                    RollDownWindow(Veh, 2)
                                    RollDownWindow(Veh, 3)
                                    WindowFrontRolled = false
                                else
                                    RollUpWindow(Veh, 0)
                                    RollUpWindow(Veh, 1)
                                    RollUpWindow(Veh, 2)
                                    RollUpWindow(Veh, 3)
                                    WindowFrontRolled = true
                                end
                            end
                        end
                    end
                elseif item == Door then
                    local Doors = {'Driver', 'Passenger', 'Rear Left', 'Rear Right', 'Hood', 'Trunk', 'All'}
                    VehicleDoor = item:IndexToItem(index)
                    if VehicleDoor == 'Driver' then
                        if Veh ~= nil and Veh ~= 0 and Veh ~= 1 then
                            if GetVehicleDoorAngleRatio(Veh, 0) > 0 then
                                SetVehicleDoorShut(Veh, 0, false)
                            else
                                SetVehicleDoorOpen(Veh, 0, false, false)
                            end
                        end
                    elseif VehicleDoor == 'Passenger' then
                        if Veh ~= nil and Veh ~= 0 and Veh ~= 1 then
                            if GetVehicleDoorAngleRatio(Veh, 1) > 0 then
                                SetVehicleDoorShut(Veh, 1, false)
                            else
                                SetVehicleDoorOpen(Veh, 1, false, false)
                            end
                        end
                    elseif VehicleDoor == 'Rear Left' then
                        if Veh ~= nil and Veh ~= 0 and Veh ~= 1 then
                            if GetVehicleDoorAngleRatio(Veh, 2) > 0 then
                                SetVehicleDoorShut(Veh, 2, false)
                            else
                                SetVehicleDoorOpen(Veh, 2, false, false)
                            end
                        end
                    elseif VehicleDoor == 'Rear Right' then
                        if Veh ~= nil and Veh ~= 0 and Veh ~= 1 then
                            if GetVehicleDoorAngleRatio(Veh, 3) > 0 then
                                SetVehicleDoorShut(Veh, 3, false)
                            else
                                SetVehicleDoorOpen(Veh, 3, false, false)
                            end
                        end
                    elseif VehicleDoor == 'Hood' then
                        if Veh ~= nil and Veh ~= 0 and Veh ~= 1 then
                            if GetVehicleDoorAngleRatio(Veh, 4) > 0 then
                                SetVehicleDoorShut(Veh, 4, false)
                            else
                                SetVehicleDoorOpen(Veh, 4, false, false)
                            end
                        end
                    elseif VehicleDoor == 'Trunk' then
                        if Veh ~= nil and Veh ~= 0 and Veh ~= 1 then
                            if GetVehicleDoorAngleRatio(Veh, 5) > 0 then
                                SetVehicleDoorShut(Veh, 5, false)
                            else
                                SetVehicleDoorOpen(Veh, 5, false, false)
                            end
                        end
                    elseif VehicleDoor == 'All' then
                        if Veh ~= nil and Veh ~= 0 and Veh ~= 1 then
                            if GetVehicleDoorAngleRatio(Veh, 0) > 0 then
                                SetVehicleDoorShut(Veh, 0, false)
                                SetVehicleDoorShut(Veh, 1, false)
                                SetVehicleDoorShut(Veh, 2, false)
                                SetVehicleDoorShut(Veh, 3, false)
                                SetVehicleDoorShut(Veh, 4, false)
                                SetVehicleDoorShut(Veh, 5, false)
                            else
                                SetVehicleDoorOpen(Veh, 0, false, false)
                                SetVehicleDoorOpen(Veh, 1, false, false)
                                SetVehicleDoorOpen(Veh, 2, false, false)
                                SetVehicleDoorOpen(Veh, 3, false, false)
                                SetVehicleDoorOpen(Veh, 4, false, false)
                                SetVehicleDoorOpen(Veh, 5, false, false)
                            end
                        end
                    end
                end
            end
            FixVeh.Activated = function(ParentMenu, SelectedItem)
                local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if Vehicle ~= nil and Vehicle ~= 0 then
                    SetVehicleEngineHealth(Vehicle, 100)
                    SetVehicleFixed(Vehicle)
                    Notify('~g~Vehicle Repaired!')
                else
                    Notify('~r~You\'re not in a Vehicle!')
                end

            end
            CleanVeh.Activated = function(ParentMenu, SelectedItem)
                local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if Vehicle ~= nil and Vehicle ~= 0 then
                    SetVehicleDirtLevel(Vehicle, 0)
                    Notify('~g~Vehicle Cleaned!')
                else
                    Notify('~r~You\'re not in a Vehicle!')
                end
            end
            DelVeh.Activated = function(ParentMenu, SelectedItem)
                if (IsPedSittingInAnyVehicle(PlayerPedId())) then 
                    local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

                    if (GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId()) then 
                        SetEntityAsMissionEntity(Vehicle, true, true)
                        DeleteVehicle(Vehicle)

                        if (DoesEntityExist(Vehicle)) then 
                            Notify('~o~Unable to delete vehicle, try again.')
                        else 
                            Notify('~r~Vehicle Deleted!')
                        end 
                    else 
                        Notify('~r~You must be in the driver\'s seat!')
                    end 
                else
                    Notify('~r~You\'re not in a Vehicle!')
                end
            end
    end



        

    if EmoteRestrict() then
        local EmotesList = {}
        for _, Emote in pairs(Config.EmotesList) do
            table.insert(EmotesList, Emote.name)
        end

        local EmotesMenu = NativeUI.CreateListItem('Emotes', EmotesList, 1, 'General RP Emotes')
        MainMenu:AddItem(EmotesMenu)
            
            MainMenu.OnListSelect = function(sender, item, index)
                if item == EmotesMenu then
                    for _, Emote in pairs(Config.EmotesList) do
                        if Emote.name == item:IndexToItem(index) then
                            PlayEmote(Emote.emote, Emote.name)
                        end
                    end
                end
            end
    end
        


    _MenuPool:RefreshIndex()
end



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		_MenuPool:ProcessMenus()	
		_MenuPool:ControlDisablingEnabled(false)
		_MenuPool:MouseControlsEnabled(false)
		
		if IsControlJustPressed(1, Config.MenuButton) and GetLastInputMethod(2) then
			if not menuOpen then
				Menu()
                MainMenu:Visible(true)
            else
                _MenuPool:CloseAllMenus()
			end
		end
	end
end)



RegisterCommand(Config.Command, function(source, args, rawCommands)
    if Config.OpenMenu == 1 then
        Menu()
        MainMenu:Visible(true)
    end
end)

Citizen.CreateThread(function()
    if Config.OpenMenu == 1 then
        TriggerEvent('chat:addSuggestion', '/' .. Config.Command, 'Used to open InteractionMenu')
    end
end)
