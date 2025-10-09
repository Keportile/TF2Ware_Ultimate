special_round <- Ware_SpecialRoundData
({
	name        = "Typing Only"
	author      = "Exortile"
	description = "Only typing this round!"
	category    = ""
})

function GetMinigameName(is_boss)
{
	return is_boss ? "typing" : "type_word"
}
