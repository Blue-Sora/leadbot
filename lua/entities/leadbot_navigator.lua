if SERVER then AddCSLuaFile() end

ENT.Base = "base_nextbot"
ENT.Type = "nextbot"

function ENT:Initialize()
	if CLIENT then return end

	self:SetModel("models/player.mdl")
	self:SetNoDraw(!GetConVar("developer"):GetBool())
	self:SetSolid(SOLID_NONE)

	local fov_convar = GetConVar("leadbot_fov")

	self:SetFOV((fov_convar:GetBool() and math.Clamp(fov_convar:GetInt(), 75, 100)) or 90)
	self.PosGen = nil
	self.NextJump = -1
	self.NextDuck = 0
	self.cur_segment = 2
	self.Target = nil
	self.LastSegmented = 0
	self.ForgetTarget = 0
	self.NextCenter = 0
	self.LookAt = Angle(0, 0, 0)
	self.LookAtTime = 0
	self.goalPos = Vector(0, 0, 0)
	self.strafeAngle = 0
	self.nextStuckJump = 0

	-- Looking/aiming
	self.nextRandomLook = 1 -- Timer for the next randomized direction to look at.
	self.isLookingToDirection = false -- Boolean, when it supposed to be looking at a certain direction, if not then it'll be looking where it is moving to.
	self.lookAngle = Angle(0, 0, 0) -- Angle to where it is looking at.
	self.stopLookingTimer = 0 -- Timer till it stops looking into that randomized direction.

	self.aimExtraAngle = Angle(0, 0, 0)

	-- Random extra values for the aiming (Intended to make it more reallistic just like as a real player, similar to Counter-Strike: Source.)
	self.lookAngleExtra = Angle(0, 0, 0) -- Extra angle that increases lookAngle variable.
	self.lookAngleExtraSin = 0 -- Used to make a smooth very tiny move of the camera for more realism, notable when it's not moving that much.
	self.lookAngleExtraSinDifference = 0 -- Not really much important, it just makes it have a difference sin value by increasing the value above to make a difference between other players cuz' I'm dumb.

	-- Walking
	--self.walkFast = true -- Boolean, if true the bot will walk fast, otherwise false, not walk fast (sprint).
	self.nextWalkNormal = CurTime() + 1 -- Timer for the next walk normal to stop walking/spriting fast.
	self.startWalkingFastTimer = 0 -- Timer till it stops walking normally and then sprints again.
	self.movingAngle = Angle(0, 0, 0)
	self.WalkType = 0 -- 0 = Walk normal, 1 = Sprint, 2 = Walk very slowly

	-- Weapons
	self.nextWeaponSwitch = CurTime() + 0.1
	self.defaultMeleeWeapon = "weapon_pistol"
	self.holdingWeapon = self.defaultMeleeWeapon
	self.forceWeaponChange = true

	-- Melees
	self.defaultMeleeWeapon = "weapon_crowbar"

	-- View position
	self.viewVpos = 40

	-- Target
	self.isTargettable = true


	-- Chatting behaviours
	self.AllowedToChat = true -- Maybe we would want a specific bot to not chat...?

	self:CReset()

	if LeadBot.AddControllerOverride then
		LeadBot.AddControllerOverride(self)
	end
end

function ENT:ChasePos()
	self.P = Path("Follow")
	self.P:SetMinLookAheadDistance(10)
	self.P:SetGoalTolerance(20)
	self.P:Compute(self, self.PosGen)

	if !self.P:IsValid() then return end

	while self.P:IsValid() do
		if self.PosGen then
			self.P:Compute(self, self.PosGen)
			self.cur_segment = 2
		end

		coroutine.wait(1)
		coroutine.yield()
	end
end

function ENT:OnInjured()
	return false
end

function ENT:OnKilled()
	return false
end

function ENT:IsNPC()
	return false
end

function ENT:Health()
	return nil
end

function ENT:OnRemove()

end
-- remade this in lua so we can finally ignore the controller's bot
-- for some reason it's not really possible to overwrite IsAbleToSee
local function PointWithinViewAngle(pos, targetpos, lookdir, fov)
	pos = targetpos - pos
	local diff = lookdir:Dot(pos)
	if diff < 0 then return false end
	local len = pos:LengthSqr()
	return diff * diff > len * fov * fov
end

function ENT:InFOV(pos, fov)
	local owner = self:GetOwner()

	if IsEntity(pos) then
		-- we must check eyepos and worldspacecenter
		-- maybe in the future add more points

		if PointWithinViewAngle(owner:EyePos(), pos:WorldSpaceCenter(), owner:GetAimVector(), fov) then
			return true
		end

		return PointWithinViewAngle(owner:EyePos(), pos:EyePos(), owner:GetAimVector(), fov)
	else
		return PointWithinViewAngle(owner:EyePos(), pos, owner:GetAimVector(), fov)
	end
end

function ENT:CanSee(ply, fov)
	if ply:GetPos():DistToSqr(self:GetPos()) > self:GetMaxVisionRange() * self:GetMaxVisionRange() then
		return false
	end

	-- TODO: check fog farz and compare with distance

	-- half fov or something
	-- probably should move this to a variable
	fov = fov or true

	if fov and !self:InFOV(ply, math.cos(0.5 * (self:GetFOV() or 90) * math.pi / 180)) then
		return false
	end

	-- TODO: we really should check worldspacecenter too
	local owner = self:GetOwner()

	local p1v = ply:EyePos() + Vector( 0, 0, 24 )
	local p2v = owner:EyePos() + Vector( 0, 0, 24 )

	--local dist = self.viewVpos

	--p2v.z = p2v.z + dist
	--p1v.z = p1v.z + dist

	local line = util.TraceLine( { start = p1v, endpos = p2v, filter = {ply}, mask = MASK_SOLID } )

	--[[
	local targets = nil

	for _, v in pairs(ents.FindInSphere(line.HitPos, 10000)) do
		if (v:IsPlayer()) then
			targets = v

			return true
		end
	end

	--]]

	return !line.Hit

	--return util.QuickTrace(p2v, p1v - p2v, {owner, self}).Entity == ply
	--return util.QuickTrace(owner:EyePos(), ply:EyePos() - owner:EyePos(), {owner, self}).Entity == ply
end

function ENT:RunBehaviour()
	while (true) do
		if self.PosGen then
			self:ChasePos({})
		end

		coroutine.yield()
	end
end


function ENT:HRun(hk, args)
	local weGotTrue = false

	
	for i, h in ipairs(hk) do
		if h(args) then
			weGotTrue = true
		end
	end

	return weGotTrue
end

function ENT:CReset()

	-- Weapons
	self.nextWeaponSwitch = CurTime() + 0.1
	
	-- Battle behaviours
	self.battle_behaviourType = 0
	self.battle_nextBehaviourTime = CurTime() + 0.1

	-- Boolean
	self.canSeeTarget = false
	self.IGuessWeAreAiming = false

	-- Targetting
	self.target_timeToRealize = 0 -- This is the timer that takes the bot to realize that there might be an enemy right on our front and target them.
	self.target_timeToAim = 0 -- Timer that it takes to aim at the direction it saw the enemy when it weren't targetted and aimed before.
	self.Target = nil
	self.IgnoreTarget = false -- Boolean, should we ignore our attack even though we have it?

	self.LooseTargetTimer = 0

	-- Enemies
	self.lastSeenEnemiesPos = {}

	-- Counter
	self.FrameCounter = 0

	-- Following
	self.followingPlayer = nil
	self.followingPlayerDistance = 20110 -- Distance to be from the following player to not try to interrupt them.
	self.followingPlayerNextThink = 0 -- If follwoing a player, this will be the next think for us to "see" that they moved or changed positions, basically like a delay to notice that they moved for realism.
	self.followingPlayerNextPositionChange = 0 -- If the player is stopped, this will be the timer till we change positions from where we are waiting for them to move to another one close to them.

	-- Sniper
	self.sniper_preparingForNextShotTime = 0

	-- Chat
	self.ChatIsTyping = false

	------------------------------------------------------------------
	-- Navmesh
	------------------------------------------------------------------	
	self.NavTimerSinceCouldntFindNav = CurTime() -- Timer since we couldn't find a goal through nav.
	self.NavTimerSinceCouldntFindNavTimerToKill = 0 -- After reaching the timer since we couldn't find any navs, this will be the timer till we kill ourself.

	------------------------------------------------------------------
	-- Goal
	------------------------------------------------------------------	
	self.goalPos = Vector(0, 0, 0)
	self.LastSegmented = 0

	------------------------------------------------------------------
	-- Specific Weapons
	------------------------------------------------------------------	

	-- Physgun
	self.Physgun_TargetProp = nil -- Current prop that we wanna get
	self.Physgun_NextLookForProp = 0 -- Timer to look for near props to get so it doesn't have to do this every frame.
	self.Physgun_TargetPropGiveUpTimer = 0 -- Timer till it gives up after finding one and trying to get it


	hook.Run("LeadBot_OnBotNavigatorReset", bot, self)
	return true
end

function ENT:CSetTarget(target)


	self.Target = target
	self.ForgetTarget = CurTime() + 2


	hook.Run("LeadBot_OnBotTarget", self:GetOwner(), target)
end
function ENT:CLooseTarget()

	hook.Run("LeadBot_OnBotTargetLoose", self:GetOwner(), self.Target)

	self.Target = nil
	self.canSeeTarget = false
end

function ENT:CSetGoal(goalvec)
	self.PosGen = goalvec
	self.LastSegmented = CurTime() + 6
end
function ENT:GetTarget()

	return self.Target
end
function ENT:HasTarget()

	return IsValid(self.Target)
end

function ENT:FollowTarget( target, IfAlreadyKeep )

	if !IfAlreadyKeep then IfAlreadyKeep = false else IfAlreadyKeep = true end

	local IsAlreadyFollowing = IsValid( self.followingPlayer )

	if !IfAlreadyKeep and IsAlreadyFollowing then self:FollowStop() return end


	if IsValid( target ) then
		self.followingPlayer = target
	end
end
function ENT:FollowStop( target )

	self.followingPlayer = nil
end
function ENT:IsFollowingPlayer( ply )

	return IsValid( self.followingPlayer )
end
function ENT:FollowGetTarget()
	return self.followingPlayer
end