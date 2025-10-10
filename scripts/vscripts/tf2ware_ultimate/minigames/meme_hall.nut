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

MP_CONCEPT_TAUNT_LAUGH <- 92

function OnTeleport(players)
{
    local heavy_loc = Ware_MinigameLocation.heavy_spawn
    local piss_loc = Ware_MinigameLocation.piss_spawn
    local heavy_rot = QAngle(0, 180, 0)
    local piss_rot = QAngle(0, 0, 0)

    for (local i = 0; i < players.len(); i++)
    {
        local loc = i % 2 == 0 ? heavy_loc : piss_loc
        local rot = i % 2 == 0 ? heavy_rot : piss_rot
        Ware_TeleportPlayer(players[i], loc, rot, vec3_zero)
    }
}

function OnStart()
{
    Ware_CreateTimer(function() {
        foreach (player in Ware_MinigamePlayers)
        {
            player.Taunt(TAUNT_MISC_ITEM, MP_CONCEPT_TAUNT_LAUGH)
        }
    }, 0.5)
}
