-- BELOVE IS YOUR SETTINGS, CHANGE THEM TO WHATEVER YOU'D LIKE & MORE SETTINGS WILL COME IN THE FUTURE! --

local useBilling = true -- OPTIONS: (true/false)
local useCameraSound = true -- OPTIONS: (true/false)
local useFlashingScreen = false -- OPTIONS: (true/false)
local useBlips = false -- OPTIONS: (true/false)
local alertPolice = false -- OPTIONS: (true/false)
local alertSpeed = 150 -- OPTIONS: (1-5000 KMH)
local speedCameras = {}

-- ABOVE IS YOUR SETTINGS, CHANGE THEM TO WHATEVER YOU'D LIKE & MORE SETTINGS WILL COME IN THE FUTURE!  --

ESX = nil
local PlayerData = {}

local hasBeenCaught = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end

	while not ESX.IsPlayerLoaded() do
		Citizen.Wait(500)
	end

	PlayerData = ESX.GetPlayerData()
	refreshBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job

	refreshBlips()
end)

local blacklist = {
	[`a45amgunmark`] = true,
	[`ambuamarok`] = true,
	[`ambucrafter`] = true,
	[`ambulance5`] = true,
	[`ambumotor`] = true,
	[`ambutouran`] = true,
	[`audiq8ambu`] = true,
	[`mule`] = true,
	[`ambu90`] = true,
	[`poltouran`] = true,
	[`police2`] = true,
	[`polamaraok`] = true,
	[`pvito`] = true,
	[`paudi`] = true,
	[`polmotor`] = true,
	[`polmotor2`] = true,
	[`polmotor3`] = true,
	[`polpassatun`] = true,
	[`nissantitan17unmark`] = true,
	[`polgolf7`] = true,
	[`e63unmark`] = true,
	[`g65amgunmark`] = true,
	[`polaudia6`] = true,
	[`polbmwat`] = true,
	[`polbmwx5m`] = true,
	[`rrstunmark`] = true,
	[`polbearcat`] = true,
	[`flatbed`] = true,
	[`asterope`] = true,
	[`anwbt6`] = true,
	[`bcla2021`] = true,
	[`oycroma`] = true,
	[`mromaprzemo`] = true,
	[`mcullinan`] = true,
	[`mansorycullinanv2`] = true,
	[`mqgts`] = true,
	[`defenderoffp`] = true,
	[`pistas`] = true,
	[`db5`] = true,
	[`polaudi`] = true,
	[`polaudi2`] = true,
	[`polmotor`] = true,
}


function IsBlackListed(vehicleName)
	if blacklist[vehicleName] then
		return true
	end

	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	if IsPedInAnyPoliceVehicle(PlayerPedId()) or DecorGetBool(vehicle, "_POLICE_LIGHTS_ACTIVE") then
		return true
	end
end

exports("IsBlacklistedCar", IsBlackListed)
exports("IsStaffCar", isStaff)


function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- BLIP FOR SPEEDCAMERA (START)

local messages = {

}

local name = "Flitspaal"

local blips = {
	-- 80KM/H ZONES
	{ colour=1, id=1, pos = vector3(-524.2645, -1776.3569, 21.3384), h = 180.0, speed = 80 }, -- 60KM/H ZONE
	{ colour=1, id=1, pos = vector3(-728.35, -1591.9, 21.32), h = 140.0, speed = 80 }, -- 60KM/H ZONE
	{ colour=1, id=1, pos = vector3(649.21, -1033.57, 37.09), h = 290.0, speed = 80, radius = 35.0 }, -- Brug bij politie bureau
	{ colour=1, id=1, pos = vector3(277.71, -836.80, 29.22), h = 212.91, speed = 80, }, --Blokkenpark 2
	{ colour=1, id=1, pos = vector3(116.66, -1022.11, 28.30), h = 15.96, speed = 80, }, --Blokkenpark 4
	{ colour=1, id=1, pos = vector3(846.80, -104.11, 79.93), h = 120.0, speed = 80, }, --taxi straat
	{ colour=1, id=1, pos = vector3(880.13, -994.6, 31.78), h = 120.0, speed = 80, }, --anwb straat
	{ colour=1, id=1, pos = vector3(-997.69, -193.38, 37.64), h = 91.06, speed = 80, },
	-- Blokkenpark onder viaduct
	{ colour=1, id=1, pos= vector3(-28.10, -745.85, 31.73), h= 210.0, speed = 80, blackListOffset = 65 },

	-- Grens controle militaire basis
	{ colour=1, id=1, pos = vector3(-2671.699, 2541.835, 15.7086), h = 210.0, speed = 80, radius = 20.0 },
	-- Grens controle gevangenis
	{ colour=1, id=1, pos = vector3(2065.61, 2627.85, 51.67), h = 210.0, speed = 80, radius = 35.0 },
	-- 100KM/H ZONES
	{ colour=1, id=1, pos = vector3(2506.0671, 4145.2431, 38.1054), h = 210.0, speed = 100 }, -- 100KM/H ZONE
	{ colour=1, id=1, pos = vector3(299.12, 2619.31, 43.81), h = 280.0, speed = 100 }, -- 100KM/H ZONE 714
	{ colour=1, id=1, pos = vector3(-2248.10, -359.58, 13.56), h = 352.30, speed = 130 }, -- 100KM/H snelweg links ingang
	{ colour=1, id=1, pos = vector3(1267.38, 581.93, 80.63), h = 0.0, speed = 130 }, --130KM/H ZONE Los Santos Freeway
	{ colour=1, id=1, pos = vector3(226.20, 1357.96, 239.59), h=0.0, speed = 100 },
	{ colour=1, id=1, pos = vector3(-1440.0, -453.94, 34.24), h=270.0, speed = 100 },
	{ colour=1, id=1, pos = vector3(6.89, 6361.93, 31.38), h = 47.52, speed = 130 },
	{ colour=1, id=1, pos = vector3(-1073.46, -736.46, 19.25), h = 219.25, speed = 80 },
	{ colour=1, id=1, pos = vector3(1174.72, -2538.40, 35.68), h = 194.44, speed = 130 },

	-- 130KM/H ZONES
	{ colour=1, id=1, pos = vector3(1584.9281, -993.4557, 59.3923), h = 0.0, speed = 130 }, -- 130KM/H ZONE
	{ colour=1, id=1, pos = vector3(-3033.2006, 1458.6004, 27.00), h = 0.0, speed = 130 }, -- 130KM/H ZONE
	{ colour=1, id=1, pos = vector3(2862.44, 3564.82, 53.0930), h = 328.0, speed = 130 }, -- 130KM/H ZONE
	{ colour=1, id=1, pos = vector3(1267.38, 581.93, 80.63), h=0.0, speed = 130 },
}

AddTextEntry('_SPEED_CAMERA', name)
function refreshBlips()
	for _, info in pairs(blips) do
		if info.blip ~= nil then
			RemoveBlip(info.blip)
			info.blip = nil
		end

		if PlayerData.job.name == 'owner' or useBlips then
			info.blip = AddBlipForCoord(info.pos.x, info.pos.y, info.pos.z)
			SetBlipSprite(info.blip, info.id)
			SetBlipDisplay(info.blip, 4)
			SetBlipScale(info.blip, 0.5)
			SetBlipColour(info.blip, info.colour)
			SetBlipAsShortRange(info.blip, true)
			BeginTextCommandSetBlipName("_SPEED_CAMERA")
			--AddTextComponentString(name)
			EndTextCommandSetBlipName(info.blip)
		end
	end
end

-- BLIP FOR SPEEDCAMERA (END)

-- ALL ZONES (START)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local minDistance = 10000
		local playerPed = PlayerPedId()
		local plyCoords = GetEntityCoords(playerPed, false)

		for i=1, #blips do
			local v = blips[i]
			local dist = #(plyCoords - v.pos)
			if dist < minDistance then
				minDistance = dist
			end

			if not v.object and dist < 100.0 then
				local object = CreateObject(1927491455, v.pos.x, v.pos.y, v.pos.z, false)
				PlaceObjectOnGroundProperly(object)
				if v.h then
					SetEntityHeading(object, v.h)
				end
				v.object = object
			elseif v.object and dist > 200.0 then
				DeleteObject(v.object)
				v.object = nil
			end

			if dist <= (v.radius or 20.0) then
				local vehicle = GetVehiclePedIsIn(playerPed)
				local SpeedKM = (GetEntitySpeed(playerPed)*4.0) - 4
				local maxSpeed = v.speed -- THIS IS THE MAX SPEED IN KM/H

				if SpeedKM > maxSpeed then
					if DoesEntityExist(vehicle) then
						if (GetPedInVehicleSeat(vehicle, -1) == playerPed) then
							if hasBeenCaught == false then
								if IsBlackListed(GetEntityModel(vehicle)) and v.blackListOffset then
									maxSpeed = maxSpeed + v.blackListOffset
								end
								if (not v.blackListOffset and IsBlackListed(GetEntityModel(vehicle))) or SpeedKM <= maxSpeed then
									Citizen.Wait(5000)-- Do Nothing
								else
									if IsBlackListed(GetEntityModel(vehicle)) then
										SpeedKM = SpeedKM - v.blackListOffset - 1.0
									end
									-- ALERT POLICE (START)
									if alertPolice == true then
										if (SpeedKM - maxSpeed) > alertSpeed then
											local x,y,z = table.unpack(plyCoords)
											TriggerServerEvent('esx_phone:send', 'police', ('Iemand heeft de flitser (%.0f KM/H) gepasseerd, hij reed %.0f KMH. Dit is %.0f KM/H te hard'):format(maxSpeed, SpeedKM, SpeedKM - maxSpeed), true, {x =x, y =y, z =z})
										end
									end
									-- ALERT POLICE (END)

									-- FLASHING EFFECT (START)
									if useFlashingScreen == true then
										OpenGui()
									end

									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end

									if useFlashingScreen == true then
										Citizen.Wait(200)
										CloseGui()
									end
									-- FLASHING EFFECT (END)
									local price = (((SpeedKM - maxSpeed) / 2) ^ 1.0) * 0.9
									price = math.floor(price)
									local overSpeedLimit = SpeedKM - maxSpeed
									notification("~w~Je hebt ~r~" .. price .. ".- betaalt ~w~ voor een flitsboete van " .. math.floor(overSpeedLimit) .. "KM/H te hard.")

									--if useBilling == true thenm
								--	local price = (((SpeedKM - maxSpeed) / 3) ^ 2.0) * 1.2
									if price > 10 then
										TriggerServerEvent('esx_speedcamera:PayBill', math.floor(price))
									end

									hasBeenCaught = true
									Citizen.Wait(5000) -- This is here to make sure the player won't get fined over and over again by the same camera!
								end
							end
						end
					end

					hasBeenCaught = false
				end
			end
		end
		if minDistance > 150 then
			local multiplier = 10 - (GetEntitySpeed(PlayerPedId())^0.5)

			Citizen.Wait(math.floor(math.clamp(multiplier * minDistance, 50, 2000)))
		end
	end
end)

function OpenGui()
	SendNUIMessage({type = 'openSpeedcamera'})
end

function CloseGui()
end

local function RemoveSpeedCameras()
	for i=1, #blips do
		if blips[i].object then
			DeleteObject(blips[i].object)
		end
	end
end

AddEventHandler('onResourceStop', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		RemoveSpeedCameras()
	end
end)

function notification(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString("~c~~w~" .. msg)
	DrawNotification(false, false)
end