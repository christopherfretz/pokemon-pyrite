	object_const_def
	const ROCKTUNNEL1F_POKE_BALL1
	const ROCKTUNNEL1F_POKE_BALL2

RockTunnel1F_MapScripts:
	def_scene_scripts

	def_callbacks

RockTunnel1FElixer:
	itemball ELIXER

RockTunnel1FTMSteelWing:
	itemball TM_STEEL_WING

RockTunnel1FHiddenXAccuracy:
	hiddenitem X_ACCURACY, EVENT_ROCK_TUNNEL_1F_HIDDEN_X_ACCURACY

RockTunnel1FHiddenXDefend:
	hiddenitem X_DEFEND, EVENT_ROCK_TUNNEL_1F_HIDDEN_X_DEFEND

RockTunnel1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	; Kanto hack (M5 8d): both of ROCK TUNNEL's mouths are on ROUTE 10 in Yellow
	; -- (8,17) north and (8,53) south -- never on ROUTE 9, which is why 8c had
	; to delete Route 9's warp and park this one.  8d pairs them properly:
	; warp 1 <-> ROUTE_10 warp 2 (north mouth), warp 2 <-> ROUTE_10 warp 3
	; (south mouth).  Only the warp COORDINATES moved; every warp index is
	; unchanged, so ROCK_TUNNEL_B1F needed no edit.
	;
	; The north mouth sits on the LADDER at (27,3), not on the nearer
	; WARP_CARPET_DOWN at (15,3) (they swapped places with warp 5), because
	; COLL_WARP_CARPET_* is a *directional* warp (engine/overworld/tile_events.asm,
	; CheckDirectionalWarp): standing on one does nothing until you press the
	; designated direction.  A cave mouth that needs a second button press is not
	; Yellow's behaviour; LADDER/CAVE/DOOR are non-directional and fire the moment
	; you step on, which is.  (Measured, and worth knowing for 8e: it does NOT
	; change where you come out.  Arriving on ROUTE_10's cave tile (8,17) leaves
	; the player at (8,18) either way, because CheckWarpFacingDown's tile list
	; makes GSC walk you one tile down out of a doorway -- same as the Pokecenter
	; door.  That is why ROUTE_10's hidden SUPER POTION had to move to (9,18).)
	; The south mouth keeps a carpet tile; nothing on ROUTE_10 (8,53) depends on
	; the exact landing tile.
	;
	; 8e NOTE: Yellow's own RockTunnel1F has EIGHT warps, north = 1/2 and
	; south = 3/4 (vendor/pokeyellow/data/maps/objects/RockTunnel1F.asm), so
	; when 8e re-cuts this map on Yellow's geometry, ROUTE_10's warp 3 must be
	; re-pointed from ROCK_TUNNEL_1F, 2 to ROCK_TUNNEL_1F, 3 -- and BOTH mouths
	; must land on Yellow's cave tiles (COLL_CAVE), never on carpet, for the
	; reason above.
	warp_event 27,  3, ROUTE_10, 2
	warp_event 11, 25, ROUTE_10, 3
	warp_event  5,  3, ROCK_TUNNEL_B1F, 3
	warp_event 15,  9, ROCK_TUNNEL_B1F, 2
	warp_event 15,  3, ROCK_TUNNEL_B1F, 4
	warp_event 27, 13, ROCK_TUNNEL_B1F, 1

	def_coord_events

	def_bg_events
	bg_event 24,  4, BGEVENT_ITEM, RockTunnel1FHiddenXAccuracy
	bg_event 21, 15, BGEVENT_ITEM, RockTunnel1FHiddenXDefend

	def_object_events
	object_event  4, 18, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RockTunnel1FElixer, EVENT_ROCK_TUNNEL_1F_ELIXER
	object_event 10, 15, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, RockTunnel1FTMSteelWing, EVENT_ROCK_TUNNEL_1F_TM_STEEL_WING
