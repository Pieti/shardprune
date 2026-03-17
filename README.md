# ShardPrune

Simple WoW Classic (Anniversary / TBC) addon to prune soul shards down to a target count.

## Features

* Deletes one soul shard per keypress (compliant with Blizzard restrictions)
* Configurable shard limit
* Designed for use with spam keybind or mouse wheel

## Usage

Set max shards:

```
/shardprune 3
```

Delete one shard (if above limit):

```
/shardprune
```

Check status:

```
/shardprune status
```

## Recommended Bind

Bind `/shardprune` to:

* Shift + Mouse Wheel (best UX)
* or any repeatable key

## Notes

Due to Blizzard API restrictions, only one shard can be deleted per hardware event.
