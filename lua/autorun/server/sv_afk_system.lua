util.AddNetworkString( "NetD3botCommandControl" )
util.AddNetworkString( "NetD3botCommandUnControl" )


-- Enable the chat command?
local AFK_EnableChatCMD = true

-- Enable AFK status messages in the center of your screen?
local AFK_EnableMessages = true

-- Enable sounds from errors?
local AFK_EnableErrorSounds = true
	
net.Receive( "NetD3botCommandControl", function( len, ply )
	RunConsoleCommand( "d3bot", "control", ply:Name() )
	if AFK_EnableMessages == true then
		GAMEMODE:CenterNotifyAll({font = "ZSHUDFontSmall"}, COLOR_CYAN, ply:Name(), COLOR_WHITE, " is now ", COLOR_RED, "AFK.")
	else
		return
	end
end)
	
net.Receive( "NetD3botCommandUnControl", function( len, ply )
	RunConsoleCommand( "d3bot", "uncontrol", ply:Name() )
	if AFK_EnableMessages == true then
		GAMEMODE:CenterNotifyAll({font = "ZSHUDFontSmall"}, COLOR_CYAN, ply:Name(), COLOR_WHITE, " is back from being ", COLOR_RED, "AFK.")
	else
		return
	end

	local playerAng = ply:GetAngles()
	timer.Simple( 0.5, function()
		ply:SetEyeAngles( Angle( playerAng.x, playerAng.y, 0 ) )
	end)
end)

hook.Add("PlayerSay", "NJKASDNJADS", function(ply, text)
	if AFK_EnableChatCMD == true then
		if string.lower(text) == "!afk" or string.lower(text) == "/afk" then
			if ply:Team() == TEAM_ZOMBIE then
				RunConsoleCommand( "d3bot", "control", ply:Name() )
				GAMEMODE:CenterNotifyAll({font = "ZSHUDFontSmall"}, COLOR_CYAN, ply:Name(), COLOR_WHITE, " is now ", COLOR_RED, "AFK.")
				ply:SendLua("AFKWarning()")
			else
				ply:CenterNotify({font = "ZSHUDFontSmall"}, COLOR_CYAN, "You ", COLOR_WHITE, "need to be a ", COLOR_RED, "zombie ", COLOR_WHITE, "to do this!")
				if AFK_EnableErrorSounds == true then
					ply:SendLua('surface.PlaySound("npc/zombie_poison/pz_alert1.wav")')
				else
					return
				end
			end

			return ""
		end
	else
		return
	end
end)