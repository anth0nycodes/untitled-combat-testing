--!strict
-- Gradually regenerates the Humanoid's Health over time.
local REGEN_RATE = 0.25 / 100 -- Regenerate this fraction of MaxHealth per second.
local REGEN_STEP = 1 -- Wait this long between each regeneration step.
local character = script.Parent
local humanoid = character:WaitForChild("Humanoid") :: Humanoid

while true do
	while humanoid.Health < humanoid.MaxHealth do
		local dt = task.wait(REGEN_STEP)
		local dh = dt * REGEN_RATE * humanoid.MaxHealth
		humanoid.Health = math.min(humanoid.Health + dh, humanoid.MaxHealth)
	end
	humanoid.HealthChanged:Wait() -- Yields indefinitely until health changes again (like taking damage)
end
