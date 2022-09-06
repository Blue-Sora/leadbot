local oldAddBot = LeadBot.AddBotOverride


-- We should actually do this for clientside... since some players might not want this enabled and others do.
CreateConVar("leadbot_renderAvatars", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Bots will have their profile pictures on scoreboard as their avatars.")

function LeadBot.AddBotOverride(bot)
    oldAddBot(bot)

    timer.Simple(0, function()
        if IsValid(bot) then
            bot:SetNWString("LeadBot_AvatarModel", player_manager.TranslatePlayerModel(bot:LBGetModel()))
            bot:SetNWVector("LeadBot_AvatarColor", bot:LBGetColor())
        end
    end)
end