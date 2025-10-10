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

class_list <-
[
    TF_CLASS_SCOUT,
    TF_CLASS_SNIPER,
    TF_CLASS_SOLDIER,
    TF_CLASS_DEMOMAN,
    TF_CLASS_MEDIC,
    TF_CLASS_HEAVYWEAPONS,
    TF_CLASS_PYRO,
    TF_CLASS_SPY,
    TF_CLASS_ENGINEER,
]

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
    foreach (player in Ware_MinigamePlayers)
    {
        Ware_SetPlayerLoadout(player, RandomElement(class_list))
    }

	Ware_SetGlobalAttribute("no_jump", 1, 1)
    Ware_CreateTimer(function() {
        foreach (player in Ware_MinigamePlayers)
        {
            player.StopTaunt(true) // both are needed to fully clear the taunt
            player.RemoveCond(TF_COND_TAUNTING)
            player.Taunt(TAUNT_MISC_ITEM, MP_CONCEPT_TAUNT_LAUGH)
        }
    }, 0.5)
}
