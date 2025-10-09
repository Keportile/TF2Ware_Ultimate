printl("Minigame 'type_word' override in action!")

minigame <- Ware_MinigameData
({
	name            = "Say the Word"
	author          = ["Gemidyne", "ficool2"]
	description     = "Say the word below!"
	duration        = 5.0
	end_delay       = 0.5
	music           = "getready"
	custom_overlay2 = "../chalkboard"
	suicide_on_end  = true
})

words <-
[
	"Jarate"
	"Sasha"
	"Engy"
	"Saxton"
	"Sandman"
	"Wario"
	"Valve"
	"Flowey" // :)
	"Mann Co"
	"Sentry"
	"Rocket"
	"Sticky"
	"Uber"
	"Cloak"
	"Sandvich"
	"Bonk"
	"Hale"
	"Taunt"
	"Spycrab"
	"Crits"
	"Payload"
	"Capture"
	"Comics"
	"Gaben"
	"Steam"
	"Scrap"
	"Sheen"
	"Sapper"
	"Conga"
	"Yeti"
	"Aussie"
	"Earbud"
	"Disguise"
	"Aimbot"
	"2Fort"
	"Dustbowl"
	"Granary"
	"Gravelpit"
	"Hydro"
	"Krampus"
	"Phlog"
	"Prophunt"
	"Smash"
	"TF2Ware"
	"Redsun"
	"VScript"
	"Crash"
	"Raiden"
	"Freaky"
	"Hawk"
	"Tuah"
	
	// these two are evil but rare
	"Bombinomicon"
	"Shahanshah"
	// I'm so sorry
	"Claidheamh Mor"

    // I am also very sorry
    "Pneumonoultramicroscopicsilicovolcanoconiosis"

    // peak
    "Bruhg"
    "Bruhg Bunkerg"
    "Pizza"
    "BK"
    "Burger King"
    "Waffle"
    "Anthrax"
    "Blahaj"
    "Muffin"
    "Mumfin"
    "Garage Door"
    "SCP-173"
    "Microwave"
    "Cringe Detected"
    "Gamer Detected"
    "Anti Cringe"
    "Cringe Inheritor"
    "Hello?"
    "500 Cigarettes"
    "Shawty"
    "Mr. Saturn"
    "Planet"
    "Daniel"
    "Ad Break"
    "Ad Free Music"
    "Kidney Stone"
    "Cobblestone Generator"
    "Die Nerd"
    "Cockroach"
    "Big Chungus"
    "Kazditi"
    "Exortile"
    "Exortle"
    "Floortile"
    "Exorcism"
    "Penguin"
    "DeathOf4Penguin"
    "Dreggoon"
    "Carbon"
    "Geetz"
    "Monster"
    "Swag"
    "Spyder"
    "Soppy"
    "Itov"
    "ProjecTechAce"
    "Squidward Community College"
    "Embassy"
]

first <- true
word <- null

function OnStart()
{
    word = RandomElement(words)
	// these spaces are to prevent localization
	Ware_ShowMinigameText(null, format(" %s ", word))
	word = word.tolower()
}

function OnPlayerSay(player, text)
{	
	if (text.tolower() == word)
	{
		if (player.IsAlive())
		{
			Ware_PassPlayer(player, true)
			if (first)
			{
				Ware_ChatPrint(null, "{player} {color}said the word first!", player, TF_COLOR_DEFAULT)
				Ware_GiveBonusPoints(player)
				first = false
			}
		}
		return false
	}
	else
	{
		if (Ware_IsPlayerPassed(player) || !player.IsAlive())
			return
		
		Ware_SuicidePlayer(player)
	}
}
