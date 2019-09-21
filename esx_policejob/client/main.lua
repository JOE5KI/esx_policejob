
-- Tenthsin Version 

local Keys = {
["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData = {}
local HasAlreadyEnteredMarker = false
local LastStation, LastPart, LastPartNum, LastEntity
local CurrentAction = nil
local CurrentActionMsg  = ''
local CurrentActionData = {}
local IsHandcuffed = false
local IsShackles = false
local HandcuffTimer = {}
local DragStatus = {}
DragStatus.IsDragged = false
local hasAlreadyJoined = false
local isDead = false
local CurrentTask = {}
local playerInService = false
local spawnedVehicles, isInShopMenu = {}, false
local ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[job].male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

			if job == 'recruit_wear' or job == 'officer_wear' or job == 'sergeant_wear' or job == 'intendent_wear' or job == 'lieutenant_wear' or job == 'chef_wear' or job == 'boss_wear' then --if job == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		else
			if Config.Uniforms[job].female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

			if job == 'recruit_wear' or job == 'officer_wear' or job == 'sergeant_wear' or job == 'intendent_wear' or job == 'lieutenant_wear' or job == 'chef_wear' or job == 'boss_wear' then --if job == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		end
	end)
end

function OpenCloakroomMenu()
	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name

	local elements = {}

	if grade ~= 'recruit' then
		table.insert(elements, { label = _U('pharmacy_take', _U('medikit')), value = 'medikit' })
		table.insert(elements, { label = _U('pharmacy_take', _U('bandage')), value = 'bandage' })
	end

	table.insert(elements, { label = 'Replenish Armor', value = 'armour' })
	table.insert(elements, { label = _U('citizen_wear'), value = 'citizen_wear' })
	--table.insert(elements, { label = _U('bullet_wear'), value = 'bullet_wear' })
	--table.insert(elements, { label = _U('gilet_wear'), value = 'gilet_wear' })

	if grade == 'recruit' then
		table.insert(elements, {label = _U('police_wear'), value = 'recruit_wear'})
	elseif grade == 'officer' then
		table.insert(elements, {label = _U('police_wear'), value = 'officer_wear'})
	elseif grade == 'sergeant' then
		table.insert(elements, {label = _U('police_wear'), value = 'sergeant_wear'})
	elseif grade == 'intendent' then
		table.insert(elements, {label = _U('police_wear'), value = 'intendent_wear'})
	elseif grade == 'lieutenant' then
		table.insert(elements, {label = _U('police_wear'), value = 'lieutenant_wear'})
	elseif grade == 'chef' then
		table.insert(elements, {label = _U('police_wear'), value = 'chef_wear'})
	elseif grade == 'boss' then
		table.insert(elements, {label = _U('police_wear'), value = 'boss_wear'})
	end

	if Config.EnableNonFreemodePeds then
		table.insert(elements, {label = 'Sheriff wear', value = 'freemode_ped', maleModel = 's_m_y_sheriff_01', femaleModel = 's_f_y_sheriff_01'})
		table.insert(elements, {label = 'Police wear', value = 'freemode_ped', maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'})
		table.insert(elements, {label = 'Swat wear', value = 'freemode_ped', maleModel = 's_m_y_swat_01', femaleModel = 's_m_y_swat_01'})
	end

	--[[table.insert(elements, { -- EUP
		label = 'Police Outfits',
		value = 'police_outfits'
	})]]

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = _U('cloakroom'),
		align = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'medikit' then
			TriggerServerEvent('esx_policejob:giveItem', data.current.value)
		elseif data.current.value == 'bandage' then
			TriggerServerEvent('esx_policejob:giveItem', data.current.value)
		elseif data.current.value == 'citizen_wear' then
			cleanPlayer(playerPed)
			if Config.EnableNonFreemodePeds then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local isMale = skin.sex == 0

					TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
							TriggerEvent('esx:restoreLoadout')
						end)
					end)

				end)
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end
			if Config.MaxInService ~= -1 then

				ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
					if isInService then

						playerInService = false

						local notification = {
							title    = _U('service_anonunce'),
							subject  = '',
							msg      = _U('service_out_announce', GetPlayerName(PlayerId())),
							iconType = 1
						}

						TriggerServerEvent('esx_service:notifyAllInService', notification, 'police')
						TriggerServerEvent('esx_service:disableService', 'police')
						ESX.ShowNotification(_U('service_out'))
					end
				end, 'police')
			end
		--elseif data.current.value == 'police_outfits' then
		--	menu.close()
		--	TriggerEvent('eup-ui:openMenu')
		elseif data.current.value == 'armour' then
			SetPedArmour(playerPed, 100)
		end

		if Config.MaxInService ~= -1 and data.current.value ~= 'citizen_wear' then
			cleanPlayer(playerPed)
			local serviceOk = 'waiting'

			ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
				if not isInService then

					ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
						if not canTakeService then
							ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
						else

							serviceOk = true
							playerInService = true

							local notification = {
								title    = _U('service_anonunce'),
								subject  = '',
								msg      = _U('service_in_announce', GetPlayerName(PlayerId())),
								iconType = 1
							}
	
							TriggerServerEvent('esx_service:notifyAllInService', notification, 'police')
							ESX.ShowNotification(_U('service_in'))
						end
					end, 'police')

				else
					serviceOk = true
				end
			end, 'police')

			while type(serviceOk) == 'string' do
				Citizen.Wait(5)
			end

			-- if we couldn't enter service don't let the player get changed
			if not serviceOk then
				return
			end
		end

		if
			data.current.value == 'recruit_wear' or
			data.current.value == 'officer_wear' or
			data.current.value == 'sergeant_wear' or
			data.current.value == 'intendent_wear' or
			data.current.value == 'lieutenant_wear' or
			data.current.value == 'chef_wear' or
			data.current.value == 'boss_wear' or
			data.current.value == 'bullet_wear' or
			data.current.value == 'gilet_wear'
		then
			cleanPlayer(playerPed)
			setUniform(data.current.value, playerPed)
		end

		if data.current.value == 'freemode_ped' then
			cleanPlayer(playerPed)
			local modelHash = ''

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					modelHash = GetHashKey(data.current.maleModel)
				else
					modelHash = GetHashKey(data.current.femaleModel)
				end

				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)

					TriggerEvent('esx:restoreLoadout')
				end)
			end)

		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenArmoryMenu(station)
	local elements = {}

	if Config.EnableArmoryManagement then
		table.insert(elements, {label = 'Get Ammo', value = 'get_ammo'})
		table.insert(elements, {label = 'Get DNA and Ballistic Analyzers', value = 'get_analyzers'})
		table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
		if PlayerData.job.grade_name ~= 'recruit' then
			table.insert(elements, {label = _U('get_weapon'),     value = 'get_weapon'})
		end
		table.insert(elements, {label = _U('put_weapon'),     value = 'put_weapon'})
		if PlayerData.job.grade_name ~= 'recruit' then
			table.insert(elements, {label = _U('remove_object'),  value = 'get_stock'})
		end
		table.insert(elements, {label = _U('deposit_object'), value = 'put_stock'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory',
	{
		title    = _U('armory'),
		align = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'get_weapon' and PlayerData.job.grade_name ~= 'recruit' then
			OpenGetWeaponMenu()
		elseif data.current.value == 'put_weapon' then
			OpenPutWeaponMenu()
		elseif data.current.value == 'get_ammo' then
			ESX.TriggerServerCallback('esx_policejob:buyAmmo', function(bought)
				if bought then
					ESX.TopicNotification("Added ammo to inventory.", "policearmoury")
				else
					PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
				end
			end, zone)
		elseif data.current.value == 'get_analyzers' then
			TriggerServerEvent('esx_policejob:getAnalyzers')
		elseif data.current.value == 'buy_weapons' then
			OpenBuyWeaponsMenu()
		elseif data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' and PlayerData.job.grade_name ~= 'recruit' then
			OpenGetStocksMenu()
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	end)
end

function OpenVehicleSpawnerMenu(type, station, part, partNum)
	local playerCoords = GetEntityCoords(PlayerPedId())
	ESX.ASyncPlayerData()
	PlayerData = ESX.GetPlayerData()
	local elements = {
		{label = _U('garage_storeditem'), action = 'garage'},
		{label = _U('garage_storeitem'), action = 'store_garage'},
		{label = _U('garage_buyitem'), action = 'buy_vehicle'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle', {
		title    = _U('garage_title'),
		align = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.action == 'buy_vehicle' then
			local shopElements, shopCoords = {}
			if type == 'car' then
				shopCoords = Config.PoliceStations[station].Vehicles[partNum].InsideShop
				local authorizedVehicles = Config.AuthorizedVehicles[PlayerData.job.grade_name]

				if #Config.AuthorizedVehicles['shared'] > 0 then
					for k,vehicle in ipairs(Config.AuthorizedVehicles['shared']) do
						local vehicleLabel = ESX.GetVehicleNameByHashName(vehicle.model)
						table.insert(shopElements, {
							label = vehicleLabel,
							model = vehicle.model,
							type  = 'car'
						})
					end
				end

				if #authorizedVehicles > 0 then
					for k,vehicle in ipairs(authorizedVehicles) do
						local vehicleLabel = ESX.GetVehicleNameByHashName(vehicle.model)
						table.insert(shopElements, {
							label = vehicleLabel,
							model = vehicle.model,
							type  = 'car'
						})
					end
				else
					if #Config.AuthorizedVehicles['shared'] == 0 then
						return
					end
				end
			elseif type == 'helicopter' then
				shopCoords = Config.PoliceStations[station].Helicopters[partNum].InsideShop
				local authorizedHelicopters = Config.AuthorizedHelicopters[PlayerData.job.grade_name]

				if #authorizedHelicopters > 0 then
					for k,vehicle in ipairs(authorizedHelicopters) do
						local vehicleLabel = ESX.GetVehicleNameByHashName(vehicle.model)
						table.insert(shopElements, {
							label = vehicleLabel,
							model = vehicle.model,
							livery = vehicle.livery or nil,
							type  = 'helicopter'
						})
					end
				else
					ESX.ShowNotification(_U('helicopter_notauthorized'))
					return
				end
			end
			OpenShopMenu(shopElements, playerCoords, shopCoords)
		elseif data.current.action == 'garage' then
			local garage = {}
			ESX.TriggerServerCallback('esx_vehicleshop:retrieveJobVehicles', function(jobVehicles)
				if #jobVehicles > 0 then
					for k,v in ipairs(jobVehicles) do
						local props = json.decode(v.vehicle)
						local vehicleName = ESX.GetVehicleNameByHashId(props.model)
						local label = ('%s - <span style="color:darkgoldenrod;">%s</span>: '):format(vehicleName, props.plate)
						if v.stored then
							label = label .. ('<span style="color:green;">%s</span>'):format(_U('garage_stored'))
						else
							label = label .. ('<span style="color:darkred;">%s</span>'):format(_U('garage_notstored'))
						end
						table.insert(garage, {
							label = label,
							stored = v.stored,
							model = props.model,
							vehicleProps = props
						})
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_garage', {
						title    = _U('garage_title'),
						align = 'bottom-right',
						elements = garage
					}, function(data2, menu2)
						if data2.current.stored then
							local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(station, part, partNum)
							if foundSpawn then
								menu2.close()
								ESX.Game.SpawnVehicle(data2.current.model, spawnPoint.coords, spawnPoint.heading, function(vehicle)
									ESX.Game.SetVehicleProperties(vehicle, data2.current.vehicleProps)
									TriggerServerEvent('esx_vehicleshop:setJobVehicleState', data2.current.vehicleProps.plate, false)
									ESX.ShowNotification(_U('garage_released'))
									
									local playerPed = PlayerPedId()
									TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
									menu2.close()
									menu.close()
								end)
							end
						else
							ESX.ShowNotification(_U('garage_notavailable'))
						end
					end, function(data2, menu2)
						menu2.close()
					end)

				else
					ESX.ShowNotification(_U('garage_empty'))
				end
			end, type)

		elseif data.current.action == 'store_garage' then

			local playerPed = PlayerPedId()

			if IsPedInAnyVehicle(playerPed, false) then
				ESX.ShowNotification('Please park the vehicle first.')
			else
				StoreNearbyVehicle(playerCoords)
			end

			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function StoreNearbyVehicle(playerCoords)
	local vehicles, vehiclePlates = ESX.Game.GetVehiclesInArea(playerCoords, 300.0), {}

	if #vehicles > 0 then
		for k,v in ipairs(vehicles) do
			-- Make sure the vehicle we're saving is empty, or else it wont be deleted
			if GetVehicleNumberOfPassengers(v) == 0 and IsVehicleSeatFree(v, -1) then
				table.insert(vehiclePlates, {
					vehicle = v,
					plate = ESX.Math.Trim(GetVehicleNumberPlateText(v))
				})
			end
		end
	else
		ESX.ShowNotification(_U('garage_store_nearby'))
		return
	end

	ESX.TriggerServerCallback('esx_ambulancejob:storeNearbyVehicle', function(storeSuccess, ownedPlates)
		if storeSuccess then
			local vehicleId = vehiclePlates[foundNum]
			local attempts = 0
			IsBusy = true

			Citizen.CreateThread(function()
				while IsBusy do
					Citizen.Wait(0)
					drawLoadingText(_U('garage_storing'), 255, 255, 255, 255)
				end
			end)

			for j=1, #ownedPlates, 1 do
				local ownedPlate = ownedPlates[j]
				for k=1, #vehiclePlates, 1 do
					if vehiclePlates[k].plate == ownedPlate then

						local theVeh = vehiclePlates[k].vehicle
						ESX.Game.DeleteVehicle(theVeh)

						while DoesEntityExist(theVeh) do
							Citizen.Wait(500)
							attempts = attempts + 1
							if attempts > 30 then
								break
							end
							vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 300.0)
							if #vehicles > 0 then
								for k,v in ipairs(vehicles) do
									if ESX.Math.Trim(GetVehicleNumberPlateText(v)) == vehiclePlates[k].plate then
										ESX.Game.DeleteVehicle(v)
										break
									end
								end
							end
						end

					end
				end
			end

			IsBusy = false

			ESX.ShowNotification(_U('garage_has_stored'))
		else
			ESX.ShowNotification(_U('garage_has_notstored'))
		end
	end, vehiclePlates)
end

function GetAvailableVehicleSpawnPoint(station, part, partNum)
	local spawnPoints = Config.PoliceStations[station][part][partNum].SpawnPoints
	local found, foundSpawnPoint = false, nil

	for i=1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
			found, foundSpawnPoint = true, spawnPoints[i]
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		ESX.ShowNotification(_U('vehicle_blocked'))
		return false
	end
end

function OpenShopMenu(elements, restoreCoords, shopCoords)
	local playerPed = PlayerPedId()
	TriggerEvent("rrp_vehremover:pauseVehicleRemoval")
	isInShopMenu = true

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title    = _U('vehicleshop_title'),
		align = 'bottom-right',
		elements = elements
	}, function(data, menu)
		local newPlate = exports['esx_vehicleshop']:GeneratePlate()
		local vehicle  = GetVehiclePedIsIn(playerPed, false)
		local props    = ESX.Game.GetVehicleProperties(vehicle)
		props.plate    = newPlate

		ESX.TriggerServerCallback('esx_policejob:buyJobVehicle', function (bought)
			if bought then
				ESX.ShowNotification(_U('vehicleshop_bought'))
				TriggerEvent("rrp_vehremover:resumeVehicleRemoval")
				isInShopMenu = false
				ESX.UI.Menu.CloseAll()
				DeleteSpawnedVehicles()
				FreezeEntityPosition(playerPed, false)
				SetEntityVisible(playerPed, true)
				ESX.Game.Teleport(playerPed, restoreCoords)
			else
				ESX.ShowNotification(_U('vehicleshop_money'))
				menu2.close()
			end
		end, props, data.current.type)
	end, function(data, menu)
		TriggerEvent("rrp_vehremover:resumeVehicleRemoval")
		isInShopMenu = false
		ESX.UI.Menu.CloseAll()
		DeleteSpawnedVehicles()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)

		ESX.Game.Teleport(playerPed, restoreCoords)
	end, function(data, menu)
		DeleteSpawnedVehicles()

		WaitForVehicleToLoad(data.current.model)
		ESX.Game.SpawnLocalVehicle(
			data.current.model,
			shopCoords,
			0.0,
			function(vehicle)
				table.insert(spawnedVehicles, vehicle)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				FreezeEntityPosition(vehicle, true)

				if data.current.livery then
					ESX.Game.RequestNetControl(vehicle)
					SetVehicleModKit(vehicle, 0)
					SetVehicleLivery(vehicle, data.current.livery)
				end
			end)
	end)

	WaitForVehicleToLoad(elements[1].model)
	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)
		table.insert(spawnedVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)

		if elements[1].livery then
			ESX.Game.RequestNetControl(vehicle)
			SetVehicleModKit(vehicle, 0)
			SetVehicleLivery(vehicle,elements[1].livery)
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isInShopMenu then
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

function DeleteSpawnedVehicles()
	while #spawnedVehicles > 0 do
		local vehicle = spawnedVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(spawnedVehicles, 1)
	end
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)

			DisableControlAction(0, Keys['TOP'], true)
			DisableControlAction(0, Keys['DOWN'], true)
			DisableControlAction(0, Keys['LEFT'], true)
			DisableControlAction(0, Keys['RIGHT'], true)
			DisableControlAction(0, 176, true) -- ENTER key
			DisableControlAction(0, Keys['BACKSPACE'], true)

			drawLoadingText(_U('vehicleshop_awaiting_model'), 255, 255, 255, 255)
		end
	end
end

function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end

function OpenPoliceActionsMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions',
	{
		title    = 'Police',
		align = 'bottom-right',
		elements = {
			{label = _U('citizen_interaction'),	value = 'citizen_interaction'},
			{label = _U('vehicle_interaction'),	value = 'vehicle_interaction'},
			{label = _U('object_spawner'),		value = 'object_spawner'},
			{label = "Jail Menu",               value = 'jail_menu'},
			{label = "Community Service",	value = 'communityservice'}
		}
	}, function(data, menu)
		if data.current.value == 'jail_menu' then
			TriggerEvent("esx-qalle-jail:openJailMenu")
		elseif data.current.value == 'communityservice' then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			SendToCommunityService(GetPlayerServerId(closestPlayer))
		elseif data.current.value == 'citizen_interaction' then
			local elements = {
				{label = _U('softcuff'), value = 'softcuff'},
				{label = _U('hardcuff'), value = 'hardcuff'},
				{label = _U('uncuff'), value = 'uncuff'},
				{label = _U('escort'),			value = 'escort'},
				{label = _U('id_card'),			value = 'identity_card'},
				{label = _U('search'),			value = 'body_search'},
				{label = _U('revive'),			value = 'revive'},
				{label = _U('heal_small'),		value = 'heal'},
				{label = _U('put_in_vehicle'),	value = 'put_in_vehicle'},
				{label = _U('out_the_vehicle'),	value = 'out_the_vehicle'},
				{label = _U('fine'),			value = 'fine'},
				{label = _U('unpaid_bills'),	value = 'unpaid_bills'},
				{label = 'Criminal Records',  	value = 'criminalrecords'}
			}

			if Config.EnableLicenses then
				table.insert(elements, { label = _U('license_check'), value = 'license' })
			end

			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'citizen_interaction',
			{
				title    = _U('citizen_interaction'),
				align = 'bottom-right',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 10.0 then
					local action = data2.current.value

					if action == 'identity_card' then
						OpenIdentityCardMenu(closestPlayer)
					elseif action == 'body_search' then
						TriggerServerEvent('esx_policejob:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
						OpenBodySearchMenu(closestPlayer)
					elseif action == 'revive' then
						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								if IsPedDeadOrDying(closestPlayerPed, 1) then
									local playerPed = PlayerPedId()
									ESX.ShowNotification(_U('revive_inprogress'))
									local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
									for i=1, 15, 1 do
										Citizen.Wait(900)
										ESX.Streaming.RequestAnimDict(lib, function()
											TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
										end)
									end
									TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
									TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
									ESX.ShowNotification(_U('revive_complete', GetPlayerName(closestPlayer)))
								else
									ESX.ShowNotification(_U('player_not_unconscious'))
								end
							else
								ESX.ShowNotification(_U('not_enough_medikit'))
							end
						end, 'medikit')
					elseif action == 'heal' then
						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local playerPed = PlayerPedId()

									IsBusy = true
									ESX.ShowNotification(_U('heal_inprogress'))
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
									ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
									IsBusy = false
								else
									ESX.ShowNotification(_U('player_not_conscious'))
								end
							else
								ESX.ShowNotification(_U('not_enough_bandage'))
							end
						end, 'bandage')
					elseif action == 'softcuff' then
						local target, distance = ESX.Game.GetClosestPlayer()
						playerheading = GetEntityHeading(GetPlayerPed(-1))
						playerlocation = GetEntityForwardVector(PlayerPedId())
						playerCoords = GetEntityCoords(GetPlayerPed(-1))
						local target_id = GetPlayerServerId(target)
						if distance <= 3.0 then
							TriggerServerEvent('esx_policejob:requestarrest', target_id, playerheading, playerCoords, playerlocation)
						else
							ESX.ShowNotification('Not close enough to cuff.')
						end
					elseif action == 'hardcuff' then
						local target, distance = ESX.Game.GetClosestPlayer()
						playerheading = GetEntityHeading(GetPlayerPed(-1))
						playerlocation = GetEntityForwardVector(PlayerPedId())
						playerCoords = GetEntityCoords(GetPlayerPed(-1))
						local target_id = GetPlayerServerId(target)
						if distance <= 3.0 then
							TriggerServerEvent('esx_policejob:requesthard', target_id, playerheading, playerCoords, playerlocation)
						else
							ESX.ShowNotification('Not close enough to cuff.')
						end
					elseif action == 'uncuff' then
						local target, distance = ESX.Game.GetClosestPlayer()
						playerheading = GetEntityHeading(GetPlayerPed(-1))
						playerlocation = GetEntityForwardVector(PlayerPedId())
						playerCoords = GetEntityCoords(GetPlayerPed(-1))
						local target_id = GetPlayerServerId(target)
						if distance <= 3.0 then
							TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
						else
							ESX.ShowNotification('Not close enough to uncuff.')
						end
					elseif action == 'escort' then
						TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
						ESX.SetTimeout(1000, function()
							local target, distance = ESX.Game.GetClosestPlayer()
							playerheading = GetEntityHeading(GetPlayerPed(-1))
							playerlocation = GetEntityForwardVector(PlayerPedId())
							playerCoords = GetEntityCoords(GetPlayerPed(-1))
							local target_id = GetPlayerServerId(target)
							if distance <= 5.0 then
								TriggerServerEvent('esx_policejob:requestarrest', target_id, playerheading, playerCoords, playerlocation)
							else
								ESX.ShowNotification('Not close enough to cuff.')
							end
						end)
					elseif action == 'fine' then
						OpenFineMenu(closestPlayer)
					elseif action == 'license' then
						ShowPlayerLicense(closestPlayer)
					elseif action == 'unpaid_bills' then
						OpenUnpaidBillsMenu(closestPlayer)
					elseif action == 'criminalrecords' then
						OpenCriminalRecords(closestPlayer)
					end

				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'vehicle_interaction' then
			local elements  = {}
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			local vehicle = ESX.Game.GetVehicleFullCheck()

			if DoesEntityExist(vehicle) then
				table.insert(elements, {label = _U('vehicle_info'),	value = 'vehicle_infos'})
				table.insert(elements, {label = _U('pick_lock'),	value = 'hijack_vehicle'})
				table.insert(elements, {label = _U('impound'),		value = 'impound'})
			end
			table.insert(elements, {label = _U('search_database'), value = 'search_database'})
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'vehicle_interaction',
			{
				title    = _U('vehicle_interaction'),
				align = 'bottom-right',
				elements = elements
			}, function(data2, menu2)
				coords  = GetEntityCoords(playerPed)
				local vehicle = ESX.Game.GetVehicleFullCheck()

				if data2.current.value == 'search_database' then
					LookupVehicle()
				elseif DoesEntityExist(vehicle) then
					local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
					if data2.current.value == 'vehicle_infos' then
						OpenVehicleInfosMenu(vehicleData)
					elseif data2.current.value == 'hijack_vehicle' then
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
							TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
							Citizen.Wait(20000)
							ClearPedTasksImmediately(playerPed)

							ESX.Game.RequestNetControl(vehicle)

							SetVehicleDoorsLocked(vehicle, 1)
							SetVehicleDoorsLockedForAllPlayers(vehicle, false)
							ESX.ShowNotification(_U('vehicle_unlocked'))
						end
					elseif data2.current.value == 'impound' then
						-- is the script busy?
						if CurrentTask.Busy then
							return
						end

						menu2.close()
						ESX.ShowHelpNotification(_U('impound_prompt'))
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

						CurrentTask.Busy = true
						CurrentTask.Task = ESX.SetTimeout(10000, function()
							ClearPedTasks(playerPed)
							ImpoundVehicle(vehicle)
							Citizen.Wait(100) -- sleep the entire script to let stuff sink back to reality
						end)

						-- keep track of that vehicle!
						Citizen.CreateThread(function()
							while CurrentTask.Busy do
								Citizen.Wait(1000)
								local vehicle = ESX.Game.GetVehicleFullCheck()
								if not DoesEntityExist(vehicle) and CurrentTask.Busy then
									ESX.ShowNotification(_U('impound_canceled_moved'))
									ESX.ClearTimeout(CurrentTask.Task)
									ClearPedTasks(playerPed)
									CurrentTask.Busy = false
									break
								end
							end
						end)
					end
				else
					ESX.ShowNotification(_U('no_vehicles_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'object_spawner' then
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'citizen_interaction',
			{
				title    = _U('traffic_interaction'),
				align = 'bottom-right',
				elements = {
					{label = _U('cone'),		value = 'prop_roadcone02a'},
					{label = _U('barrier'),		value = 'prop_barrier_work05'},
					{label = _U('spikestrips'),	value = 'p_ld_stinger_s'},
					{label = _U('box'),			value = 'prop_boxpile_07d'},
					{label = _U('cash'),		value = 'hei_prop_cash_crate_half_full'}
				}
			}, function(data2, menu2)
				local model     = data2.current.value
				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				local forward   = GetEntityForwardVector(playerPed)
				local x, y, z   = table.unpack(coords + forward * 1.0)

				if model == 'prop_roadcone02a' then
					z = z - 2.0
				end

				ESX.Game.SpawnObject(model, {
					x = x,
					y = y,
					z = z
				}, function(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))
					PlaceObjectOnGroundProperly(obj)
				end)

			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end



RegisterCommand("cuff", function(source, args, raw)
	if PlayerData.job.name == 'police' then
		local target, distance = ESX.Game.GetClosestPlayer()
		playerheading = GetEntityHeading(GetPlayerPed(-1))
		playerlocation = GetEntityForwardVector(PlayerPedId())
		playerCoords = GetEntityCoords(GetPlayerPed(-1))
		local target_id = GetPlayerServerId(target)
		if distance <= 3.0 then
			TriggerServerEvent('esx_policejob:requesthard', target_id, playerheading, playerCoords, playerlocation)
		else
			ESX.ShowNotification('Not close enough to cuff.')
		end
	end
end, false)

RegisterCommand("loosen", function(source, args, raw)
	if PlayerData.job.name == 'police' then
		local target, distance = ESX.Game.GetClosestPlayer()
		playerheading = GetEntityHeading(GetPlayerPed(-1))
		playerlocation = GetEntityForwardVector(PlayerPedId())
		playerCoords = GetEntityCoords(GetPlayerPed(-1))
		local target_id = GetPlayerServerId(target)
		if distance <= 3.0 then
			TriggerServerEvent('esx_policejob:sc', target_id, playerheading, playerCoords, playerlocation)
		else
			ESX.ShowNotification('Not close enough to uncuff.')
		end
	end
end, false)

RegisterCommand("uncuff", function(source, args, raw)
	if PlayerData.job.name == 'police' then
		local target, distance = ESX.Game.GetClosestPlayer()
		playerheading = GetEntityHeading(GetPlayerPed(-1))
		playerlocation = GetEntityForwardVector(PlayerPedId())
		playerCoords = GetEntityCoords(GetPlayerPed(-1))
		local target_id = GetPlayerServerId(target)
		if distance <= 3.0 then
			TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
		else
			ESX.ShowNotification('Not close enough to uncuff.')
		end
	end
end, false)

RegisterCommand("escort", function(source, args, raw)
	if PlayerData.job.name == 'police' then
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		if closestPlayer ~= -1 and closestDistance <= 10.0 then
			TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
		end
	else
		ESX.TopicNotification("You must be a police officer.", "mustbepolice")
	end
end, false)

function OpenIdentityCardMenu(player)

	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

		local elements    = {}
		local nameLabel   = _U('name', data.name)
		local jobLabel    = nil
		local sexLabel    = nil
		local dobLabel    = nil
		local heightLabel = nil
		local idLabel     = nil
	
		if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
			jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
		else
			jobLabel = _U('job', data.job.label)
		end
	
		if Config.EnableESXIdentity then
	
			nameLabel = _U('name', data.firstname .. ' ' .. data.lastname)
	
			if data.sex ~= nil then
				if string.lower(data.sex) == 'm' then
					sexLabel = _U('sex', _U('male'))
				else
					sexLabel = _U('sex', _U('female'))
				end
			else
				sexLabel = _U('sex', _U('unknown'))
			end
	
			if data.dob ~= nil then
				dobLabel = _U('dob', data.dob)
			else
				dobLabel = _U('dob', _U('unknown'))
			end
	
			if data.height ~= nil then
				heightLabel = _U('height', data.height)
			else
				heightLabel = _U('height', _U('unknown'))
			end
	
			if data.name ~= nil then
				idLabel = _U('id', data.name)
			else
				idLabel = _U('id', _U('unknown'))
			end
	
		end
	
		local elements = {
			{label = nameLabel, value = nil},
			{label = jobLabel,  value = nil},
		}
	
		if Config.EnableESXIdentity then
			table.insert(elements, {label = sexLabel, value = nil})
			table.insert(elements, {label = dobLabel, value = nil})
			table.insert(elements, {label = heightLabel, value = nil})
			table.insert(elements, {label = idLabel, value = nil})
		end
	
		if data.drunk ~= nil then
			table.insert(elements, {label = _U('bac', data.drunk), value = nil})
		end
	
		if data.licenses ~= nil then
	
			table.insert(elements, {label = _U('license_label'), value = nil})
	
			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label, value = nil})
			end
	
		end
	
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
		{
			title    = _U('citizen_interaction'),
			align = 'bottom-right',
			elements = elements,
		}, function(data, menu)
	
		end, function(data, menu)
			menu.close()
		end)
	
	end, GetPlayerServerId(player))

end

function OpenBodySearchMenu(player)
	TriggerEvent("esx_inventoryhud:openPlayerInventory", GetPlayerServerId(player), GetPlayerName(player), true, true)
end

function OpenBodySearchMenuOld(player)

	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)

		local elements = {}

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
				table.insert(elements, {
					label    = _U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})
				break
			end
		end

		table.insert(elements, {label = _U('guns_label'), value = nil})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end

		table.insert(elements, {label = _U('inventory_label'), value = nil})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search',
		{
			title    = _U('search'),
			align = 'bottom-right',
			elements = elements,
		},
		function(data, menu)

			local itemType = data.current.itemType
			local itemName = data.current.value
			local amount   = data.current.amount

			if data.current.value ~= nil then
				TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)
				OpenBodySearchMenu(player)
			end

		end, function(data, menu)
			menu.close()
		end)

	end, GetPlayerServerId(player))

end

function OpenFineMenu(player)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'Fine Menu Reason', {
		title = "Fine Reason?",
	}, function (data2, menu2)
		local label = data2.value
		menu2.close()
		if string.len(label) > 0 then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'Fine Menu Amount', {
				title = "Fine Amount?",
			}, function (data3, menu3)
				local amount = tonumber(data3.value)
				menu3.close()
				if amount > 0 then
					if Config.EnablePlayerManagement then
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', _U('fine_total', label), amount)
					else
						TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', _U('fine_total', label), amount)
					end
				else
					menu3.close()
					ESX.ShowNotification('Invalid amount.')
				end
			end, function (data3, menu3)
				menu3.close()
			end)
		else
			menu2.close()
			ESX.ShowNotification('Invalid reason.')
		end
	end, function (data2, menu2)
		menu2.close()
	end)
end

function LookupVehicle()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle',
	{
		title = _U('search_database_title'),
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 2 or length > 13 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('esx_policejob:getVehicleFromPlate', function(owner, found)
				if found then
					ESX.ShowNotification(_U('search_database_found', owner))
				else
					ESX.ShowNotification(_U('search_database_error_not_found'))
				end
			end, data.value)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function ShowPlayerLicense(player)
	local elements = {}
	local targetName
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		if data.licenses then
			for i=1, #data.licenses, 1 do
				if data.licenses[i].label and data.licenses[i].type then
					table.insert(elements, {
						label = data.licenses[i].label,
						type = data.licenses[i].type
					})
				end
			end
		end
		
		if Config.EnableESXIdentity then
			targetName = data.firstname .. ' ' .. data.lastname
		else
			targetName = data.name
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license',
		{
			title    = _U('license_revoke'),
			align = 'bottom-right',
			elements = elements,
		}, function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, targetName))
			TriggerServerEvent('esx_policejob:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))
			
			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.type)
			
			ESX.SetTimeout(300, function()
				ShowPlayerLicense(player)
			end)
		end, function(data, menu)
			menu.close()
		end)

	end, GetPlayerServerId(player))
end

function OpenUnpaidBillsMenu(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
		for i=1, #bills, 1 do
			table.insert(elements, {
				label = bills[i].label .. ' - <span style="color: red;">$' .. bills[i].amount .. '</span>',
				value = bills[i].id
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing',
		{
			title    = _U('unpaid_bills'),
			align = 'bottom-right',
			elements = elements
		}, function(data, menu)
	
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenVehicleInfosMenu(vehicleData)

	ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(retrivedInfo)

		local elements = {}

		table.insert(elements, {label = _U('plate', retrivedInfo.plate), value = nil})

		if retrivedInfo.owner == nil then
			table.insert(elements, {label = _U('owner_unknown'), value = nil})
		else
			table.insert(elements, {label = _U('owner', retrivedInfo.owner), value = nil})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos',
		{
			title    = _U('vehicle_info'),
			align = 'bottom-right',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)

	end, vehicleData.plate)

end

function OpenGetWeaponMenu()

	ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
					value = weapons[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon',
		{
			title    = _U('get_weapon_menu'),
			align = 'bottom-right',
			elements = elements
		}, function(data, menu)

			menu.close()

			ESX.TriggerServerCallback('esx_policejob:removeArmoryWeapon', function()
				OpenGetWeaponMenu()
			end, data.current.value)

		end, function(data, menu)
			menu.close()
		end)
	end)

end

function OpenPutWeaponMenu()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label,
				value = weaponList[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon',
	{
		title    = _U('put_weapon_menu'),
		align = 'bottom-right',
		elements = elements
	}, function(data, menu)

		menu.close()

		ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value, true)

	end, function(data, menu)
		menu.close()
	end)
end

function OpenBuyWeaponsMenu()

	local elements = {}
	local playerPed = PlayerPedId()
	ESX.ASyncPlayerData()
	PlayerData = ESX.GetPlayerData()

	for k,v in ipairs(Config.AuthorizedWeapons[PlayerData.job.grade_name]) do
		local weaponNum, weapon = ESX.GetWeapon(v.weapon)
		local components, label = {}

		local hasWeapon = HasPedGotWeapon(playerPed, GetHashKey(v.weapon), false)

		if v.components then
			for i=1, #v.components do
				if v.components[i] then

					local component = weapon.components[i]
					local hasComponent = HasPedGotWeaponComponent(playerPed, GetHashKey(v.weapon), component.hash)

					if hasComponent then
						label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_owned'))
					else
						if v.components[i] > 0 then
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_item', ESX.Math.GroupDigits(v.components[i])))
						else
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_free'))
						end
					end

					table.insert(components, {
						label = label,
						componentLabel = component.label,
						hash = component.hash,
						name = component.name,
						price = v.components[i],
						hasComponent = hasComponent,
						componentNum = i
					})
				end
			end
		end

		if hasWeapon and v.components then
			label = ('%s: <span style="color:green;">></span>'):format(weapon.label)
		elseif hasWeapon and not v.components then
			label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_owned'))
		else
			if v.price > 0 then
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_item', ESX.Math.GroupDigits(v.price)))
			else
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_free'))
			end
		end

		table.insert(elements, {
			label = label,
			weaponLabel = weapon.label,
			name = weapon.name,
			components = components,
			price = v.price,
			hasWeapon = hasWeapon
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons', {
		title    = _U('armory_weapontitle'),
		align = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.hasWeapon then
			if #data.current.components > 0 then
				OpenWeaponComponentShop(data.current.components, data.current.name, menu)
			end
		else
			ESX.TriggerServerCallback('esx_policejob:buyWeapon', function(bought)
				if bought then
					if data.current.price > 0 then
						ESX.ShowNotification(_U('armory_bought', data.current.weaponLabel, ESX.Math.GroupDigits(data.current.price)))
					end
					menu.close()
					OpenBuyWeaponsMenu()
				else
					ESX.ShowNotification(_U('armory_money'))
				end
			end, data.current.name, 1)
		end

	end, function(data, menu)
		menu.close()
	end)

end

function OpenWeaponComponentShop(components, weaponName, parentShop)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons_components', {
		title    = _U('armory_componenttitle'),
		align = 'bottom-right',
		elements = components
	}, function(data, menu)

		if data.current.hasComponent then
			ESX.ShowNotification(_U('armory_hascomponent'))
		else
			ESX.TriggerServerCallback('esx_policejob:buyWeapon', function(bought)
				if bought then
					if data.current.price > 0 then
						ESX.ShowNotification(_U('armory_bought', data.current.componentLabel, ESX.Math.GroupDigits(data.current.price)))
					end

					menu.close()
					parentShop.close()

					OpenBuyWeaponsMenu()
				else
					ESX.ShowNotification(_U('armory_money'))
				end
			end, weaponName, 2, data.current.componentNum)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenu()

	ESX.TriggerServerCallback('esx_policejob:getStockItems', function(items)

		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = _U('police_stock'),
			align = 'bottom-right',
			elements = elements
		}, function(data, menu)

			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_policejob:getStockItem', itemName, count)

					Citizen.Wait(300)
					OpenGetStocksMenu()
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end)

end

function OpenPutStocksMenu()

	ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = _U('inventory'),
			align = 'bottom-right',
			elements = elements
		}, function(data, menu)

			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_policejob:putStockItems', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksMenu()
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)
	end)

end

function OpenCriminalRecords(closestPlayer)
    ESX.TriggerServerCallback('esx_qalle_brottsregister:grab', GetPlayerServerId(closestPlayer), function(crimes)
        local elements = {}
        table.insert(elements, {label = 'Add Crime To Player', value = 'crime'})
        table.insert(elements, {label = '----= Crimes =----', value = 'spacer'})
        for i=1, #crimes, 1 do
            table.insert(elements, {label = crimes[i].date .. ' - ' .. crimes[i].crime, value = crimes[i].crime, name = crimes[i].name})
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'brottsregister',
        {
            title    = 'Criminal Record',
            elements = elements
        },
        function(data2, menu2)
            if data2.current.value == 'crime' then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'brottsregister_second',
                {
                    title = 'Crime?'
                },
                function(data3, menu3)
                    local crime = (data3.value)
                    if crime == tonumber(data3.value) then
                        ESX.ShowNotification('Action Impossible')
                        menu3.close()
                    else
                        menu2.close()
                        menu3.close()
                        TriggerServerEvent('esx_qalle_brottsregister:add', GetPlayerServerId(closestPlayer), crime)
                        ESX.ShowNotification('Added to register!')
                        Citizen.Wait(100)
                        OpenCriminalRecords(closestPlayer)
                    end
                end,
                function(data3, menu3)
                    menu3.close()
                end)
            else
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_confirmation',
                {
                    title    = 'Remove?',
                    elements = {
                        {label = 'Yes', value = 'yes'},
                        {label = 'No', value = 'no'}
                    }
                },
                function(data3, menu3)
                    if data3.current.value == 'yes' then
                        menu2.close()
                        menu3.close()
                        TriggerServerEvent('esx_qalle_brottsregister:remove', GetPlayerServerId(closestPlayer), data2.current.value)
                        ESX.ShowNotification('Removed!')
                        Citizen.Wait(100)
                        OpenCriminalRecords(closestPlayer)
                    else
                        menu3.close()
                    end
                end,
                function(data3, menu3)
                    menu3.close()
                end)
            end
        end,
        function(data2, menu2)
            menu2.close()
        end)
    end)
end

AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)

	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}

	elseif part == 'Armory' then

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}

	elseif part == 'Vehicles' then

		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}

	elseif part == 'Helicopters' then

		CurrentAction     = 'Helicopters'
		CurrentActionMsg  = _U('helicopter_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}

	elseif part == 'BossActions' then

		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}

	end

end)

AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if PlayerData.job ~= nil and PlayerData.job.name == 'police' and IsPedOnFoot(playerPed) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('remove_prop')
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed)
			ESX.Game.RequestNetControl(vehicle)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end)

AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()
	local playerPed = PlayerPedId()
	Citizen.CreateThread(function()
		if IsHandcuffed then
			if Config.EnableHandcuffTimer then
				if HandcuffTimer.active then
					ESX.ClearTimeout(HandcuffTimer.task)
				end
				StartHandcuffTimer()
			end
		else
			if Config.EnableHandcuffTimer and HandcuffTimer.active then
				ESX.ClearTimeout(HandcuffTimer.task)
			end
		end
	end)
end)


RegisterNetEvent('esx_policejob:unrestrain')
AddEventHandler('esx_policejob:unrestrain', function()
	if IsHandcuffed then
		local playerPed = PlayerPedId()
		IsHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)

		-- end timer
		if Config.EnableHandcuffTimer and HandcuffTimer.active then
			ESX.ClearTimeout(HandcuffTimer.task)
		end
	end
end)



-- Shackles


RegisterNetEvent('esx_policejob:hardcuff')
AddEventHandler('esx_policejob:hardcuff', function()
	local playerPed = PlayerPedId()
	Citizen.CreateThread(function()
		if IsShackles then
			if Config.EnableHandcuffTimer then
				if HandcuffTimer.active then
					ESX.ClearTimeout(HandcuffTimer.task)
				end
				StartHandcuffTimer()
			end
		else
			if Config.EnableHandcuffTimer and HandcuffTimer.active then
				ESX.ClearTimeout(HandcuffTimer.task)
			end
		end
	end)
end)


RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(copID)
	if not IsHandcuffed then
		return
	end

	DragStatus.IsDragged = not DragStatus.IsDragged
	DragStatus.CopId     = tonumber(copID)
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		Citizen.Wait(1)

		if IsHandcuffed then
			playerPed = PlayerPedId()

			if DragStatus.IsDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))

				-- undrag if target is in an vehicle
				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					DragStatus.IsDragged = false
					DetachEntity(playerPed, true, false)
				end

				if IsPedDeadOrDying(targetPed, true) then
					DragStatus.IsDragged = false
					DetachEntity(playerPed, true, false)
				end

			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if not IsHandcuffed then
		return
	end

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				DragStatus.IsDragged = false
			end
		end
	end
end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end    
end

RegisterNetEvent('esx_policejob:getarrested')
AddEventHandler('esx_policejob:getarrested', function(playerheading, playercoords, playerlocation)
	playerPed = GetPlayerPed(-1)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	LoadAnimDict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	IsHandcuffed = true
	IsShackles = false
	TriggerEvent('esx_policejob:handcuff')
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
end)


RegisterNetEvent('esx_policejob:doarrested')
AddEventHandler('esx_policejob:doarrested', function()
	Citizen.Wait(250)
	LoadAnimDict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Citizen.Wait(3000)

end) 

RegisterNetEvent('esx_policejob:douncuffing')
AddEventHandler('esx_policejob:douncuffing', function()
	Citizen.Wait(250)
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('esx_policejob:getuncuffed')
AddEventHandler('esx_policejob:getuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	IsHandcuffed = false
	IsShackles = false
	TriggerEvent('esx_policejob:handcuff')
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('esx_policejob:loose')
AddEventHandler('esx_policejob:loose', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	IsHandcuffed = true
	IsShackles = false
	TriggerEvent('esx_policejob:handcuff')
	ClearPedTasks(GetPlayerPed(-1))
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if IsHandcuffed then
			--DisableControlAction(0, 1, true) -- Disable pan
			DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			--DisableControlAction(0, 32, true) -- W
			--DisableControlAction(0, 34, true) -- A
			--DisableControlAction(0, 31, true) -- S
			--DisableControlAction(0, 30, true) -- D

			DisableControlAction(0, 45, true) -- Reload
			--DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			DisableControlAction(0, 20, true) -- Z

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)


-- shackles
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if IsShackles then
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 31, true) -- S
			DisableControlAction(0, 30, true) -- D
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)


RegisterNetEvent('esx_policejob:getarrestedhard')
AddEventHandler('esx_policejob:getarrestedhard', function(playerheading, playercoords, playerlocation)
	playerPed = GetPlayerPed(-1)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	LoadAnimDict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	IsHandcuffed = true
	IsShackles = true
	TriggerEvent('esx_policejob:hardcuff')
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
end)



-- Create blips
Citizen.CreateThread(function()

	for k,v in pairs(Config.PoliceStations) do
		local blip = AddBlipForCoord(v.Blip.Coords)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, tonumber(GetConvar('blip_scale', '0.5')))
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('map_blip'))
		EndTextCommandSetBlipName(blip)
	end

end)

-- Display markers
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if PlayerData.job ~= nil and PlayerData.job.name == 'police' then

			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			local isInMarker, hasExited, letSleep = false, false, true
			local currentStation, currentPart, currentPartNum

			for k,v in pairs(Config.PoliceStations) do

				for i=1, #v.Cloakrooms, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.Cloakrooms[i], true)

					if distance < Config.DrawDistance then
						DrawMarker(20, v.Cloakrooms[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Cloakroom', i
					end
				end

				for i=1, #v.Armories, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.Armories[i], true)

					if distance < Config.DrawDistance then
						DrawMarker(21, v.Armories[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
					end
				end

				for i=1, #v.Vehicles, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner, true)

					if distance < Config.DrawDistance then
						DrawMarker(36, v.Vehicles[i].Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vehicles', i
					end
				end

				for i=1, #v.Helicopters, 1 do
					local distance =  GetDistanceBetweenCoords(coords, v.Helicopters[i].Spawner, true)

					if distance < Config.DrawDistance then
						DrawMarker(34, v.Helicopters[i].Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Helicopters', i
					end
				end

				if Config.EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
					for i=1, #v.BossActions, 1 do
						local distance = GetDistanceBetweenCoords(coords, v.BossActions[i], true)

						if distance < Config.DrawDistance then
							DrawMarker(22, v.BossActions[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
							letSleep = false
						end

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
						end
					end
				end
			end

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
	
				if
					(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)

			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end

			if letSleep then
				Citizen.Wait(500)
			end

		else
			Citizen.Wait(500)
		end

	end
end)

-- Enter / Exit entity zone events
Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_barrier_work05',
		'p_ld_stinger_s',
		'prop_boxpile_07d',
		'hei_prop_cash_crate_half_full'
	}

	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(coords, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance  = GetDistanceBetweenCoords(coords, objCoords, true)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 10.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('esx_policejob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity ~= nil then
				TriggerEvent('esx_policejob:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentAction ~= nil then
			if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
				ESX.ShowHelpNotification(CurrentActionMsg)
			end

			if IsControlJustReleased(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' then

				if CurrentAction == 'menu_cloakroom' then
					OpenCloakroomMenu()
				elseif CurrentAction == 'menu_armory' then
					if Config.MaxInService == -1 then
						OpenArmoryMenu(CurrentActionData.station)
					elseif playerInService then
						OpenArmoryMenu(CurrentActionData.station)
					else
						ESX.ShowNotification(_U('service_not'))
					end
				elseif CurrentAction == 'menu_vehicle_spawner' then
					if Config.MaxInService == -1 then
						OpenVehicleSpawnerMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
					elseif playerInService then
						OpenVehicleSpawnerMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
					else
						ESX.ShowNotification(_U('service_not'))
					end
				elseif CurrentAction == 'Helicopters' then
					if Config.MaxInService == -1 then
						OpenVehicleSpawnerMenu('helicopter', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
					elseif playerInService then
						OpenVehicleSpawnerMenu('helicopter', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
					else
						ESX.ShowNotification(_U('service_not'))
					end
				elseif CurrentAction == 'delete_vehicle' then
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				elseif CurrentAction == 'menu_boss_actions' then
					ESX.UI.Menu.CloseAll()
					TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)
						menu.close()

						CurrentAction     = 'menu_boss_actions'
						CurrentActionMsg  = _U('open_bossmenu')
						CurrentActionData = {}
					end, { wash = false }) -- disable washing money
				elseif CurrentAction == 'remove_entity' then
					
					ESX.Game.RequestNetControl(CurrentActionData.entity)
					
					DeleteEntity(CurrentActionData.entity)
				end
				
				CurrentAction = nil
			end
		end -- CurrentAction end
		
		if IsControlJustReleased(0, Keys['F6']) and not isDead and PlayerData.job ~= nil and PlayerData.job.name == 'police' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') then
			if Config.MaxInService == -1 then
				OpenPoliceActionsMenu()
			elseif playerInService then
				OpenPoliceActionsMenu()
			else
				ESX.ShowNotification(_U('service_not'))
			end
		end
		
		if IsControlJustReleased(0, Keys['E']) and CurrentTask.Busy then
			ESX.ShowNotification(_U('impound_canceled'))
			ESX.ClearTimeout(CurrentTask.Task)
			ClearPedTasks(PlayerPedId())
			
			CurrentTask.Busy = false
		end
	end
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('esx_policejob:unrestrain')
	
	if not hasAlreadyJoined then
		TriggerServerEvent('esx_policejob:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_policejob:unrestrain')

		if Config.MaxInService ~= -1 then
			TriggerServerEvent('esx_service:disableService', 'police')
		end

		if Config.EnableHandcuffTimer and HandcuffTimer.Active then
			ESX.ClearTimeout(HandcuffTimer.Task)
		end
	end
end)

-- handcuff timer, unrestrain the player after an certain amount of time
function StartHandcuffTimer()
	if Config.EnableHandcuffTimer and HandcuffTimer.Active then
		ESX.ClearTimeout(HandcuffTimer.Task)
	end

	HandcuffTimer.Active = true

	HandcuffTimer.Task = ESX.SetTimeout(Config.HandcuffTimer, function()
		ESX.ShowNotification(_U('unrestrained_timer'))
		TriggerEvent('esx_policejob:unrestrain')
		HandcuffTimer.Active = false
	end)
end

function SendToCommunityService(player)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'Community Service Menu', {
		title = "Community Service Menu",
	}, function (data2, menu)
		local community_services_count = tonumber(data2.value)
		
		if community_services_count == nil then
			ESX.ShowNotification('Invalid services count.')
		else
			TriggerServerEvent("esx_communityservice:sendToCommunityService", player, community_services_count)
			menu.close()
		end
	end, function (data2, menu)
		menu.close()
	end)
end

function ImpoundVehicle(vehicle)
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	ESX.TriggerServerCallback("eden_garage:storevimpound", function(valid)
		if (valid) then
			ESX.Game.DeleteVehicle(vehicle)
			ESX.TopicNotification("The vehicle is now impounded.", "garage")
		else
			ESX.TopicNotification("You can not store this vehicle in the impound.", "garage")
		end
	end, vehicleProps)
	CurrentTask.Busy = false
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)