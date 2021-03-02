local delaytime = CurTime()
local checkfordelay = 5
local AFKTimer = 0
local AFKCounter = true


-- How long should we wait to put them in AFK mode?
-- Do not put this below 20 or above 60.
local AFK_TimeUntilAFK = 30

-- Enable the auto AFK module?
local AFK_EnableAutoAFK = true

hook.Add( "Move", "AFKSystem", function( ply, mv )
    if AFKCounter and ply:Team() == TEAM_UNDEAD then
        if delaytime + checkfordelay < CurTime() and !ply:IsBot() then
            if mv:GetButtons() == 0 then
                AFKTimer = AFKTimer + 1
            else
                AFKTimer = 0
            end
            delaytime = CurTime()
        end
        
        if AFK_EnableAutoAFK == true then
            if AFKTimer == AFK_TimeUntilAFK then
                net.Start( "NetD3botCommandControl" ) net.SendToServer()
                AFKTimer = 0
                AFKCounter = false
            end
        else
            return
        end
    elseif AFKCounter == false then
        if ply:KeyPressed(IN_USE) or ply:Team() == TEAM_HUMAN then
            net.Start( "NetD3botCommandUnControl" ) net.SendToServer()
            AFKCounter = true
        end
    end
end)

function AFKWarning()
    AFKCounter = false
end

hook.Add("HUDPaint", "ShowAFKMessahe", function()
    if AFKCounter == false then
        draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 250 ))
        draw.SimpleTextBlurry("You are now in AFK mode.", "ZSHUDFontBig", ScrW() / 2, ScrH() / 2 - 450, Color(200, 0, 0), TEXT_ALIGN_CENTER)
        draw.SimpleTextBlurry("While in AFK mode, you are controlled by a bot.", "ZSHUDFontSmall", ScrW() / 2, ScrH() / 2 - 375, COLOR_GRAY, TEXT_ALIGN_CENTER)
        draw.SimpleTextBlurry("Press your USE key (Default: E) to exit AFK mode.", "ZSHUDFont", ScrW() / 2, ScrH() / 2 - 300, COLOR_CYAN, TEXT_ALIGN_CENTER)
        draw.SimpleTextBlur("Created by the_horde (STEAM_0:0:105668971).", "ZSHUDFontTiny", ScrW() / 2, ScrH() / 2 - 520, COLOR_GRAY, TEXT_ALIGN_CENTER)
    end
end)