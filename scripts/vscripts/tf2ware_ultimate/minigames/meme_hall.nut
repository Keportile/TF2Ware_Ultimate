minigame <- Ware_MinigameData
({
	name        = "Meme Hall"
	author		= "Exortile"
	description = "Enjoy The Memes!"
	duration    = 15.0
	location    = "meme_hall"
	music       = "eek"
	start_pass  = true
})

function OnTeleport(players)
{
    local heavy_loc = Ware_MinigameLocation.heavy_spawn
    local piss_loc = Ware_MinigameLocation.piss_spawn

    for (local i = 0; i < players.len(); i++)
    {
        local loc = i % 2 == 0 ? heavy_loc : piss_loc;
        Ware_TeleportPlayer(players[i], loc, QAngle(0, 0, 0), vec3_zero)
    }
}
