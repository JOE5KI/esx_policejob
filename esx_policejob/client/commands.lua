local PlayerData = {}

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