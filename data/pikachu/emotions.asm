; Yellow's 34 Pikachu emotion scripts, ported verbatim from
; vendor/pokeyellow/data/pikachu/pikachu_emotions.asm.  The only substitutions
; are in the *interpreter* (engine/pikachu/emotions.asm), not here:
;   pikaemotion_emotebubble -> FollowerSpawnEmote / FollowerDespawnEmote
;   pikaemotion_pcm         -> cry PIKACHU + the PlayPikachuVoiceClip hook
;   pikaemotion_movement    -> our own mini-interpreter over wFollowerStruct
;   pikaemotion_pikapic     -> stubbed, records the index in wPikaPicAnimNumber
; `db $ff` is Yellow's own end-of-script byte (PIKAEMOTION_END).

PikachuEmotion0:
	db PIKAEMOTION_END

PikachuEmotion2:
	pikaemotion_dummy2
	pikaemotion_emotebubble SMILE_BUBBLE
	pikaemotion_pcm PikachuCry35
	pikaemotion_pikapic PikaPicAnimScript2
	db PIKAEMOTION_END

PikachuEmotion10:
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm PikachuCry5
	pikaemotion_pikapic PikaPicAnimScript10
	db PIKAEMOTION_END

PikachuEmotion7:
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_movement PikachuMovementData_fd224
	pikaemotion_pcm PikachuCry1
	pikaemotion_movement PikachuMovementData_fd224
	pikaemotion_pikapic PikaPicAnimScript7
	db PIKAEMOTION_END

PikachuEmotion4:
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_movement PikachuMovementData_fd230
	pikaemotion_pcm PikachuCry29
	pikaemotion_pikapic PikaPicAnimScript4
	db PIKAEMOTION_END

PikachuEmotion1:
	pikaemotion_dummy2
	pikaemotion_pcm
	pikaemotion_pikapic PikaPicAnimScript1
	db PIKAEMOTION_END

PikachuEmotion8:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry39
	pikaemotion_pikapic PikaPicAnimScript8
	db PIKAEMOTION_END

PikachuEmotion5:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry31
	pikaemotion_pikapic PikaPicAnimScript5
	db PIKAEMOTION_END

PikachuEmotion6:
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_pcm
	pikaemotion_movement PikachuMovementData_fd21e
	pikaemotion_emotebubble SKULL_BUBBLE
	pikaemotion_pikapic PikaPicAnimScript6
	db PIKAEMOTION_END

PikachuEmotion3:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry40
	pikaemotion_pikapic PikaPicAnimScript3
	db PIKAEMOTION_END

PikachuEmotion9:
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_pcm PikachuCry6
	pikaemotion_movement PikachuMovementData_fd218
	pikaemotion_emotebubble SKULL_BUBBLE
	pikaemotion_pikapic PikaPicAnimScript9
	db PIKAEMOTION_END

PikachuEmotion11:
	pikaemotion_emotebubble ZZZ_BUBBLE
	pikaemotion_pcm PikachuCry37
	pikaemotion_pikapic PikaPicAnimScript11
	db PIKAEMOTION_END

PikachuEmotion12:
	pikaemotion_dummy2
	pikaemotion_pcm
	pikaemotion_pikapic PikaPicAnimScript12
	db PIKAEMOTION_END

PikachuEmotion13:
	pikaemotion_dummy2
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADEXTRAPIKASPRITES
	pikaemotion_movement PikachuMovementData_fd21e
	pikaemotion_pikapic PikaPicAnimScript13
	db PIKAEMOTION_END

PikachuEmotion14:
	pikaemotion_dummy2
	pikaemotion_emotebubble BOLT_BUBBLE
	pikaemotion_pcm PikachuCry10
	pikaemotion_pikapic PikaPicAnimScript14
	db PIKAEMOTION_END

PikachuEmotion15:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry34
	pikaemotion_pikapic PikaPicAnimScript15
	db PIKAEMOTION_END

PikachuEmotion16:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry33
	pikaemotion_pikapic PikaPicAnimScript16
	db PIKAEMOTION_END

PikachuEmotion17:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry13
	pikaemotion_pikapic PikaPicAnimScript17
	db PIKAEMOTION_END

PikachuEmotion18:
	pikaemotion_dummy2
	pikaemotion_pcm
	pikaemotion_pikapic PikaPicAnimScript18
	db PIKAEMOTION_END

PikachuEmotion19:
	pikaemotion_dummy2
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm PikachuCry33
	pikaemotion_pikapic PikaPicAnimScript19
	db PIKAEMOTION_END

PikachuEmotion20:
	pikaemotion_dummy2
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm PikachuCry5
	pikaemotion_pikapic PikaPicAnimScript20
	db PIKAEMOTION_END

PikachuEmotion21:
	pikaemotion_dummy2
	pikaemotion_emotebubble FISH_BUBBLE
	pikaemotion_pcm
	pikaemotion_pikapic PikaPicAnimScript21
	db PIKAEMOTION_END

PikachuEmotion22:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry4
	pikaemotion_pikapic PikaPicAnimScript22
	db PIKAEMOTION_END

PikachuEmotion23:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry19
	pikaemotion_pikapic PikaPicAnimScript23
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	db PIKAEMOTION_END

PikachuEmotion24:
	pikaemotion_dummy2
	pikaemotion_emotebubble EXCLAMATION_BUBBLE
	pikaemotion_pcm
	pikaemotion_pikapic PikaPicAnimScript24
	db PIKAEMOTION_END

PikachuEmotion25:
	pikaemotion_dummy2
	pikaemotion_emotebubble BOLT_BUBBLE
	pikaemotion_pcm PikachuCry35
	pikaemotion_pikapic PikaPicAnimScript25
	db PIKAEMOTION_END

PikachuEmotion26:
	pikaemotion_dummy2
	pikaemotion_emotebubble ZZZ_BUBBLE
	pikaemotion_pcm PikachuCry37
	pikaemotion_pikapic PikaPicAnimScript26
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_CHECKPEWTERCENTER
	db PIKAEMOTION_END

PikachuEmotion27:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry9
	pikaemotion_pikapic PikaPicAnimScript27
	db PIKAEMOTION_END

PikachuEmotion28:
	pikaemotion_dummy2
	pikaemotion_pcm PikachuCry15
	pikaemotion_pikapic PikaPicAnimScript28
	db PIKAEMOTION_END

PikachuEmotion29:
	pikaemotion_pcm PikachuCry5
	pikaemotion_pikapic PikaPicAnimScript10
	db PIKAEMOTION_END

PikachuEmotion30:
	pikaemotion_9
	pikaemotion_emotebubble HEART_BUBBLE
	pikaemotion_pcm PikachuCry5
	pikaemotion_pikapic PikaPicAnimScript20
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_LOADFONT
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_CHECKLAVENDERTOWER
	db PIKAEMOTION_END

PikachuEmotion31:
	pikaemotion_pcm PikachuCry19
	pikaemotion_pikapic PikaPicAnimScript23
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_SHOWMAPVIEW
	pikaemotion_subcmd PIKAEMOTION_SUBCMD_CHECKBILLSHOUSE
	db PIKAEMOTION_END

PikachuEmotion32:
	pikaemotion_pcm PikachuCry26
	pikaemotion_pikapic PikaPicAnimScript23
	db PIKAEMOTION_END

; Movement data.  Yellow's encoding is documented next to each block; see
; constants/pikachu_emotion_constants.asm for the opcode mapping.  Only these
; four are reachable from the 34 emotion scripts; PikachuMovementData_fd22c and
; _fd238 belong to map scripts we have not ported (see the note at the bottom).

PikachuMovementData_fd218:
; Yellow: db $00 / $39, 2 - 1 / $3e, 31 - 1 / $3f
; Two clockwise quarter-turns (DOWN -> LEFT -> UP: Pikachu turns its back on
; you), then holds for 31 units.  68 frames total.
	pikamove_init
	pikamove_turn 2
	pikamove_hold 31
	pikamove_end

PikachuMovementData_fd21e:
; Yellow: db $00 / $39, 1 - 1 / $3e, 31 - 1 / $3f
; One clockwise quarter-turn (DOWN -> LEFT: it looks away sideways), hold.
; 66 frames total.
	pikamove_init
	pikamove_turn 1
	pikamove_hold 31
	pikamove_end

PikachuMovementData_fd224:
; Yellow: db $00 / $3c, 8 - 1, (2 << 4) | (16 - 1) x2 / $3f
; Two quick in-place hops, 8 units each, 16px high.  34 frames total.
	pikamove_init
	pikamove_hop 8, 2
	pikamove_hop 8, 2
	pikamove_end

PikachuMovementData_fd230:
; Yellow: db $00 / $3c, 16 - 1, (1 << 4) | (16 - 1) x2 / $3f
; The same two hops at half speed, 16 units each.  66 frames total.
	pikamove_init
	pikamove_hop 16, 1
	pikamove_hop 16, 1
	pikamove_end

PikachuMovementData_fd22c:
; Yellow: db $3b, 32 - 1, 4 - 1 / $3f
; Spin: 32 units, one counterclockwise quarter-turn every 4 units = two full
; revolutions, from wherever Pikachu is already standing (no $00 init).
; Reachable only from Yellow's map scripts, never from an emotion script.
	pikamove_turnevery 32, 4
	pikamove_end

; PikachuMovementData_fd238 is NOT ported.  It walks Pikachu around the player
; with Yellow's diagonal step opcodes ($05..$08), which move the sprite between
; tiles; our follower is a real Crystal map object whose collision and
; follow-the-player logic would fight that, and no emotion script reaches it.
; It is used by Yellow's map scripts only (docs/PIKACHU-EMOTIONS.md A1.7).
