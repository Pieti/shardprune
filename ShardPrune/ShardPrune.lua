local SOUL_SHARD_ID = 6265
local maxShards = 10

local addonName = "ShardPrune"

local function Msg(text)
	print("|cffff6600" .. addonName .. ":|r " .. text)
end

local function IsSoulShardBag(bag)
	if bag == 0 then
		return false
	end

	local family = C_Container.GetContainerNumFreeSlots(bag)
	if not family then
		return false
	end

	local _, bagFamily = C_Container.GetContainerNumFreeSlots(bag)
	return bagFamily == 8
end

local function GetShardSlots(includeShardBags)
	local slots = {}

	for bag = 0, 4 do
		local isShardBag = IsSoulShardBag(bag)

		if includeShardBags or not isShardBag then
			local numSlots = C_Container.GetContainerNumSlots(bag)
			for slot = 1, numSlots do
				if C_Container.GetContainerItemID(bag, slot) == SOUL_SHARD_ID then
					slots[#slots + 1] = { bag = bag, slot = slot }
				end
			end
		end
	end

	return slots
end

local function GetTotalShardCount()
	return #GetShardSlots(true)
end

local function GetPrunableShardSlots()
	return GetShardSlots(false)
end

local function PruneOneShard()
	if CursorHasItem() then
		ClearCursor()
	end

	local totalShards = GetTotalShardCount()
	if totalShards <= maxShards then
		return false
	end

	local prunableShards = GetPrunableShardSlots()
	local prunableCount = #prunableShards

	if prunableCount == 0 then
		Msg("Over the limit, but all extra shards are in soul shard bags.")
		return false
	end

	local target = prunableShards[prunableCount]

	C_Container.PickupContainerItem(target.bag, target.slot)

	if not CursorHasItem() then
		return false
	end

	DeleteCursorItem()

	if CursorHasItem() then
		ClearCursor()
		Msg("Delete was blocked. Use the bind again.")
		return false
	end

	return true, totalShards - 1
end

SLASH_SHARDPRUNE1 = "/shardprune"
SlashCmdList["SHARDPRUNE"] = function(msg)
	msg = (msg or ""):lower():match("^%s*(.-)%s*$")

	if msg == "status" then
		Msg("Keeping up to " .. maxShards .. " shard(s). You have " .. GetTotalShardCount() .. " total.")
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
		Msg("Deleted 1 shard. " .. remaining .. " total remaining.")
	end
end
