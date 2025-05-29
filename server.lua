ESX = exports["es_extended"]:getSharedObject()

local danceRooms = {}  -- Format: [roomNumber] = {owner = identifier, players = { [identifier] = playerId }}

RegisterCommand('danceroom', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    local subCommand = args[1]
    if subCommand == 'create' then
        local roomNumber = tonumber(args[2])
        if not roomNumber or roomNumber < 1 or roomNumber > 25 then
            TriggerClientEvent('chat:addMessage', source, { args = { 'SYSTEM :', 'Nomor room harus antara 1 - 25.' } })
            return
        end

        if danceRooms[roomNumber] then
            TriggerClientEvent('chat:addMessage', source, { args = { 'SYSTEM :', 'Room tersebut sudah ada.' } })
        else
            danceRooms[roomNumber] = {
                owner = identifier,
                players = { [identifier] = source }
            }
            TriggerClientEvent('chat:addMessage', source, { args = { 'SYSTEM :', 'Room #' .. roomNumber .. ' berhasil dibuat.' } })
        end

    elseif subCommand == 'join' then
        local roomNumber = tonumber(args[2])
        local room = danceRooms[roomNumber]

        if not room then
            TriggerClientEvent('chat:addMessage', source, { args = { 'SYSTEM :', 'Room tidak ditemukan.' } })
        else
            room.players[identifier] = source
            TriggerClientEvent('chat:addMessage', source, { args = { 'SYSTEM :', 'Kamu telah bergabung ke room #' .. roomNumber } })
        end

    elseif subCommand == 'leave' then
        for k, room in pairs(danceRooms) do
            if room.players[identifier] then
                room.players[identifier] = nil
                TriggerClientEvent('chat:addMessage', source, { args = { 'SYSTEM :', 'Kamu telah keluar dari room #' .. k } })
                return
            end
        end
        TriggerClientEvent('chat:addMessage', source, { args = { 'SYSTEM :', 'Kamu tidak berada di dalam room.' } })

    elseif subCommand == 'disband' then
        for k, room in pairs(danceRooms) do
            if room.owner == identifier then
                for _, playerId in pairs(room.players) do
                    TriggerClientEvent('chat:addMessage', playerId, { args = { 'SYSTEM :', 'Room #' .. k .. ' telah dibubarkan oleh pemilik.' } })
                end
                danceRooms[k] = nil
                return
            end
        end
        TriggerClientEvent('chat:addMessage', source, { args = { 'SYSTEM :', 'Kamu bukan pemilik room.' } })

    else
        TriggerClientEvent('chat:addMessage', source, { args = { 'SYSTEM :', 'Perintah tidak dikenali. Gunakan create/join/leave/disband.' } })
    end
end)

RegisterCommand('dancenow', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local animName = args[1]

    if not animName then
        TriggerClientEvent('chat:addMessage', source, { args = { 'SYSTEM :', 'Harap masukkan nama animasi/emote!' } })
        return
    end

    for roomNumber, room in pairs(danceRooms) do
        if room.owner == identifier then
            for _, playerId in pairs(room.players) do
                TriggerClientEvent('danceRoom:playAnimation', playerId, animName)
            end
            return
        end
    end

    TriggerClientEvent('chat:addMessage', source, { args = { 'SYSTEM :', 'Kamu bukan pemilik room mana pun.' } })
end)
