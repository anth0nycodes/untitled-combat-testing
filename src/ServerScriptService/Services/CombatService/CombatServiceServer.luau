--!strict
local CombatServiceServer = {}

-- Game Services
local RS = game:GetService("ReplicatedStorage")

-- Fighter Config
local Fighters = RS.Shared.Fighters
local fighter = Fighters.Brawler -- Default to Brawler for now, can change later when implementing fighter selection logic
local fighterConfigModule = require(fighter)
local fighterConfig = fighterConfigModule.FighterConfig

-- Remotes
local AttackRemote = RS.Remotes.AttackRemote

function CombatServiceServer.Init()
	AttackRemote.OnServerEvent:Connect(function(player: Player, combo: number, isHitboxChecked: boolean)
		local DAMAGE = if combo == fighterConfig.MaxComboCount
			then fighterConfig.Damage.Heavy
			else fighterConfig.Damage.Normal
		local humanoids = fighterConfig.CreateHitbox(player, isHitboxChecked)

		if not humanoids then
			return
		end

		for _, humanoid in humanoids do
			if humanoid.Health <= 0 then
				continue
			end
			humanoid:TakeDamage(DAMAGE)
		end
	end)
end

return CombatServiceServer
