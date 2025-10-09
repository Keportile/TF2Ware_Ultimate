printl("Minigame 'projectile_jump' override in action!")

local MODE_ROCKET       = 0
local MODE_STICKY       = 1
local MODE_SHORTCIRCUIT = 2

mode_infos <-
{
	[MODE_ROCKET]       = [ "Rocket jump!",       "rocket_jump",        384.0],
	[MODE_STICKY]       = [ "Sticky jump!",       "sticky_jump",        384.0],
	[MODE_SHORTCIRCUIT] = [ "Short Circuit jump!", "shortcircuit_jump", 384.0],
}

minigame <- Ware_MinigameData
({
	name           = "Projectile Jump"
	author         = ["Mecha the Slag", "TonyBaretta", "ficool2"]
	modes          = mode_infos.len()
	description    = mode_infos[Ware_MinigameMode][0]
	duration       = 4.0
	end_delay      = 1.0
	music          = "goodtimes"
	custom_overlay = mode_infos[Ware_MinigameMode][1]
	allow_damage   = false
	allow_building = true
	convars        = 
	{
		tf_damageforcescale_self_soldier_badrj = 10
		tf_damageforcescale_self_soldier_rj    = 20
		tf_damageforcescale_pyro_jump          = 20
		tf_fastbuild                           = 1
	}
})

function OnPrecache()
{
	foreach (mode in mode_infos)
		PrecacheOverlay("hud/tf2ware_ultimate/minigames/" + mode[1])
}

function OnStart()
{
	local player_class, weapon
	if (Ware_MinigameMode == MODE_ROCKET)
	{
		player_class = TF_CLASS_SOLDIER
		weapon = "Rocket Launcher"
	}
	else if (Ware_MinigameMode == MODE_STICKY)
	{
		player_class = TF_CLASS_DEMOMAN
		weapon = "Stickybomb Launcher"
	}
	else if (Ware_MinigameMode == MODE_SHORTCIRCUIT)
	{
		player_class = TF_CLASS_ENGINEER
		weapon = "Short Circuit"
		orbs <- {}
	}
	
	foreach(player in Ware_MinigamePlayers)
	{
		Ware_SetPlayerLoadout(player, player_class, weapon)
		Ware_GetPlayerMiniData(player).self_damage <- false
	}
}

function OnUpdate()
{
	local height = mode_infos[Ware_MinigameMode][2]
	foreach (player in Ware_MinigamePlayers)
	{
		if (!player.IsAlive())
			continue
		if (player.GetAbsVelocity().Length() > velocity && (Ware_GetPlayerMiniData(player).self_damage || Ware_MinigameMode == MODE_SHORTCIRCUIT)) // TODO: see shortcircuit ontakedamage
			Ware_PassPlayer(player, true)
	}

	if (Ware_MinigameMode == MODE_SHORTCIRCUIT)
	{
		local dead_orbs = {}
		foreach (orb, data in orbs)
		{
			if (orb.IsValid())
				data.origin = orb.GetOrigin()
			else
				dead_orbs[orb] <- data
		}

		for (local orb; orb = Entities.FindByClassname(orb, "tf_projectile_mechanicalarmorb");)
		{
			if (!(orb in orbs) && !orb.IsEFlagSet(EFL_KILLME))
				orbs[orb] <- { origin = orb.GetOrigin(), owner = orb.GetOwner() }
		}

		foreach (orb, data in dead_orbs)
		{
			delete orbs[orb]

			local player = data.owner
			local origin = data.origin

			local radius = 100.0

			// copied from Ware_RadiusDamagePlayers
			local dist = VectorDistance(player.GetOrigin(), origin)
			if (dist > radius)
				continue

			dist += DIST_EPSILON
			local falloff = 1.0 - dist / radius
			if (falloff <= 0.0)
				continue

			local dir = player.EyeAngles().Forward()
			dir.Norm()

			local dot = dir.Dot(Vector(0, 0, -1.0))
			if (dot > 0.707) // cos(45)
				player.SetAbsVelocity(player.GetAbsVelocity() - dir * 2000.0 * dot * falloff)
		}
	}
}

function OnEnd()
{
}

if (Ware_MinigameMode == MODE_SHORTCIRCUIT)
{
	function OnTakeDamage(params)
	{
		CheckSelfDamage(params) // TODO: this mode doesnt work for damagecheck bcuz shortcircuit does no self damage
		local weapon = params.weapon
		if (weapon && weapon.GetName() == "tf_weapon_mechanical_arm")
			params.damage = 0.0
	}
}
