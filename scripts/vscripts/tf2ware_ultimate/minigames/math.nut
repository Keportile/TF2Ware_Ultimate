printl("Minigame 'math' override in action!")

minigame <- Ware_MinigameData
({
	name            = "Math"
	author          = ["Mecha the Slag", "ficool2"]
	description     = "Type the answer!"
	duration        = 4.0
	end_delay       = 0.5
	music           = "question"
	custom_overlay  = "type_answer"
	custom_overlay2 = "../chalkboard"
	modes           = 4
	suicide_on_end  = true
})

a <- null
b <- null
operator <- null
answer <- null

first <- true

fucked_up_mult <- false

function OnStart()
{
	if (Ware_MinigameMode == 0)
	{
		if (RandomInt(0, 49) == 0)
		{
			a = RandomInt(1, 9) * 1000
			b = 9001 - a
		}
		else
		{
			a = RandomInt(3, 15)
			b = RandomInt(3, 15)
		}
		
		answer = a + b
		operator = "+"
	}
	else if (Ware_MinigameMode == 1)
	{
		a = RandomInt(3, 15)
		b = RandomInt(3, 15)
		answer = a - b
		operator = "-"
	}
	else if (Ware_MinigameMode == 2)
	{
        if (RandomInt(0, 9) == 0)
        {
            // really wonky multiplication that results in just 1
            fucked_up_mult = true
            a = RandomFloat(123.8939, 789.5391)
            b = 1.0 / a
            answer = 1
        }
        else
        {
            // normal multiplication
            a = RandomInt(2, 12)
            b = RandomInt(2, 12)
            if (RandomInt(0, 9) == 0)
            a = -a	
            if (RandomInt(0, 9) == 0)
            b = -b
            answer = a * b
        }
		operator = "*"
	}
	else if (Ware_MinigameMode == 3)
	{
		// always leaves no remainder
		b = RandomInt(2, 10)
		a = b * RandomInt(1, 10)
		answer = a / b
		operator = "/"		
	}
	
    if (fucked_up_mult)
    {
        Ware_ShowMinigameText(null, format("%f %s %f = ?", a, operator, b))
    }
    else
    {
        Ware_ShowMinigameText(null, format("%d %s %d = ?", a, operator, b))
    }
}

function OnEnd()
{
    local format_str = fucked_up_mult ? "The correct answer was {float} {str} {float} = {color}{int}" : "The correct answer was {int} {str} {int} = {color}{int}"
	Ware_ChatPrint(null, format_str, a, operator, b, COLOR_LIME, answer)
}

function OnPlayerSay(player, text)
{
	local num = StringToInteger(text)
	if (num == null)
		return
	
	if (num != answer)
	{
		if (player.IsAlive() && !Ware_IsPlayerPassed(player))
		{
            if (fucked_up_mult)
            {
                local text = format("%f %s %f = %s", a, operator, b, text)
                Ware_ShowMinigameText(player, text)
            }
            else
            {
                local text = format("%d %s %d = %s", a, operator, b, text)
                Ware_ShowMinigameText(player, text)
            }
			Ware_SuicidePlayer(player)
		}		
		return true
	}
		
	if (!Ware_IsPlayerPassed(player) && player.IsAlive())
	{
        if (fucked_up_mult)
        {
            local text = format("%f %s %f = %d", a, operator, b, num)
            Ware_ShowMinigameText(player, text)
        }
        else
        {
            local text = format("%d %s %d = %d", a, operator, b, num)
            Ware_ShowMinigameText(player, text)
        }
		Ware_PassPlayer(player, true)
		
		if (first)
		{
			Ware_ChatPrint(null, "{player} {color}guessed the answer first!", player, TF_COLOR_DEFAULT)
			Ware_GiveBonusPoints(player)
			first = false
		}
	}
	
	return false
}
