	object_const_def
	const ROCKTUNNELB1F_POKE_BALL1
	const ROCKTUNNELB1F_POKE_BALL2
	const ROCKTUNNELB1F_POKE_BALL3

RockTunnelB1F_MapScripts:
	def_scene_scripts

	def_callbacks

RockTunnelB1FIron:
	itemball IRON

RockTunnelB1FPPUp:
	itemball PP_UP

RockTunnelB1FRevive:
	itemball REVIVE

RockTunnelB1FHiddenMaxPotion:
	hiddenitem MAX_POTION, EVENT_ROCK_TUNNEL_B1F_HIDDEN_MAX_POTION

RockTunnelB1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	; Kanto hack (M5 8e): Yellow's own B1F ladder coordinates, paired with
	; ROCK_TUNNEL_1F warps 5-8 in order (1F 5 <-> B1F 1, ... 1F 8 <-> B1F 4) --
	; vendor/pokeyellow/data/maps/objects/RockTunnelB1F.asm.  The objects,
	; items and wild table below are still Crystal's, and so is this map's
	; .blk: 8f re-cuts B1F on Yellow's geometry.
	; ⚠ UNTIL 8f LANDS THIS MAP IS A TRAP.  Crystal's blocks put a WALL under
	; (33,25) with four walled neighbours, so a player who takes 1F's ladder at
	; (37,3) arrives with nowhere to step and cannot re-trigger the warp
	; (a warp only fires on a $7x collision).  Do not cut a release from this
	; state; 8f fixes it by re-cutting the .blk.
	warp_event 33, 25, ROCK_TUNNEL_1F, 5
	warp_event 27,  3, ROCK_TUNNEL_1F, 6
	warp_event 23, 11, ROCK_TUNNEL_1F, 7
	warp_event  3,  3, ROCK_TUNNEL_1F, 8

	def_coord_events

	def_bg_events
	bg_event  4, 14, BGEVENT_ITEM, RockTunnelB1FHiddenMaxPotion

	def_object_events
	object_event  7, 25, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RockTunnelB1FIron, EVENT_ROCK_TUNNEL_B1F_IRON
	object_event  6, 17, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RockTunnelB1FPPUp, EVENT_ROCK_TUNNEL_B1F_PP_UP
	object_event 15,  2, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RockTunnelB1FRevive, EVENT_ROCK_TUNNEL_B1F_REVIVE
