local SOUL_SHARD_ID = 6265
local maxShards = 3

local addonName = "ShardPrune"

local function Msg(text)
	print("|cffff6600" .. addonName .. ":|r " .. text)
end

local function GetShardSlots()
	local slots = {}

	for bag = 0, 4 do
		local numSlots = C_Container.GetContainerNumSlots(bag)
		for slot = 1, numSlots do
			if C_Container.GetContainerItemID(bag, slot) == SOUL_SHARD_ID then
				slots[#slots + 1] = { bag = bag, slot = slot }
			end
		end
	end

	return slots
end

local function GetShardCount()
	return #GetShardSlots()
end

local function PruneOneShard()
	if CursorHasItem() then
		ClearCursor()
	end

	local shardSlots = GetShardSlots()
	local total = #shardSlots

	if total <= maxShards then
		return false
	end

	-- Delete the last shard found
	local target = shardSlots[total]

	C_Container.PickupContainerItem(target.bag, target.slot)

	if not CursorHasItem() then
		Msg("Could not pick up a shard.")
		return false
	end

	DeleteCursorItem()

	if CursorHasItem() then
		ClearCursor()
		Msg("Delete was blocked. Use the bind again.")
		return false
	end

	return true, total - 1
end

SLASH_SHARDPRUNE1 = "/shardprune"
SlashCmdList["SHARDPRUNE"] = function(msg)
	msg = (msg or ""):lower():match("^%s*(.-)%s*$")

	if msg == "status" then
		Msg("Currently keeping up to " .. maxShards .. " shard(s). You have " .. GetShardCount() .. ".")
		return
	end

	local n = tonumber(msg)
	if n then
		maxShards = math.max(0, math.floor(n))
		Msg("Max shards set to " .. maxShards .. ".")
		return
	end

	local deleted, remaining = PruneOneShard()
	if deleted then
		Msg("Deleted 1 shard. " .. remaining .. " remaining.")
	end
end
