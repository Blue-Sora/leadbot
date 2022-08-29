LeadBot.RespawnAllowed = true -- allows bots to respawn automatically when dead
LeadBot.PlayerColor = true -- disable this to get the default gmod style players
LeadBot.NoNavMesh = false -- disable the nav mesh check
LeadBot.TeamPlay = false -- don't hurt players on the bots team
LeadBot.LerpAim = true -- interpolate aim (smooth aim)
LeadBot.AFKBotOverride = false -- allows for gamemodes such as Dogfight which use IsBot() to pass real humans as bots
LeadBot.SuicideAFK = false -- kill the player when entering/exiting afk
LeadBot.NoFlashlight = false -- disable flashlight being enabled in dark areas
LeadBot.Strategies = 1 -- how many strategies can the bot pick from
LeadBot.NextBotNames = "Rodrigo gostosão,Killer Girl,José Pedro Henrique Lindo,Meu fone bugo,Eu sou muito lindo,Eu sou eu,Morreu kkkkkkkk,Pro playerzão,Miau miau,AAAA,Oi meu chapa,Niny,Bolsonera,ABCDEF,Eu sou muito ruim,Irei dar ragequit,Manteiga,Panelapin,0088,69,Aaaadoro,Miojo,Mingu,007,Adoro gritar"
LeadBot.NextBotNamesPos = 0
LeadBot.Gamemode = "sandbox"
--Leadbot.HL2_Weapons = {"weapon_smg1", "weapon_357", "weapon_shotgun", "weapon_pistol", "weapon_crossbow", "weapon_ar2", "weapon_frag"}

--[[ COMMANDS ]]--

concommand.Add("leadbot_add", function(ply, _, args) if IsValid(ply) and !ply:IsSuperAdmin() then return end local amount = 1 if tonumber(args[1]) then amount = tonumber(args[1]) end for i = 1, amount do timer.Simple(i * 0.1, function() LeadBot.AddBot() end) end end, nil, "Adds a LeadBot")
concommand.Add("leadbot_kick", function(ply, _, args) if !args[1] or IsValid(ply) and !ply:IsSuperAdmin() then return end if args[1] ~= "all" then for k, v in pairs(player.GetBots()) do if string.find(v:GetName(), args[1]) then v:Kick() return end end else for k, v in pairs(player.GetBots()) do v:Kick() end end end, nil, "Kicks LeadBots (all is avaliable!)")
CreateConVar("leadbot_strategy", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enables the strategy system for newly created bots.")
CreateConVar("leadbot_names", "", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Bot names, seperated by commas.")
CreateConVar("leadbot_models", "", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Bot models, seperated by commas.")
CreateConVar("leadbot_name_prefix", "", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Bot name prefix")
CreateConVar("leadbot_fov", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "LeadBot FOV\nSet to 0 to use the preset FOV.")

concommand.Add("leadbot_kill", function(ply, _, args) if !args[1] or IsValid(ply) and !ply:IsSuperAdmin() then return end if args[1] ~= "all" then for k, v in pairs(player.GetBots()) do if string.find(v:GetName(), args[1]) then v:Kill() return end end else for k, v in pairs(player.GetBots()) do v:Kill() end end end, nil, "Kill LeadBots (all is avaliable!)")
CreateConVar("leadbot_stop", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Stop bots from moving and thinking.")
CreateConVar("leadbot_weapons", "_hl2", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Bot weapons able to use, seperated by commas. You can also leave it default with '_hl2' to make them select Half-life 2 weapons by default.")
CreateConVar("leadbot_keepWeapon", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Forces your (and other net players) bot to keep a specified weapon without changing it to another. (Experimental)")
CreateConVar("leadbot_move", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Stops bots from moving and shooting, they'll still think.")
CreateConVar("leadbot_chat", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Stops bots from talking in chat. (Note: Disabling this will make them to also not be able to ask for help from their team or let them know about something if the gamemode you're playing has to do with teams.)")

concommand.Add("thiagobot_tp", 
function(ply, _, args)
    --local tppos = player.GetByID(1):GetPos()
    --local remembpos = player.GetByID(1):GetPos()
    local tppos = ply:GetPos()
    local remembpos = ply:GetPos()

    local random = true
    local dist = 20

    print(tppos)

    for _, ply in ipairs(player.GetAll()) do
        if (ply:IsLBot()) then

            
            if ( random ) then
                tppos.x = remembpos.x + dist + math.random(-150, 150)
                tppos.y = remembpos.y + dist + math.random(-150, 150)
            end

            ply:SetPos( tppos )
        end
    end

    return
end
, 
nil, "Teleports all bots into your position.")

concommand.Add("thiagobot_separatebyteams", 
function(ply, _, args)

    local team_amount = 2

    local selectedPlayers = {}
    local playerNum = 0

    local halfpnum

    for _, ply in ipairs(player.GetAll()) do

        selectedPlayers[#selectedPlayers + 1] = ply
    end

    playerNum = #selectedPlayers
    halfpnum = math.floor(playerNum / 2)
    

    -- Create teams
    --team.SetUp(1, "Griffin & Kryuger", Color(255, 0, 0))
    --team.SetUp(2, "Sangvis Ferri", Color(255, 0, 255))

    local nextTeamNum = 1

    for _, ply in ipairs(selectedPlayers) do
        if (_ >= halfpnum) then

            nextTeamNum = nextTeamNum + 1
        end

        if (_ < halfpnum) then
            ply:SetTeam( nextTeamNum )
        end

        print(team.NumPlayers(ply:Team()))
    end

    PrintTable( team.GetAllTeams() )
    return
end
, 
nil, "Test/experimental. Create teams for each players to 2 teams against each other.")

concommand.Add("thiagobot_movetome", 
function(ply, _, args)
    local tppos = player.GetByID(1):GetPos()
    local teamindex = tonumber(args[1])

    local controller
    
    for _, ply in ipairs(player.GetAll()) do
        if (ply:IsLBot() and ply:Team() == teamindex) then

            print(ply:GetName())

            controller = ply.ControllerBot

            controller.PosGen = tppos
            controller.LastSegmented = CurTime() + 10
        end
    end

    return
end
, 
nil, "Teleports all bots into your position.")

concommand.Add("thiagobot_test", 
function(ply, _, args)

    PrintTable(ents.GetAll())
    --for _, ply in ipairs(ent.GetAll()) do
    --end

    return
end
, 
nil, "Test function for when I was developing.")

concommand.Add("thiagobot_test2", 
function(ply, _, args)

    local ActiveWeapon = ply:GetActiveWeapon()

    local HoldType = ActiveWeapon:GetHoldType()

    print(ActiveWeapon)
    print("Player '".. ply:Name() .."' hold weapon type: "..HoldType)

    return
end
, 
nil, "Test function for when I was developing.")

--[[ FUNCTIONS ]]--

local name_Default = {
    alyx = "Alyx Vance",
    kleiner = "Isaac Kleiner",
    breen = "Dr. Wallace Breen",
    gman = "The G-Man",
    odessa = "Odessa Cubbage",
    eli = "Eli Vance",
    monk = "Father Grigori",
    mossman = "Judith Mossman",
    mossmanarctic = "Judith Mossman",
    barney = "Barney Calhoun",


    dod_american = "American Soldier",
    dod_german = "German Soldier",

    css_swat = "GIGN",
    css_leet = "Elite Crew",
    css_arctic = "Artic Avengers",
    css_urban = "SEAL Team Six",
    css_riot = "GSG-9",
    css_gasmask = "SAS",
    css_phoenix = "Phoenix Connexion",
    css_guerilla = "Guerilla Warfare",

    hostage01 = "Art",
    hostage02 = "Sandro",
    hostage03 = "Vance",
    hostage04 = "Cohrt",

    police = "Civil Protection",
    policefem = "Civil Protection",

    chell = "Chell",

    combine = "Combine Soldier",
    combineprison = "Combine Prison Guard",
    combineelite = "Elite Combine Soldier",
    stripped = "Stripped Combine Soldier",

    zombie = "Zombie",
    zombiefast = "Fast Zombie",
    zombine = "Zombine",
    corpse = "Corpse",
    charple = "Charple",
    skeleton = "Skeleton",

    male01 = "Van",
    male02 = "Ted",
    male03 = "Joe",
    male04 = "Eric",
    male05 = "Art",
    male06 = "Sandro",
    male07 = "Mike",
    male08 = "Vance",
    male09 = "Erdin",
    male10 = "Van",
    male11 = "Ted",
    male12 = "Joe",
    male13 = "Eric",
    male14 = "Art",
    male15 = "Sandro",
    male16 = "Mike",
    male17 = "Vance",
    male18 = "Erdin",
    female01 = "Joey",
    female02 = "Kanisha",
    female03 = "Kim",
    female04 = "Chau",
    female05 = "Naomi",
    female06 = "Lakeetra",
    female07 = "Joey",
    female08 = "Kanisha",
    female09 = "Kim",
    female10 = "Chau",
    female11 = "Naomi",
    female12 = "Lakeetra",

    medic01 = "Van",
    medic02 = "Ted",
    medic03 = "Joe",
    medic04 = "Eric",
    medic05 = "Art",
    medic06 = "Sandro",
    medic07 = "Mike",
    medic08 = "Vance",
    medic09 = "Erdin",
    medic10 = "Joey",
    medic11 = "Kanisha",
    medic12 = "Kim",
    medic13 = "Chau",
    medic14 = "Naomi",
    medic15 = "Lakeetra",

    refugee01 = "Ted",
    refugee02 = "Eric",
    refugee03 = "Sandro",
    refugee04 = "Vance",
}

function reset_default_names()
    local conv = GetConVar("leadbot_names"):GetString()

    LeadBot.NextBotNamesPos = 0

    if (conv == "_THIAGO") then


    end
end

function LeadBot.AddBot()
    if !FindMetaTable("NextBot").GetFOV then
        ErrorNoHalt("You must be using the dev version of Garry's mod!\nhttps://wiki.facepunch.com/gmod/Dev_Branch\n")
        return
    end

    if !navmesh.IsLoaded() and !LeadBot.NoNavMesh then
        ErrorNoHalt("There is no navmesh! Generate one using \"nav_generate\"!\n")
        return
    end

    if player.GetCount() >= game.MaxPlayers() then
        MsgN("[LeadBot] Player limit reached!")
        return
    end

    local original_name
    local generated = "Leadbot #" .. #player.GetBots() + 1
    local model = ""
    local color = Vector(-1, -1, -1)
    local weaponcolor = Vector(0.30, 1.80, 2.10)
    local strategy = 0
    local splitlist
    local splitlistnew = {}
    local namesw = GetConVar("leadbot_names"):GetString()

    local found

    if (namesw == "_THIAGO") then
        namesw = "Rodrigo gostosão,Killer Girl,José Pedro Henrique Lindo,Meu fone bugo,Eu sou muito lindo,Eu sou eu,Morreu kkkkkkkk,Pro playerzão,Miau miau,AAAA,Oi meu chapa,Niny,Bolsonera,ABCDEF,Eu sou muito ruim,Irei dar ragequit,Manteiga,Panelapin,0088,69,Aaaadoro,Miojo,Mingu,007,Adoro gritar"
    end

    if (namesw ~= "") then
        splitlist = string.Split(namesw, ",")

        -- Get available from these
        for i, nm in ipairs(splitlist) do

            found = false
            for h, ply in ipairs(player.GetAll()) do

                if (ply:Name() == nm) then
                    found = true
                end
            end

            if (!found) then
                splitlistnew[#splitlistnew + 1] = nm
            end
        end

        if (#splitlistnew <= 0) then
            namesw = ""
        else
            generated = splitlistnew[ math.random(1, #splitlistnew) ]
        end
    end

    if (namesw == "") then
        local name, _ = table.Random(player_manager.AllValidModels())
        local translate = player_manager.TranslateToPlayerModelName(name)
        name = translate

        for _, ply in pairs(player.GetBots()) do
            if ply.OriginalName == name or string.lower(ply:Nick()) == name or name_Default[name] and ply:Nick() == name_Default[name] then
                name = ""
            end
        end

        if name == "" then
            local i = 0
            while name == "" do
                i = i + 1
                local str = player_manager.TranslateToPlayerModelName(table.Random(player_manager.AllValidModels()))
                for _, ply in pairs(player.GetBots()) do
                    if ply.OriginalName == str or string.lower(ply:Nick()) == str or name_Default[str] and ply:Nick() == name_Default[str] then
                        str = ""
                    end
                end

                if str == "" and i < #player_manager.AllValidModels() then continue end
                name = str
            end
        end

        original_name = name
        model = name
        name = string.lower(name)
        name = name_Default[name] or name

        local name_Generated = string.Split(name, "/")
        name_Generated = name_Generated[#name_Generated]
        name_Generated = string.Split(name_Generated, " ")

        for i, namestr in pairs(name_Generated) do
            name_Generated[i] = string.upper(string.sub(namestr, 1, 1)) .. string.sub(namestr, 2)
        end

        name_Generated = table.concat(name_Generated, " ")
        generated = name_Generated
    end

    if LeadBot.PlayerColor == "default" then
        generated = "Kleiner"
    end

    generated = GetConVar("leadbot_name_prefix"):GetString() .. generated

    local name = LeadBot.Prefix .. generated
    local bot = player.CreateNextBot(name)

    if !IsValid(bot) then
        MsgN("[LeadBot] Unable to create bot!")
        return
    end

    if GetConVar("leadbot_strategy"):GetBool() then
        strategy = math.random(0, LeadBot.Strategies)
    end

    if LeadBot.PlayerColor ~= "default" then
        if model == "" then
            if GetConVar("leadbot_models"):GetString() ~= "" then
                model = table.Random(string.Split(GetConVar("leadbot_models"):GetString(), ","))
            else
                model = player_manager.TranslateToPlayerModelName(table.Random(player_manager.AllValidModels()))
            end
        end

        if color == Vector(-1, -1, -1) then
            local botcolor = ColorRand()
            local botweaponcolor = ColorRand()
            color = Vector(botcolor.r / 255, botcolor.g / 255, botcolor.b / 255)
            weaponcolor = Vector(botweaponcolor.r / 255, botweaponcolor.g / 255, botweaponcolor.b / 255)
        end
    else
        model = "kleiner"
        color = Vector(0.24, 0.34, 0.41)
    end

    bot.LeadBot_Config = {model, color, weaponcolor, strategy}

    -- for legacy purposes, will be removed soon when gamemodes are updated
    bot.BotStrategy = strategy
    bot.OriginalName = original_name
    bot.ControllerBot = ents.Create("leadbot_navigator")
    bot.ControllerBot:Spawn()
    bot.ControllerBot:SetOwner(bot)
    bot.LeadBot = true
    LeadBot.AddBotOverride(bot)
    LeadBot.AddBotControllerOverride(bot, bot.ControllerBot)
    MsgN("[LeadBot] Bot " .. name .. " with strategy " .. bot.BotStrategy .. " added!")
end

--[[ DEFAULT DM AI ]]--

function LeadBot.AddBotOverride(bot)
    if math.random(2) == 1 then
        timer.Simple(math.random(1, 4), function()
            LeadBot.TalkToMe(bot, "join")
        end)
    end
end

function LeadBot.AddBotControllerOverride(bot, controller)
end

function LeadBot.PlayerSpawn(bot)
end

function LeadBot.Think()
    local controller

    for _, bot in pairs(player.GetAll()) do
        if (bot:IsLBot()) then
            if (LeadBot.RespawnAllowed and bot.NextSpawnTime and !bot:Alive() and bot.NextSpawnTime < CurTime() and LeadBot.Gamemode == "sandbox" and math.random(1, 33) == 27) then
                bot:Spawn()

                controller = bot.ControllerBot


                -- Reset variables
                controller.nextWeaponSwitch = 0
                controller.forceWeaponChange = true

                controller.Target = nil

                -- Boolean
                controller.IGuessWeAreAiming = false

                -- Reset
                controller:CReset()

                -- Just to make it more likely a real player, let's also give it the physgun on respawn
                bot:Give("weapon_physgun")
                bot:Give("weapon_physcannon")

                bot:SelectWeapon("weapon_physgun")
                return
            end

            local wep = bot:GetActiveWeapon()
            if IsValid(wep) then
                --local ammoty = wep:GetPrimaryAmmoType() or wep.Primary.Ammo
                --bot:SetAmmo(999, ammoty)
            end
        end
    end
end

function LeadBot.PostPlayerDeath(bot)
end

function LeadBot.PlayerHurt(ply, bot, hp, dmg)
    if bot:IsPlayer() then
        if hp <= dmg and math.random(3) == 1 and bot:IsLBot() then
            LeadBot.TalkToMe(bot, "taunt")
        end

        local controller = ply:GetController()

        controller.LookAtTime = CurTime() + 2
        controller.LookAt = ((bot:GetPos() + VectorRand() * 128) - ply:GetPos()):Angle()
    end
end

function LeadBot.StartCommand(bot, cmd)
    local buttons = IN_CANCEL
    local botWeapon = bot:GetActiveWeapon()
    local controller = bot.ControllerBot
    local target = controller.Target

    local weaponUpdate = false

    local botweapons = GetConVar("leadbot_weapons"):GetString()

    local shouldmove = GetConVar("leadbot_move"):GetBool()

    if !IsValid(controller) then return end


    if (GetConVar("leadbot_stop"):GetBool() or !bot:Alive()) then
        cmd:ClearButtons()
        cmd:ClearMovement()
        return
    end

    --if LeadBot.NoSprint then
        --buttons = 0
   -- end


   -- Walking fast and normal changing behaviours
    if (controller.nextWalkNormal < CurTime()) then
        controller.nextWalkNormal = CurTime() + math.Rand(0.75, 26.5)

        if (math.random(1, 3) >= 2) then
            controller.walkFast = false

            controller.walkNormalTimer = CurTime() + math.Rand(1.35, 11.1)
        end
    end
    if (controller.walkNormalTimer < CurTime()) then
        controller.walkFast = true
    end

    if (controller.walkFast or IsValid(target)) then
        buttons = IN_SPEED
    end


   -- Weapon info
   local holdtype = ""

   if (IsValid(botWeapon)) then
        holdtype = botWeapon:GetHoldType()
   end

   local ismelee = GetIsMelee(botWeapon)

    -- Reload
    if (!ismelee) then
        if (IsValid(botWeapon) and (botWeapon:Clip1() == 0 or !IsValid(target) and botWeapon:Clip1() <= botWeapon:GetMaxClip1() / 2)) then
            buttons = buttons + IN_RELOAD
        end
    end

     -- Behaviours time
     if (controller.battle_nextBehaviourTime < CurTime()) then
        controller.battle_nextBehaviourTime = CurTime() + math.Rand(0.44, 15)


        if (math.random(1, 5) >= 3) then
            local OrderOfChance = {0, 0, 0, 1}
            controller.battle_behaviourType = OrderOfChance[ math.random(1, #OrderOfChance) ]


            if (controller.battle_behaviourType ~= 0) then
                controller.battle_nextBehaviourTime = CurTime() + math.Rand(0.14, 4)
            end
        end
     end

    -- Shooting at target

    -- Weapons shooting
    local isPhysgun = holdtype == "physgun"
    if (IsValid(target)) then

        -- Memorize in this frame if we can see the target, so we don't have to check it everytime and use this variable instead.
        controller.canSeeTarget = controller:CanSee(target)
        local canSeeTarget = controller.canSeeTarget

        if (!ismelee) then
            local isSniper = holdtype == "crossbow"


            if (!isPhysgun) then
                -- Behaviours
                if (controller.battle_behaviourType == 1) then -- Attack while crouching

                    if (holdtype ~= "shotgun" and !isSniper) then
                        buttons = buttons + IN_DUCK
                    end
                end


                -- Sniper check
                local sniper_targetTooClose = false
                if (isSniper) then
                    targetDistance = target:GetPos():DistToSqr( bot:GetPos() )


                    sniper_targetTooClose = targetDistance < 87333
                end

                -- Shooting
                if (math.random(2) == 1) then
                    if (controller.canSeeTarget) then
                        if (holdtype ~= "grenade" and !isSniper or isSniper and !controller.IGuessWeAreAiming) then
                            buttons = buttons + IN_ATTACK
                        elseif (holdtype == "grenade") then
                            if (bot:GetPos():DistToSqr( target:GetPos() ) > 41216) then -- Throw high range
                                buttons = buttons + IN_ATTACK
                            else -- Throw low range
                                --buttons = buttons + IN_ATTACK2
                            end
                        end


                        if (holdtype == "ar2") then
                            if (math.random(1, 95) >= 93) then
                                buttons = buttons + IN_ATTACK2
                            end
                        end
                    end
                end


                -- Sniper behaviour
                if (isSniper) then
                    if (sniper_targetTooClose and controller.IGuessWeAreAiming) then
                        controller.IGuessWeAreAiming = false

                        --buttons = buttons + IN_ATTACK2
                    end

                    if (canSeeTarget and !sniper_targetTooClose) then
                        if (!controller.IGuessWeAreAiming) then
                            --buttons = buttons + IN_ATTACK2

                            if (controller.sniper_preparingForNextShotTime < CurTime()) then
                                controller.IGuessWeAreAiming = true
                                controller.sniper_preparingForNextShotTime = CurTime() + math.Rand(0.74, 6.38)
                            end
                        else
                            if (controller.sniper_preparingForNextShotTime < CurTime()) then
                                buttons = buttons + IN_ATTACK

                                controller.IGuessWeAreAiming = false
                                controller.sniper_preparingForNextShotTime = CurTime() + math.Rand(0.4, 1.11)
                            end
                        end
                    end
                end
            else -- Physgun behaviour
                local prop = controller.Physgun_TargetProp
                if (IsValid(prop)) then
                    if (prop:IsPlayerHolding()) then
                        local plytarget = util.TraceLine( { start = bot:EyePos(), endpos = target:EyePos(), filter = {prop, target}, mask = MASK_SOLID } )


                        if (controller:CanSee(target, true) and !plytarget.Hit) then
                            buttons = buttons + IN_ATTACK
                        end
                    end
                end
            end
        else -- Melees

            if (bot:GetPos():DistToSqr( target:GetPos() ) < 7763) then
                if (math.random(1, 2) == 2) then
                    buttons = buttons + IN_ATTACK
                end
            end


            -- Random jumps (To make it harder to be hit if the target has a possible weapon and to walk fast)
            if (math.random(1, 70) == 15) then
                controller.NextJump = 0
            end
        end
    else
    end


    -- Weapon physgun behaviour
    if (isPhysgun) then
        -- Look for objects if we don't have one.
        if (!IsValid(controller.Physgun_TargetProp)) then


            if (controller.Physgun_NextLookForProp < CurTime()) then

                controller.Physgun_NextLookForProp = CurTime() + math.Rand(0.86, 2.75)

                local FoundProps = {}

                -- Looking for prop entities
                local props = ents.FindInSphere( bot:GetPos(), 2048 )
                for _, prop in ipairs(props) do

                    if (prop:GetClass() == "prop_physics") then
                        if (!prop:IsPlayerHolding()) then
                            FoundProps[#FoundProps + 1] = prop
                        end
                    end
                end


                -- Check if size of array FoundProps is higher than 0
                if (#FoundProps > 0) then
                    -- Pick a random one of the found props
                    local pick = math.random(1, #FoundProps)


                    -- Target the prop
                    controller.Physgun_TargetProp = FoundProps[ pick ]
                    controller.Physgun_TargetPropGiveUpTimer = CurTime() + math.Rand(2.44, 8.26)
                end
            end
        else
            local targetprop = controller.Physgun_TargetProp


            if (!targetprop:IsPlayerHolding()) then
                controller:CSetGoal(targetprop:GetPos())

                controller.IgnoreTarget = true

                -- Look at the prop
                controller.LookAt = (targetprop:GetPos() - bot:GetShootPos()):Angle()
                controller.LookAtTime = CurTime() + 1

                -- Check distance till we are close enough to get it
                if (bot:GetPos():DistToSqr(targetprop:GetPos()) < 8000) then

                    buttons = buttons + IN_ATTACK2
                end

                -- Timer till we give up trying to get that prop
                if (controller.Physgun_TargetPropGiveUpTimer < CurTime()) then
                    controller.Physgun_TargetProp = nil
                end
            else
                controller.IgnoreTarget = false

                -- Keep doing it every frame while we are holding it, incase if we accidentally loose it because of a wall or something so we still have it targetted to try to get it again.
                controller.Physgun_TargetPropGiveUpTimer = CurTime() + math.Rand(3.44, 6.26)

            end
        end
    end

    -- Climbing ladders
    if bot:GetMoveType() == MOVETYPE_LADDER then
        local pos = controller.goalPos
        local ang = ((pos + bot:GetCurrentViewOffset()) - bot:GetShootPos()):Angle()

        if pos.z > controller:GetPos().z then
            controller.LookAt = Angle(-30, ang.y, 0)
        else
            controller.LookAt = Angle(30, ang.y, 0)
        end

        controller.LookAtTime = CurTime() + 0.1
        controller.NextJump = -1
        buttons = buttons + IN_FORWARD
    end


    if (shouldmove) then
        if controller.NextDuck > CurTime() then
            if (math.random(1, 65) ~= 34) then
                buttons = buttons + IN_DUCK
            end
        elseif controller.NextJump <= 0 then
            controller.NextJump = CurTime() + 1

            if (math.random(1, 65) ~= 34) then
                buttons = buttons + IN_JUMP
            end
        end

        -- Crouch jump
        if !bot:IsOnGround() and controller.NextJump > CurTime() then
            buttons = buttons + IN_DUCK
        end
    end


    -- Check interactive/destroyable objects on our path.
    local dt = util.QuickTrace(bot:EyePos(), bot:GetForward() * 45, bot)

    if IsValid(dt.Entity) then
        local class = dt.Entity:GetClass()


        if (!IsValid(target)) then
            if (class == "prop_physics" or class == "func_breakable_surf") then -- Destroy
                if (!isPhysgun) then
                    -- Force use of melee to not waste ammo
                    controller.nextWeaponSwitch = CurTime() + 1
                    controller.holdingWeapon = controller.defaultMeleeWeapon

                    weaponUpdate = true

                    buttons = buttons + IN_ATTACK
                end
            elseif (class == "prop_door_rotating" or class == "func_door_rotating") then -- Interact

                if (math.random(1, 24) == 14) then
                    buttons = buttons + IN_USE
                end

                controller.nextRandomLook = CurTime() + 1
            end
        end
    end 


    -------------------------------------------------------------------------------------------
    -- Selecting weapons behaviour

    -- Timer to switch weapons
    --local weaponlist = {"weapon_smg1", "weapon_357", "weapon_shotgun", "weapon_pistol", "weapon_crossbow", "weapon_ar2", "weapon_frag"}

    if (botweapons == "_hl2") then
        botweapons = "weapon_smg1,weapon_357,weapon_shotgun,weapon_pistol,weapon_crossbow,weapon_ar2,weapon_frag"
        --botweapons = "weapon_p228,weapon_m4a1,weapon_smokegrenade,weapon_m3,weapon_xm1014,weapon_m249,weapon_awp,weapon_mp5navy,weapon_ump45,weapon_sg550,weapon_tmp,weapon_deagle,weapon_scout,weapon_sg552,weapon_usp,weapon_mac10,weapon_galil,weapon_hegrenade,weapon_flashbang,weapon_fiveseven,weapon_p90,weapon_g3sg1,weapon_ak47,weapon_famas,weapon_aug,weapon_glock,weapon_elite,weapon_frag,weapon_frag"
        --botweapons = "weapon_csgo_ak47,weapon_csgo_awp,weapon_csgo_elite,weapon_csgo_m4a1,weapon_csgo_ssg08,weapon_csgo_m4a1_silencer,weapon_csgo_mp9,weapon_csgo_mp5sd,weapon_csgo_nova,weapon_csgo_sawedoff,weapon_csgo_bizon,weapon_csgo_deagle,weapon_csgo_g3sg1,weapon_csgo_p90,weapon_csgo_cz75a,weapon_csgo_p250,weapon_csgo_famas,weapon_csgo_glock,weapon_csgo_mp7,weapon_csgo_mag7,weapon_csgo_ump45,weapon_csgo_usp_silencer,weapon_csgo_xm1014,weapon_csgo_mac10,weapon_frag,weapon_frag"
    end

    --if (botweapons ~= "_hl2") then -- Custom weapons
        --weaponlist = table.Random(string.Split(botweapons, ","))
        weaponlist = string.Split(botweapons, ",")
    --end

    if (IsValid(botWeapon)) then
        if (botWeapon:GetClass() == "weapon_physgun") then
            --controller.nextWeaponSwitch = 0
        end
    end

    if (controller.nextWeaponSwitch < CurTime() or controller.forceWeaponChange) then
        controller.nextWeaponSwitch = CurTime() + math.Rand(0.75, 37)


        if (math.random(1, 5) >= 2 or controller.forceWeaponChange) then
            local pick = math.random(1, #weaponlist)

            weaponUpdate = true

            controller.holdingWeapon = weaponlist[pick]

            controller.forceWeaponChange = false


            -- Check if we have this weapon on us, if not, try to give it to us then.
            if (!bot:HasWeapon(controller.holdingWeapon)) then
                bot:Give(controller.holdingWeapon)
            end
        end
    end

    --bot:SelectWeapon((IsValid(controller.Target) and controller.Target:GetPos():DistToSqr(controller:GetPos()) < 129000 and "weapon_shotgun") or "weapon_smg1")
    --bot:SelectWeapon(currentWeapon)


    if (weaponUpdate) then
        local keep = false
        local oldwp

        if (!bot:IsBot()) then
            if (GetConVar("leadbot_keepWeapon"):GetBool()) then
                keep = true
                oldwp = bot:GetActiveWeapon()
            end
        end

        local currentWeapon = controller.holdingWeapon
        bot:SelectWeapon(currentWeapon)

        if (keep) then
            bot:SelectWeapon(oldwp)
        end

        typeofweapon = bot:GetActiveWeapon():GetHoldType()

        if (typeofweapon == "grenade" and !keep) then
            controller.nextWeaponSwitch = CurTime() + math.Rand(0.55, 0.75)
        end
    end

    cmd:ClearButtons()
    cmd:ClearMovement()
    cmd:SetButtons(buttons)


    if (!shouldmove) then 
        cmd:ClearButtons() 
        cmd:ClearMovement() 
    end
end

function LeadBot.PlayerMove(bot, cmd, mv)
    local shouldthink = !GetConVar("leadbot_stop"):GetBool()
    local shouldmove = GetConVar("leadbot_move"):GetBool()

    if (!shouldthink) then 
        return 
    end

    local controller = bot.ControllerBot
    local buttons = cmd:GetButtons()

    local weapon = bot:GetActiveWeapon()
    local holdtype = ""

    if (IsValid(weapon)) then
        holdtype = weapon:GetHoldType()
    end

    if (!IsValid(controller)) then
        bot.ControllerBot = ents.Create("leadbot_navigator")
        bot.ControllerBot:Spawn()
        bot.ControllerBot:SetOwner(bot)
        controller = bot.ControllerBot
    end

    --[[local min, max = controller:GetModelBounds()
    debugoverlay.Box(controller:GetPos(), min, max, 0.1, Color(255, 0, 0, 0), true)]]

    -- force a recompute
    if controller.PosGen and controller.P and controller.TPos ~= controller.PosGen then
        controller.TPos = controller.PosGen
        controller.P:Compute(controller, controller.PosGen)
    end

    if controller:GetPos() ~= bot:GetPos() then
        controller:SetPos(bot:GetPos())
    end

    if controller:GetAngles() ~= bot:EyeAngles() then
        controller:SetAngles(bot:EyeAngles())
    end

    mv:SetForwardSpeed(1200)

    if (!IsValid(controller.Target) or controller.ForgetTarget < CurTime() or controller.Target:Health() <= 0)  then
        controller.Target = nil
    end

    if !IsValid(controller.Target) then
        local possibleTargets = {}


        -- NPC and player version of targetting (Uses and can eat a lot of FPS too than just targetting the players)
        --[[
        local _en = ents.FindInSphere( bot:GetPos(), 2048 )
        for _, ply in ipairs(_en) do
            if (IsValid(ply)) then
                if (controller:CanSee(ply)) then
                    if ((ply:IsPlayer() and (ply:Team() ~= bot:Team())) or (ply:IsNPC())) then
                        possibleTargets[#possibleTargets + 1] = ply
                    end
                end
            end
        end
        --]]

        -- Only players
        for _, ply in ipairs(player.GetAll()) do
            --if ply ~= bot and ((ply:IsPlayer() and (!LeadBot.TeamPlay or (LeadBot.TeamPlay and (ply:Team() ~= bot:Team())))) or ply:IsNPC()) and ply:GetPos():DistToSqr(bot:GetPos()) < 2250000 then
            if (ply ~= bot and ply:Team() ~= bot:Team() and ply:GetPos():DistToSqr(bot:GetPos()) < 2250000) then
                --local targetpos = ply:EyePos() - Vector(0, 0, 10)
                --local trace = util.TraceLine({
                    --start = bot:GetShootPos(),
                    --endpos = targetpos,
                    --filter = function(ent) return ent == ply end
                --})

                if (ply:Alive() and controller:CanSee(ply)) then
                    possibleTargets[#possibleTargets + 1] = ply

                    --controller.Target = ply
                    --controller.ForgetTarget = CurTime() + 2
                end
            end
        end

        -- Pick target
        if (#possibleTargets > 0) then
            local pickt = math.random(1, #possibleTargets)

            --controller.Target = possibleTargets[pickt]
            --controller.ForgetTarget = CurTime() + 2

            controller:CSetTarget(possibleTargets[ pickt ])
            controller.LookAt = controller.movingAngle

            controller.canSeeTarget = true
        end
    elseif controller.ForgetTarget < CurTime() and controller:CanSee(controller.Target) then
        controller.ForgetTarget = CurTime() + 2.11

        controller.canSeeTarget = false
    end

    -- eyesight
    local lerp = FrameTime() * math.random(8, 20)
    local lerpc = FrameTime() * 8

    if !LeadBot.LerpAim then
        lerp = 1
        lerpc = 1
    end

    --local dt = util.QuickTrace(bot:EyePos(), bot:GetForward() * 45, bot)

    --if IsValid(dt.Entity) and dt.Entity:GetClass() == "prop_door_rotating" then
        --dt.Entity:Fire("OpenAwayFrom", bot, 0)
    --end
    local isSniper = holdtype == "crossbow"

    local forceSpeed = false
    local forceSpeedVal = 0

    local target = controller.Target
    local hastarget = IsValid(target)
    local targetignore = controller.IgnoreTarget
    if targetignore then hastarget = false end

    if (shouldmove) then
        if (!hastarget and (!controller.PosGen or bot:GetPos():DistToSqr(controller.PosGen) < 1000 or controller.LastSegmented < CurTime())) then
            -- find a random spot on the map, and in 10 seconds do it again!
            --local navs = navmesh.Find(bot:GetPos(), 185341, 1000, 1000)
            
            --if (#navs > 0) then
                --local navpicked = math.random(1, #navs)

                --controller.PosGen = navs [ navpicked ]:GetCenter()
            -- controller.LastSegmented = CurTime() + 10
            --end

            controller.PosGen = controller:FindSpot("random", {pos = bot:GetPos(), radius = 8311, stepup = 400, stepdown = 2100})
            --controller.PosGen = controller:FindSpot("random", {pos = bot:GetPos(), radius = 92311, stepup = 1000, stepdown = 1000})
            --controller.PosGen = controller:FindSpot("random", {pos = bot:GetPos(), radius = 72311})
            
            controller.LastSegmented = CurTime() + 10
        elseif (hastarget) then
            if (!GetIsMelee(weapon)) then
                local gooddistance = 90000
                local sniperdistance = 87333 -- Distance to not make the sniper try to aim and kill



                -- move to our target
                local distance = target:GetPos():DistToSqr( bot:GetPos() )
                controller.PosGen = target:GetPos()

                -- back up if the target is really close
                -- TODO: find a random spot rather than trying to back up into what could just be a wall
                -- something like controller.PosGen = controller:FindSpot("random", {pos = bot:GetPos() - bot:GetForward() * 350, radius = 1000})?
                if distance <= gooddistance then
                    mv:SetForwardSpeed(-1200)
                end

                if (isSniper) then
                    if (controller.canSeeTarget and controller.IGuessWeAreAiming) then
                        if (distance > sniperdistance) then
                            mv:SetForwardSpeed(0)

                            forceSpeed = true
                            forceSpeedVal = 0
                        end
                    end
                end
            else

                local pos = target:GetPos()

                pos.z = pos.z - 20

                -- move to our target
                controller.PosGen = pos
            end
        end
    end

    -- Look angle extra
    --[[

    -- Dancing bots
    controller.lookAngleExtra = Vector(
        math.sin(controller.FrameCounter * 0.11) / 8,
        math.sin(controller.FrameCounter * 0.75) / 9,
        math.cos(controller.FrameCounter * 0.23) / 6
    ):Angle()

    -- Funny bots nodding as yes with their head
    controller.lookAngleExtra = Angle(
        math.sin(controller.FrameCounter / 4.11) * 8.12,
        math.sin(controller.FrameCounter / 6.75) * 0.75,
        math.cos(controller.FrameCounter / 8.23) * 3.23
    )   
    --]]
    controller.lookAngleExtra = Angle(
        math.sin(controller.FrameCounter / 35.11) * 0.52,
        math.sin(controller.FrameCounter / 35.75) * 0.45,
        math.cos(controller.FrameCounter / 35.23) * 0.33
    )   


    controller.FrameCounter = controller.FrameCounter + 1
    if (controller.FrameCounter >= 100000) then
        controller.FrameCounter = 0
    end

    -- When has no targets
    local mva = controller.movingAngle
    if (!hastarget) then

        -- Random looking into a direction
        if (controller.nextRandomLook < CurTime()) then
            

            controller.nextRandomLook = CurTime() + math.Rand(0.75, 8)

            if (math.random(1, 5) >= 2) then
                controller.isLookingToDirection = true

                if (math.random(1, 5) >= 3) then -- Random direction
                    controller.lookAngle = Angle( math.random(-40, 40), math.random(0, 360), math.random(0, 360) )
                else -- Checking our backs instead of a random direction
                    local nangle = bot:EyeAngles()

                    nangle.x = nangle.x + math.random(-10, 10)
                    nangle.y = nangle.y + math.random(170, 190)
                    nangle.z = nangle.z + math.random(-10, 10)

                    controller.lookAngle = nangle
                end

                controller.stopLookingTimer = CurTime() + math.Rand(0.14, 2.42)
            end
        end

        if (controller.isLookingToDirection) then
            mva = controller.lookAngle

            if (controller.stopLookingTimer < CurTime()) then
                controller.isLookingToDirection = false

            end
        end

        -- Facing
        if (controller.LookAtTime > CurTime()) then
            local ang = LerpAngle(lerpc, bot:EyeAngles(), controller.LookAt + controller.lookAngleExtra)
            bot:SetEyeAngles(Angle(ang.p, ang.y, 0))
        else
            local ang = LerpAngle(lerpc, bot:EyeAngles(), mva + controller.lookAngleExtra)
            bot:SetEyeAngles(Angle(ang.p, ang.y, 0))
        end
    else -- When has targets
        local ptv = controller.Target:EyePos()


        ptv.z = ptv.z - 8

        --local dist = controller.viewVpos

        --ptv.z = ptv.z + dist/2

        local ang = (ptv - bot:GetShootPos()):Angle() + controller.lookAngleExtra
        --controller.LookAt.x = controller.LookAt.x + ((ang.x - controller.LookAt.x ) * 4)
        --controller.LookAt.y = controller.LookAt.y + ((ang.y - controller.LookAt.y ) * 4)
        --controller.LookAt.z = controller.LookAt.z + ((ang.z - controller.LookAt.z ) / 4)

        bot:SetEyeAngles(LerpAngle(lerp, bot:EyeAngles(), ang))
        --bot:SetEyeAngles(LerpAngle(lerp, bot:EyeAngles(), (ptv - bot:GetShootPos()):Angle() + controller.lookAngleExtra))
    end

    -- movement also has a similar issue, but it's more severe...
    if !controller.P then
        return
    end

    local segments = controller.P:GetAllSegments()

    if !segments then return end

    local cur_segment = controller.cur_segment
    local curgoal = segments[cur_segment]

    -- got nowhere to go, why keep moving?
    if !curgoal then
        mv:SetForwardSpeed(0)

        --[[
        if (hastarget) then


            -- Aim towards target
            if (hastarget) then

                local ptv = controller.Target:EyePos()

                mv:SetMoveAngles((ptv - bot:EyePos()):Angle())

                ptv.z = ptv.z - 8

                bot:SetEyeAngles(LerpAngle(lerp, bot:EyeAngles(), (ptv - bot:GetShootPos()):Angle()))
            else
        end
        --]]
        return
    end

    -- think every step of the way!
    if segments[cur_segment + 1] and Vector(bot:GetPos().x, bot:GetPos().y, 0):DistToSqr(Vector(curgoal.pos.x, curgoal.pos.y)) < 100 then
        controller.cur_segment = controller.cur_segment + 1
        curgoal = segments[controller.cur_segment]
    end

    local goalpos = curgoal.pos

    -- waaay too slow during gamplay
    --[[if bot:GetVelocity():Length2DSqr() <= 225 and controller.NextCenter == 0 and controller.NextCenter < CurTime() then
        controller.NextCenter = CurTime() + math.Rand(0.5, 0.65)
    end

    if controller.NextCenter ~= 0 and controller.NextCenter < CurTime() then
        if bot:GetVelocity():Length2DSqr() <= 225 then
            controller.strafeAngle = ((controller.strafeAngle == 1 and 2) or 1)
        end

        controller.NextCenter = 0
    end]]

    if bot:GetVelocity():Length2DSqr() <= 225 then
        if controller.NextCenter < CurTime() then
            controller.strafeAngle = ((controller.strafeAngle == 1 and 2) or 1)
            --controller.NextCenter = CurTime() + math.Rand(0.3, 0.65)
            controller.NextCenter = CurTime() + math.Rand(0.2, 0.31)
        elseif controller.nextStuckJump < CurTime() then
            if !bot:Crouching() then
                controller.NextJump = 0
            end
            controller.nextStuckJump = CurTime() + math.Rand(1, 2)
        end
    end

    if controller.NextCenter > CurTime() then
        if controller.strafeAngle == 1 then
            mv:SetSideSpeed(1500)
        elseif controller.strafeAngle == 2 then
            mv:SetSideSpeed(-1500)
        else
            mv:SetForwardSpeed(-1500)
        end
    end

    -- Area
    local area_att = curgoal.area:GetAttributes()

    -- jump
    if controller.NextJump ~= 0 and curgoal.type > 1 and controller.NextJump < CurTime() or area_att == NAV_MESH_JUMP then
        controller.NextJump = 0
    end

    -- duck
    if area_att == NAV_MESH_CROUCH then
        controller.NextDuck = CurTime() + 0.1
    end

    controller.goalPos = goalpos

    --if GetConVar("developer"):GetBool() then
        --controller.P:Draw()
    --end

    local mva = ((goalpos + bot:GetCurrentViewOffset()) - bot:GetShootPos()):Angle()

    mv:SetMoveAngles(mva)

    if (forceSpeed) then
        --print("Mom, I'm just testing if this is actually working")

        mv:SetForwardSpeed(forceSpeedVal)
    end


    -- Should bots move?
    if (!shouldmove) then
        mv:SetForwardSpeed(0)
        mv:SetSideSpeed(0)

        buttons = IN_CANCEL

        cmd:ClearButtons()
        cmd:ClearMovement()
    end


    -- Memorize moving angles
    controller.movingAngle = mva

    -- Aim towards target
    --[[
    if (hastarget) then
        local ptv = controller.Target:EyePos()


        ptv.z = ptv.z - 8

        --local dist = controller.viewVpos

        --ptv.z = ptv.z + dist/2

        bot:SetEyeAngles(LerpAngle(lerp, bot:EyeAngles(), (ptv - bot:GetShootPos()):Angle()))
    else -- When has no targets

        -- Random looking into a direction
        if (controller.nextRandomLook < CurTime()) then
            

            controller.nextRandomLook = CurTime() + math.Rand(0.75, 11)

            if (math.random(1, 5) >= 2) then
                controller.isLookingToDirection = true

                if (math.random(1, 5) >= 8) then -- Random direction
                    controller.lookAngle = Angle( math.random(-40, 40), math.random(0, 360), math.random(0, 360) )
                else -- Checking our backs instead of a random direction
                    local nangle = bot:EyeAngles()

                    nangle.x = nangle.x + math.random(-10, 10)
                    nangle.y = nangle.y + math.random(170, 190)
                    nangle.z = nangle.z + math.random(-10, 10)

                    controller.lookAngle = nangle
                end

                controller.stopLookingTimer = CurTime() + math.Rand(0.14, 2.42)
            end
        end

        if (controller.isLookingToDirection) then
            mva = controller.lookAngle

            if (controller.stopLookingTimer < CurTime()) then
                controller.isLookingToDirection = false

            end
        end

        if controller.LookAtTime > CurTime() then
            local ang = LerpAngle(lerpc, bot:EyeAngles(), controller.LookAt)
            bot:SetEyeAngles(Angle(ang.p, ang.y, 0))
        else
            local ang = LerpAngle(lerpc, bot:EyeAngles(), mva)
            bot:SetEyeAngles(Angle(ang.p, ang.y, 0))
        end
    end
    --]]
end

function GetIsMelee(wp)
    if !IsValid(wp) then

        return false

    end

    local holdtype = wp:GetHoldType()
    return holdtype == "melee" or holdtype == "knife" or holdtype == "fist" or holdtype == "melee2"
end

function BotSay(ply, msg, onlyTeam)
    if (!GetConVar("thiagobot_chat"):GetBool()) then return end
    if (onlyTeam == nil) then onlyTeam = true end


    ply:Say(msg, onlyTeam)

    return true
end
function BotSwitchWeapons(ply, wp)


end

--[[ HOOKS ]]--

hook.Add("PlayerDisconnected", "LeadBot_Disconnect", function(bot)
    if IsValid(bot.ControllerBot) then
        bot.ControllerBot:Remove()
    end
end)

hook.Add("SetupMove", "LeadBot_Control", function(bot, mv, cmd)
    if bot:IsLBot() then
        LeadBot.PlayerMove(bot, cmd, mv)
    end
end)

hook.Add("StartCommand", "LeadBot_Control", function(bot, cmd)
    if bot:IsLBot() then
        LeadBot.StartCommand(bot, cmd)
    end
end)

hook.Add("PostPlayerDeath", "LeadBot_Death", function(bot)
    if bot:IsLBot() then
        LeadBot.PostPlayerDeath(bot)
    end
end)

hook.Add("EntityTakeDamage", "LeadBot_Hurt", function(ply, dmgi)
    local bot = dmgi:GetAttacker()
    local hp = ply:Health()
    local dmg = dmgi:GetDamage()

    if IsValid(ply) and ply:IsPlayer() and ply:IsLBot() then
        LeadBot.PlayerHurt(ply, bot, hp, dmg)
    end
end)

hook.Add("Think", "LeadBot_Think", function()
    LeadBot.Think()
end)

hook.Add("PlayerSpawn", "LeadBot_Spawn", function(bot)
    if bot:IsLBot() then
        LeadBot.PlayerSpawn(bot)
    end
end)

--[[ META ]]--

local player_meta = FindMetaTable("Player")
local oldInfo = player_meta.GetInfo

function player_meta.IsLBot(self, realbotsonly)
    if realbotsonly == true then
        return self.LeadBot and self:IsBot() or false
    end

    return self.LeadBot or false
end

function player_meta.LBGetStrategy(self)
    if self.LeadBot_Config then
        return self.LeadBot_Config[4]
    else
        return 0
    end
end

function player_meta.LBGetModel(self)
    if self.LeadBot_Config then
        return self.LeadBot_Config[1]
    else
        return "kleiner"
    end
end

function player_meta.LBGetColor(self, weapon)
    if self.LeadBot_Config then
        if weapon == true then
            return self.LeadBot_Config[3]
        else
            return self.LeadBot_Config[2]
        end
    else
        return Vector(0, 0, 0)
    end
end

function player_meta.GetInfo(self, convar)
    if self:IsBot() and self:IsLBot() then
        if convar == "cl_playermodel" then
            return self:LBGetModel() --self.LeadBot_Config[1]
        elseif convar == "cl_playercolor" then
            return self:LBGetColor() --self.LeadBot_Config[2]
        elseif convar == "cl_weaponcolor" then
            return self:LBGetColor(true) --self.LeadBot_Config[3]
        else
            return ""
        end
    else
        return oldInfo(self, convar)
    end
end

function player_meta.GetController(self)
    if self:IsLBot() then
        return self.ControllerBot
    end
end