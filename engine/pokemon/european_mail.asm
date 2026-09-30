ParseMailLanguage:
	ld c, MAIL_LANG_ENGLISH
	ld hl, sPartyMon1MailNationality - sPartyMon1Mail
	add hl, de
	ld a, [hli]
	cp CHARVAL("C")
	jr z, .cnmail
	cp CHARVAL("E")
	ret nz
	ld a, [hli]
	inc c ; MAIL_LANG_FRENCH
	cp CHARVAL("F")
	ret z
	inc c ; MAIL_LANG_GERMAN
	cp CHARVAL("G")
	ret z
	inc c ; MAIL_LANG_ITALIAN
	cp CHARVAL("I")
	ret z
	inc c ; MAIL_LANG_SPANISH
	cp CHARVAL("S")
	ret z
	ld c, MAIL_LANG_ENGLISH
	ret
.cnmail
	ld a, [hli]
	cp CHARVAL("N")
	ret nz
	ld c, MAIL_LANG_CHINESE
	ret

; The regular font.
StandardEnglishFont:
INCBIN "gfx/font/english.1bpp"

; An extended font.
FrenchGermanFont:
INCBIN "gfx/font/french_german.1bpp"

; An even more extended font.
SpanishItalianFont:
INCBIN "gfx/font/spanish_italian.1bpp"

ConvertFrenchGermanMailToEnglish:
; Called if mail is French or German
; Converts 's 't 'v from French/German character set to English
	ld b, sPartyMon1MailAuthor - sPartyMon1Mail
	ld h, d
	ld l, e
.loop
	ld a, [hl]
	cp $dc ; 's in French/German font
	jr nz, .check_intermediate_chars
	ld a, CHARVAL("'s")
	jr .replace

.check_intermediate_chars
	sub CHARVAL("'s")
	jr c, .dont_replace
	cp CHARVAL("'v") - CHARVAL("'s") + 1
	jr nc, .dont_replace
	add $cd

.replace
	ld [hl], a

.dont_replace
	inc hl
	dec b
	jr nz, .loop
	ret

ConvertEnglishMailToFrenchGerman:
; Called if mail is English and game is French or German
; Converts 's 't 'v from English character set to French/German
	ld b, sPartyMon1MailAuthor - sPartyMon1Mail
	ld h, d
	ld l, e
.loop
	ld a, [hl]
	cp CHARVAL("'s")
	jr nz, .check_intermediate_chars
	ld a, $dc ; 's in French/German font
	jr .replace

.check_intermediate_chars
	sub $cd
	jr c, .dont_replace
	cp CHARVAL("'v") - CHARVAL("'s") + 1
	jr nc, .dont_replace
	add CHARVAL("'s")

.replace
	ld [hl], a

.dont_replace
	inc hl
	dec b
	jr nz, .loop
	ret

ConvertSpanishItalianMailToEnglish:
; Called if mail is Spanish or Italian
; Converts 'd 'l 'm 'r 's 't 'v from Spanish/Italian character set to English
ConvertEnglishMailToSpanishItalian:
; Called if mail is English and game is Spanish or Italian
; Converts 'd 'l 'm 'r 's 't 'v from English character set to Spanish/Italian
	ld b, sPartyMon1MailAuthor - sPartyMon1Mail
	ld h, d
	ld l, e
.loop
	ld a, [hl]
	and $f0
	cp $d0
	jr nz, .dont_replace
	ld a, [hl]
	add $8
	and $f
	or $d0
	ld [hl], a

.dont_replace
	inc hl
	dec b
	jr nz, .loop
	ret
