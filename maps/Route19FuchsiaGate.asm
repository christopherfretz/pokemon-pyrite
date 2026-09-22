; Kanto hack (M9 12c, D98): RETIRED.  Yellow has no map here at all -- ROUTE 19
; runs straight out of FUCHSIA CITY's south edge, and 12c restored that: the
; city's two gate warps and ROUTE 19's landing warp are deleted, FUCHSIA's
; bottom block row is Yellow's plain FLOOR again, and 12b's $cb LEDGE_TWIN
; fence on ROUTE 19 blocks (4,0)/(5,0) is gone.  Nothing warps here and nothing
; warps out; the map is unreachable.
;
; The file stays in the build, unreferenced, exactly like
; FuchsiaPokecenter2FBeta -- the `map Route19FuchsiaGate, ...` row in
; data/maps/maps.asm names these labels, and ROUTE_19_FUCHSIA_GATE stays
; registered in constants/map_constants.asm as a dead positional id (D49: never
; renumber).  Its warp list is emptied because the destinations it named
; (FUCHSIA_CITY warps 10/11, ROUTE_19 warp 1) no longer exist.
;
; M7 10o's note on what was deleted, for the record: the gate's OFFICER told
; Crystal's story -- CINNABAR's volcano erupting and closing ROUTE 19
; "indefinitely" -- a Gen 2 story beat with no Yellow counterpart, and the
; first NPC a player met walking south out of FUCHSIA.  There was no Yellow
; text to port in its place, so 10o made the gate a silent pass-through.
Route19FuchsiaGate_MapScripts:
	def_scene_scripts

	def_callbacks

Route19FuchsiaGate_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events

	def_bg_events

	def_object_events
