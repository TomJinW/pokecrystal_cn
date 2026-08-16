PlaceWaitingText::
	; hlcoord 4, 9
	; ld b, 2
	; ld c, 9
	hlcoord 2, 8
	ld b, 2
	ld c, 13

	ld a, [wBattleMode]
	and a
	jr z, .notinbattle

	call Textbox
	jr .proceed

.notinbattle
	predef LinkTextboxAtHL

.proceed
	hlcoord 5, 10
	; hlcoord 5, 11
	ld de, .Waiting
	call PlaceString
	ld c, 50
	jp DelayFrames

.Waiting:
	db_w "请您稍等……！@"
