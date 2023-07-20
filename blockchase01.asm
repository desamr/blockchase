org 29000
	
	;border
	xor a
	;ld a,1
	call 8859

	call 3503             ;clear screen

	;mostrar pantalla presentacion

	;musica
	;ld de, 5
	;ld bc, 300
	;ld a, 7
	;call sound_manager_effects_enqueue
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	;esperar hasta pulsar una tecla
	;call pulsa_tecla
	;call suelta_tecla


	;declaracion de constantes
	num_pantalla 		equ 50000
	pantalla_actual 	equ 50001
	beams 			equ 50002
	vidas 			equ 50003
	score 			equ 50004
	hiscore 		equ 50006
	total_pantallas 	equ 50008

	FONT_CHARSET 		equ 50009 		;Direccion de memoria del charset.
	FONT_X 			equ 50011      		;Coordenada X en baja resolucion (0-31)
	FONT_Y 			equ 50012      		;Coordenada Y en baja resolucion (0-23)
	FONT_ATTRIB 		equ 50013 		;Atributo a utilizar en la impresion.

	posiciones_enemigos 	equ 50014		;los 4 bytes mas bajos indican 0 si el puesto esta vacio, 1 lleno

	enemigo1		equ 50015
	enemigo2		equ 50016
	enemigo3		equ 50017
	enemigo4		equ 50018
	llave			equ 50019
	multiplicador		equ 50020

	xor a
	ld (enemigo1),a
	ld (enemigo2),a
	ld (enemigo3),a
	ld (enemigo4),a
	ld (llave),a
	ld (multiplicador),a

	enemigo1_fila		equ 50021
	enemigo1_col		equ 50022
	enemigo2_fila		equ 50023
	enemigo2_col		equ 50024
	enemigo3_fila		equ 50025
	enemigo3_col		equ 50026
	enemigo4_fila		equ 50027
	enemigo4_col		equ 50028

	enemigo1_coord		equ 50029
	enemigo2_coord		equ 50030
	enemigo3_coord		equ 50031
	enemigo4_coord		equ 50032

	SPRITE_ATTR		equ 50033	;donde se guarda el atributo de tinta (el papel sera siempre negro)
	SPRITE_COORD		equ 50034	;donde esta la fila (4 bits + signific) y la columna (4 bits - signific)
						;dentro del sprite. Both van de 0 a 8
	SPRITE_FILA		equ 50035	;posicion de la fila en pantalla en baja resolucion del sprite
	SPRITE_COL		equ 50036

	hpos			equ 50037
	sentido_player		equ 50039
	sentido_enemigo1	equ 50040	

	efila			equ 50041	;fila de la entrada
	ecol			equ 50042	;col de la entrada
	elinea			equ 50043	;0-arriba, 1-dere, 2-abajo, 3-izq
	sfila			equ 50044	;fila de la salida
	scol			equ 50045	;col de la salida
	slinea			equ 50046	;0-arriba, 1-dere, 2-abajo, 3-izq
	
	player_fila		equ 50048
	player_col		equ 50049
	player_coord		equ 50050

	ciclos_player		equ 50051
	ciclos_enemigo1		equ 50052 
	ciclos_enemigo2		equ 50053 
	ciclos_enemigo3		equ 50054 
	ciclos_enemigo4		equ 50055  

	sentido_enemigo2	equ 50056
	sentido_enemigo3	equ 50057
	sentido_enemigo4	equ 50058

	llave_fila		equ 50059
	llave_col		equ 50060
	ciclos_llave		equ 50061
	llave_mostrada		equ 50062
	veces_multiplicadas	equ 50063

	sfila_aux		equ 50064	;usadas cuando se pinta la salida para no modificar los valores originales
	scol_aux		equ 50065	;que son usados en la comprobacion de si el player esta en la salida



	;carga de variables para pantalla menu
	LD HL, 15616-256           	; Saltamos los 32 caracteres iniciales
  	LD (FONT_CHARSET), HL 

  	call 3503             ;clear screen




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
menu_principal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	call limpia_scores
	call pintalimpia_escenario

	ld a,2
	ld (FONT_X),a
	ld a,10
	ld (FONT_Y),a
	ld a,6
	ld (FONT_ATTRIB),a
	LD HL, menu_texto1
  	CALL PrintString_8x8

  	ld a,2
	ld (FONT_X),a
  	ld a,12
	ld (FONT_Y),a
  	LD HL, menu_texto2
  	CALL PrintString_8x8

  	


 lee_teclado_menu:
	
	;call suelta_tecla

	Comprobar_tecla_0:
		LD A, $23
		CALL Check_Key
		JR C, no_pulsada_0            ; Carry = 1, tecla no pulsada

		jp redefinicion

		no_pulsada_0:

	Comprobar_tecla_1:
		LD A, $24
		CALL Check_Key
		JR C, lee_teclado_menu            ; Carry = 1, tecla no pulsada

		jp inicializa_juego

	jr lee_teclado_menu
	

redefinicion

	call pintalimpia_escenario

	;; Pedimos tecla ARRIBA;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a,2
	ld (FONT_X),a
	ld a,10
	ld (FONT_Y),a
	ld a,6
	ld (FONT_ATTRIB),a
	LD HL, key_up
  	CALL PrintString_8x8
  	
  	CALL suelta_tecla	        ; Esperamos teclado libre
 
	Pedir_Arriba:
	 
	  	CALL Find_Key                   ; Llamamos a la rutina
		JR NZ, Pedir_Arriba             ; Repetir si la tecla no es válida
		INC D
		JR Z, Pedir_Arriba              ; Repetir si no se pulsó ninguna tecla
		DEC D

		LD A, D
		LD (tecla_arriba), A


	;; Pedimos siguiente tecla (ABAJO);;;;;;;;;;;;;;;;
		ld a,2
		ld (FONT_X),a
		ld a,10
		ld (FONT_Y),a
		ld a,6
		ld (FONT_ATTRIB),a
		LD HL, key_down
	  	CALL PrintString_8x8

		CALL suelta_tecla   	        ; Esperamos teclado libre

	Pedir_Abajo:
	 
		CALL Find_Key                   ; Llamamos a la rutina
		JR NZ, Pedir_Abajo              ; Repetir si la tecla no es válida
		INC D
		JR Z, Pedir_Abajo               ; Repetir si no se pulsó ninguna tecla
		DEC D

		LD A, D
		LD (tecla_abajo), A


	;; Pedimos siguiente tecla (DERECHA);;;;;;;;;;;;;;;;;
		ld a,2
		ld (FONT_X),a
		ld a,10
		ld (FONT_Y),a
		ld a,6
		ld (FONT_ATTRIB),a
		LD HL, key_right
	  	CALL PrintString_8x8
	  	
		CALL suelta_tecla     ; Esperamos teclado libre

	Pedir_Derecha:
	 
		CALL Find_Key                   ; Llamamos a la rutina
		JR NZ, Pedir_Derecha              ; Repetir si la tecla no es válida
		INC D
		JR Z, Pedir_Derecha               ; Repetir si no se pulsó ninguna tecla
		DEC D

		LD A, D
		LD (tecla_derecha), A


	;; Pedimos siguiente tecla (IZQ);;;;;;;;;;;;;;;;;;
		ld a,2
		ld (FONT_X),a
		ld a,10
		ld (FONT_Y),a
		ld a,6
		ld (FONT_ATTRIB),a
		LD HL, key_left
	  	CALL PrintString_8x8
	  	
		CALL suelta_tecla     ; Esperamos teclado libre

	Pedir_Izq:
	 
		CALL Find_Key                   ; Llamamos a la rutina
		JR NZ, Pedir_Izq              ; Repetir si la tecla no es válida
		INC D
		JR Z, Pedir_Izq               ; Repetir si no se pulsó ninguna tecla
		DEC D

		LD A, D
		LD (tecla_izquierda), A




	;; Pedimos siguiente tecla (BEAM);;;;;;;;;;;;;;;;;;
		ld a,2
		ld (FONT_X),a
		ld a,10
		ld (FONT_Y),a
		ld a,6
		ld (FONT_ATTRIB),a
		LD HL, key_beam
	  	CALL PrintString_8x8
	  	
		CALL suelta_tecla     ; Esperamos teclado libre

	Pedir_Beam:
	 
		CALL Find_Key                   ; Llamamos a la rutina
		JR NZ, Pedir_Beam              ; Repetir si la tecla no es válida
		INC D
		JR Z, Pedir_Beam               ; Repetir si no se pulsó ninguna tecla
		DEC D

		LD A, D
		LD (tecla_beam), A



	;; Pedimos siguiente tecla (PAUSA);;;;;;;;;;;;;;;;;
		ld a,2
		ld (FONT_X),a
		ld a,10
		ld (FONT_Y),a
		ld a,6
		ld (FONT_ATTRIB),a
		LD HL, key_pause
	  	CALL PrintString_8x8
	  	
		CALL suelta_tecla     ; Esperamos teclado libre

	Pedir_Pause:
	 
		CALL Find_Key                   ; Llamamos a la rutina
		JR NZ, Pedir_Pause              ; Repetir si la tecla no es válida
		INC D
		JR Z, Pedir_Pause               ; Repetir si no se pulsó ninguna tecla
		DEC D

		LD A, D
		LD (tecla_pause), A
	 
	  
		call suelta_tecla  	;Este ultimo, para evitar volver a la redifinicion en caso de que la tecla
						;elegida para pause sea 0.



	jp menu_principal


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
inicializa_juego
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	;carga de variables para el juego
	ld a,1
	ld (num_pantalla),a

	ld a,64
	ld (total_pantallas),a

	ld a,3
	ld (vidas),a
	ld (beams),a

	xor a
	ld (score),a
	ld (ciclos_enemigo1),a
	ld (llave_mostrada),a

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pinta_scores:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	call limpia_scores
	call actualiza_scores

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;pinta_escenario
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	call pintalimpia_escenario
	halt

	

;leer_tabla_pantalla 	;se lee de la tabla de pantallas y se copia en las variables a usar en la pantalla actual
	ld bc,pantallas
	ld a,(num_pantalla)
	ld l,a
	ld h,0
	sla l
	rl h
	add hl,bc

	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a


	ld a,(hl)
	
	;valores de la tabla pantalla
	;1-tipo enemigo 1 (0 si no hay,1-4:tipo)
	;2-tipo enemigo 2
	;3-tipo enemigo 3
	;4-tipo enemigo 4
	;5-llave (0 no hay, ciclos para aparecer)
	;6-multiplicador de ciclos (minimo y por defecto, 1)
	ld (enemigo1),a
	inc l
	ld a,(hl)
	ld (enemigo2),a
	inc l
	ld a,(hl)
	ld (enemigo3),a
	inc l
	ld a,(hl)
	ld (enemigo4),a
	inc l
	ld a,(hl)
	ld (llave),a
	inc l
	ld a,(hl)
	ld (multiplicador),a

	xor a
	ld (llave_mostrada),a

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
inicializa_enemigos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


		xor a
		ld (posiciones_enemigos),a

		;comprobar si existe enemigo1
		ld a,(enemigo1)
		cp 0
		jr z,check_enemigo2
		cp 1
		jr z,enemigo1_es_verde
		cp 2
		jr z,enemigo1_es_amarillo
		cp 3
		jr z,enemigo1_es_magenta
		ld a,2			;enemigo1 es rojo
		ld (SPRITE_ATTR),a
		jr posiciona_enemigo1
	enemigo1_es_verde:
		ld a,4			;enemigo1 es verde
		ld (SPRITE_ATTR),a
		jr posiciona_enemigo1
	enemigo1_es_amarillo:
		ld a,6			;enemigo1 es amarillo
		ld (SPRITE_ATTR),a
		jr posiciona_enemigo1
	enemigo1_es_magenta:
		ld a,3			;enemigo1 es magenta
		ld (SPRITE_ATTR),a


		;posicionar y pintar enemigo1
	posiciona_enemigo1
		ld a,1
		ld (enemigo1_fila),a
		ld (enemigo1_col),a

		ld (SPRITE_FILA),a
		ld (SPRITE_COL),a

		ld a,01000100b		;fila 4 (4 bits + significativos). col 4 (4 bits - significativos)
		ld (enemigo1_coord),a
		
		ld (SPRITE_COORD),a

		

		call pinta_sprite


		ld a,(posiciones_enemigos)
		inc a
		ld (posiciones_enemigos),a


	check_enemigo2

		;comprobar si existe enemigo2
		ld a,(enemigo2)
		cp 0
		jp z,check_enemigo3

		cp 1
		jr z,enemigo2_es_verde
		cp 2
		jr z,enemigo2_es_amarillo
		cp 3
		jr z,enemigo2_es_magenta
		ld a,2			;enemigo2 es rojo
		ld (SPRITE_ATTR),a
		jr posiciona_enemigo2
	enemigo2_es_verde:
		ld a,4			;enemigo2 es verde
		ld (SPRITE_ATTR),a
		jr posiciona_enemigo2
	enemigo2_es_amarillo:
		ld a,6			;enemigo2 es amarillo
		ld (SPRITE_ATTR),a
		jr posiciona_enemigo2
	enemigo2_es_magenta:
		ld a,3			;enemigo2 es magenta
		ld (SPRITE_ATTR),a


		;posicionar y pintar enemigo2
	posiciona_enemigo2
		ld a,(posiciones_enemigos)
		cp 0
		jr z,posicion_enemigos1_para_enemigo2
		cp 1
		jr z,posicion_enemigos2_para_enemigo2
		cp 2
		jr z,posicion_enemigos3_para_enemigo2
		;entonces en la cuarta posicion
		ld a,21
		ld (enemigo2_fila),a
		ld (enemigo2_col),a

		ld (SPRITE_FILA),a
		ld (SPRITE_COL),a
		jr posiciona_enemigo2b
	posicion_enemigos1_para_enemigo2
		ld a,1
		ld (enemigo2_fila),a
		ld (enemigo2_col),a
		ld (SPRITE_FILA),a
		ld (SPRITE_COL),a
		jr posiciona_enemigo2b
	posicion_enemigos2_para_enemigo2
		ld a,1
		ld (enemigo2_fila),a
		ld (SPRITE_FILA),a
		ld a,21
		ld (enemigo2_col),a
		ld (SPRITE_COL),a
		jr posiciona_enemigo2b
	posicion_enemigos3_para_enemigo2
		ld a,21
		ld (enemigo2_fila),a
		ld (SPRITE_FILA),a
		ld a,1
		ld (enemigo2_col),a
		ld (SPRITE_COL),a



	posiciona_enemigo2b
		

		ld a,01000100b		;fila 4 (4 bits + significativos). col 4 (4 bits - significativos)
		ld (enemigo2_coord),a
		
		ld (SPRITE_COORD),a


		call pinta_sprite

		ld a,(posiciones_enemigos)
		inc a
		ld (posiciones_enemigos),a


	check_enemigo3

		;comprobar si existe enemigo3
		ld a,(enemigo3)
		cp 0
		jp z,check_enemigo4

		cp 1
		jr z,enemigo3_es_verde
		cp 2
		jr z,enemigo3_es_amarillo
		cp 3
		jr z,enemigo3_es_magenta
		ld a,2			;enemigo3 es rojo
		ld (SPRITE_ATTR),a
		jr posiciona_enemigo3
	enemigo3_es_verde:
		ld a,4			;enemigo3 es verde
		ld (SPRITE_ATTR),a
		jr posiciona_enemigo3
	enemigo3_es_amarillo:
		ld a,6			;enemigo3 es amarillo
		ld (SPRITE_ATTR),a
		jr posiciona_enemigo3
	enemigo3_es_magenta:
		ld a,3			;enemigo3 es magenta
		ld (SPRITE_ATTR),a


		;posicionar y pintar enemigo3
	posiciona_enemigo3
		ld a,(posiciones_enemigos)
		cp 0
		jr z,posicion_enemigos1_para_enemigo3
		cp 1
		jr z,posicion_enemigos2_para_enemigo3
		cp 2
		jr z,posicion_enemigos3_para_enemigo3
		;entonces en la cuarta posicion
		ld a,21

		ld (enemigo3_fila),a
		ld (enemigo3_col),a

		ld (SPRITE_FILA),a
		ld (SPRITE_COL),a
		jr posiciona_enemigo3b
	posicion_enemigos1_para_enemigo3
		ld a,1
		ld (enemigo3_fila),a
		ld (enemigo3_col),a
		ld (SPRITE_FILA),a
		ld (SPRITE_COL),a
		jr posiciona_enemigo3b
	posicion_enemigos2_para_enemigo3
		ld a,1
		ld (enemigo3_fila),a
		ld (SPRITE_FILA),a
		ld a,21
		ld (enemigo3_col),a
		ld (SPRITE_COL),a
		jr posiciona_enemigo3b
	posicion_enemigos3_para_enemigo3
		ld a,21
		ld (enemigo3_fila),a
		ld (SPRITE_FILA),a
		ld a,1
		ld (enemigo3_col),a
		ld (SPRITE_COL),a

	posiciona_enemigo3b
		ld a,01000100b		;fila 4 (4 bits + significativos). col 4 (4 bits - significativos)
		ld (enemigo3_coord),a
		
		ld (SPRITE_COORD),a


		call pinta_sprite

		ld a,(posiciones_enemigos)
		inc a
		ld (posiciones_enemigos),a


	check_enemigo4

		;comprobar si existe enemigo4
		ld a,(enemigo4)
		cp 0
		jp z,crear_entrada	;ya no hay que comprobar mas enemigos asi que me voy al siguiente paso

		cp 1
		jr z,enemigo4_es_verde
		cp 2
		jr z,enemigo4_es_amarillo
		cp 3
		jr z,enemigo4_es_magenta
		ld a,2			;enemigo4 es rojo
		ld (SPRITE_ATTR),a
		jr posiciona_enemigo4
	enemigo4_es_verde:
		ld a,4			;enemigo4 es verde
		ld (SPRITE_ATTR),a
		jr posiciona_enemigo4
	enemigo4_es_amarillo:
		ld a,6			;enemigo4 es amarillo
		ld (SPRITE_ATTR),a
		jr posiciona_enemigo4
	enemigo4_es_magenta:
		ld a,3			;enemigo4 es magenta
		ld (SPRITE_ATTR),a


		;posicionar y pintar enemigo4
	posiciona_enemigo4
		ld a,(posiciones_enemigos)
		cp 0
		jp z,posicion_enemigos1_para_enemigo4
		cp 1
		jp z,posicion_enemigos2_para_enemigo4
		cp 2
		jp z,posicion_enemigos3_para_enemigo4
		;entonces en la cuarta posicion
		ld a,21

		ld (enemigo4_fila),a
		ld (enemigo4_col),a

		ld (SPRITE_FILA),a
		ld (SPRITE_COL),a
		jr posiciona_enemigo4b
	posicion_enemigos1_para_enemigo4
		ld a,1
		ld (enemigo4_fila),a
		ld (enemigo4_col),a
		ld (SPRITE_FILA),a
		ld (SPRITE_COL),a
		jr posiciona_enemigo4b
	posicion_enemigos2_para_enemigo4
		ld a,1
		ld (enemigo4_fila),a
		ld (SPRITE_FILA),a
		ld a,21
		ld (enemigo4_col),a
		ld (SPRITE_COL),a
		jr posiciona_enemigo4b
	posicion_enemigos3_para_enemigo4
		ld a,21
		ld (enemigo4_fila),a
		ld (SPRITE_FILA),a
		ld a,1
		ld (enemigo4_col),a
		ld (SPRITE_COL),a

	posiciona_enemigo4b
		ld a,01000100b		;fila 4 (4 bits + significativos). col 4 (4 bits - significativos)
		ld (enemigo4_coord),a
		
		ld (SPRITE_COORD),a


		call pinta_sprite

		ld a,(posiciones_enemigos)
		inc a
		ld (posiciones_enemigos),a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
crear_entrada:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	call random


	and 3
	;;;;;;;debug
	;ld a,3
	;;;;;;;;;;;
	entrada0
		cp 0
		jr nz,entrada1
		ld (elinea),a
		ld (efila),a
		ld a,2
		ld (slinea),a
		ld a,23
		ld (sfila),a
		random_entrada0b:
			call random
			and 00011111b
			cp 4
			jr c,random_entrada0b
			cp 16
			jr nc,random_entrada0b
			ld (ecol),a
		random_entrada0c:
			call random
	
			and 00011111b
	 
			cp 4
			jr c,random_entrada0c
			cp 16
			jr nc,random_entrada0c
			ld (scol),a
			jp pinta_entrada
	entrada1
		cp 1
		jr nz,entrada2
		ld (elinea),a
		xor a
		ld (scol),a
		ld a,3
		ld (slinea),a
		ld a,23
		ld (ecol),a
		random_entrada1b:
			call random
			and 00011111b
			cp 4
			jr c,random_entrada1b
			cp 16
			jr nc,random_entrada1b
			ld (efila),a
		random_entrada1c:
			call random
			and 00011111b
			cp 4
			jr c,random_entrada1c
			cp 16
			jr nc,random_entrada1c
			ld (sfila),a
			jp pinta_entrada
	entrada2
		cp 2
		jr nz,entrada3
		ld (elinea),a
		xor a
		ld (sfila),a
		ld (slinea),a
		ld a,23
		ld (efila),a
		random_entrada2b:
			call random
			and 00011111b
			cp 4
			jr c,random_entrada2b
			cp 16
			jr nc,random_entrada2b
			ld (ecol),a
		random_entrada2c:
			call random
			and 00011111b
			cp 4
			jr c,random_entrada2c
			cp 16
			jr nc,random_entrada2c
			ld (scol),a

			jp pinta_entrada
	entrada3
		ld (elinea),a
		xor a
		ld (ecol),a
		ld a,1
		ld (slinea),a
		ld a,23
		ld (scol),a
		random_entrada3b:
			call random
			and 00011111b
			cp 4
			jr c,random_entrada3b
			cp 16
			jr nc,random_entrada3b
			ld (efila),a
		random_entrada3c:
			call random
			and 00011111b
			cp 4
			jr c,random_entrada3c
			cp 16
			jr nc,random_entrada3c
			ld (sfila),a
	
	pinta_entrada:
		call pinta_entrada_LR
		



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
crear_salida 		;solo se crea si no hace falta llave
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a,(llave)
	cp 0
	jr nz,animacion_entrada		;en el bucle principal vemos cuando le toca aparecer
	;tiene que pintarse ya

	halt
	halt
	halt
	halt		;hay que poner estos halt. si no,no se ejecuta la llamada a pinta_salida

	call pinta_salida_LR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
animacion_entrada	;se pone el status a 1 (saliendo)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;ld a,1
		;ld (status),a


		ld a,(elinea)
		cp 0
		jr nz,ani_elinea1
		ld a,(ecol)
		dec a
		dec a
		;ld (ecol),a
		ld (player_col),a
		xor a
		ld (player_fila),a
		ld a,00000100b
		ld (player_coord),a
		ld a,2
		ld (sentido_player),a
		jr sigue_animacion_entrada
	ani_elinea1
		cp 1
		jr nz,ani_elinea2
		ld a,(efila)
		dec a
		dec a
		;ld (efila),a
		ld (player_fila),a
		ld a,22
		ld (player_col),a
		ld a,01001000b
		ld (player_coord),a
		ld a,3
		ld (sentido_player),a
		jr sigue_animacion_entrada
	ani_elinea2
		cp 2
		jr nz,ani_elinea3
		ld a,(ecol)
		dec a
		dec a
		;ld (ecol),a
		ld (player_col),a
		ld a,22
		ld (player_fila),a
		ld a,10000100b
		ld (player_coord),a
		xor a
		ld (sentido_player),a
		jr sigue_animacion_entrada
	ani_elinea3
		ld a,(efila)
		dec a
		dec a
		;ld (efila),a
		ld (player_fila),a
		xor a
		ld (player_col),a
		ld a,01000000b
		ld (player_coord),a
		ld a,1
		ld (sentido_player),a

	sigue_animacion_entrada
		ld a,71			;player es blanco brillante
		ld (SPRITE_ATTR),a
		ld a,(player_fila)
		ld (SPRITE_FILA),a
		ld a,(player_col)
		ld (SPRITE_COL),a
		ld a,(player_coord)
		ld (SPRITE_COORD),a
		call pinta_sprite

		ld a,(player_coord)


		ld c,a
		ld b,8
		bucle_animacion_entrada
			
			call bucle_animacion_entrada_rutina
			
			djnz bucle_animacion_entrada

inicializa_player 	;se posiciona el player en funcion del sentido.sumo o resto posicion
		ld a,(sentido_player)
		cp 0
		jr nz,iniplayer_sentido1

		ld a,01110100b
		ld (player_coord),a
		ld a,(player_fila)
		dec a
		ld (player_fila),a
		jr inicializa_player_fin

		iniplayer_sentido1
		cp 1
		jr nz,iniplayer_sentido2

		ld a,01000001b
		ld (player_coord),a
		ld a,(player_col)
		inc a
		ld (player_col),a
		jr inicializa_player_fin

		iniplayer_sentido2
		cp 2
		jr nz,iniplayer_sentido3

		ld a,00010100b
		ld (player_coord),a
		ld a,(player_fila)
		inc a
		ld (player_fila),a
		jr inicializa_player_fin

		iniplayer_sentido3

		ld a,01000111b
		ld (player_coord),a
		ld a,(player_col)
		dec a
		ld (player_col),a

	inicializa_player_fin
		ld a,71		;player es blanco brillante
		ld (SPRITE_ATTR),a
		ld a,(player_fila)
		ld (SPRITE_FILA),a
		ld a,(player_col)
		ld (SPRITE_COL),a
		ld a,(player_coord)
		ld (SPRITE_COORD),a
		;call pulsa_tecla
		;call suelta_tecla
		call pinta_sprite


;ld a,2
;ld (status),a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bucle_principal		;status 2 (juego)
			;a cada paso por el bucle, todos los personajes tienen que moverse.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		

		call retardo1
	
captura_teclas

	;comprobar_tecla_izquierda:
	ld a, (tecla_izquierda)
	call check_key
	jr c, izq_no_pulsada            ; carry = 1, tecla no pulsada

	ld a,3
	ld (sentido_player),a

	izq_no_pulsada:

	;comprobar_tecla_derecha:
	ld a, (tecla_derecha)
	call check_key
	jr c, dere_no_pulsada            ; carry = 1, tecla no pulsada

	ld a,1
	ld (sentido_player),a

	dere_no_pulsada:
	
	;comprobar_tecla_arriba:
	ld a, (tecla_arriba)
	call check_key
	jr c, arr_no_pulsada            ; carry = 1, tecla no pulsada

	xor a
	ld (sentido_player),a

	arr_no_pulsada:
	
	;comprobar_tecla_abajo:
	ld a, (tecla_abajo)
	call check_key
	jr c, aba_no_pulsada            ; carry = 1, tecla no pulsada

	ld a,2
	ld (sentido_player),a

	aba_no_pulsada:
	
	;comprobar_tecla_beam:
	ld a, (tecla_beam)
	call check_key
	jr c, beam_no_pulsada            ; carry = 1, tecla no pulsada

	ld a,(beams)
	cp 0
	jp z,beam_no_pulsada
	dec a
	ld (beams),a
	call actualiza_scores

	call pulsa_tecla
	;borrar player actual
	xor a
	ld (SPRITE_ATTR),a

	ld a,(player_fila)
	ld (SPRITE_FILA),a
	ld a,(player_col)
	ld (SPRITE_COL),a

	call pinta_sprite

	;nueva fila
	call random
	and 00001111b
	inc a
	inc a
	inc a
	ld (player_fila),a

	;nueva col
	call random
	and 00001111b
	inc a
	inc a
	inc a
	ld (player_col),a
	call suelta_tecla




	beam_no_pulsada:

	;comprobar_tecla_pause:
	ld a,(tecla_pause)
	call check_key
	jr c, mueve_player

	call pulsa_tecla
	call suelta_tecla
	call pulsa_tecla
	call suelta_tecla



mueve_player:
	;ciclos
	ld a,(ciclos_player)
	cp 2
	jr nz,incrementa_ciclos_player
	xor a
	ld (ciclos_player),a
	jr mov_player
	incrementa_ciclos_player:
		inc a
		ld (ciclos_player),a
		jp mueve_enemigos

	mov_player:
		ld a,(player_coord)
		ld (SPRITE_COORD),a
		ld a,(player_fila)
		ld (SPRITE_FILA),a
		ld a,(player_col)
		ld (SPRITE_COL),a
		ld a,71		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		ld (SPRITE_ATTR),a


		ld a,(sentido_player)
		cp 0
		jr nz,no_sentido_player_arriba

		
		call mueve_player_arriba
		jp mueve_enemigos

		no_sentido_player_arriba:
		cp 1
		jr nz,no_sentido_player_derecha

		call mueve_player_derecha
		jp mueve_enemigos

		no_sentido_player_derecha:
		cp 2
		jr nz,no_sentido_player_abajo

		call mueve_player_abajo
		jp mueve_enemigos

		no_sentido_player_abajo:
		call mueve_player_izquierda
	

mueve_enemigos:



	mueve_enemigo1:
		
		;ciclos
		ld a,(enemigo1)
	

		cp 0
		jp z,mueve_enemigo2
		cp 1
		jr nz,ene1_ciclos_ene2
		ld b,6
		jr run_ciclos_enemigo1
		
		ene1_ciclos_ene2:
		cp 2
		jr nz,ene1_ciclos_ene3
		ld b,5
		jr run_ciclos_enemigo1

		ene1_ciclos_ene3:
		cp 3
		jr nz,ene1_ciclos_ene4
		ld b,4
		jr run_ciclos_enemigo1

		ene1_ciclos_ene4:
		ld b,3

		run_ciclos_enemigo1:
	
			ld a,(ciclos_enemigo1)
			cp b
			jr nz,incrementa_ciclos_enemigo1
			xor a
			ld (ciclos_enemigo1),a
			jr mov_enemigo1
			incrementa_ciclos_enemigo1:
				inc a
				ld (ciclos_enemigo1),a
				jp mueve_enemigo2

		
			mov_enemigo1:


			ld a,(enemigo1_fila)
			ld b,a
			ld a,(player_fila)
			sub b
			call absa
			ld b,a			;dejo en b la distancia absoluta en las filas 
			ld a,(enemigo1_col)
			ld c,a
			ld a,(player_col)
			sub c
			call absa		;en a tengo la distancia absoluta en las cols
			cp b			;lo comparo con la dist abs en las filas

			jr nc, enemigo1_COLmenorFILA
	
			;muevo verticalmente
			ld a,(enemigo1_fila)
			ld b,a
			ld a,(player_fila)
			cp b
			jr c,playerfila_menor_enemigo1
			ld a,2			;sentido abajo
			ld (sentido_enemigo1),a
			halt

			jp mov_enemigo1_fin

		playerfila_menor_enemigo1:
			xor a			;sentido arriba
			ld (sentido_enemigo1),a
			jr mov_enemigo1_fin

		enemigo1_COLmenorFILA:	;muevo horizontalmente

			ld a,(enemigo1_col)
			ld b,a
			ld a,(player_col)
			cp b
	
			jr c,playercol_menor_enemigo1
			ld a,1			;sentido derecha
			ld (sentido_enemigo1),a
			jr mov_enemigo1_fin

		playercol_menor_enemigo1:
			ld a,3			;sentido izquierda
			ld (sentido_enemigo1),a
			jr mov_enemigo1_fin

		enemigo1_random:

			call random
			and 3
			ld (sentido_enemigo1),a

		mov_enemigo1_fin:

			ld a,(enemigo1_coord)
			ld b,a
			ld a,(enemigo1_fila)
			ld (SPRITE_FILA),a
			ld a,(enemigo1_col)
			ld (SPRITE_COL),a
			ld a,(sentido_enemigo1)
	
			cp 0				;comprueba arriba
			jr nz,enemigo1_sentido_NO_arriba
			;ld a,b
			ld a,(enemigo1_coord)
			ld (SPRITE_COORD),a

			call cambia_coord_enemigo_arriba

			ld a,(SPRITE_COORD)
			ld (enemigo1_coord),a
			ld a,(SPRITE_FILA)
			ld (enemigo1_fila),a
			ld a,b
			ld (sentido_enemigo1),a

			jr mov_enemigo1_finfin

			enemigo1_sentido_NO_arriba:	;comprueba derecha
				cp 1
				jr nz,enemigo1_sentido_NO_derecha
				;ld a,b
				ld a,(enemigo1_coord)
				ld (SPRITE_COORD),a
			
				call cambia_coord_enemigo_derecha

				ld a,(SPRITE_COORD)
				ld (enemigo1_coord),a
				ld a,(SPRITE_COL)
				ld (enemigo1_col),a
				ld a,b
				ld (sentido_enemigo1),a
	
				jr mov_enemigo1_finfin

			enemigo1_sentido_NO_derecha:	;comprueba abajo
				cp 2
				jr nz,enemigo1_sentido_NO_abajo
				;ld a,b
				ld a,(enemigo1_coord)
				ld (SPRITE_COORD),a

				call cambia_coord_enemigo_abajo

				ld a,(SPRITE_COORD)
				ld (enemigo1_coord),a
				ld a,(SPRITE_FILA)
				ld (enemigo1_fila),a
				ld a,b
				ld (sentido_enemigo1),a

				jr mov_enemigo1_finfin

			enemigo1_sentido_NO_abajo:	;es izquierda
				cp 3
				jr nz,mov_enemigo1_finfin
				;ld a,b
				ld a,(enemigo1_coord)
				ld (SPRITE_COORD),a
				
				call cambia_coord_enemigo_izquierda

				ld a,(SPRITE_COORD)
				ld (enemigo1_coord),a
				ld a,(SPRITE_COL)
				ld (enemigo1_col),a
				ld a,b
				ld (sentido_enemigo1),a

		mov_enemigo1_finfin:
			ld a,(SPRITE_COORD)
			ld (enemigo1_coord),a
			;ld a,(sentido_enemigos)
			;and 11111100b
			;or b
			
			ld a,(enemigo1)
			cp 1
			jr nz,enemigo1_no_verde_bis
			ld a,4				;es verde
			jr mov_enemigo1_finfinfin

			enemigo1_no_verde_bis:
				cp 2
				jr nz,enemigo1_no_amarillo_bis
				ld a,6
				jr mov_enemigo1_finfinfin

			enemigo1_no_amarillo_bis:
				cp 3
				jr nz,enemigo1_no_magenta_bis
				ld a,3
				jr mov_enemigo1_finfinfin

			enemigo1_no_magenta_bis:
				ld a,2

		mov_enemigo1_finfinfin:
;ld a,52;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;debug
			ld (SPRITE_ATTR),a
			ld a,(enemigo1_fila)
			ld (SPRITE_FILA),a
			ld a,(enemigo1_col)
			ld (SPRITE_COL),a

			call pinta_sprite







	mueve_enemigo2:

		;ciclos
		ld a,(enemigo2)
	

		cp 0
		jp z,mueve_enemigo3
		cp 1
		jr nz,ene2_ciclos_ene2
		ld b,6
		jr run_ciclos_enemigo2
		
		ene2_ciclos_ene2:
		cp 2
		jr nz,ene2_ciclos_ene3
		ld b,5
		jr run_ciclos_enemigo2

		ene2_ciclos_ene3:
		cp 3
		jr nz,ene2_ciclos_ene4
		ld b,4
		jr run_ciclos_enemigo2

		ene2_ciclos_ene4:
		ld b,3

		run_ciclos_enemigo2:
	
			ld a,(ciclos_enemigo2)
			cp b
			jr nz,incrementa_ciclos_enemigo2
			xor a
			ld (ciclos_enemigo2),a
			jr mov_enemigo2
			incrementa_ciclos_enemigo2:
				inc a
				ld (ciclos_enemigo2),a
				jp mueve_enemigo3

		
			mov_enemigo2:


			ld a,(enemigo2_fila)
			ld b,a
			ld a,(player_fila)
			sub b
			call absa
			ld b,a			;dejo en b la distancia absoluta en las filas 
			ld a,(enemigo2_col)
			ld c,a
			ld a,(player_col)
			sub c
			call absa		;en a tengo la distancia absoluta en las cols
			cp b			;lo comparo con la dist abs en las filas

			jr nc, enemigo2_COLmenorFILA
	
			;muevo verticalmente
			ld a,(enemigo2_fila)
			ld b,a
			ld a,(player_fila)
			cp b
			jr c,playerfila_menor_enemigo2
			ld a,2			;sentido abajo
	
			ld (sentido_enemigo2),a
			halt

			jp mov_enemigo2_fin

		playerfila_menor_enemigo2:
			xor a			;sentido arriba
			
			ld (sentido_enemigo2),a
			jr mov_enemigo2_fin

		enemigo2_COLmenorFILA:	;muevo horizontalmente

			ld a,(enemigo2_col)
			ld b,a
			ld a,(player_col)
			cp b
	
			jr c,playercol_menor_enemigo2
			ld a,1			;sentido derecha
			
			ld (sentido_enemigo2),a
			jr mov_enemigo2_fin

		playercol_menor_enemigo2:
			ld a,3			;sentido izquierda
			
			ld (sentido_enemigo2),a
			jr mov_enemigo2_fin

		enemigo2_random:

			call random
			and 3
			
			ld (sentido_enemigo2),a

		mov_enemigo2_fin:
			
			ld a,(enemigo2_coord)
			ld b,a
			ld a,(enemigo2_fila)
			ld (SPRITE_FILA),a
			ld a,(enemigo2_col)
			ld (SPRITE_COL),a
			ld a,(sentido_enemigo2)
	
			cp 0				;comprueba arriba
			jr nz,enemigo2_sentido_NO_arriba
			;ld a,b
			ld a,(enemigo2_coord)
			ld (SPRITE_COORD),a

			call cambia_coord_enemigo_arriba

			ld a,(SPRITE_COORD)
			ld (enemigo2_coord),a
			ld a,(SPRITE_FILA)
			ld (enemigo2_fila),a
			ld a,b
			ld (sentido_enemigo2),a

			jr mov_enemigo2_finfin

			enemigo2_sentido_NO_arriba:	;comprueba derecha
				cp 1
				jr nz,enemigo2_sentido_NO_derecha
				;ld a,b
				ld a,(enemigo2_coord)
				ld (SPRITE_COORD),a
			
				call cambia_coord_enemigo_derecha

				ld a,(SPRITE_COORD)
				ld (enemigo2_coord),a
				ld a,(SPRITE_COL)
				ld (enemigo2_col),a
				ld a,b
				ld (sentido_enemigo2),a
	
				jr mov_enemigo2_finfin

			enemigo2_sentido_NO_derecha:	;comprueba abajo
				cp 2
				jr nz,enemigo2_sentido_NO_abajo
				;ld a,b
				ld a,(enemigo2_coord)
				ld (SPRITE_COORD),a

				call cambia_coord_enemigo_abajo

				ld a,(SPRITE_COORD)
				ld (enemigo2_coord),a
				ld a,(SPRITE_FILA)
				ld (enemigo2_fila),a
				ld a,b
				ld (sentido_enemigo2),a

				jr mov_enemigo2_finfin

			enemigo2_sentido_NO_abajo:	;es izquierda
				cp 3
				jr nz,mov_enemigo2_finfin
				;ld a,b
				ld a,(enemigo2_coord)
				ld (SPRITE_COORD),a
				
				call cambia_coord_enemigo_izquierda

				ld a,(SPRITE_COORD)
				ld (enemigo2_coord),a
				ld a,(SPRITE_COL)
				ld (enemigo2_col),a
				ld a,b
				ld (sentido_enemigo2),a

		mov_enemigo2_finfin:
			ld a,(SPRITE_COORD)
			ld (enemigo2_coord),a
			;ld a,(sentido_enemigos)
			;and 11111100b
			;or b
			
			ld a,(enemigo2)
			cp 1
			jr nz,enemigo2_no_verde_bis
			ld a,4				;es verde
			jr mov_enemigo2_finfinfin

			enemigo2_no_verde_bis:
				cp 2
				jr nz,enemigo2_no_amarillo_bis
				ld a,6
				jr mov_enemigo2_finfinfin

			enemigo2_no_amarillo_bis:
				cp 3
				jr nz,enemigo2_no_magenta_bis
				ld a,3
				jr mov_enemigo2_finfinfin

			enemigo2_no_magenta_bis:
				ld a,2

		mov_enemigo2_finfinfin:
			ld (SPRITE_ATTR),a
			ld a,(enemigo2_fila)
			ld (SPRITE_FILA),a
			ld a,(enemigo2_col)
			ld (SPRITE_COL),a

			call pinta_sprite





	mueve_enemigo3:

		;ciclos
		ld a,(enemigo3)
	

		cp 0
		jp z,mueve_enemigo4
		cp 1
		jr nz,ene3_ciclos_ene2
		ld b,6
		jr run_ciclos_enemigo3
		
		ene3_ciclos_ene2:
		cp 2
		jr nz,ene3_ciclos_ene3
		ld b,5
		jr run_ciclos_enemigo3

		ene3_ciclos_ene3:
		cp 3
		jr nz,ene3_ciclos_ene4
		ld b,4
		jr run_ciclos_enemigo3

		ene3_ciclos_ene4:
		ld b,3

		run_ciclos_enemigo3:
	
			ld a,(ciclos_enemigo3)
			cp b
			jr nz,incrementa_ciclos_enemigo3
			xor a
			ld (ciclos_enemigo3),a
			jr mov_enemigo3
			incrementa_ciclos_enemigo3:
				inc a
				ld (ciclos_enemigo3),a
				jp mueve_enemigo4

		
			mov_enemigo3:


			ld a,(enemigo3_fila)
			ld b,a
			ld a,(player_fila)
			sub b
			call absa
			ld b,a			;dejo en b la distancia absoluta en las filas 
			ld a,(enemigo3_col)
			ld c,a
			ld a,(player_col)
			sub c
			call absa		;en a tengo la distancia absoluta en las cols
			cp b			;lo comparo con la dist abs en las filas

			jr nc, enemigo3_COLmenorFILA
	
			;muevo verticalmente
			ld a,(enemigo3_fila)
			ld b,a
			ld a,(player_fila)
			cp b
			jr c,playerfila_menor_enemigo3
			ld a,2			;sentido abajo
	
			ld (sentido_enemigo3),a
			halt

			jp mov_enemigo3_fin

		playerfila_menor_enemigo3:
			xor a			;sentido arriba
			
			ld (sentido_enemigo3),a
			jr mov_enemigo3_fin

		enemigo3_COLmenorFILA:	;muevo horizontalmente

			ld a,(enemigo3_col)
			ld b,a
			ld a,(player_col)
			cp b
	
			jr c,playercol_menor_enemigo3
			ld a,1			;sentido derecha
			
			ld (sentido_enemigo3),a
			jr mov_enemigo3_fin

		playercol_menor_enemigo3:
			ld a,3			;sentido izquierda
			
			ld (sentido_enemigo3),a
			jr mov_enemigo3_fin

		enemigo3_random:

			call random
			and 3
			
			ld (sentido_enemigo3),a

		mov_enemigo3_fin:
			
			ld a,(enemigo3_coord)
			ld b,a
			ld a,(enemigo3_fila)
			ld (SPRITE_FILA),a
			ld a,(enemigo3_col)
			ld (SPRITE_COL),a
			ld a,(sentido_enemigo3)
	
			cp 0				;comprueba arriba
			jr nz,enemigo3_sentido_NO_arriba
			;ld a,b
			ld a,(enemigo3_coord)
			ld (SPRITE_COORD),a

			call cambia_coord_enemigo_arriba

			ld a,(SPRITE_COORD)
			ld (enemigo3_coord),a
			ld a,(SPRITE_FILA)
			ld (enemigo3_fila),a
			ld a,b
			ld (sentido_enemigo3),a

			jr mov_enemigo3_finfin

			enemigo3_sentido_NO_arriba:	;comprueba derecha
				cp 1
				jr nz,enemigo3_sentido_NO_derecha
				;ld a,b
				ld a,(enemigo3_coord)
				ld (SPRITE_COORD),a
			
				call cambia_coord_enemigo_derecha

				ld a,(SPRITE_COORD)
				ld (enemigo3_coord),a
				ld a,(SPRITE_COL)
				ld (enemigo3_col),a
				ld a,b
				ld (sentido_enemigo3),a
	
				jr mov_enemigo3_finfin

			enemigo3_sentido_NO_derecha:	;comprueba abajo
				cp 2
				jr nz,enemigo3_sentido_NO_abajo
				;ld a,b
				ld a,(enemigo3_coord)
				ld (SPRITE_COORD),a

				call cambia_coord_enemigo_abajo

				ld a,(SPRITE_COORD)
				ld (enemigo3_coord),a
				ld a,(SPRITE_FILA)
				ld (enemigo3_fila),a
				ld a,b
				ld (sentido_enemigo3),a

				jr mov_enemigo3_finfin

			enemigo3_sentido_NO_abajo:	;es izquierda
				cp 3
				jr nz,mov_enemigo3_finfin
				;ld a,b
				ld a,(enemigo3_coord)
				ld (SPRITE_COORD),a
				
				call cambia_coord_enemigo_izquierda

				ld a,(SPRITE_COORD)
				ld (enemigo3_coord),a
				ld a,(SPRITE_COL)
				ld (enemigo3_col),a
				ld a,b
				ld (sentido_enemigo3),a

		mov_enemigo3_finfin:
			ld a,(SPRITE_COORD)
			ld (enemigo3_coord),a
			;ld a,(sentido_enemigos)
			;and 11111100b
			;or b
			
			ld a,(enemigo3)
			cp 1
			jr nz,enemigo3_no_verde_bis
			ld a,4				;es verde
			jr mov_enemigo3_finfinfin

			enemigo3_no_verde_bis:
				cp 2
				jr nz,enemigo3_no_amarillo_bis
				ld a,6
				jr mov_enemigo3_finfinfin

			enemigo3_no_amarillo_bis:
				cp 3
				jr nz,enemigo3_no_magenta_bis
				ld a,3
				jr mov_enemigo3_finfinfin

			enemigo3_no_magenta_bis:
				ld a,2

		mov_enemigo3_finfinfin:
			ld (SPRITE_ATTR),a
			ld a,(enemigo3_fila)
			ld (SPRITE_FILA),a
			ld a,(enemigo3_col)
			ld (SPRITE_COL),a

			call pinta_sprite
		


	mueve_enemigo4:

		;ciclos
		ld a,(enemigo4)
	

		cp 0
		jp z,chequea_llave
		cp 1
		jr nz,ene4_ciclos_ene2
		ld b,6
		jr run_ciclos_enemigo4
		
		ene4_ciclos_ene2:
		cp 2
		jr nz,ene4_ciclos_ene3
		ld b,5
		jr run_ciclos_enemigo4

		ene4_ciclos_ene3:
		cp 3
		jr nz,ene4_ciclos_ene4
		ld b,4
		jr run_ciclos_enemigo4

		ene4_ciclos_ene4:
		ld b,3

		run_ciclos_enemigo4:
	
			ld a,(ciclos_enemigo4)
			cp b
			jr nz,incrementa_ciclos_enemigo4
			xor a
			ld (ciclos_enemigo4),a
			jr mov_enemigo4
			incrementa_ciclos_enemigo4:
				inc a
				ld (ciclos_enemigo4),a
				jp chequea_llave

		
			mov_enemigo4:


			ld a,(enemigo4_fila)
			ld b,a
			ld a,(player_fila)
			sub b
			call absa
			ld b,a			;dejo en b la distancia absoluta en las filas 
			ld a,(enemigo4_col)
			ld c,a
			ld a,(player_col)
			sub c
			call absa		;en a tengo la distancia absoluta en las cols
			cp b			;lo comparo con la dist abs en las filas

			jr nc, enemigo4_COLmenorFILA
	
			;muevo verticalmente
			ld a,(enemigo4_fila)
			ld b,a
			ld a,(player_fila)
			cp b
			jr c,playerfila_menor_enemigo4
			ld a,2			;sentido abajo
	
			ld (sentido_enemigo4),a
			halt

			jp mov_enemigo4_fin

		playerfila_menor_enemigo4:
			xor a			;sentido arriba
			
			ld (sentido_enemigo4),a
			jr mov_enemigo4_fin

		enemigo4_COLmenorFILA:	;muevo horizontalmente

			ld a,(enemigo4_col)
			ld b,a
			ld a,(player_col)
			cp b
	
			jr c,playercol_menor_enemigo4
			ld a,1			;sentido derecha
			
			ld (sentido_enemigo4),a
			jr mov_enemigo4_fin

		playercol_menor_enemigo4:
			ld a,3			;sentido izquierda
			
			ld (sentido_enemigo4),a
			jr mov_enemigo4_fin

		enemigo4_random:

			call random
			and 3
			
			ld (sentido_enemigo4),a

		mov_enemigo4_fin:
			
			ld a,(enemigo4_coord)
			ld b,a
			ld a,(enemigo4_fila)
			ld (SPRITE_FILA),a
			ld a,(enemigo4_col)
			ld (SPRITE_COL),a
			ld a,(sentido_enemigo4)
	
			cp 0				;comprueba arriba
			jr nz,enemigo4_sentido_NO_arriba
			;ld a,b
			ld a,(enemigo4_coord)
			ld (SPRITE_COORD),a

			call cambia_coord_enemigo_arriba

			ld a,(SPRITE_COORD)
			ld (enemigo4_coord),a
			ld a,(SPRITE_FILA)
			ld (enemigo4_fila),a
			ld a,b
			ld (sentido_enemigo4),a

			jr mov_enemigo4_finfin

			enemigo4_sentido_NO_arriba:	;comprueba derecha
				cp 1
				jr nz,enemigo4_sentido_NO_derecha
				;ld a,b
				ld a,(enemigo4_coord)
				ld (SPRITE_COORD),a
			
				call cambia_coord_enemigo_derecha

				ld a,(SPRITE_COORD)
				ld (enemigo4_coord),a
				ld a,(SPRITE_COL)
				ld (enemigo4_col),a
				ld a,b
				ld (sentido_enemigo4),a
	
				jr mov_enemigo4_finfin

			enemigo4_sentido_NO_derecha:	;comprueba abajo
				cp 2
				jr nz,enemigo4_sentido_NO_abajo
				;ld a,b
				ld a,(enemigo4_coord)
				ld (SPRITE_COORD),a

				call cambia_coord_enemigo_abajo

				ld a,(SPRITE_COORD)
				ld (enemigo4_coord),a
				ld a,(SPRITE_FILA)
				ld (enemigo4_fila),a
				ld a,b
				ld (sentido_enemigo4),a

				jr mov_enemigo4_finfin

			enemigo4_sentido_NO_abajo:	;es izquierda
				cp 3
				jr nz,mov_enemigo4_finfin
				;ld a,b
				ld a,(enemigo4_coord)
				ld (SPRITE_COORD),a
				
				call cambia_coord_enemigo_izquierda

				ld a,(SPRITE_COORD)
				ld (enemigo4_coord),a
				ld a,(SPRITE_COL)
				ld (enemigo4_col),a
				ld a,b
				ld (sentido_enemigo4),a

		mov_enemigo4_finfin:
			ld a,(SPRITE_COORD)
			ld (enemigo4_coord),a
			;ld a,(sentido_enemigos)
			;and 11111100b
			;or b
			
			ld a,(enemigo4)
			cp 1
			jr nz,enemigo4_no_verde_bis
			ld a,4				;es verde
			jr mov_enemigo4_finfinfin

			enemigo4_no_verde_bis:
				cp 2
				jr nz,enemigo4_no_amarillo_bis
				ld a,6
				jr mov_enemigo4_finfinfin

			enemigo4_no_amarillo_bis:
				cp 3
				jr nz,enemigo4_no_magenta_bis
				ld a,3
				jr mov_enemigo4_finfinfin

			enemigo4_no_magenta_bis:
				ld a,2

		mov_enemigo4_finfinfin:
			ld (SPRITE_ATTR),a
			ld a,(enemigo4_fila)
			ld (SPRITE_FILA),a
			ld a,(enemigo4_col)
			ld (SPRITE_COL),a

			call pinta_sprite


chequea_llave:

	ld a,(llave_mostrada)
	cp 1
	jp z,muestra_llave_fin
	cp 2
	jp z,comprueba_colisiones

	;ciclos
	
	ld a,(llave)
	cp 0
	jp z,comprueba_colisiones

	

	;multiplicar_ciclos_llave
	;	sla a
	;	djnz multiplicar_ciclos_llave
	;ld b,a

	run_ciclos_llave:
		
		ld a,(ciclos_llave)
		cp b
		jr nz,incrementa_ciclos_llave
		xor a
		ld (ciclos_llave),a
		jr multiplicador_llave
		incrementa_ciclos_llave:
			inc a
			ld (ciclos_llave),a
			jp comprueba_colisiones

	multiplicador_llave:
		ld a,(multiplicador)
		ld b,a
		ld a,(veces_multiplicadas)
		cp b
		jr nz,incrementa_veces_multiplicadas
		xor a
		ld (veces_multiplicadas),a
		jr muestra_llave
		incrementa_veces_multiplicadas:
			inc a
			ld (veces_multiplicadas),a
			xor a
			ld (ciclos_llave),a
			jp comprueba_colisiones

	muestra_llave:

		
		random_llave_fila
			call random
			and 00011111b
			cp 3
			jr c,random_llave_fila
			cp 21
			jr nc,random_llave_fila
			ld (llave_fila),a

		random_llave_col
			call random
			and 00011111b
			cp 3
			jr c,random_llave_col
			cp 21
			jr nc,random_llave_col
			ld (llave_col),a


	muestra_llave_fin:

		;calcular posicion en alta resolucion de la llave
		ld a,(llave_fila)
		ld b,a
		ld a,(llave_col)
		ld c,a
		call Get_Char_Offset_LR		;dir pantalla en HL
		
		call pinta_llave
		
		ld a,1
		ld (llave_mostrada),a
		


comprueba_colisiones
	ld a,(llave_mostrada)
	cp 1
	jp nz,otras_colisiones

	call check_colision_llave ;la rutina devuelve en a: 0-no colision 1-colision
	cp 0
	jr z,otras_colisiones

	;hay colision con llave
	;calcular posicion en alta resolucion de la llave
	ld a,(llave_fila)
	ld b,a
	ld a,(llave_col)
	ld c,a
	call Get_Char_Offset_LR		;dir pantalla en HL
	call borra_llave
	
	ld a,2
	ld (llave_mostrada),a
	call pinta_salida_LR


	otras_colisiones:
		call check_colision_enemigos
		;la rutina devuelve en a: 0-no colision 1-colision
		;xor a ;;debug
		cp 0
		jp z,comprueba_salida
		;hay colision: status:3-colision
; 	;debug
; 	ld ix,16384
; 	ld (ix),a
; 	ld (ix+1),c
; 	ld a,(enemigo3)
; 	ld (ix+2),a
; 	ld a,(enemigo3_fila)
; 	ld (ix+3),a
; 	ld a,(enemigo3_col)
; 	ld (ix+4),a
; 	ld a,(enemigo3_coord)
; 	ld (ix+5),a
	
; 	;border
; 	ld a,1
; 	call 8859 
		call explosion
		ld a,(vidas)
		dec a
		ld (vidas),a
		cp 0
		jp z,go_menu_principal
		;quedan vidas
		jp pinta_scores

		go_menu_principal:
			call pulsa_tecla
			call suelta_tecla
			jp menu_principal

comprueba_salida
	;call check_salida
	;la rutina devuelve en a: 0-no en salida 1-en salida
	;xor a ;;debug
	;cp 0
	jp z,bucle_principal

	
	;el player ha llegado a la salida

	player_en_salida:
	call animacion_salida
	ld a,(total_pantallas)
	ld b,a
	ld a,(num_pantalla)
	inc a
	ld (num_pantalla),a
	cp b
	jp nz,pinta_scores
	;ultima pantalla
	;;;call pantalla_congrats
	jp menu_principal



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;RUTINAS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;-------------------------------------------------------------
;Comprueba si hay colision con alguno de los enemigos
;Devuelve a=0 no hay colision; a=1 hay
;-------------------------------------------------------------
check_colision_enemigos:

	ld a,enemigo1
	cp 0
	jr z,entonces_check_enemigo2
	call check_colision_enemigo1
	cp 1
	jr z,fin_check_colision_enemigos

	entonces_check_enemigo2:
	ld a,enemigo2
	cp 0
	jr z,entonces_check_enemigo3
	call check_colision_enemigo2
	cp 1
	jr z,fin_check_colision_enemigos

	entonces_check_enemigo3:
	ld a,enemigo3
	cp 0
	jr z,entonces_check_enemigo4
	call check_colision_enemigo3
	cp 1
	jr z,fin_check_colision_enemigos

	entonces_check_enemigo4:
	ld a,enemigo4
	cp 0
	jr z,no_colisiones_enemigos
	call check_colision_enemigo4
	cp 1
	jr z,fin_check_colision_enemigos

 	no_colisiones_enemigos:
 	xor a
 	;ret;debug
 	fin_check_colision_enemigos:


		ret








;--------------------------------------------------------------
check_colision_enemigo1:
	
	;enemigo1 fuera del alcance por arriba
		
		ld a,(player_fila)
		dec a
		ld b,a

		ld a,(enemigo1_fila)

		cp b
		jp c,enemigo1_no_colision


	;enemigo1 fuera del alcance por la izq
		

		ld a,(player_col)
		dec a
		ld b,a

		ld a,(enemigo1_col)

		cp b
		jp c,enemigo1_no_colision

	;enemigo1 fuera del alcance por abajo:
		

		ld a,(player_fila)
		inc a
		ld b,a

		ld a,(enemigo1_fila)

		cp b
		jp nc,enemigo1_no_colision

	;enemigo1 fuera del alcance por la derecha
		

		ld a,(player_col)
		inc a
		ld b,a

		ld a,(enemigo1_col)

		cp b
		jp nc,enemigo1_no_colision


	;comparaciones a nivel de coordenadas internas, pero segun las 9 posibles situaciones

	enemigo1_caso1:
		;comprobar columna
		ld a,(player_col)
		dec a
		ld b,a
		ld a,(enemigo1_col)
		cp b
		jr nz,enemigo1_caso2
		
		;comprobar fila
		ld a,(player_fila)
		dec a
		ld b,a
		ld a,(enemigo1_fila)
		cp b
		jr nz,enemigo1_caso2

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo1_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo1_no_colision
			jp m,enemigo1_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo1_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo1_no_colision
			jp m,enemigo1_no_colision

		jp enemigo1_colision

			

	enemigo1_caso2:
		;comprobar columna
		ld a,(player_col)
		ld b,a
		ld a,(enemigo1_col)
		cp b
		jr nz,enemigo1_caso3
		
		;comprobar fila
		ld a,(player_fila)
		dec a
		ld b,a
		ld a,(enemigo1_fila)
		cp b
		jr nz,enemigo1_caso3

		;Comprobacion coordenadas internas

			;COL
			ld a,(enemigo1_coord)
			and 00001111b
			ld b,a

			ld a,(player_coord)
			and 00001111b

			sub b
			call absa

			cp 8
			jp z,enemigo1_no_colision

		
			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo1_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b

			cp 0
			jp m,enemigo1_no_colision
			jp z,enemigo1_no_colision


		jp enemigo1_colision


	enemigo1_caso3:
		;comprobar columna
		ld a,(player_col)
		inc a
		ld b,a
		ld a,(enemigo1_col)
		cp b
		jr nz,enemigo1_caso4
		
		;comprobar fila
		ld a,(player_fila)
		dec a
		ld b,a
		ld a,(enemigo1_fila)
		cp b
		jr nz,enemigo1_caso4

		;Comprobacion coordenadas internas

			;COL
			ld a,(enemigo1_coord)
			and 00001111b
			ld b,a

			ld a,(player_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo1_no_colision
			jp m,enemigo1_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo1_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo1_no_colision
			jp m,enemigo1_no_colision
	
		jp enemigo1_colision


	enemigo1_caso4:
		;comprobar columna
		ld a,(player_col)
		dec a
		ld b,a
		ld a,(enemigo1_col)
		cp b
		jr nz,enemigo1_caso5
		
		;comprobar fila
		ld a,(player_fila)
		ld b,a
		ld a,(enemigo1_fila)
		cp b
		jr nz,enemigo1_caso5

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo1_coord)

			and 00001111b

			sub b
		
			cp 0
			jp z,enemigo1_no_colision
			jp m,enemigo1_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo1_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b

			call absa
			cp 8
			jp z,enemigo1_no_colision


		jp enemigo1_colision


	enemigo1_caso5:
		;comprobar columna
		ld a,(player_col)
		ld b,a
		ld a,(enemigo1_col)
		cp b
		jr nz,enemigo1_caso6
		
		;comprobar fila
		ld a,(player_fila)
		ld b,a
		ld a,(enemigo1_fila)
		cp b
		jr nz,enemigo1_caso6

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo1_coord)
			and 00001111b

			sub b
			call absa
			cp 8
			jp z,enemigo1_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo1_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			call absa
			cp 8
			jp z,enemigo1_no_colision


		jp enemigo1_colision


	enemigo1_caso6:
		;comprobar columna
		ld a,(player_col)
		inc a
		ld b,a
		ld a,(enemigo1_col)
		cp b
		jr nz,enemigo1_caso7
		
		;comprobar fila
		ld a,(player_fila)
		ld b,a
		ld a,(enemigo1_fila)
		cp b
		jr nz,enemigo1_caso7

		;Comprobacion coordenadas internas

			;COL
			ld a,(enemigo1_coord)
			and 00001111b
			ld b,a

			ld a,(player_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo1_no_colision
			jp m,enemigo1_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo1_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b

			call absa
			cp 8
			jp z,enemigo1_no_colision

		jp enemigo1_colision


	enemigo1_caso7:
		;comprobar columna
		ld a,(player_col)
		dec a
		ld b,a
		ld a,(enemigo1_col)
		cp b
		jr nz,enemigo1_caso8
		
		;comprobar fila
		ld a,(player_fila)
		inc a
		ld b,a
		ld a,(enemigo1_fila)
		cp b
		jr nz,enemigo1_caso8

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo1_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo1_no_colision
			jp m,enemigo1_no_colision

			;FILA
			ld a,(enemigo1_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(player_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo1_no_colision
			jp m,enemigo1_no_colision

		jp enemigo1_colision



	enemigo1_caso8:
		;comprobar columna
		ld a,(player_col)
		ld b,a
		ld a,(enemigo1_col)
		cp b
		jr nz,enemigo1_caso9
		
		;comprobar fila
		ld a,(player_fila)
		inc a
		ld b,a
		ld a,(enemigo1_fila)
		cp b
		jr nz,enemigo1_caso9

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo1_coord)
			and 00001111b

			sub b
			call absa
			cp 8
			jp z,enemigo1_no_colision

			;FILA
			ld a,(enemigo1_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(player_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo1_no_colision
			jp m,enemigo1_no_colision

		jp enemigo1_colision

	enemigo1_caso9:
		;comprobar columna
		ld a,(player_col)
		inc a
		ld b,a
		ld a,(enemigo1_col)
		cp b
		jr nz,enemigo1_no_colision
		
		;comprobar fila
		ld a,(player_fila)
		inc a
		ld b,a
		ld a,(enemigo1_fila)
		cp b
		jr nz,enemigo1_no_colision

		;Comprobacion coordenadas internas

			;COL
			ld a,(enemigo1_coord)
			and 00001111b
			ld b,a

			ld a,(player_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo1_no_colision
			jp m,enemigo1_no_colision

			;FILA
			ld a,(enemigo1_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(player_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo1_no_colision
			jp m,enemigo1_no_colision



	enemigo1_colision:
	ld a,1
	ret

	enemigo1_no_colision:

		xor a
		ret





;--------------------------------------------------------------
check_colision_enemigo2:

	;enemigo2 fuera del alcance por arriba
		
		ld a,(player_fila)
		dec a
		ld b,a

		ld a,(enemigo2_fila)

		cp b
		jp c,enemigo2_no_colision


	;enemigo2 fuera del alcance por la izq
		

		ld a,(player_col)
		dec a
		ld b,a

		ld a,(enemigo2_col)

		cp b
		jp c,enemigo2_no_colision

	;enemigo2 fuera del alcance por abajo:
		

		ld a,(player_fila)
		inc a
		ld b,a

		ld a,(enemigo2_fila)

		cp b
		jp nc,enemigo2_no_colision

	;enemigo2 fuera del alcance por la derecha
		

		ld a,(player_col)
		inc a
		ld b,a

		ld a,(enemigo2_col)

		cp b
		jp nc,enemigo2_no_colision


	;comparaciones a nivel de coordenadas internas, pero segun las 9 posibles situaciones

	enemigo2_caso1:
		;comprobar columna
		ld a,(player_col)
		dec a
		ld b,a
		ld a,(enemigo2_col)
		cp b
		jr nz,enemigo2_caso2
		
		;comprobar fila
		ld a,(player_fila)
		dec a
		ld b,a
		ld a,(enemigo2_fila)
		cp b
		jr nz,enemigo2_caso2

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo2_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo2_no_colision
			jp m,enemigo2_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo2_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo2_no_colision
			jp m,enemigo2_no_colision

		jp enemigo2_colision

			

	enemigo2_caso2:
		;comprobar columna
		ld a,(player_col)
		ld b,a
		ld a,(enemigo2_col)
		cp b
		jr nz,enemigo2_caso3
		
		;comprobar fila
		ld a,(player_fila)
		dec a
		ld b,a
		ld a,(enemigo2_fila)
		cp b
		jr nz,enemigo2_caso3

		;Comprobacion coordenadas internas

			;COL
			ld a,(enemigo2_coord)
			and 00001111b
			ld b,a

			ld a,(player_coord)
			and 00001111b

			sub b
			call absa

			cp 8
			jp z,enemigo2_no_colision

		
			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo2_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b

			cp 0
			jp m,enemigo2_no_colision
			jp z,enemigo2_no_colision


		jp enemigo2_colision


	enemigo2_caso3:
		;comprobar columna
		ld a,(player_col)
		inc a
		ld b,a
		ld a,(enemigo2_col)
		cp b
		jr nz,enemigo2_caso4
		
		;comprobar fila
		ld a,(player_fila)
		dec a
		ld b,a
		ld a,(enemigo2_fila)
		cp b
		jr nz,enemigo2_caso4

		;Comprobacion coordenadas internas

			;COL
			ld a,(enemigo2_coord)
			and 00001111b
			ld b,a

			ld a,(player_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo2_no_colision
			jp m,enemigo2_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo2_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo2_no_colision
			jp m,enemigo2_no_colision
	
		jp enemigo2_colision


	enemigo2_caso4:
		;comprobar columna
		ld a,(player_col)
		dec a
		ld b,a
		ld a,(enemigo2_col)
		cp b
		jr nz,enemigo2_caso5
		
		;comprobar fila
		ld a,(player_fila)
		ld b,a
		ld a,(enemigo2_fila)
		cp b
		jr nz,enemigo2_caso5

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo2_coord)

			and 00001111b

			sub b
		
			cp 0
			jp z,enemigo2_no_colision
			jp m,enemigo2_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo2_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b

			call absa
			cp 8
			jp z,enemigo2_no_colision


		jp enemigo2_colision


	enemigo2_caso5:
		;comprobar columna
		ld a,(player_col)
		ld b,a
		ld a,(enemigo2_col)
		cp b
		jr nz,enemigo2_caso6
		
		;comprobar fila
		ld a,(player_fila)
		ld b,a
		ld a,(enemigo2_fila)
		cp b
		jr nz,enemigo2_caso6

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo2_coord)
			and 00001111b

			sub b
			call absa
			cp 8
			jp z,enemigo2_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo2_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			call absa
			cp 8
			jp z,enemigo2_no_colision


		jp enemigo2_colision


	enemigo2_caso6:
		;comprobar columna
		ld a,(player_col)
		inc a
		ld b,a
		ld a,(enemigo2_col)
		cp b
		jr nz,enemigo2_caso7
		
		;comprobar fila
		ld a,(player_fila)
		ld b,a
		ld a,(enemigo2_fila)
		cp b
		jr nz,enemigo2_caso7

		;Comprobacion coordenadas internas

			;COL
			ld a,(enemigo2_coord)
			and 00001111b
			ld b,a

			ld a,(player_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo2_no_colision
			jp m,enemigo2_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo2_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b

			call absa
			cp 8
			jp z,enemigo2_no_colision

		jp enemigo2_colision


	enemigo2_caso7:
		;comprobar columna
		ld a,(player_col)
		dec a
		ld b,a
		ld a,(enemigo2_col)
		cp b
		jr nz,enemigo2_caso8
		
		;comprobar fila
		ld a,(player_fila)
		inc a
		ld b,a
		ld a,(enemigo2_fila)
		cp b
		jr nz,enemigo2_caso8

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo2_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo2_no_colision
			jp m,enemigo2_no_colision

			;FILA
			ld a,(enemigo2_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(player_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo2_no_colision
			jp m,enemigo2_no_colision

		jp enemigo2_colision



	enemigo2_caso8:
		;comprobar columna
		ld a,(player_col)
		ld b,a
		ld a,(enemigo2_col)
		cp b
		jr nz,enemigo2_caso9
		
		;comprobar fila
		ld a,(player_fila)
		inc a
		ld b,a
		ld a,(enemigo2_fila)
		cp b
		jr nz,enemigo2_caso9

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo2_coord)
			and 00001111b

			sub b
			call absa
			cp 8
			jp z,enemigo2_no_colision

			;FILA
			ld a,(enemigo2_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(player_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo2_no_colision
			jp m,enemigo2_no_colision

		jp enemigo2_colision

	enemigo2_caso9:
		;comprobar columna
		ld a,(player_col)
		inc a
		ld b,a
		ld a,(enemigo2_col)
		cp b
		jr nz,enemigo2_no_colision
		
		;comprobar fila
		ld a,(player_fila)
		inc a
		ld b,a
		ld a,(enemigo2_fila)
		cp b
		jr nz,enemigo2_no_colision

		;Comprobacion coordenadas internas

			;COL
			ld a,(enemigo2_coord)
			and 00001111b
			ld b,a

			ld a,(player_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo2_no_colision
			jp m,enemigo2_no_colision

			;FILA
			ld a,(enemigo2_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(player_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo2_no_colision
			jp m,enemigo2_no_colision



	enemigo2_colision:
	ld a,1
	ret

	enemigo2_no_colision:

		xor a
		ret






;--------------------------------------------------------------
check_colision_enemigo3:
	
	;enemigo3 fuera del alcance por arriba
		
		ld a,(player_fila)
		dec a
		ld b,a

		ld a,(enemigo3_fila)

		cp b
		jp c,enemigo3_no_colision


	;enemigo3 fuera del alcance por la izq
		

		ld a,(player_col)
		dec a
		ld b,a

		ld a,(enemigo3_col)

		cp b
		jp c,enemigo3_no_colision

	;enemigo3 fuera del alcance por abajo:
		

		ld a,(player_fila)
		inc a
		ld b,a

		ld a,(enemigo3_fila)

		cp b
		jp nc,enemigo3_no_colision

	;enemigo3 fuera del alcance por la derecha
		

		ld a,(player_col)
		inc a
		ld b,a

		ld a,(enemigo3_col)

		cp b
		jp nc,enemigo3_no_colision


	;comparaciones a nivel de coordenadas internas, pero segun las 9 posibles situaciones

	enemigo3_caso1:
	ld c,1;debug
		;comprobar columna
		ld a,(player_col)
		dec a
		ld b,a
		ld a,(enemigo3_col)
		cp b
		jr nz,enemigo3_caso2
		
		;comprobar fila
		ld a,(player_fila)
		dec a
		ld b,a
		ld a,(enemigo3_fila)
		cp b
		jr nz,enemigo3_caso2

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo3_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo3_no_colision
			jp m,enemigo3_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo3_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo3_no_colision
			jp m,enemigo3_no_colision

		jp enemigo3_colision

			

	enemigo3_caso2:
	ld c,2;debug
		;comprobar columna
		ld a,(player_col)
		ld b,a
		ld a,(enemigo3_col)
		cp b
		jr nz,enemigo3_caso3
		
		;comprobar fila
		ld a,(player_fila)
		dec a
		ld b,a
		ld a,(enemigo3_fila)
		cp b
		jr nz,enemigo3_caso3

		;Comprobacion coordenadas internas

			;COL
			ld a,(enemigo3_coord)
			and 00001111b
			ld b,a

			ld a,(player_coord)
			and 00001111b

			sub b
			call absa

			cp 8
			jp z,enemigo3_no_colision

		
			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo3_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b

			cp 0
			jp m,enemigo3_no_colision
			jp z,enemigo3_no_colision


		jp enemigo3_colision


	enemigo3_caso3:
	ld c,3;debug
		;comprobar columna
		ld a,(player_col)
		inc a
		ld b,a
		ld a,(enemigo3_col)
		cp b
		jr nz,enemigo3_caso4
		
		;comprobar fila
		ld a,(player_fila)
		dec a
		ld b,a
		ld a,(enemigo3_fila)
		cp b
		jr nz,enemigo3_caso4

		;Comprobacion coordenadas internas

			;COL
			ld a,(enemigo3_coord)
			and 00001111b
			ld b,a

			ld a,(player_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo3_no_colision
			jp m,enemigo3_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo3_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo3_no_colision
			jp m,enemigo3_no_colision
	
		jp enemigo3_colision


	enemigo3_caso4:
	ld c,4;debug
		;comprobar columna
		ld a,(player_col)
		dec a
		ld b,a
		ld a,(enemigo3_col)
		cp b
		jr nz,enemigo3_caso5
		
		;comprobar fila
		ld a,(player_fila)
		ld b,a
		ld a,(enemigo3_fila)
		cp b
		jr nz,enemigo3_caso5

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo3_coord)

			and 00001111b

			sub b
		
			cp 0
			jp z,enemigo3_no_colision
			jp m,enemigo3_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo3_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b

			call absa
			cp 8
			jp z,enemigo3_no_colision


		jp enemigo3_colision


	enemigo3_caso5:
	ld c,5;debug
		;comprobar columna
		ld a,(player_col)
		ld b,a
		ld a,(enemigo3_col)
		cp b
		jr nz,enemigo3_caso6
		
		;comprobar fila
		ld a,(player_fila)
		ld b,a
		ld a,(enemigo3_fila)
		cp b
		jr nz,enemigo3_caso6

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo3_coord)
			and 00001111b

			sub b
			call absa
			cp 8
			jp z,enemigo3_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo3_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			call absa
			cp 8
			jp z,enemigo3_no_colision


		jp enemigo3_colision


	enemigo3_caso6:
	ld c,6;debug
		;comprobar columna
		ld a,(player_col)
		inc a
		ld b,a
		ld a,(enemigo3_col)
		cp b
		jr nz,enemigo3_caso7
		
		;comprobar fila
		ld a,(player_fila)
		ld b,a
		ld a,(enemigo3_fila)
		cp b
		jr nz,enemigo3_caso7

		;Comprobacion coordenadas internas

			;COL
			ld a,(enemigo3_coord)
			and 00001111b
			ld b,a

			ld a,(player_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo3_no_colision
			jp m,enemigo3_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo3_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b

			call absa
			cp 8
			jp z,enemigo3_no_colision

		jp enemigo3_colision


	enemigo3_caso7:
	ld c,7;debug
		;comprobar columna
		ld a,(player_col)
		dec a
		ld b,a
		ld a,(enemigo3_col)
		cp b
		jr nz,enemigo3_caso8
		
		;comprobar fila
		ld a,(player_fila)
		inc a
		ld b,a
		ld a,(enemigo3_fila)
		cp b
		jr nz,enemigo3_caso8

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo3_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo3_no_colision
			jp m,enemigo3_no_colision

			;FILA
			ld a,(enemigo3_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(player_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo3_no_colision
			jp m,enemigo3_no_colision

		jp enemigo3_colision



	enemigo3_caso8:
	ld c,8;debug
		;comprobar columna
		ld a,(player_col)
		ld b,a
		ld a,(enemigo3_col)
		cp b
		jr nz,enemigo3_caso9
		
		;comprobar fila
		ld a,(player_fila)
		inc a
		ld b,a
		ld a,(enemigo3_fila)
		cp b
		jr nz,enemigo3_caso9

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo3_coord)
			and 00001111b

			sub b
			call absa
			cp 8
			jp z,enemigo3_no_colision

			;FILA
			ld a,(enemigo3_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(player_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo3_no_colision
			jp m,enemigo3_no_colision

		jp enemigo3_colision

	enemigo3_caso9:
	ld c,9;debug
		;comprobar columna
		ld a,(player_col)
		inc a
		ld b,a
		ld a,(enemigo3_col)
		cp b
		jr nz,enemigo3_no_colision
		
		;comprobar fila
		ld a,(player_fila)
		inc a
		ld b,a
		ld a,(enemigo3_fila)
		cp b
		jr nz,enemigo3_no_colision

		;Comprobacion coordenadas internas

			;COL
			ld a,(enemigo3_coord)
			and 00001111b
			ld b,a

			ld a,(player_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo3_no_colision
			jp m,enemigo3_no_colision

			;FILA
			ld a,(enemigo3_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(player_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo3_no_colision
			jp m,enemigo3_no_colision



	enemigo3_colision:
	
	
	
	ld a,1
	ret

	enemigo3_no_colision:

		xor a
		ret






;--------------------------------------------------------------
check_colision_enemigo4:
	
	;enemigo4 fuera del alcance por arriba
		
		ld a,(player_fila)
		dec a
		ld b,a

		ld a,(enemigo4_fila)

		cp b
		jp c,enemigo4_no_colision


	;enemigo4 fuera del alcance por la izq
		

		ld a,(player_col)
		dec a
		ld b,a

		ld a,(enemigo4_col)

		cp b
		jp c,enemigo4_no_colision

	;enemigo4 fuera del alcance por abajo:
		

		ld a,(player_fila)
		inc a
		ld b,a

		ld a,(enemigo4_fila)

		cp b
		jp nc,enemigo4_no_colision

	;enemigo4 fuera del alcance por la derecha
		

		ld a,(player_col)
		inc a
		ld b,a

		ld a,(enemigo4_col)

		cp b
		jp nc,enemigo4_no_colision


	;comparaciones a nivel de coordenadas internas, pero segun las 9 posibles situaciones

	enemigo4_caso1:
		;comprobar columna
		ld a,(player_col)
		dec a
		ld b,a
		ld a,(enemigo4_col)
		cp b
		jr nz,enemigo4_caso2
		
		;comprobar fila
		ld a,(player_fila)
		dec a
		ld b,a
		ld a,(enemigo4_fila)
		cp b
		jr nz,enemigo4_caso2

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo4_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo4_no_colision
			jp m,enemigo4_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo4_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo4_no_colision
			jp m,enemigo4_no_colision

		jp enemigo4_colision

			

	enemigo4_caso2:
		;comprobar columna
		ld a,(player_col)
		ld b,a
		ld a,(enemigo4_col)
		cp b
		jr nz,enemigo4_caso3
		
		;comprobar fila
		ld a,(player_fila)
		dec a
		ld b,a
		ld a,(enemigo4_fila)
		cp b
		jr nz,enemigo4_caso3

		;Comprobacion coordenadas internas

			;COL
			ld a,(enemigo4_coord)
			and 00001111b
			ld b,a

			ld a,(player_coord)
			and 00001111b

			sub b
			call absa

			cp 8
			jp z,enemigo4_no_colision

		
			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo4_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b

			cp 0
			jp m,enemigo4_no_colision
			jp z,enemigo4_no_colision


		jp enemigo4_colision


	enemigo4_caso3:
		;comprobar columna
		ld a,(player_col)
		inc a
		ld b,a
		ld a,(enemigo4_col)
		cp b
		jr nz,enemigo4_caso4
		
		;comprobar fila
		ld a,(player_fila)
		dec a
		ld b,a
		ld a,(enemigo4_fila)
		cp b
		jr nz,enemigo4_caso4

		;Comprobacion coordenadas internas

			;COL
			ld a,(enemigo4_coord)
			and 00001111b
			ld b,a

			ld a,(player_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo4_no_colision
			jp m,enemigo4_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo4_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo4_no_colision
			jp m,enemigo4_no_colision
	
		jp enemigo4_colision


	enemigo4_caso4:
		;comprobar columna
		ld a,(player_col)
		dec a
		ld b,a
		ld a,(enemigo4_col)
		cp b
		jr nz,enemigo4_caso5
		
		;comprobar fila
		ld a,(player_fila)
		ld b,a
		ld a,(enemigo4_fila)
		cp b
		jr nz,enemigo4_caso5

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo4_coord)

			and 00001111b

			sub b
		
			cp 0
			jp z,enemigo4_no_colision
			jp m,enemigo4_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo4_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b

			call absa
			cp 8
			jp z,enemigo4_no_colision


		jp enemigo4_colision


	enemigo4_caso5:
		;comprobar columna
		ld a,(player_col)
		ld b,a
		ld a,(enemigo4_col)
		cp b
		jr nz,enemigo4_caso6
		
		;comprobar fila
		ld a,(player_fila)
		ld b,a
		ld a,(enemigo4_fila)
		cp b
		jr nz,enemigo4_caso6

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo4_coord)
			and 00001111b

			sub b
			call absa
			cp 8
			jp z,enemigo4_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo4_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			call absa
			cp 8
			jp z,enemigo4_no_colision


		jp enemigo4_colision


	enemigo4_caso6:
		;comprobar columna
		ld a,(player_col)
		inc a
		ld b,a
		ld a,(enemigo4_col)
		cp b
		jr nz,enemigo4_caso7
		
		;comprobar fila
		ld a,(player_fila)
		ld b,a
		ld a,(enemigo4_fila)
		cp b
		jr nz,enemigo4_caso7

		;Comprobacion coordenadas internas

			;COL
			ld a,(enemigo4_coord)
			and 00001111b
			ld b,a

			ld a,(player_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo4_no_colision
			jp m,enemigo4_no_colision

			;FILA
			ld a,(player_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(enemigo4_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b

			call absa
			cp 8
			jp z,enemigo4_no_colision

		jp enemigo4_colision


	enemigo4_caso7:
		;comprobar columna
		ld a,(player_col)
		dec a
		ld b,a
		ld a,(enemigo4_col)
		cp b
		jr nz,enemigo4_caso8
		
		;comprobar fila
		ld a,(player_fila)
		inc a
		ld b,a
		ld a,(enemigo4_fila)
		cp b
		jr nz,enemigo4_caso8

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo4_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo4_no_colision
			jp m,enemigo4_no_colision

			;FILA
			ld a,(enemigo4_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(player_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo4_no_colision
			jp m,enemigo4_no_colision

		jp enemigo4_colision



	enemigo4_caso8:
		;comprobar columna
		ld a,(player_col)
		ld b,a
		ld a,(enemigo4_col)
		cp b
		jr nz,enemigo4_caso9
		
		;comprobar fila
		ld a,(player_fila)
		inc a
		ld b,a
		ld a,(enemigo4_fila)
		cp b
		jr nz,enemigo4_caso9

		;Comprobacion coordenadas internas

			;COL
			ld a,(player_coord)
			and 00001111b
			ld b,a

			ld a,(enemigo4_coord)
			and 00001111b

			sub b
			call absa
			cp 8
			jp z,enemigo4_no_colision

			;FILA
			ld a,(enemigo4_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(player_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo4_no_colision
			jp m,enemigo4_no_colision

		jp enemigo4_colision

	enemigo4_caso9:
		;comprobar columna
		ld a,(player_col)
		inc a
		ld b,a
		ld a,(enemigo4_col)
		cp b
		jr nz,enemigo4_no_colision
		
		;comprobar fila
		ld a,(player_fila)
		inc a
		ld b,a
		ld a,(enemigo4_fila)
		cp b
		jr nz,enemigo4_no_colision

		;Comprobacion coordenadas internas

			;COL
			ld a,(enemigo4_coord)
			and 00001111b
			ld b,a

			ld a,(player_coord)
			and 00001111b

			sub b
			
			cp 0
			jp z,enemigo4_no_colision
			jp m,enemigo4_no_colision

			;FILA
			ld a,(enemigo4_coord)
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a
			ld b,a

			ld a,(player_coord)
			
			and 11110000b
			rrc a
			rrc a
			rrc a
			rrc a

			sub b
			cp 0
			jp z,enemigo4_no_colision
			jp m,enemigo4_no_colision



	enemigo4_colision:
	ld a,1
	ret

	enemigo4_no_colision:

		xor a
		ret












;-------------------------------------------------------------
;Se llama cuando previamente hemos llegado al limite dentro del sprite
;Se llama desde las rutinas de movimiento del sprite
;Entrada: a=sentido
;Salida: c=0 todo ok. c=1 colision con limite. c=2 salida
;-------------------------------------------------------------
comprueba_limites:
	cp 0
	jr z,cl_sentido_arriba
	cp 1
	jr z,cl_sentido_derecha
	cp 2
	jr z,cl_sentido_abajo
	;sentido izq
	ld a,(SPRITE_COL)
	jr cl_horiz

	cl_sentido_arriba:
		ld a,(SPRITE_FILA)

	cl_horiz:
		cp 1
		jr z,cl_colision_pared
		ld c,0			;no hay colision
		ret

	cl_sentido_derecha:
		ld a,(SPRITE_COL)
		jr cl_vert

	cl_sentido_abajo:
		ld a,(SPRITE_FILA)

	cl_vert:
		cp 21
		jr z,cl_colision_pared
		ld c,0			;no hay colision
		ret

	cl_colision_pared:
		;aqui hay que comprobar si es o no salida
		call check_salida
		cp 1

		jr z, cl_salida


		ld c,1
		ret

	cl_salida

		ld c,2
		ret
;-------------------------------------------------------------
;Comprobar si el player ha llegado a la salida
;devuelve a=0 no, a=1 si
;-------------------------------------------------------------
check_salida:

	;la salida puede estar en cuatro sitios. slinea 0,1,2 o 3
	;para cada una hay que comprobar solo la fila o columna anterior, no la misma
	;ya que solo podemos aproximarnos a la salida por un flanco

	slinea0:

	ld a,(slinea)

	cp 0		
	jp nz, slinea1

	;la salida esta arriba. tiene que darse que player_fila sea 1, y
	;caso 1: que player_col-1 (inc a)= scol y que player_coord_col = 8
	;caso 2: o que player_col = scol
	;caso 3: o que player_col+1 (dec a)= scol
	;caso 4: o que player_col+2 (dec a dec a)= scol y player_coord_col < 8


	ld a,(player_fila)
	cp 1
	jp nz,slinea1


	;slinea0_caso1
		ld a,(player_col)
		inc a
		ld b,a

		ld a,(scol)

		cp b
		jr nz,slinea0_caso2

		ld a,(player_coord)
		and 00001111b

		cp 8
		jr nz,slinea0_caso2

		ld a,1
		ret

	slinea0_caso2:
		ld a,(player_col)
		ld b,a

		ld a,(scol)
		cp b

		jr nz,slinea0_caso3

		ld a,1
		ret

	slinea0_caso3:
		ld a,(player_col)
		dec a
		ld b,a

		ld a,(scol)
		cp b

		jr nz,slinea0_caso4

		ld a,1
		ret

	slinea0_caso4:
		ld a,(player_col)
		dec a
		dec a
		ld b,a

		ld a,(scol)
		cp b
		jr nz,slinea1

		ld a,(player_coord)
		and 00001111b

		cp 0
		jr nz,slinea1

		ld a,1
		ret





	slinea1:

	ld a,(slinea)
	cp 1		
	jp nz, slinea2

	;la salida esta a la derecha. tiene que darse que player_col sea 21, y
	;caso 1: que player_fila-1 (inc a)= sfila y que player_coord_fila = 8
	;caso 2: o que player_fila = sfila
	;caso 3: o que player_fila+1 (dec a)= sfila
	;caso 4: o que player_fila+2 (dec a dec a)= sfila y player_coord_fila < 8

	ld a,(player_col)
	cp 21
	jp nz,slinea2

	slinea1_caso1:
		ld a,(player_fila)
		inc a
		ld b,a

		ld a,(sfila)

		cp b
		jr nz,slinea1_caso2

		ld a,(player_coord)
		and 11110000b
		rrc a
		rrc a
		rrc a
		rrc a

		cp 8
		jr nz,slinea1_caso2

		;ld a,(player_coord)
		;and 00001111b
		;cp 8 
		;jr nz, slinea1_caso2

		ld a,1
		ret

	slinea1_caso2:
		ld a,(player_fila)
		ld b,a

		ld a,(sfila)
		cp b

		jr nz,slinea1_caso3

		;ld a,(player_coord)
		;and 00001111b
		;cp 8 
		;jr nz, slinea1_caso3

		ld a,1
		ret

	slinea1_caso3:
		ld a,(player_fila)
		dec a
		ld b,a

		ld a,(sfila)
		cp b

		jr nz,slinea1_caso4

		;ld a,(player_coord)
		;and 00001111b
		;cp 8 
		;jr nz, slinea1_caso4

		ld a,1
		ret

	slinea1_caso4:
		ld a,(player_fila)
		dec a
		dec a
		ld b,a

		ld a,(sfila)
		cp b
		jr nz,slinea2

		ld a,(player_coord)
		and 11110000b
		rrc a
		rrc a
		rrc a
		rrc a

		cp 0
		jr nz,slinea2

		;ld a,(player_coord)
		;and 00001111b
		;cp 8 
		;jr nz, slinea2

		ld a,1
		ret





	slinea2:

	ld a,(slinea)
	cp 2
	jp nz,slinea3

	;la salida esta abajo. tiene que darse que player_fila sea 21, y
	;caso 1: que player_fila-1 (inc a)= sfila y que player_coord_fila = 8
	;caso 2: o que player_fila = sfila
	;caso 3: o que player_fila+1 (dec a)= sfila
	;caso 4: o que player_fila+2 (dec a dec a)= sfila y player_coord_fila = 0

	ld a,(player_fila)
	cp 21
	jp nz,slinea3

	slinea2_caso1:
		ld a,(player_col)
		inc a
		ld b,a

		ld a,(scol)

		cp b
		jr nz,slinea2_caso2

		ld a,(player_coord)
		and 00001111b

		cp 8
		jr nz,slinea2_caso2


		ld a,1
		ret

	slinea2_caso2:
		ld a,(player_col)
		ld b,a

		ld a,(scol)
		cp b

		jr nz,slinea2_caso3


		ld a,1
		ret

	slinea2_caso3:
		ld a,(player_col)
		dec a
		ld b,a

		ld a,(scol)
		cp b

		jr nz,slinea2_caso4



		ld a,1
		ret

	slinea2_caso4:
		ld a,(player_col)
		dec a
		dec a
		ld b,a

		ld a,(scol)
		cp b
		jr nz,slinea3

		ld a,(player_coord)
		and 00001111b

		cp 0
		jr nz,slinea3

		

		ld a,1
		ret






	slinea3:
	
	ld a,(slinea)
	cp 3
	jp nz,check_salida_NO


	;la salida esta a la izq. tiene que darse que player_col sea 1, y
	;caso 1: que player_fila-1 (inc a)= sfila y que player_coord_fila = 8
	;caso 2: o que player_fila = sfila
	;caso 3: o que player_fila+1 (dec a)= sfila
	;caso 4: o que player_fila+2 (dec a dec a)= sfila y player_coord_fila = 0


	ld a,(player_col)
	cp 1
	jp nz,check_salida_NO

	slinea3_caso1:
		ld a,(player_fila)
		inc a
		ld b,a

		ld a,(sfila)

		cp b
		jr nz,slinea3_caso2

		ld a,(player_coord)
		and 11110000b
		rrc a
		rrc a
		rrc a
		rrc a

		cp 8
		jr nz,slinea3_caso2

		
		ld a,1
		ret

	slinea3_caso2:
		ld a,(player_fila)
		ld b,a

		ld a,(sfila)
		cp b

		jr nz,slinea3_caso3



		ld a,1
		ret

	slinea3_caso3:
		ld a,(player_fila)
		dec a
		ld b,a

		ld a,(sfila)
		cp b

		jr nz,slinea3_caso4

	
		ld a,1
		ret

	slinea3_caso4:
		ld a,(player_fila)
		dec a
		dec a
		ld b,a

		ld a,(sfila)
		cp b
		jr nz,check_salida_NO

		ld a,(player_coord)
		and 11110000b
		rrc a
		rrc a
		rrc a
		rrc a

		cp 0
		jr nz,check_salida_NO

		

		ld a,1
		ret



	check_salida_NO:

	xor a
	ret

;-------------------------------------------------------------
;Comprobar si el player esta colisionando con la llave
;devuelve a=0 no, a=1 si
;-------------------------------------------------------------
check_colision_llave:
	;comprobamos fila anterior;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ld a,(player_fila)


	inc a
	ld b,a

	ld a,(llave_fila)


	cp b
	jr nz,comprueba_misma_fila

	;player esta en la fila anterior de la llave.
	;comprobamos col anterior
	ld a,(player_col)
	inc a
	ld b,a

	ld a,(llave_col)

	cp b
	jr nz,comprueba_misma_col

	;player esta en la fila anterior y col anterior de la llave
		;hay que comprobar player_coord
		ld a,(player_coord)
		;comprobamos la col
		and 00001111b

		cp 0
		jp z,fin_colision_llave_NO ;si esta en la col 0 no esta tocando. nos salimos con a=0
		;la col es mayor que 0. comprobamos la fila
		ld a,(player_coord)
		and 11110000b
		rlc a
		rlc a
		rlc a
		rlc a
		cp 0
		jr z,fin_colision_llave_NO ;si esta en la fila 0 no esta tocando. nos salimos con a=0.
		;esta tocando. nos salimos con a=1
		jr fin_colision_llave_SI

	comprueba_misma_col:;;;;;;;;;;;;;;;;
		;player esta en la fila anterior de la llave y vamos a ver si esta tambien en misma col
		ld a,(player_col)
		ld b,a

		ld a,(llave_col)
		cp b
		jr nz,fin_colision_llave_NO

		
		;player esta en la fila anterior y en la misma col
		;hay que comprobar player_coord
		ld a,(player_coord)
		;comprobamos la col
		and 00001111b
		cp 8
		jr z,fin_colision_llave_NO ; si esta en la col 8 no esta tocando.nos salimos con a=0
		;la col es menor que 8. comprobamos la fila
		and 11110000b
		rlc a
		rlc a
		rlc a
		rlc a
		cp 0
		jr z,fin_colision_llave_NO ;si esta en la fila 0 no esta tocando. nos salimos con a=0.
		;esta tocando. nos salimos con a=1
		jr fin_colision_llave_SI





	comprueba_misma_fila: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ld a,(player_fila)
	ld b,a

	ld a,(llave_fila)
	cp b
	jr nz,fin_colision_llave_NO ;no hay mas que comprobar. no esta tocando

	;player esta en la misma fila. 
	;Veamos primero la col anterior
	ld a,(player_col)
	inc a
	ld b,a

	ld a,(llave_col)
	cp b
	jr nz,comprueba_misma_col2

	;player esta en la misma fila que la llave y en la col anterior
		;hay que comprobar player_coord
		ld a,(player_coord)
		;comprobamos la col
		and 00001111b
		cp 8
		jr z,fin_colision_llave_NO ;esta en col 8, no tocando. salimos con a=0
		;la col es menor que 8. comprobamos la fila
		ld a,(player_coord)
		and 11110000b
		rlc a
		rlc a
		rlc a
		rlc a
		cp 8
		jr z,fin_colision_llave_NO ;si esta en la fila 8 no esta tocando. nos salimos con a=0.
		;esta tocando. nos salimos con a=1
		jr fin_colision_llave_SI



	comprueba_misma_col2:
		;player esta en la misma fila y vamos a ver si tambien en la misma col
		ld a,(player_col)
		ld b,a

		ld a,(llave_col)
		cp b
		jr nz,fin_colision_llave_NO

		
		;player esta en la misma fila y en la misma col
		;hay que comprobar player_coord
		ld a,(player_coord)
		;comprobamos la col
		and 00001111b
		cp 8
		jr z,fin_colision_llave_NO ; si esta en la col 8 no esta tocando.nos salimos con a=0
		;la col es menor que 8. comprobamos la fila
		and 11110000b
		rlc a
		rlc a
		rlc a
		rlc a
		cp 8
		jr z,fin_colision_llave_NO ;si esta en la fila 8 no esta tocando. nos salimos con a=0.
		;esta tocando. nos salimos con a=1
		jr fin_colision_llave_SI



	fin_colision_llave_SI:
		ld a,1
		ret
	fin_colision_llave_NO:
		xor a
		ret


;-------------------------------------------------------------
;VALOR ABSOLUTO DE A
;-------------------------------------------------------------
absa:
	bit 7,a
	ret z
	neg
	ret

;-------------------------------------------------------------
;Rutinas de movimiento del player
;-------------------------------------------------------------
mueve_player_derecha:
	ld a,(SPRITE_COORD)
	and 00001111b
	cp 8
	jr c,md_menor_player
	;esta en el limite dentro del sprite
	ld a,1 				;sentido derecha
	call comprueba_limites 		;me devuelve c=0 o c=1 (colision)
	ld a,c
	cp 0
	jr z,cambia_player_derecha

	;si esta en un limite hay que comprobar si es salida
	cp 2
	jp z,player_en_salida


	;no es salida

	call explosion
	ld a,(vidas)
	dec a
	ld (vidas),a
	cp 0
	jp z,menu_principal
	;quedan vidas
	jp pinta_scores
	ret				;creo que no se ejecuta nunca

	cambia_player_derecha:
		ld a,(player_col)
		inc a
		ld (player_col),a
		ld (SPRITE_COL),a
		ld a,1
		jr prepara_byte_dere_player

	md_menor_player:
		inc a

	prepara_byte_dere_player:
		ld b,a
		ld a,(SPRITE_COORD)
		and 11110000b
		or b
		ld (SPRITE_COORD),a
		ld (player_coord),a
		call pinta_sprite

	ret



mueve_player_izquierda:
	ld a,(SPRITE_COORD)
	and 00001111b
	cp 0
	jr nz,mi_mayor_player
	;esta en el limite dentro del sprite
	ld a,3				;sentido izquierda
	call comprueba_limites 		;me devuelve c=0 o c=1 (colision)
	ld a,c
	cp 0
	jr z,cambia_player_izquierda

	;si esta en un limite hay que comprobar si es salida
	cp 2
	jp z,player_en_salida

	

	;no es salida


	call explosion
	ld a,(vidas)
	dec a
	ld (vidas),a
	cp 0
	jp z,menu_principal
	;quedan vidas
	jp pinta_scores
	ret				;creo que no se ejecuta nunca

	cambia_player_izquierda:
		ld a,(player_col)
		dec a
		ld (player_col),a
		ld (SPRITE_COL),a
		ld a,7
		jr prepara_byte_izq_player

	mi_mayor_player:
		dec a

	prepara_byte_izq_player:
		ld b,a
		ld a,(SPRITE_COORD)
		and 11110000b
		or b
		ld (SPRITE_COORD),a
		ld (player_coord),a
		call pinta_sprite

	ret



mueve_player_arriba:
	ld a,(SPRITE_COORD)
	and 11110000b
	rrc a
	rrc a
	rrc a
	rrc a			;0000xxxx
	cp 0
	jr nz,mar_mayor_player
	xor a			;sentido arriba
	call comprueba_limites
	ld a,c
	cp 0
	jr z,mar_cambia_player_arriba

	;si esta en un limite hay que comprobar si es salida
	cp 2
	jp z,player_en_salida


	;no es salida
	call explosion
	ld a,(vidas)
	dec a
	ld (vidas),a
	cp 0
	jp z,menu_principal
	;quedan vidas
	jp pinta_scores
	ret				;creo que no se ejecuta nunca

	mar_cambia_player_arriba:
		ld a,(player_fila)
		dec a
		ld (player_fila),a
		ld (SPRITE_FILA),a
		ld a,7
		jr mar_prepara_byte_arriba
	
	mar_mayor_player:
		dec a

	mar_prepara_byte_arriba:
		rlc a
		rlc a
		rlc a
		rlc a
		ld b,a
		ld a,(SPRITE_COORD)
		and 00001111b
		or b
		ld (SPRITE_COORD),a
		ld (player_coord),a
		call pinta_sprite

	ret



mueve_player_abajo:
	ld a,(SPRITE_COORD)
	and 11110000b
	rrc a
	rrc a
	rrc a
	rrc a			;0000xxxx
	cp 8
	jr c,mab_menor_player
	ld a,2			;sentido abajo
	call comprueba_limites
	ld a,c
	cp 0
	jr z,mab_cambia_player_abajo

	;si esta en un limite hay que comprobar si es salida
	cp 2
	jp z,player_en_salida


	;no es salida
	call explosion
	ld a,(vidas)
	dec a
	ld (vidas),a
	cp 0
	jp z,menu_principal
	;quedan vidas
	jp pinta_scores
	ret				;creo que no se ejecuta nunca

	mab_cambia_player_abajo:
		ld a,(player_fila)
		inc a
		ld (player_fila),a
		ld (SPRITE_FILA),a
		ld a,1
		jr mab_prepara_byte_abajo
		
	mab_menor_player:
		inc a

	mab_prepara_byte_abajo:
		rlc a
		rlc a
		rlc a
		rlc a
		ld b,a
		ld a,(SPRITE_COORD)
		and 00001111b
		or b
		ld (SPRITE_COORD),a
		ld (player_coord),a
		call pinta_sprite

	ret


;-------------------------------------------------------------
;Rutinas de movimiento de los enemigos
;Entrada: SPRITE_COORD,SPRITE COL,SPRITE_FILA
;Salida: SPRITE_COORD, SPRITE_COL o SPRITE_FILA, b:sentido
;-------------------------------------------------------------
cambia_coord_enemigo_derecha:

	and 00001111b
	cp 8
	jr c,cced_menor
	;esta en el limite dentro del sprite
	ld a,1 				;sentido derecha
	call comprueba_limites 		;me devuelve c=0 o c=1 (colision)
	ld a,c

	cp 0
	jr z,cambia_enemigo_derecha
	ld b,3				;el sentido cambia al contrario (izquierda)
	ret

	cambia_enemigo_derecha:
		push af
		ld a,(SPRITE_COL)

		inc a

		ld (SPRITE_COL),a
		pop af
		ld b,1
		jr prepara_byte_dere_enemigo

	cced_menor:
		inc a
		ld b,a

	prepara_byte_dere_enemigo:
		;ld b,a
		ld a,(SPRITE_COORD)
		;ld a,(enemigo1_coord)
		and 11110000b
		or b
	
		ld (SPRITE_COORD),a
		ld b,1			;el sentido continua siendo derecha

	ret



cambia_coord_enemigo_izquierda:

	and 00001111b
	cp 0
	jr nz,ccei_mayor
	;esta en el limite dentro del sprite
	ld a,3				;sentido izquierda
	call comprueba_limites 		;me devuelve c=0 o c=1 (colision)
	ld a,c
	cp 0
	jr z,cambia_enemigo_izquierda
	ld b,1				;el sentido cambia al contrario (derecha)
	ret				

	cambia_enemigo_izquierda:
		push af
		ld a,(SPRITE_COL)
		dec a
		ld (SPRITE_COL),a
		pop af
		ld b,7
		jr prepara_byte_izq_enemigo

	ccei_mayor:
		dec a
		ld b,a

	prepara_byte_izq_enemigo:
		;ld b,a
		ld a,(SPRITE_COORD)
		;ld a,(enemigo1_coord)
		and 11110000b
		or b
		ld (SPRITE_COORD),a
		ld b,3			;el sentido sigue izquierda

	ret



cambia_coord_enemigo_arriba:
	
	and 11110000b
	rrc a
	rrc a
	rrc a
	rrc a			;0000xxxx
	cp 0
	jr nz,ccear_mayor
	xor a			;sentido arriba
	call comprueba_limites
	ld a,c
	cp 0
	jr z,cambia_enemigo_arriba
	ld b,2				;sentido cambia a abajo
	ret				

	cambia_enemigo_arriba:
		push af
		ld a,(SPRITE_FILA)
		dec a
		ld (SPRITE_FILA),a
		pop af
		ld a,7
		jr prepara_byte_arriba_enemigo
	
	ccear_mayor:
		dec a


	prepara_byte_arriba_enemigo:
		rlc a
		rlc a
		rlc a
		rlc a
		ld b,a
		ld a,(SPRITE_COORD)
		;ld a,(enemigo1_coord)
		and 00001111b
		or b
		ld (SPRITE_COORD),a
		xor b			;sentido sigue arriba

	ret



cambia_coord_enemigo_abajo:
	

	and 11110000b

	rrc a
	rrc a
	rrc a
	rrc a			;0000xxxx
	;ld d,a

	cp 8
	jr c,cceab_menor
	

	ld a,2			;sentido abajo
	call comprueba_limites
	ld a,c
	cp 0
	jr z,cambia_enemigo_abajo
	xor b				;cambia sentido arriba
	ret				;creo que no se ejecuta nunca

	cambia_enemigo_abajo:
		push af
		ld a,(SPRITE_FILA)
		inc a
		ld (SPRITE_FILA),a
		pop af
		ld a,1
		jr prepara_byte_abajo_enemigo
		
	cceab_menor:
		inc a


	prepara_byte_abajo_enemigo:
		rlc a
		rlc a
		rlc a
		rlc a

		ld b,a

		ld a,(SPRITE_COORD)
		;ld a,(enemigo1_coord)

		and 00001111b

		or b

		ld (SPRITE_COORD),a
		ld b,2			;sentido sigue abajo

	ret






;-------------------------------------------------------------
;EXPLOSION DEL PLAYER
;-------------------------------------------------------------
explosion:
; halt
; ld a,(player_fila)
; ld hl,16384
; ld (hl),a
; ld a,(player_col)
; ld hl,16385
; ld (hl),a
; ld a,(enemigo1_fila)
; ld hl,16386
; ld (hl),a
; ld a,(enemigo1_col)
; ld hl,16387
; ld (hl),a
; ld a,(player_coord)
; ld hl,16388
; ld (hl),a
; ld a,(enemigo1_coord)
; ld hl,16389
; ld (hl),a
; call pulsa_tecla
; call suelta_tecla

		ld a,(player_fila)
		ld b,a
		ld a,(player_col)
		ld c,a
		call Get_Char_Offset_LR
		call desintegracion

		ld a,(player_col)
		inc a
		ld (player_col),a

		ld a,(player_fila)
		ld b,a
		ld a,(player_col)
		ld c,a
		call Get_Char_Offset_LR
		call desintegracion

		ld a,(player_fila)
		inc a
		ld (player_fila),a

		ld b,a
		ld a,(player_col)
		ld c,a
		call Get_Char_Offset_LR
		call desintegracion

		ld a,(player_col)
		dec a
		ld (player_col),a

		ld a,(player_fila)
		ld b,a
		ld a,(player_col)
		ld c,a
		call Get_Char_Offset_LR
		call desintegracion


	

	ret

;-------------------------------------------------------------
bucle_animacion_entrada_rutina:
;-------------------------------------------------------------
	ld a,(sentido_player)
						
			
	cp 0			;va hacia arriba. decrementa fila
	jr nz,ani_sentido1
	ld a,c
	and 11110000b
	rrc a
	rrc a 
	rrc a
	rrc a
	dec a
	sla a
	sla a
	sla a
	sla a
	ld c,a
	ld a,(player_coord)
	and 00001111b
	or c
	jr sigue_bucle_animacion_entrada


	ani_sentido1
	cp 1			;va hacia derecha
	jr nz,ani_sentido2
	ld a,c
	and 00001111b
	inc a
	ld c,a
	ld a,(player_coord)
	and 11110000b
	or c
	jr sigue_bucle_animacion_entrada


	ani_sentido2
	cp 2			;va hacia abajo
	jr nz,ani_sentido3
	ld a,c
	and 11110000b
	rrc a
	rrc a 
	rrc a
	rrc a
	inc a
	sla a
	sla a 
	sla a
	sla a
	ld c,a
	ld a,(player_coord)
	and 00001111b
	or c
	jr sigue_bucle_animacion_entrada


	ani_sentido3		;va hacia izq
	ld a,c
	and 00001111b
	dec a
	ld c,a
	ld a,(player_coord)
	and 11110000b
	or c



	sigue_bucle_animacion_entrada
	ld (player_coord),a
	ld c,a

	ld (SPRITE_COORD),a

	ld a,(player_fila)
	ld (SPRITE_FILA),a
	ld a,(player_col)
	ld (SPRITE_COL),a

	call pinta_sprite
	call retardo

	;ld c,0
	ret



;-------------------------------------------------------------
bucle_animacion_salida_rutina:
;-------------------------------------------------------------
	ld a,(sentido_player)
						
			
	cp 0			;va hacia arriba. decrementa fila
	jr nz,anisalida_sentido1
	ld a,c
	and 11110000b
	rrc a
	rrc a 
	rrc a
	rrc a
	dec a
	sla a
	sla a
	sla a
	sla a
	ld c,a
	ld a,(player_coord)
	and 00001111b
	or c
	jr sigue_bucle_animacion_salida


	anisalida_sentido1
	cp 1			;va hacia derecha
	jr nz,anisalida_sentido2
	ld a,(player_coord)
	and 00001111b

	inc a
	ld c,a
	ld a,(player_coord)
	and 11110000b
	or c
	jr sigue_bucle_animacion_salida


	anisalida_sentido2
	cp 2			;va hacia abajo
	jr nz,anisalida_sentido3
	ld a,c
	and 11110000b
	rrc a
	rrc a 
	rrc a
	rrc a
	inc a
	sla a
	sla a 
	sla a
	sla a
	ld c,a
	ld a,(player_coord)
	and 00001111b
	or c
	jr sigue_bucle_animacion_salida


	anisalida_sentido3		;va hacia izq
	ld a,c
	and 00001111b
	dec a
	ld c,a
	ld a,(player_coord)
	and 11110000b
	or c



	sigue_bucle_animacion_salida
	ld (player_coord),a
	ld c,a

	ld (SPRITE_COORD),a

	ld a,(player_fila)
	ld (SPRITE_FILA),a
	ld a,(player_col)
	ld (SPRITE_COL),a

	call pinta_sprite
	call retardo


	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
animacion_salida:	;status 3 = saliendo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;ld a,3
		;ld (status),a

		ld a,(slinea)
		cp 0
		jr nz,anisalida_slinea1
		
		xor a
		ld (player_fila),a
		ld a,10000000b
		ld b,a
		ld a,(player_coord)
		and 00001111b
		or b
		
		ld (player_coord),a
		xor a
		ld (sentido_player),a
		jr sigue_animacion_salida
	anisalida_slinea1
		cp 1
		jr nz,anisalida_slinea2
		
		ld a,22
		ld (player_col),a
		
		ld a,(player_coord)
		and 11110000b
		

		ld (player_coord),a

		ld a,1
		ld (sentido_player),a
		jr sigue_animacion_salida
	anisalida_slinea2
		cp 2
		jr nz,anisalida_slinea3
		ld a,(scol)
		
		
		
		ld a,22
		ld (player_fila),a
		
		ld a,(player_coord)
		and 00001111b
		

		ld (player_coord),a
		ld a,2
		ld (sentido_player),a
		jr sigue_animacion_salida
	anisalida_slinea3
		ld a,(sfila)
		
		
		xor a
		ld (player_col),a
		ld b,8
		ld a,(player_coord)
		
		and 11110000b
		or b
		
		ld (player_coord),a
		ld a,3
		ld (sentido_player),a

	sigue_animacion_salida
		ld a,71			;player es blanco brillante
		ld (SPRITE_ATTR),a
		ld a,(player_fila)
		ld (SPRITE_FILA),a
		ld a,(player_col)
		ld (SPRITE_COL),a
		ld a,(player_coord)
		ld (SPRITE_COORD),a
		call pinta_sprite

		ld a,(player_coord)


		ld c,a
		ld b,8
		bucle_animacion_salida
			
			call bucle_animacion_salida_rutina
			
			djnz bucle_animacion_salida


	;poner a 0 los enemigos para no arrastrar anteriores valores
	xor a
	ld (enemigo1),a
	ld (enemigo1_fila),a
	ld (enemigo1_col),a
	ld (enemigo1_coord),a
	ld (enemigo2),a
	ld (enemigo2_fila),a
	ld (enemigo2_col),a
	ld (enemigo2_coord),a
	ld (enemigo3),a
	ld (enemigo3_fila),a
	ld (enemigo3_col),a
	ld (enemigo3_coord),a
	ld (enemigo4),a
	ld (enemigo4_fila),a
	ld (enemigo4_col),a
	ld (enemigo4_coord),a

	ret

;-------------------------------------------------------------
;PINTA LA ENTRADA A LA PANTALLA
;Entrada: (efila)(ecol)(elinea)
;-------------------------------------------------------------
pinta_entrada_LR:

	push bc
	ld b,2
	bucle_pinta_entrada
		push bc
		ld a,(efila)
		ld b,a
		ld a,(ecol)
		ld c,a
		call Get_Char_Offset_LR
		call desintegracion

		;comprobar si la entrada esta en fila (0 o 23) o en col (0 o 23)
		;para anadir otro bloque (la entrada sera de dos bloques)
		ld a,(elinea)
		bit 0,a
		;cp 0
		jr nz,elinea_impar 
		ld a,(ecol)
		inc a
		ld (ecol),a
		jr sigue_pinta_entrada
	elinea_impar				;es en col 0 o 23
		ld a,(efila)
		inc a
		ld (efila),a
		
	sigue_pinta_entrada
		pop bc
		djnz bucle_pinta_entrada

	pop bc
	ret

;-------------------------------------------------------------
;PINTA LA SALIDA de LA PANTALLA
;Entrada: (sfila)(scol)(slinea)
;-------------------------------------------------------------
pinta_salida_LR:

	ld a,(sfila)
	ld (sfila_aux),a

	ld a,(scol)
	ld (scol_aux),a


	ld b,3
	bucle_pinta_salida
		push bc
		ld a,(sfila_aux)
		ld b,a
		ld a,(scol_aux)
		ld c,a
		call Get_Char_Offset_LR
		call desintegracion

		;comprobar si la salida esta en fila (0 o 23) o en col (0 o 23)
		;para anadir dos bloques mas (la salida sera de tres bloques)
		ld a,(slinea)
		bit 0,a
		;cp 0
		jr nz,slinea_impar
		ld a,(scol_aux)
		inc a
		ld (scol_aux),a
		jr sigue_pinta_salida
	slinea_impar
		ld a,(sfila_aux)
		inc a
		ld (sfila_aux),a
		
	sigue_pinta_salida
		pop bc
		djnz bucle_pinta_salida



	ret

;-------------------------------------------------------------
;desintegra un bloque
;-------------------------------------------------------------
desintegracion:
	ld (hpos),hl

	ld (hl),16
  	call miniretardo
	inc h
	ld (hl),32
	call miniretardo
	inc h
	ld (hl),4
	call miniretardo
	inc h
	ld (hl),1
	call miniretardo
	inc h
	ld (hl),128
	call miniretardo
	inc h
	ld (hl),8
	call miniretardo
	inc h
	ld (hl),2
	inc h
	ld (hl),64

	ld hl,(hpos)
  	ld (hl),0
  	call retardo
	inc h
	ld (hl),0
	call retardo
	inc h
	ld (hl),0
	call retardo
	inc h
	ld (hl),0
	call retardo
	inc h
	ld (hl),0
	call retardo
	inc h
	ld (hl),0
	call retardo
	inc h
	ld (hl),0
	inc h
	ld (hl),0

	ret
;-------------------------------------------------------------
; Simple pseudo-random number generator.
; Steps a pointer through the ROM (held in seed), returning
; the contents of the byte at that location.
;-------------------------------------------------------------

random_old:
	ld hl,(seed)        ; Pointer
       	ld a,h
       	and 31              ; keep it within first 8k of ROM.
       	ld h,a
       	ld a,(hl)           ; Get "random" number from location.
       	inc hl              ; Increment pointer.
       	ld (seed),hl
       	ret
;------------------------------------------------------------------------------
; This routine below is part of the ZX Spectrum libzx library by Sebastian Mihai, 2016
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
;
; Random number routine. Original name: get_next_random:
;
;------------------------------------------------------------------------------

	lastRandomNumber db 33
	romPointer dw 3		; our random numbers are, in part, based on reading
						; bytes from the 16kb ROM, whose contents are "pretty
						; random"

; Gets an 8-bit random number. 
; It is computed using a combination of:
;     - the last returned random number
;     - a byte from ROM, in increasing order
;     - current values of various registers
;     - a flat incremented value
;
; Output:
; 		A - next random number
random:
	push af
	
	push hl
	; advance ROM pointer
	ld hl, romPointer
	ld c, (hl)
	inc hl
	ld b, (hl)				; BC := word (romPointer)
	ld hl, 3
	add hl, bc				; HL := ROM pointer advanced by 3
	ld a, h
	and %00111111
	ld h, a					; H := H mod %00111111
							; essentially, HL := HL mod 16384, to make sure
							; HL points at a ROM location
	ld (romPointer), hl		; save new location
	pop hl
	
	; now compute the random number
	
	pop bc					; BC := AF
	rlc c
	rlc b
	ld a, (lastRandomNumber)
	add a, b				; current register values are "pretty random"
	add a, c				; so add them in the mix
	add a, 47
	add a, d
	add a, e
	add a, h
	add a, l
	
	ld hl, romPointer
	add a, (hl)				; the contents of the ROM are "pretty random"
							; so add it in the mix
	
	ld hl, lastRandomNumber
	ld (hl), a				; save this number
	
	ret


;-------------------------------------------------------------
;Dado el array de sprites y las coordenadas internas del sprite, calcula la dir del sprite
;-------------------------------------------------------------
escoge_sprite:

	push bc
  	ld bc,coordenadas ;array de sprites
	ld a,(SPRITE_COORD)
	and 11110000b   ;me quedo con la fila
	rrc a
	rrc a
	rrc a     ;queda en la derecha y multiplicado por 2: 000XXXX0

	ld l,a


	ld a,(SPRITE_COORD)
	and 00001111b   ;me quedo con la columna

	add a,l     ;tengo aqui filax2+col

	ld l,a      ;y lo guardo en l
	ld a,(SPRITE_COORD)

	add a,l

	ld l,a
	ld h,0
	add hl,bc   ;en hl queda la dir del sprite

	LD A, (HL)                      ; Leemos la parte baja de la direccion en A
	INC HL                          ; ... para no corromper HL y poder leer ...
	;PUSH HL
	LD D, (HL)                      ; ... la parte alta sobre D ...
	LD E, A
	pop bc

	ret
;-------------------------------------------------------------
;Rutina que pinta tanto el sprite del palyer como los enemigos
;Entrada:
;	SPRITE_ATTR	;donde se guarda el atributo de tinta (el papel sera siempre negro)
;	SPRITE_COORD	;donde esta la fila (4 bits + signific) y la columna (4 bits - signific)
;			;dentro del sprite. Both van de 0 a 15
;	SPRITE_FILA	;posicion de la fila en pantalla en baja resolucion del sprite
;	SPRITE_COL	;posicion de la columna en pantalla en baja resolucion del sprite
;-------------------------------------------------------------
pinta_sprite:

	push af
	push bc

	


	;asignar atributo
	ld a,(SPRITE_FILA)
	ld b,a
	ld a,(SPRITE_COL)
	ld c,a
	call Get_Attribute_Offset_LR
	ld a,(SPRITE_ATTR)
	ld (hl),a


	;calcular posicion en alta resolucion dadas fila y col en baja resolucion
	ld a,(SPRITE_FILA)
	ld b,a
	ld a,(SPRITE_COL)
	ld c,a
	call Get_Char_Offset_LR		;dir pantalla en HL
	ld (hpos),hl


	
	
	;escoger sprite y ponerlo en de
	call escoge_sprite		;dir del sprite en de

	;ld hl,16390
	;ld a,(SPRITE_COORD)
	;ld (hl),a
	;ld hl,(hpos)
	;call Wait_For_Keys_Pressed
	;call Wait_For_Keys_Released

	ld b,2               ;numero de columnas del sprite
bucle_columna      
  	push bc              ;me guardo el b mas externo
  	ld b,2               ;numero de bloques x columna 
bucle_fila
  	push bc

  	;asignar atributo
	ld a,(SPRITE_FILA)
	ld b,a
	ld a,(SPRITE_COL)
	ld c,a
  	call Get_Attribute_Offset_LR
	ld a,(SPRITE_ATTR)
	ld (hl),a

  	ld b,8
  	ld hl,(hpos)
drawsp8x8_loop:
    	ld a,(de)
    	ld (hl), a         ; (HL) = A = escribir dato a la pantalla
    	inc de             ; Incrementamos DE (puntero sprite)
    	inc h              ; Incrementamos scanline HL (HL+=256)
    
    	djnz drawsp8x8_loop

    	;recupero la posicion y le sumo 1 para el sig bloque
    	ld a,(SPRITE_FILA)
    	inc a
    	ld (SPRITE_FILA),a
    	ld b,a
    	ld a,(SPRITE_COL)
    	ld c,a
    	call Get_Char_Offset_LR
    	ld (hpos),hl

    	pop bc
    	
    	djnz bucle_fila

    	;nos colocamos en la fila inicial e incrementamos columna
    	ld a,(SPRITE_FILA)
    	dec a
    	dec a
    	ld (SPRITE_FILA),a
    	ld b,a
    	ld a,(SPRITE_COL)
    	inc a
    	ld (SPRITE_COL),a
    	ld c,a
    	call Get_Char_Offset_LR
    	ld (hpos),hl
    	
    	pop bc
    	
    	djnz bucle_columna

    	;posiciono la fila y la columna como al principio
    	ld a,(SPRITE_FILA)
    	dec a
    	ld (SPRITE_FILA),a
    	ld a,(SPRITE_COL)
    	dec a
    	ld (SPRITE_COL),a



	pop bc
	pop af

	ret

;-----------------------------------------------------------------------
;pinta el logotipo de copyleft
;-----------------------------------------------------------------------
copyleft:

	push af
	push bc

	


	;asignar atributo
	ld a,12
	ld b,a
	ld a,25
	ld c,a
	call Get_Attribute_Offset_LR
	ld a,7
	ld (hl),a


	
	ld de,copyleftlogo
	ld hl,18585
	

  	ld b,8
copyleft_loop:
    	ld a,(de)
    	ld (hl), a         ; (HL) = A = escribir dato a la pantalla
    	inc de             ; Incrementamos DE (puntero sprite)
    	inc h              ; Incrementamos scanline HL (HL+=256)
    
    	djnz copyleft_loop

    	

	pop bc
	pop af

	ret

;-------------------------------------------------------------
; Get_Attribute_Offset_LR: 
; Obtener la direccion de memoria del atributo del caracter
; (c,f) especificado. Por David Webb.
;
; Entrada:   B = FILA,  C = COLUMNA
; Salida:    HL = Direccion del atributo
;-------------------------------------------------------------
Get_Attribute_Offset_LR:
   LD A, B            ; Ponemos en A la fila (000FFFFFb)
   RRCA
   RRCA
   RRCA               ; Desplazamos A 3 veces (A=A>>3) 
   AND 3              ; A = A AND 00000011 = los 2 bits mas
                      ; altos de FILA (000FFFFFb -> 000000FFb)
   ADD A, $58         ; Ponemos los bits 15-10 como 010110b
   LD H, A            ; Lo cargamos en el byte alto de HL
   LD A, B            ; Recuperamos de nuevo en A la FILA
   AND 7              ; Nos quedamos con los 3 bits que faltan
   RRCA           
   RRCA               ; Los rotamos para colocarlos en su
   RRCA               ; ubicacion final (<<5 = >>3)
   ADD A, C           ; Sumamos el numero de columna
   LD L, A            ; Lo colocamos en L
   RET                ; HL = 010110FFFFFCCCCCb 

;-------------------------------------------------------------
; Get_Char_Offset_LR(c,f)
; Obtener la direccion de memoria del caracter (c,f) indicado.
;
; Entrada:   B = FILA,  C = COLUMNA
; Salida:   HL = Direccion de memoria del caracter (c,f)
;-------------------------------------------------------------
Get_Char_Offset_LR:
   LD A, B         ; A = B, para extraer los bits de tercio
   AND $18         ; A = A AND 00011000b
                   ; A = estado de bits de TERCIO desde FILA
   ADD A, $40      ; Sumamos $40 (2 bits superiores = 010)
   LD H, A         ; Ya tenemos la parte alta calculada
                   ; H = 010TT000
   LD A, B         ; Ahora calculamos la parte baja
   AND 7           ; Nos quedamos con los bits más bajos de FILA
                   ; que coinciden con FT (Fila dentro del tercio)
   RRCA            ; Ahora A = 00000NNNb     (N=FT)
   RRCA            ; Desplazamos A 3 veces a la derecha
   RRCA            ; A = NNN00000b
   ADD A, C        ; Sumamos COLUMNA -> A = NNNCCCCCb
   LD L, A         ; Lo cargamos en la parte baja de la direccion
   RET             ; HL = 010TT000NNNCCCCCb

;-------------------------------------------------------------
; PrintChar_8x8:
; Imprime un caracter de 8x8 pixeles de un charset.
;
; Entrada (paso por parametros en memoria):
; -----------------------------------------------------
; FONT_CHARSET = Direccion de memoria del charset.
; FONT_X       = Coordenada X en baja resolucion (0-31)
; FONT_Y       = Coordenada Y en baja resolucion (0-23)
; FONT_ATTRIB  = Atributo a utilizar en la impresion.
; Registro A   = ASCII del caracter a dibujar.
;-------------------------------------------------------------
PrintChar_8x8:
 
   LD BC, (FONT_X)      ; B = Y,  C = X
   EX AF, AF'           ; Nos guardamos el caracter en A'
 
   ;;; Calculamos las coordenadas destino de pantalla en DE:
   LD A, B
   AND $18
   ADD A, $40
   LD D, A
   LD A, B
   AND 7
   RRCA
   RRCA
   RRCA
   ADD A, C
   LD E, A              ; DE contiene ahora la direccion destino.
 
   ;;; Calcular posicion origen (array sprites) en HL como:
   ;;;     direccion = base_sprites + (NUM_SPRITE*8)
   EX AF, AF'           ; Recuperamos el caracter a dibujar de A'
   LD BC, (FONT_CHARSET)
   LD H, 0
   LD L, A
   ADD HL, HL
   ADD HL, HL
   ADD HL, HL
   ADD HL, BC         ; HL = BC + HL = FONT_CHARSET + (A * 8)
 
   EX DE, HL          ; Intercambiamos DE y HL (DE=origen, HL=destino)
 
   ;;; Dibujar 7 scanlines (DE) -> (HL) y bajar scanline (y DE++)
   LD B, 7            ; 7 scanlines a dibujar
 
drawchar8_loop:
   LD A, (DE)         ; Tomamos el dato del caracter
   LD (HL), A         ; Establecemos el valor en videomemoria
   INC DE             ; Incrementamos puntero en caracter
   INC H              ; Incrementamos puntero en pantalla (scanline+=1)
   DJNZ drawchar8_loop
 
   ;;; La octava iteracion (8o scanline) aparte, para evitar los INCs
   LD A, (DE)         ; Tomamos el dato del caracter
   LD (HL), A         ; Establecemos el valor en videomemoria
 
   LD A, H            ; Recuperamos el valor inicial de HL
   SUB 7              ; Restando los 7 "INC H"'s realizados
 
   ;;; Calcular posicion destino en area de atributos en DE.
                      ; Tenemos A = H
   RRCA               ; Codigo de Get_Attr_Offset_From_Image
   RRCA
   RRCA
   AND 3
   OR $58
   LD D, A
   LD E, L
 
   ;;; Escribir el atributo en memoria
   LD A, (FONT_ATTRIB)
   LD (DE), A         ; Escribimos el atributo en memoria
   RET

;-------------------------------------------------------
;RETARDO
;-------------------------------------------------------
retardo:
	push af
  	push bc
	;ld bc,$1FFF       ;8191d
	;ld bc,$1000       ;4096d
	ld bc,$C00        ;3072d
	;ld bc,$600        ;1536d
	;ld bc,$180
	wait
		dec bc
		ld a,b
		or c
		jr nz,wait

  	pop bc
  	pop af
  	
  	ret

miniretardo:
	push af
  	push bc
      
	ld bc,$010
	wait2
		dec bc
		ld a,b
		or c
		jr nz,wait2

  	pop bc
  	pop af
  	
  	ret

retardo1:
	push af
  	push bc
	;ld bc,$1FFF       ;8191d
	;ld bc,$1000       ;4096d
	;ld bc,$C00        ;3072d
	;ld bc,$600        ;1536d
	ld bc,$180        
	wait3
		dec bc
		ld a,b
		or c
		jr nz,wait3

  	pop bc
  	pop af
  	
  	ret
;-----------------------------------------------------------------------
; Esta rutina espera a que haya alguna tecla pulsada para volver.
;-----------------------------------------------------------------------
pulsa_tecla:
	xor a   
	in a, (254)
	or 224
	inc a
	jr z, pulsa_tecla
	ret
 
;-----------------------------------------------------------------------
; Esta rutina espera a que no haya ninguna tecla pulsada para volver.
;-----------------------------------------------------------------------
suelta_tecla:
	xor a
	in a, (254)
	or 224
	inc a
	jr nz, suelta_tecla
	ret

;-----------------------------------------------------------------------
; Chequea el estado de una tecla concreta, aquella de scancode
; codificado en A (como parametro de entrada).
;
; Devuelve:    CARRY FLAG = 0 -> Tecla pulsada
;              CARRY FLAG = 1 y BC = 0 -> Tecla no pulsada
;-----------------------------------------------------------------------
check_key:
	ld c, a          ; copia de a

	and 7
	inc a
	ld b, a          ; b = 16 - (num. linea dirección)

	srl c
	srl c
	srl c
	ld a, 5
	sub c
	ld c, a          ; c = (semifila + 1)

	ld a, $fe
 
ckhifind:           	 ; calcular el octeto de mayor peso del puerto
	rrca
	djnz ckhifind

	in a, ($fe)      ; leemos la semifila

cknxkey:
	rra
	dec c
	jr nz, cknxkey   ; ponemos el bit de tecla en el cf

	ret   
;-----------------------------------------------------------------------
; Pinta el escenario limpiando lo que hubiera anteriormente
;-----------------------------------------------------------------------
pintalimpia_escenario:

;linea horizontal top;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld b,24
	ld hl,$4000
pe_bucle24_top
	ld a,1
	call pinta_bloque_pared
	inc l
	djnz pe_bucle24_top

;linea vertical left primer tercio;;;;;;;;;;;;;;;;;;;;;;
	ld b,7
	ld hl,$4020
pe_bucle22_left_tercio1:
	ld a,1
	call pinta_bloque_pared
	ld a,l
	add a,$20
	ld l,a
	djnz pe_bucle22_left_tercio1

;linea vertical left segundo tercio;;;;;;;;;;;;;;;;;;;;;
	ld b,8
	ld hl,$4800
pe_bucle22_left_tercio2:
	ld a,1
	call pinta_bloque_pared
	ld a,l
	add a,$20
	ld l,a
	djnz pe_bucle22_left_tercio2

;linea vertical left tercer tercio;;;;;;;;;;;;;;;;;;;;;;
	ld b,7
	ld hl,$5000
pe_bucle22_left_tercio3:
	ld a,1
	call pinta_bloque_pared
	ld a,l
	add a,$20
	ld l,a
	djnz pe_bucle22_left_tercio3

;interior del cuadro;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld b,22
	ld hl,$4021
pe_bucle_fila_tercio1:
	push bc
	push hl
	ld b,7
	pe_bucle_col_tercio1:
		call pinta_bloque_vacio
		ld a,l
		add a,$20
		ld l,a
		djnz pe_bucle_col_tercio1
	pop hl
	pop bc
	inc l
	djnz pe_bucle_fila_tercio1

	ld b,22
	ld hl,$4801
pe_bucle_fila_tercio2:
	push bc
	push hl
	ld b,8
	pe_bucle_col_tercio2:
		call pinta_bloque_vacio
		ld a,l
		add a,$20
		ld l,a
		djnz pe_bucle_col_tercio2
	pop hl
	pop bc
	inc l
	djnz pe_bucle_fila_tercio2

	ld b,22
	ld hl,$5001
pe_bucle_fila_tercio3:
	push bc
	push hl
	ld b,7
	pe_bucle_col_tercio3:
		call pinta_bloque_vacio
		ld a,l
		add a,$20
		ld l,a
		djnz pe_bucle_col_tercio3
	pop hl
	pop bc
	inc l
	djnz pe_bucle_fila_tercio3




;linea vertical right primer tercio;;;;;;;;;;;;;;;;;;;;;;
	ld b,7
	ld hl,$4037
pe_bucle22_right_tercio1:
	ld a,1
	call pinta_bloque_pared
	ld a,l
	add a,$20
	ld l,a
	djnz pe_bucle22_right_tercio1

;linea vertical right segundo tercio;;;;;;;;;;;;;;;;;;;;;
	ld b,8
	ld hl,$4817
pe_bucle22_right_tercio2:
	ld a,1
	call pinta_bloque_pared
	ld a,l
	add a,$20
	ld l,a
	djnz pe_bucle22_right_tercio2

;linea vertical right tercer tercio;;;;;;;;;;;;;;;;;;;;;;
	ld b,7
	ld hl,$5017
pe_bucle22_right_tercio3:
	ld a,1
	call pinta_bloque_pared
	ld a,l
	add a,$20
	ld l,a
	djnz pe_bucle22_right_tercio3



;linea bottom horizontal;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld b,24
	ld hl,$50E0
pe_bucle24_bottom
	ld a,1
	call pinta_bloque_pared
	inc l
	djnz pe_bucle24_bottom


call pinta_titulo
	ret

;-----------------------------------------------------------------------
; Pinta un bloque de pared
;-----------------------------------------------------------------------
pinta_bloque_pared:
	
	;atributos_pared
	call Attr_Offset_From_Image
 
   	;LD A, 1             ; azul sobre negro
   	LD (de), A           

   	

	ld (hl),126
	inc h
	ld (hl),129
	inc h
	ld (hl),189
	inc h
	ld (hl),165
	inc h
	ld (hl),165
	inc h
	ld (hl),189
	inc h
	ld (hl),129
	inc h
	ld (hl),126
	dec h
	dec h
	dec h
	dec h
	dec h
	dec h
	dec h
	

	ret

;-----------------------------------------------------------------------
; Pinta un bloque vacio
;-----------------------------------------------------------------------
pinta_bloque_vacio:
	


	;atributos_escenario
	call Attr_Offset_From_Image
 
   	ld a,6             ; amarillo sobre negro
   	LD (de), A  


	ld (hl),0
	inc h
	ld (hl),0
	inc h
	ld (hl),0
	inc h
	ld (hl),0
	inc h
	ld (hl),0
	inc h
	ld (hl),0
	inc h
	ld (hl),0
	inc h
	ld (hl),0
	dec h
	dec h
	dec h
	dec h
	dec h
	dec h
	dec h

	ret

;-----------------------------------------------------------------------
; Pinta llave 
;Entrada: HL - posicion para pintar
;-----------------------------------------------------------------------
pinta_llave:
	



	
	call Attr_Offset_From_Image
 
   	LD A, 5             ; cyan sobre negro
   	LD (de), A           

   	

	ld (hl),0
	inc h
	ld (hl),7
	inc h
	ld (hl),5
	inc h
	ld (hl),253
	inc h
	ld (hl),165
	inc h
	ld (hl),167
	inc h
	ld (hl),0
	inc h
	ld (hl),0
	dec h
	dec h
	dec h
	dec h
	dec h
	dec h
	dec h
	

	ret

;-----------------------------------------------------------------------
; Borra llave 
;Entrada: HL - posicion para pintar
;-----------------------------------------------------------------------
borra_llave:
      

   	
	ld b,8
	borra_llave_loop1
		ld (hl),0
		inc h
		djnz borra_llave_loop1

	ld b,8
	borra_llave_loop2
		dec h
		djnz borra_llave_loop2
	
	
	

	ret

;-------------------------------------------------------------
;Limpia la zona de titulo y score
;-------------------------------------------------------------
limpia_scores:

;Limpieza


	ld b,8
	ld hl,$4018
pe_bucle_filascore_tercio1:
	push bc
	push hl
	ld b,8
	pe_bucle_colscore_tercio1:
		call pinta_bloque_vacio
		ld a,l
		add a,$20
		ld l,a
		djnz pe_bucle_colscore_tercio1
	pop hl
	pop bc
	inc l
	djnz pe_bucle_filascore_tercio1

	ld b,8
	ld hl,$4818
pe_bucle_filascore_tercio2:
	push bc
	push hl
	ld b,8
	pe_bucle_colscore_tercio2:
		call pinta_bloque_vacio
		ld a,l
		add a,$20
		ld l,a
		djnz pe_bucle_colscore_tercio2
	pop hl
	pop bc
	inc l
	djnz pe_bucle_filascore_tercio2

	ld b,8
	ld hl,$5018
pe_bucle_filascore_tercio3:
	push bc
	push hl
	ld b,8
	pe_bucle_colscore_tercio3:
		call pinta_bloque_vacio
		ld a,l
		add a,$20
		ld l,a
		djnz pe_bucle_colscore_tercio3
	pop hl
	pop bc
	inc l
	djnz pe_bucle_filascore_tercio3



	;Score


	ld a,25
	ld (FONT_X),a
	ld a,18
	ld (FONT_Y),a
	ld a,6
	ld (FONT_ATTRIB),a
	LD HL, texto_room
  	CALL PrintString_8x8



	;Vidas

	ld a,25
	ld (FONT_X),a
	ld a,20
	ld (FONT_Y),a
	LD HL, texto_lives
  	CALL PrintString_8x8



  	;Beams

	ld a,25
	ld (FONT_X),a
	ld a,22
	ld (FONT_Y),a
	LD HL, texto_beams
  	CALL PrintString_8x8


	ret

;-------------------------------------------------------------
;pinta el titulo
;-------------------------------------------------------------
pinta_titulo:
	;Decorado
	;Banner titulo

	;linea horizontal top;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		ld b,8
		ld hl,$4018
	pe_bucle8_top
		ld a,2
		call pinta_bloque_pared
		inc l
		djnz pe_bucle8_top

	;linea vertical left primer tercio;;;;;;;;;;;;;;;;;;;;;;
		ld b,7
		ld hl,$4038
	pe_bucle_left_tercio1:
		ld a,2
		call pinta_bloque_pared
		ld a,l
		add a,$20
		ld l,a
		djnz pe_bucle_left_tercio1

	;linea vertical left segundo tercio;;;;;;;;;;;;;;;;;;;;;
		ld b,8
		ld hl,$4818
	pe_bucle_left_tercio2:
		ld a,2
		call pinta_bloque_pared
		ld a,l
		add a,$20
		ld l,a
		djnz pe_bucle_left_tercio2

; 	;linea vertical left tercer tercio;;;;;;;;;;;;;;;;;;;;;;
; 		ld b,2
; 		ld hl,$5018
; 	pe_bucle_left_tercio3:
; 		ld a,2
; 		call pinta_bloque_pared
; 		ld a,l
; 		add a,$20
; 		ld l,a
; 		djnz pe_bucle_left_tercio3

	;linea horizontal bottom;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		ld b,8
		ld hl,$5018
	pe_bucle8_bottom
		ld a,2
		call pinta_bloque_pared
		inc l
		djnz pe_bucle8_bottom


	;linea vertical right primer tercio;;;;;;;;;;;;;;;;;;;;;;
		ld b,7
		ld hl,$403F
	pe_bucle_right_tercio1:
		ld a,2
		call pinta_bloque_pared
		ld a,l
		add a,$20
		ld l,a
		djnz pe_bucle_right_tercio1

	;linea vertical right segundo tercio;;;;;;;;;;;;;;;;;;;;;
		ld b,8
		ld hl,$481F
	pe_bucle_right_tercio2:
		ld a,2
		call pinta_bloque_pared
		ld a,l
		add a,$20
		ld l,a
		djnz pe_bucle_right_tercio2

; 	;linea vertical right tercer tercio;;;;;;;;;;;;;;;;;;;;;;
; 		ld b,2
; 		ld hl,$501F
; 	pe_bucle_right_tercio3:
; 		ld a,2
; 		call pinta_bloque_pared
; 		ld a,l
; 		add a,$20
; 		ld l,a
; 		djnz pe_bucle_right_tercio3


	;TItulo y Creditos
	ld a,25
	ld (FONT_X),a
	ld a,3
	ld (FONT_Y),a
	ld a,6
	ld (FONT_ATTRIB),a
	LD HL, texto_titulo1
  	CALL PrintString_8x8

  	ld a,25
	ld (FONT_X),a
	ld a,4
	ld (FONT_Y),a
	ld a,6
	ld (FONT_ATTRIB),a
	LD HL, texto_titulo2
  	CALL PrintString_8x8

  	ld a,25
	ld (FONT_X),a
	ld a,6
	ld (FONT_Y),a
	ld a,7
	ld (FONT_ATTRIB),a
	LD HL, texto_titulo3
  	CALL PrintString_8x8

  	ld a,25
	ld (FONT_X),a
	ld a,8
	ld (FONT_Y),a
	ld a,1
	ld (FONT_ATTRIB),a
	LD HL, texto_titulo4
  	CALL PrintString_8x8

  	ld a,25
	ld (FONT_X),a
	ld a,9
	ld (FONT_Y),a
	ld a,1
	ld (FONT_ATTRIB),a
	LD HL, texto_titulo5
  	CALL PrintString_8x8

  	ld a,26
	ld (FONT_X),a
	ld a,12
	ld (FONT_Y),a
	ld a,7
	ld (FONT_ATTRIB),a
	LD HL, texto_titulo6
  	CALL PrintString_8x8

  	;copyleft logo 18585
  	call copyleft

	ret
;-------------------------------------------------------------
;actualiza el marcador
;-------------------------------------------------------------
actualiza_scores:
	ld a,29
	ld (FONT_X),a
	ld a,18
	ld (FONT_Y),a
	ld a,3
	ld (FONT_ATTRIB),a

	ld bc,numeros
	ld a,(num_pantalla)
	ld l,a
	ld h,0
	sla l
	rl h
	add hl,bc

	ld a,(hl)
	inc hl
	;push hl
	ld h,(hl)
	ld l,a
	
  	CALL PrintString_8x8


  	ld a,30
	ld (FONT_X),a
	ld a,20
	ld (FONT_Y),a
	ld a,3
	ld (FONT_ATTRIB),a

	ld bc,numeros
	ld a,(vidas)
	ld l,a
	ld h,0
	sla l
	rl h
	add hl,bc

	ld a,(hl)
	inc hl
	;push hl
	ld h,(hl)
	ld l,a
	
  	CALL PrintString_8x8


  	ld a,30
	ld (FONT_X),a
	ld a,22
	ld (FONT_Y),a
	ld a,3
	ld (FONT_ATTRIB),a

	ld bc,numeros
	ld a,(beams)
	ld l,a
	ld h,0
	sla l
	rl h
	add hl,bc

	ld a,(hl)
	inc hl
	;push hl
	ld h,(hl)
	ld l,a
	
  	CALL PrintString_8x8
 	

  	ret
;-------------------------------------------------------------
; Attr_Offset_From_Image (DF-ATT):
;
; Entrada:  HL = Direccion de memoria de imagen.
; Salida:   DE = Direccion de atributo correspondiente a HL.
;-------------------------------------------------------------
Attr_Offset_From_Image:
	push AF
	LD A, H
	RRCA
	RRCA
	RRCA
	AND 3
	OR $58
	LD D, A
	LD E, L
	pop AF
	RET

;-------------------------------------------------------------
; PrintString_8x8:
; Imprime una cadena de texto de un charset de fuente 8x8.
;
; Entrada (paso por parametros en memoria):
; -----------------------------------------------------
; FONT_CHARSET = Direccion de memoria del charset.
; FONT_X       = Coordenada X en baja resolucion (0-31)
; FONT_Y       = Coordenada Y en baja resolucion (0-23)
; FONT_ATTRIB  = Atributo a utilizar en la impresion.
; Registro HL  = Puntero a la cadena de texto a imprimir.
;                Debe acabar en 0
;-------------------------------------------------------------
PrintString_8x8:
 
   ;;; Bucle de impresion de caracter
pstring8_loop:
   LD A, (HL)                ; Leemos un caracter de la cadena
   OR A
   RET Z                     ; Si es 0 (fin de cadena) volver
   INC HL                    ; Siguiente caracter en la cadena
   PUSH HL                   ; Salvaguardamos HL
   CALL PrintChar_8x8        ; Imprimimos el caracter
   POP HL                    ; Recuperamos HL
 
   ;;; Ajustamos coordenadas X e Y
   LD A, (FONT_X)            ; Incrementamos la X
   INC A                     ; pero comprobamos si borde derecho
   CP 32                     ; X > 31? 	;LE pongo 32 para que no me borre 
   					;algunos caracteres de la pared en la
   					;izquierda. 
   JR C, pstring8_noedgex    ; No, se puede guardar el valor
 
   LD A, (FONT_Y)            ; Cogemos coordenada Y
   CP 23                     ; Si ya es 23, no incrementar
   JR NC, pstring8_noedgey   ; Si es 23, saltar
 
   INC A                     ; No es 23, cambiar Y
   LD (FONT_Y), A
 
pstring8_noedgey:
   LD (FONT_Y), A            ; Guardamos la coordenada Y
   XOR A                     ; Y ademas hacemos A = X = 0
 
pstring8_noedgex
   LD (FONT_X), A            ; Almacenamos el valor de X
   JR pstring8_loop

;----------------------------------------------------------------------------
; Chequea el teclado para detectar la pulsación de una tecla.
; Devuelve un código en el registro D que indica:
;
;    Bits 0, 1 y 2 de "D": Fila de teclas (puerto) detectada.
;    Bits 3, 4 y 5 de "D": Posición de la tecla en esa media fila
;
; Así, el valor devuelto nos indica la semifila a leer y el bit a testear.
; El registro D valdrá 255 ($FF) si no hay ninguna tecla pulsada.
;
; Flags: ZF desactivado: Más de una tecla pulsada
;        ZF activado: Tecla correctamente leída
;-----------------------------------------------------------------------------
Find_Key:
 
   LD DE, $FF2F         ; Valor inicial "ninguna tecla"
   LD BC, $FEFE         ; Puerto
 
NXHALF:
   IN A, (C)
   CPL 
   AND $1F
   JR Z, NPRESS         ; Saltar si ninguna tecla pulsada
 
   INC D                ; Comprobamos si hay más de 1 tecla pulsada
   RET NZ               ; Si es así volver con Z a 0
 
   LD H, A              ; Cálculo del valor de la tecla
   LD A, E
 
KLOOP:
   SUB 8
   SRL H
   JR NC, KLOOP
 
   RET NZ               ; Comprobar si más de una tecla pulsada
 
   LD D, A              ; Guardar valor de tecla en D
 
NPRESS:                 ; Comprobar el resto de semifilas
   DEC E
   RLC B
   JR C, NXHALF         ; Repetimos escaneo para otra semifila
 
   CP A                 ; Ponemos flag a zero
   RET Z                ; Volvemos


;------------------------------------------------------------------
; Chequea el estado de una tecla concreta, aquella de scancode
; codificado en A (como parametro de entrada).
;
; Devuelve:    CARRY FLAG = 0 -> Tecla pulsada
;              CARRY FLAG = 1 y BC = 0 -> Tecla no pulsada
;------------------------------------------------------------------
Check_Key:
   LD C, A          ; Copia de A
 
   AND 7
   INC A
   LD B, A          ; B = 16 - (num. linea dirección)
 
   SRL C
   SRL C
   SRL C
   LD A, 5
   SUB C
   LD C, A          ; C = (semifila + 1)
 
   LD A, $FE
 
CKHiFind:           ; Calcular el octeto de mayor peso del puerto
   RRCA
   DJNZ CKHiFind
 
   IN A, ($FE)      ; Leemos la semifila
 
CKNXKey:
   RRA
   DEC C
   JR NZ, CKNXKey   ; Ponemos el bit de tecla en el CF
 
   RET   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DATOS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
seed   defw 100
;-------------------------------------------------------------------------
; Textos menu principal
;-------------------------------------------------------------------------
menu_texto1:  	defb '0 - Redefine keys', 0
menu_texto2:  	defb '1 - Start', 0
key_up		defb 'UP   ',0
key_down	defb 'DOWN ',0
key_left	defb 'LEFT ',0
key_right	defb 'RIGHT',0
key_beam	defb 'BEAM ',0
key_pause	defb 'PAUSE',0
texto_room	defb 'ROOM ',0
texto_lives	defb 'LIVES',0
texto_beams	defb 'BEAMS',0
texto_titulo1	defb 'BLOCK',0
texto_titulo2	defb 'CHASE',0
texto_titulo3	defb 'by',0
texto_titulo4	defb 'The',0
texto_titulo5	defb 'Flake',0
texto_titulo6	defb '2017',0

tecla_arriba  	DEFB  $25
tecla_abajo   	DEFB  $26
tecla_izquierda	DEFB  $1A
tecla_derecha  	DEFB  $22
tecla_beam    	DEFB  $20
tecla_pause    	DEFB  $23

numero000	defb '0 ',0
numero001	defb '1 ',0
numero002	defb '2 ',0
numero003	defb '3 ',0
numero004	defb '4 ',0
numero005	defb '5 ',0
numero006	defb '6 ',0
numero007	defb '7 ',0
numero008	defb '8 ',0
numero009	defb '9 ',0
numero010	defb '10',0
numero011	defb '11',0
numero012	defb '12',0
numero013	defb '13',0
numero014	defb '14',0
numero015	defb '15',0
numero016	defb '16',0
numero017	defb '17',0
numero018	defb '18',0
numero019	defb '19',0
numero020	defb '20',0
numero021	defb '21',0
numero022	defb '22',0
numero023	defb '23',0
numero024	defb '24',0
numero025	defb '25',0
numero026	defb '26',0
numero027	defb '27',0
numero028	defb '28',0
numero029	defb '29',0
numero030	defb '30',0
numero031	defb '31',0
numero032	defb '32',0
numero033	defb '33',0
numero034	defb '34',0
numero035	defb '35',0
numero036	defb '36',0
numero037	defb '37',0
numero038	defb '38',0
numero039	defb '39',0
numero040	defb '40',0
numero041	defb '41',0
numero042	defb '42',0
numero043	defb '43',0
numero044	defb '44',0
numero045	defb '45',0
numero046	defb '46',0
numero047	defb '47',0
numero048	defb '48',0
numero049	defb '49',0
numero050	defb '50',0
numero051	defb '51',0
numero052	defb '52',0
numero053	defb '53',0
numero054	defb '54',0
numero055	defb '55',0
numero056	defb '56',0
numero057	defb '57',0
numero058	defb '58',0
numero059	defb '59',0
numero060	defb '60',0
numero061	defb '61',0
numero062	defb '62',0
numero063	defb '63',0
numero064	defb '64',0

numeros 
	defw numero000
	defw numero001,numero002,numero003,numero004
	defw numero005,numero006,numero007,numero008
	defw numero009,numero010,numero011,numero012
	defw numero013,numero014,numero015,numero016
	defw numero017,numero018,numero019,numero020
	defw numero021,numero022,numero023,numero024
	defw numero025,numero026,numero027,numero028
	defw numero029,numero030,numero031,numero032
	defw numero033,numero034,numero035,numero036
	defw numero037,numero038,numero039,numero040
	defw numero041,numero042,numero043,numero044
	defw numero045,numero046,numero047,numero048
	defw numero049,numero050,numero051,numero052
	defw numero053,numero054,numero055,numero056
	defw numero057,numero058,numero059,numero060
	defw numero061,numero062,numero063,numero064

pantallas
	defw pantalla000
	defw pantalla001,pantalla002,pantalla003,pantalla004
	defw pantalla005,pantalla006,pantalla007,pantalla008
	defw pantalla009,pantalla010,pantalla011,pantalla012
	defw pantalla013,pantalla014,pantalla015,pantalla016
	defw pantalla017,pantalla018,pantalla019,pantalla020
	defw pantalla021,pantalla022,pantalla023,pantalla024
	defw pantalla025,pantalla026,pantalla027,pantalla028
	defw pantalla029,pantalla030,pantalla031,pantalla032
	defw pantalla033,pantalla034,pantalla035,pantalla036
	defw pantalla037,pantalla038,pantalla039,pantalla040
	defw pantalla041,pantalla042,pantalla043,pantalla044
	defw pantalla045,pantalla046,pantalla047,pantalla048
	defw pantalla049,pantalla050,pantalla051,pantalla052
	defw pantalla053,pantalla054,pantalla055,pantalla056
	defw pantalla057,pantalla058,pantalla059,pantalla060
	defw pantalla061,pantalla062,pantalla063,pantalla064

;pantalla##	defb tipo enemigo 1,...2, 3 y 4., llave 0 no 1 si, multiplicador (1 por defecto)
pantalla000 	defb 0,0,0,0,0,0
pantalla001	defb 1,0,0,0,0,1
pantalla002	defb 1,1,0,0,0,1
pantalla003	defb 1,1,1,0,0,1
pantalla004	defb 1,1,1,1,0,1
pantalla005	defb 2,0,0,0,0,1
pantalla006	defb 2,1,0,0,0,1
pantalla007	defb 2,1,1,0,0,1
pantalla008	defb 2,1,1,1,0,1
pantalla009	defb 2,2,0,0,0,1
pantalla010	defb 2,2,1,0,0,1
pantalla011	defb 2,2,1,1,0,1
pantalla012	defb 2,2,2,0,0,1
pantalla013	defb 2,2,2,1,0,1
pantalla014	defb 2,2,2,2,0,1
pantalla015	defb 3,0,0,0,1,1
pantalla016	defb 3,1,0,0,1,1
pantalla017	defb 3,1,1,0,1,1
pantalla018	defb 3,1,1,1,1,1
pantalla019	defb 3,2,0,0,1,1
pantalla020	defb 3,2,1,0,1,1
pantalla021	defb 3,2,1,1,1,1
pantalla022	defb 3,2,2,0,1,50
pantalla023	defb 3,2,2,1,1,50
pantalla024	defb 3,2,2,2,1,50
pantalla025	defb 3,3,0,0,1,50
pantalla026	defb 3,3,1,0,1,50
pantalla027	defb 3,3,1,1,1,50
pantalla028	defb 3,3,2,0,1,50
pantalla029	defb 3,3,2,1,1,50
pantalla030	defb 3,3,2,2,1,50
pantalla031	defb 3,3,3,0,1,50
pantalla032	defb 3,3,3,1,1,100
pantalla033	defb 3,3,3,2,1,100
pantalla034	defb 3,3,3,3,1,100
pantalla035	defb 4,0,0,0,1,100
pantalla036	defb 4,1,0,0,1,100
pantalla037	defb 4,1,1,0,1,100
pantalla038	defb 4,1,1,1,1,100
pantalla039	defb 4,2,0,0,1,100
pantalla040	defb 4,2,1,0,1,100
pantalla041	defb 4,2,1,1,1,100
pantalla042	defb 4,2,2,0,1,150
pantalla043	defb 4,2,2,1,1,150
pantalla044	defb 4,2,2,2,1,150
pantalla045	defb 4,3,0,0,1,150
pantalla046	defb 4,3,1,0,1,150
pantalla047	defb 4,3,1,1,1,150
pantalla048	defb 4,3,2,0,1,150
pantalla049	defb 4,3,2,1,1,150
pantalla050	defb 4,3,2,2,1,150
pantalla051	defb 4,3,3,0,1,150
pantalla052	defb 4,3,3,1,1,200
pantalla053	defb 4,3,3,2,1,200
pantalla054	defb 4,3,3,3,1,200
pantalla055	defb 4,4,0,0,1,200
pantalla056	defb 4,4,1,0,1,200
pantalla057	defb 4,4,1,1,1,200
pantalla058	defb 4,4,2,0,1,200
pantalla059	defb 4,4,2,1,1,200
pantalla060	defb 4,4,2,2,1,200
pantalla061	defb 4,4,3,0,1,200
pantalla062	defb 4,4,3,1,1,250
pantalla063	defb 4,4,3,2,1,250
pantalla064	defb 4,4,3,3,1,250

copyleftlogo	defb 126,129,185,133,133,185,129,126

coordenadas
	defw c000,c001,c002,c003,c004,c005,c006,c007,c008
	defw c016,c017,c018,c019,c020,c021,c022,c023,c024
	defw c032,c033,c034,c035,c036,c037,c038,c039,c040
	defw c048,c049,c050,c051,c052,c053,c054,c055,c056
	defw c064,c065,c066,c067,c068,c069,c070,c071,c072
	defw c080,c081,c082,c083,c084,c085,c086,c087,c088
	defw c096,c097,c098,c099,c100,c101,c102,c103,c104
	defw c112,c113,c114,c115,c116,c117,c118,c119,c120
	defw c128,c129,c130,c131,c132,c133,c134,c135,c136

c000	DEFB	255,189,253,253,253,253,129,255
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
c001	DEFB	127, 94,126,126,126,126, 64,127
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	128,128,128,128,128,128,128,128
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
c002	DEFB	 63, 47, 63, 63, 63, 63, 32, 63
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	192, 64, 64, 64, 64, 64, 64,192
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
c003	DEFB	 31, 23, 31, 31, 31, 31, 16, 31
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	224,160,160,160,160,160, 32,224
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
c004	DEFB	 15, 11, 15, 15, 15, 15,  8, 15
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	240,208,208,208,208,208, 16,240
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
c005	DEFB	  7,  5,  7,  7,  7,  7,  4,  7
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	248,232,232,232,232,232,  8,248
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
c006	DEFB	  3,  2,  3,  3,  3,  3,  2,  3
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	252,244,244,244,244,244,  4,252
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
c007	DEFB	  1,  1,  1,  1,  1,  1,  1,  1
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	254,122,250,250,250,250,  2,254
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
c008	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	255,189,253,253,253,253,129,255
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
c016	DEFB	  0,255,189,253,253,253,253,129
	DEFB	255,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
c017	DEFB	  0,127, 94,126,126,126,126, 64
	DEFB	127,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,128,128,128,128,128,128,128
	DEFB	128,  0,  0,  0,  0,  0,  0,  0
c018	DEFB	  0, 63, 47, 63, 63, 63, 63, 32
	DEFB	 63,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,192, 64, 64, 64, 64, 64, 64
	DEFB	192,  0,  0,  0,  0,  0,  0,  0
c019	DEFB	  0, 31, 23, 31, 31, 31, 31, 16
	DEFB	 31,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,224,160,160,160,160,160, 32
	DEFB	224,  0,  0,  0,  0,  0,  0,  0
c020	DEFB	  0, 15, 11, 15, 15, 15, 15,  8
	DEFB	 15,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,240,208,208,208,208,208, 16
	DEFB	240,  0,  0,  0,  0,  0,  0,  0
c021	DEFB	  0,  7,  5,  7,  7,  7,  7,  4
	DEFB	  7,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,248,232,232,232,232,232,  8
	DEFB	248,  0,  0,  0,  0,  0,  0,  0
c022	DEFB	  0,  3,  2,  3,  3,  3,  3,  2
	DEFB	  3,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,252,244,244,244,244,244,  4
	DEFB	252,  0,  0,  0,  0,  0,  0,  0
c023	DEFB	  0,  1,  1,  1,  1,  1,  1,  1
	DEFB	  1,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,254,122,250,250,250,250,  2
	DEFB	254,  0,  0,  0,  0,  0,  0,  0
c024	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,255,189,253,253,253,253,129
	DEFB	255,  0,  0,  0,  0,  0,  0,  0
c032	DEFB	  0,  0,255,189,253,253,253,253
	DEFB	129,255,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
c033	DEFB	  0,  0,127, 94,126,126,126,126
	DEFB	 64,127,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,128,128,128,128,128,128
	DEFB	128,128,  0,  0,  0,  0,  0,  0
c034	DEFB	  0,  0, 63, 47, 63, 63, 63, 63
	DEFB	 32, 63,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,192, 64, 64, 64, 64, 64
	DEFB	 64,192,  0,  0,  0,  0,  0,  0
c035	DEFB	  0,  0, 31, 23, 31, 31, 31, 31
	DEFB	 16, 31,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,224,160,160,160,160,160
	DEFB	 32,224,  0,  0,  0,  0,  0,  0
c036	DEFB	  0,  0, 15, 11, 15, 15, 15, 15
	DEFB	  8, 15,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,240,208,208,208,208,208
	DEFB	 16,240,  0,  0,  0,  0,  0,  0
c037	DEFB	  0,  0,  7,  5,  7,  7,  7,  7
	DEFB	  4,  7,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,248,232,232,232,232,232
	DEFB	  8,248,  0,  0,  0,  0,  0,  0
c038	DEFB	  0,  0,  3,  2,  3,  3,  3,  3
	DEFB	  2,  3,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,252,244,244,244,244,244
	DEFB	  4,252,  0,  0,  0,  0,  0,  0
c039	DEFB	  0,  0,  1,  1,  1,  1,  1,  1
	DEFB	  1,  1,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,254,122,250,250,250,250
	DEFB	  2,254,  0,  0,  0,  0,  0,  0
c040	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,255,189,253,253,253,253
	DEFB	129,255,  0,  0,  0,  0,  0,  0
c048	DEFB	  0,  0,  0,255,189,253,253,253
	DEFB	253,129,255,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
c049	DEFB	  0,  0,  0,127, 94,126,126,126
	DEFB	126, 64,127,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,128,128,128,128,128
	DEFB	128,128,128,  0,  0,  0,  0,  0
c050	DEFB	  0,  0,  0, 63, 47, 63, 63, 63
	DEFB	 63, 32, 63,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,192, 64, 64, 64, 64
	DEFB	 64, 64,192,  0,  0,  0,  0,  0
c051	DEFB	  0,  0,  0, 31, 23, 31, 31, 31
	DEFB	 31, 16, 31,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,224,160,160,160,160
	DEFB	160, 32,224,  0,  0,  0,  0,  0
c052	DEFB	  0,  0,  0, 15, 11, 15, 15, 15
	DEFB	 15,  8, 15,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,240,208,208,208,208
	DEFB	208, 16,240,  0,  0,  0,  0,  0 
c053	DEFB	  0,  0,  0,  7,  5,  7,  7,  7
	DEFB	  7,  4,  7,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,248,232,232,232,232
	DEFB	232,  8,248,  0,  0,  0,  0,  0
c054	DEFB	  0,  0,  0,  3,  2,  3,  3,  3
	DEFB	  3,  2,  3,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,252,244,244,244,244
	DEFB	244,  4,252,  0,  0,  0,  0,  0
c055	DEFB	  0,  0,  0,  1,  1,  1,  1,  1
	DEFB	  1,  1,  1,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,254,122,250,250,250
	DEFB	250,  2,254,  0,  0,  0,  0,  0
c056	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,255,189,253,253,253
	DEFB	253,129,255,  0,  0,  0,  0,  0
c064	DEFB	  0,  0,  0,  0,255,189,253,253
	DEFB	253,253,129,255,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
c065	DEFB	  0,  0,  0,  0,127, 94,126,126
	DEFB	126,126, 64,127,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,128,128,128,128
	DEFB	128,128,128,128,  0,  0,  0,  0
c066	DEFB	  0,  0,  0,  0, 63, 47, 63, 63
	DEFB	 63, 63, 32, 63,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,192, 64, 64, 64
	DEFB	 64, 64, 64,192,  0,  0,  0,  0
c067	DEFB	  0,  0,  0,  0, 31, 23, 31, 31
	DEFB	 31, 31, 16, 31,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,224,160,160,160
	DEFB	160,160, 32,224,  0,  0,  0,  0
c068	DEFB	  0,  0,  0,  0, 15, 11, 15, 15
	DEFB	 15, 15,  8, 15,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,240,208,208,208
	DEFB	208,208, 16,240,  0,  0,  0,  0
c069	DEFB	  0,  0,  0,  0,  7,  5,  7,  7
	DEFB	  7,  7,  4,  7,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,248,232,232,232
	DEFB	232,232,  8,248,  0,  0,  0,  0
c070	DEFB	  0,  0,  0,  0,  3,  2,  3,  3
	DEFB	  3,  3,  2,  3,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,252,244,244,244
	DEFB	244,244,  4,252,  0,  0,  0,  0
c071	DEFB	  0,  0,  0,  0,  1,  1,  1,  1
	DEFB	  1,  1,  1,  1,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,254,122,250,250
	DEFB	250,250,  2,254,  0,  0,  0,  0
c072	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,255,189,253,253
	DEFB	253,253,129,255,  0,  0,  0,  0
c080	DEFB	  0,  0,  0,  0,  0,255,189,253
	DEFB	253,253,253,129,255,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
c081	DEFB	  0,  0,  0,  0,  0,127, 94,126
	DEFB	126,126,126, 64,127,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,128,128,128
	DEFB	128,128,128,128,128,  0,  0,  0
c082	DEFB	  0,  0,  0,  0,  0, 63, 47, 63
	DEFB	 63, 63, 63, 32, 63,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,192, 64, 64
	DEFB	 64, 64, 64, 64,192,  0,  0,  0
c083	DEFB	  0,  0,  0,  0,  0, 31, 23, 31
	DEFB	 31, 31, 31, 16, 31,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,224,160,160
	DEFB	160,160,160, 32,224,  0,  0,  0
c084	DEFB	  0,  0,  0,  0,  0, 15, 11, 15
	DEFB	 15, 15, 15,  8, 15,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,240,208,208
	DEFB	208,208,208, 16,240,  0,  0,  0
c085	DEFB	  0,  0,  0,  0,  0,  7,  5,  7
	DEFB	  7,  7,  7,  4,  7,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,248,232,232
	DEFB	232,232,232,  8,248,  0,  0,  0
c086	DEFB	  0,  0,  0,  0,  0,  3,  2,  3
	DEFB	  3,  3,  3,  2,  3,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,252,244,244
	DEFB	244,244,244,  4,252,  0,  0,  0
c087	DEFB	  0,  0,  0,  0,  0,  1,  1,  1
	DEFB	  1,  1,  1,  1,  1,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,254,122,250
	DEFB	250,250,250,  2,254,  0,  0,  0
c088	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,255,189,253
	DEFB	253,253,253,129,255,  0,  0,  0
c096	DEFB	  0,  0,  0,  0,  0,  0,255,189
	DEFB	253,253,253,253,129,255,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
c097	DEFB	  0,  0,  0,  0,  0,  0,127, 94
	DEFB	126,126,126,126, 64,127,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,128,128
	DEFB	128,128,128,128,128,128,  0,  0
c098	DEFB	  0,  0,  0,  0,  0,  0, 63, 47
	DEFB	 63, 63, 63, 63, 32, 63,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,192, 64
	DEFB	 64, 64, 64, 64, 64,192,  0,  0
c099	DEFB	  0,  0,  0,  0,  0,  0, 31, 23
	DEFB	 31, 31, 31, 31, 16, 31,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,224,160
	DEFB	160,160,160,160, 32,224,  0,  0
c100	DEFB	  0,  0,  0,  0,  0,  0, 15, 11
	DEFB	 15, 15, 15, 15,  8, 15,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,240,208
	DEFB	208,208,208,208, 16,240,  0,  0
c101	DEFB	  0,  0,  0,  0,  0,  0,  7,  5
	DEFB	  7,  7,  7,  7,  4,  7,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,248,232
	DEFB	232,232,232,232,  8,248,  0,  0
c102	DEFB	  0,  0,  0,  0,  0,  0,  3,  2
	DEFB	  3,  3,  3,  3,  2,  3,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,252,244
	DEFB	244,244,244,244,  4,252,  0,  0
c103	DEFB	  0,  0,  0,  0,  0,  0,  1,  1
	DEFB	  1,  1,  1,  1,  1,  1,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,254,122
	DEFB	250,250,250,250,  2,254,  0,  0
c104	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,255,189
	DEFB	253,253,253,253,129,255,  0,  0
c112	DEFB	  0,  0,  0,  0,  0,  0,  0,255
	DEFB	189,253,253,253,253,129,255,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
c113	DEFB	  0,  0,  0,  0,  0,  0,  0,127
	DEFB	 94,126,126,126,126, 64,127,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,128
	DEFB	128,128,128,128,128,128,128,  0
c114	DEFB	  0,  0,  0,  0,  0,  0,  0, 63
	DEFB	 47, 63, 63, 63, 63, 32, 63,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,192
	DEFB	 64, 64, 64, 64, 64, 64,192,  0
c115	DEFB	  0,  0,  0,  0,  0,  0,  0, 31
	DEFB	 23, 31, 31, 31, 31, 16, 31,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,224
	DEFB	160,160,160,160,160, 32,224,  0
c116	DEFB	  0,  0,  0,  0,  0,  0,  0, 15
	DEFB	 11, 15, 15, 15, 15,  8, 15,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,240
	DEFB	208,208,208,208,208, 16,240,  0
c117	DEFB	  0,  0,  0,  0,  0,  0,  0,  7
	DEFB	  5,  7,  7,  7,  7,  4,  7,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,248
	DEFB	232,232,232,232,232,  8,248,  0
c118	DEFB	  0,  0,  0,  0,  0,  0,  0,  3
	DEFB	  2,  3,  3,  3,  3,  2,  3,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,252
	DEFB	244,244,244,244,244,  4,252,  0
c119	DEFB	  0,  0,  0,  0,  0,  0,  0,  1
	DEFB	  1,  1,  1,  1,  1,  1,  1,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,254
	DEFB	122,250,250,250,250,  2,254,  0
c120	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,255
	DEFB	189,253,253,253,253,129,255,  0
c128	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	255,189,253,253,253,253,129,255
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
c129	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	127, 94,126,126,126,126, 64,127
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	128,128,128,128,128,128,128,128
c130	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	 63, 47, 63, 63, 63, 63, 32, 63
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	192, 64, 64, 64, 64, 64, 64,192
c131	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	 31, 23, 31, 31, 31, 31, 16, 31
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	224,160,160,160,160,160, 32,224
c132	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	 15, 11, 15, 15, 15, 15,  8, 15
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	240,208,208,208,208,208, 16,240
c133	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  7,  5,  7,  7,  7,  7,  4,  7
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	248,232,232,232,232,232,  8,248
c134	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  3,  2,  3,  3,  3,  3,  2,  3
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	252,244,244,244,244,244,  4,252
c135	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  1,  1,  1,  1,  1,  1,  1,  1
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	254,122,250,250,250,250,  2,254
c136	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  0
	DEFB	255,189,253,253,253,253,129,255

end 29000

	;debug;;;;;;;;;;;
halt
ld hl,16415
ld (hl),10101010b
ld a,29
ld (FONT_X),a
ld a,0
ld (FONT_Y),a
ld a,6
ld (FONT_ATTRIB),a
LD HL, numero001
CALL PrintString_8x8
halt
;;;;;;;;;;;;;;;;;
ld de,22559
ld a,22
ld (de),a
ld de,16415
ld a,h
ld (de),a
inc d
ld a,l
ld (de),a
ret


		ld a,(enemigo1)
		cp 0		;no hay enemigo1
		jp z,mov_enemigo2
		cp 1		;enemigo1 es verde
		jr nz,enemigo1_no_verde
		call random
		cp 192
		jr enemigo1_tipo_comprobado

		enemigo1_no_verde:		;comprobamos si es amarillo (tipo 2)
			ld a,(enemigo1)
			cp 2
			jr nz,enemigo1_no_amarillo
			call random
			cp 128
			jr enemigo1_tipo_comprobado

		enemigo1_no_amarillo:		;comprobamos si es magenta (tipo 3)
			ld a,(enemigo1)
			cp 3
			;jr nz,enemigo_no_magenta
			jr nz,enemigo1_comprueba_ciclos
			call random
			cp 64
			jr enemigo1_tipo_comprobado

		;enemigo1_no_magenta:		:el enemigo entonces es rojo (tipo 4)
			

		enemigo1_tipo_comprobado:
			jp c,enemigo1_random	;menos del 75%
		enemigo1_comprueba_ciclos:

			ld a,(ciclos_enemigos)	;mas o igual de 75%
			and 00000011b		;me quedo con los ciclos del enemigo1
			cp 3
			jp nz,mov_enemigo2
		
