--!strict
-- Types
local Types = require(script.Parent.Types)
local Config = {} :: Types.ConfigType

-- Game Services
local RS = game:GetService("ReplicatedStorage")

-- Brawler Animations
local BrawlerAnimations = RS.Assets.Animations.Brawler

-- Brawler SFX
local NormalStrike = RS.Assets.SFX.Fighters.Brawler.Normal
local HeavyStrike = RS.Assets.SFX.Fighters.Brawler.Heavy

Config.FighterConfig = {
	Animations = {
		BrawlerAnimations.M1One,
		BrawlerAnimations.M1Two,
		BrawlerAnimations.M1Three,
	},
	SFX = { Normal = NormalStrike, Heavy = HeavyStrike },
	Damage = { Normal = 3, Heavy = 8 },
	MaxComboCount = 3,
	HitboxType = "Box", -- Box for Brawler,
	CreateHitbox = function(player: Player, isHitboxChecked: boolean)
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart

		local hitboxCFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -2.5)
		local hitboxSize = Vector3.new(5, 5, 2)

		local overlapParams = OverlapParams.new()
		overlapParams.ExcludeInstances = { character } -- excludes the attacker's character from the hitbox

		if isHitboxChecked then
			local hitbox = Instance.new("Part")
			hitbox.Size = hitboxSize
			hitbox.Color = Color3.new(1, 0, 0)
			hitbox.Transparency = 0.8
			hitbox.CFrame = hitboxCFrame
			hitbox.CanCollide = false
			hitbox.Anchored = true
			hitbox.Parent = workspace

			task.delay(0.35, function()
				hitbox:Destroy()
			end)
		end

		local hitboxParts = workspace:GetPartBoundsInBox(hitboxCFrame, hitboxSize, overlapParams)
		local humanoids: { Humanoid } = {}

		for _, part in hitboxParts do
			local model = part:FindFirstAncestorOfClass("Model")
			if not model then
				continue
			end

			local humanoid = model:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				continue
			end

			-- prevents a single attack from dealing damage multiple times
			if table.find(humanoids, humanoid) then
				continue
			end
			table.insert(humanoids, humanoid)
		end

		return humanoids
	end,
}

return Config
