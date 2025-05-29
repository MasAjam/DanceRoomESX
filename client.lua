RegisterNetEvent('danceRoom:playAnimation')
AddEventHandler('danceRoom:playAnimation', function(anim)
    if not anim or anim == "" then
        print("[DanceRoom] Animasi tidak valid.")
        return
    end

    ExecuteCommand("e " .. anim)
end)
