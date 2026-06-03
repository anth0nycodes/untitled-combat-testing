--!strict

-- TODO: Swap out slayer animation assets for the actual slayer animations once they are done

-- Types
local Types = require(script.Parent.Types)
local Config = {} :: Types.ConfigType

-- Game Services
local RS = game:GetService("ReplicatedStorage")

-- Slayer Animations
local SlayerAnimations = RS.Assets.Animations.Slayer

-- Slayer SFX
local NormalSlice = RS.Assets.SFX.Fighters.Slayer.Normal
local HeavySlice = RS.Assets.SFX.Fighters.Slayer.Heavy

Config.FighterConfig = {
	Animations = {
		SlayerAnimations.M1One,
		SlayerAnimations.M1Two,
		SlayerAnimations.M1Three,
	},
	SFX = { Normal = NormalSlice, Heavy = HeavySlice },
	Damage = { Normal = 3, Heavy = 8 },
	MaxComboCount = 3,
	HitboxType = "Weapon", -- Weapon for Slayer
	-- Make actual slayer hitbox later
	CreateHitbox = function(player: Player, isHitboxChecked: boolean)
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart

		local hitboxCFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -2.5)
		local hitboxSize = Vector3.new(10, 10, 10)

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
