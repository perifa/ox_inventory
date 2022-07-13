function server.hasGroup(inv, group)
	if type(group) == 'table' then
		for name, rank in pairs(group) do
			local groupRank = inv.player.groups[name]
			if groupRank and groupRank >= (rank or 0) then
				return name, groupRank
			end
		end
	else
		local groupRank = inv.player.groups[group]
		if groupRank then
			return group, groupRank
		end
	end
end

function server.setPlayerData(player)
	if not player.groups then
		shared.warning(("server.setPlayerData did not receive any groups for '%s'"):format(player?.name or GetPlayerName(player)))
	end

	return {
		source = player.source,
		name = player.name,
		groups = player.groups or {},
		sex = player.sex,
		dateofbirth = player.dateofbirth,
	}
end

if shared.framework == 'esx' then
	local ESX

	SetTimeout(500, function()
		ESX = exports.core:getSharedObject()

		if ESX.CreatePickup then
			error('ox_inventory requires a ESX Legacy v1.6.0 or above, refer to the documentation.')
		end

		server.UseItem = ESX.UseItem
		server.GetCharacterFromPlayerId = ESX.GetCharacterFromPlayerId
		server.UsableItemsCallbacks = ESX.GetUsableItems()
	end)

	-- Accounts that need to be synced with physical items
	server.accounts = {
		money = 0,
		black_money = 0,
	}

	function server.setPlayerData(character)
		return {
			source = character.source,
			name = character.name,
			groups = character.roles,
			sex = character.sex or character.variables.sex,
			dateofbirth = character.dateofbirth or character.variables.dateofbirth
		}
	end

	RegisterServerEvent('ox_inventory:requestPlayerInventory', function()
		local playerId = source
		local character = server.GetCharacterFromPlayerId(playerId)

		if character then
			exports.ox_inventory:setPlayerInventory(character, character?.inventory)
		end
	end)
end
