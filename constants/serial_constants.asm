; wLinkMode
	const_def
	const LINK_NULL        ; 0
	const LINK_TIMECAPSULE ; 1
	const LINK_TRADECENTER ; 2
	const LINK_COLOSSEUM   ; 3
	const LINK_MOBILE      ; 4

; wChosenCableClubRoom
	const_def
	const CABLECLUBROOM_NULL        ; 0
	const CABLECLUBROOM_TRADECENTER ; 1
	const CABLECLUBROOM_COLOSSEUM   ; 2

; hSerialReceive high nybbles
DEF SERIAL_TIMECAPSULE EQU $60
DEF SERIAL_TRADECENTER EQU $70
DEF SERIAL_BATTLE      EQU $80

DEF ESTABLISH_CONNECTION_WITH_INTERNAL_CLOCK EQU $01
DEF ESTABLISH_CONNECTION_WITH_EXTERNAL_CLOCK EQU $02

; hSerialConnectionStatus
DEF USING_EXTERNAL_CLOCK       EQU $01
DEF USING_INTERNAL_CLOCK       EQU $02
DEF CONNECTION_NOT_ESTABLISHED EQU $ff

; length of a patch list
DEF SERIAL_PATCH_LIST_LENGTH          EQU 200
; size of the patch area (offsets into this area may not have special values)
DEF SERIAL_PATCH_DATA_SIZE            EQU $fc
; signals the start of an array of bytes transferred over the link cable
DEF SERIAL_PREAMBLE_BYTE              EQU $fd
; this byte is used when there is no data to send
DEF SERIAL_NO_DATA_BYTE               EQU $fe
; signals the end of one part of a patch list (there are two parts) for player/enemy party data
DEF SERIAL_PATCH_LIST_PART_TERMINATOR EQU $ff
; used to replace SERIAL_NO_DATA_BYTE
DEF SERIAL_PATCH_REPLACEMENT_BYTE     EQU $ff

DEF SERIAL_PREAMBLE_LENGTH       EQU 6
DEF SERIAL_RN_PREAMBLE_LENGTH    EQU 7
DEF SERIAL_PATCH_PREAMBLE_LENGTH EQU 3
DEF SERIAL_RNS_LENGTH            EQU 10

DEF SERIAL_PADDING_LENGTH EQU 3

; LK1f (docs/LK1-LINK.md "## LK1f findings"): the pyrite feature byte.  The
; Gen 2 party block ends in SERIAL_PADDING_LENGTH bytes that vanilla Crystal
; leaves at zero (ClearLinkData) and never reads back on receive: they are the
; slack that absorbs the preamble shift of Serial_ExchangeBytes (a received
; block can carry up to 2 extra leading $FD, measured in LK1b, which pushes the
; last 2 padding bytes off the end of the 450-byte receive buffer).  Pyrite
; therefore uses only the FIRST padding byte, the one that still arrives after
; that shift.  The margin is used up toward the slave: there the byte lands on
; the last byte of the 450-byte buffer, so a shift of 3 (never observed; the
; measured maximum is 2) loses it and the slave masks while the master keeps
; the gender -- a one-sided cosmetic loss, no corruption.  A peer that sends
; LINK_PYRITE_FEATURES there keeps the explicit gender bits (GF2/GF3,
; CaughtLevel bits 7-6) on a traded mon; anything else ($00 from vanilla
; Crystal or a pre-LK1f pyrite) gets them masked, as before.
; $8F is 'P' in the charmap.  It cannot be produced by accident at that spot:
; not $00 (vanilla/pre-LK1f), $FE (wLinkReceivedPartyEnd, read when the shift
; is 3 and the byte is lost), $FD/$FF (preamble, patch replacement), $20/$21
; (mail framing) or $01/$02 (connection bytes).  The other two padding bytes
; stay $00 (reserved).
DEF LINK_PYRITE_FEATURES EQU $8f

DEF SERIAL_MAIL_PREAMBLE_BYTE    EQU $20
DEF SERIAL_MAIL_PREAMBLE_LENGTH  EQU 5
; used to replace SERIAL_NO_DATA_BYTE
DEF SERIAL_MAIL_REPLACEMENT_BYTE EQU $21

; timeout duration after exchanging a byte
DEF SERIAL_LINK_BYTE_TIMEOUT EQU $5000

DEF MAX_MYSTERY_GIFT_PARTNERS EQU 5
