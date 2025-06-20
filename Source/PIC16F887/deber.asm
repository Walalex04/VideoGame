
_main:

;deber.c,25 :: 		void main() {
;deber.c,27 :: 		PORTB = 0x00; //set inital state
	CLRF       PORTB+0
;deber.c,29 :: 		TRISB = 0x00; //as output
	CLRF       TRISB+0
;deber.c,33 :: 		TRISC3_bit = 1;
	BSF        TRISC3_bit+0, BitPos(TRISC3_bit+0)
;deber.c,34 :: 		TRISA4_bit = 1;
	BSF        TRISA4_bit+0, BitPos(TRISA4_bit+0)
;deber.c,37 :: 		SSPADD = 0xA0;  // Dirección del esclavo
	MOVLW      160
	MOVWF      SSPADD+0
;deber.c,38 :: 		SSPSTAT = 0x80; // Slew rate off (para 100 kHz)
	MOVLW      128
	MOVWF      SSPSTAT+0
;deber.c,39 :: 		SSPCON = 0x36;  // Modo esclavo 7-bit + habilita SSP + CKP
	MOVLW      54
	MOVWF      SSPCON+0
;deber.c,40 :: 		SSPCON2 = 0x01; // Habilita esclavo
	MOVLW      1
	MOVWF      SSPCON2+0
;deber.c,41 :: 		while(1){
L_main0:
;deber.c,62 :: 		if(PIR1 & 0x08){
	BTFSS      PIR1+0, 3
	GOTO       L_main2
;deber.c,64 :: 		dummy = SSPBUF; // Leer para limpiar
	MOVF       SSPBUF+0, 0
	MOVWF      main_dummy_L2+0
;deber.c,65 :: 		while (!(SSPSTAT & 0x01)); // Esperar a que BF = 1
L_main3:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_main4
	GOTO       L_main3
L_main4:
;deber.c,67 :: 		if ((SSPSTAT & 0x24) == 0x00) { // D_nA = 0, R_nW = 0
	MOVLW      36
	ANDWF      SSPSTAT+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main5
;deber.c,68 :: 		unsigned char dato = SSPBUF; // Maestro escribe
	MOVF       SSPBUF+0, 0
	MOVWF      main_dato_L3+0
;deber.c,69 :: 		music(dato);
	MOVF       main_dato_L3+0, 0
	MOVWF      FARG_music_note+0
	CALL       _music+0
;deber.c,70 :: 		}
L_main5:
;deber.c,72 :: 		PIR1 &= ~0x08; // Limpiar SSPIF
	BCF        PIR1+0, 3
;deber.c,73 :: 		}
L_main2:
;deber.c,74 :: 		}
	GOTO       L_main0
;deber.c,75 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_music:

;deber.c,78 :: 		void music(char note){
;deber.c,80 :: 		switch(note){
	GOTO       L_music6
;deber.c,81 :: 		case 0x01:
L_music8:
;deber.c,82 :: 		for(i = 0; i <= 100; i++){
	CLRF       R1+0
	CLRF       R1+1
L_music9:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__music99
	MOVF       R1+0, 0
	SUBLW      100
L__music99:
	BTFSS      STATUS+0, 0
	GOTO       L_music10
;deber.c,83 :: 		PORTB = 0x01;
	MOVLW      1
	MOVWF      PORTB+0
;deber.c,84 :: 		C4;
	MOVLW      10
	MOVWF      R12+0
	MOVLW      242
	MOVWF      R13+0
L_music12:
	DECFSZ     R13+0, 1
	GOTO       L_music12
	DECFSZ     R12+0, 1
	GOTO       L_music12
	NOP
;deber.c,85 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;deber.c,86 :: 		C4;
	MOVLW      10
	MOVWF      R12+0
	MOVLW      242
	MOVWF      R13+0
L_music13:
	DECFSZ     R13+0, 1
	GOTO       L_music13
	DECFSZ     R12+0, 1
	GOTO       L_music13
	NOP
;deber.c,82 :: 		for(i = 0; i <= 100; i++){
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;deber.c,87 :: 		}
	GOTO       L_music9
L_music10:
;deber.c,88 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_music14:
	DECFSZ     R13+0, 1
	GOTO       L_music14
	DECFSZ     R12+0, 1
	GOTO       L_music14
	NOP
;deber.c,89 :: 		for(i = 0; i <= 100; i++){
	CLRF       R1+0
	CLRF       R1+1
L_music15:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__music100
	MOVF       R1+0, 0
	SUBLW      100
L__music100:
	BTFSS      STATUS+0, 0
	GOTO       L_music16
;deber.c,90 :: 		PORTB = 0x01;
	MOVLW      1
	MOVWF      PORTB+0
;deber.c,91 :: 		D4;
	MOVLW      9
	MOVWF      R12+0
	MOVLW      212
	MOVWF      R13+0
L_music18:
	DECFSZ     R13+0, 1
	GOTO       L_music18
	DECFSZ     R12+0, 1
	GOTO       L_music18
	NOP
;deber.c,92 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;deber.c,93 :: 		D4;
	MOVLW      9
	MOVWF      R12+0
	MOVLW      212
	MOVWF      R13+0
L_music19:
	DECFSZ     R13+0, 1
	GOTO       L_music19
	DECFSZ     R12+0, 1
	GOTO       L_music19
	NOP
;deber.c,89 :: 		for(i = 0; i <= 100; i++){
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;deber.c,94 :: 		}
	GOTO       L_music15
L_music16:
;deber.c,95 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_music20:
	DECFSZ     R13+0, 1
	GOTO       L_music20
	DECFSZ     R12+0, 1
	GOTO       L_music20
	NOP
;deber.c,96 :: 		for(i = 0; i <= 100; i++){
	CLRF       R1+0
	CLRF       R1+1
L_music21:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__music101
	MOVF       R1+0, 0
	SUBLW      100
L__music101:
	BTFSS      STATUS+0, 0
	GOTO       L_music22
;deber.c,97 :: 		PORTB = 0x01;
	MOVLW      1
	MOVWF      PORTB+0
;deber.c,98 :: 		G4;
	MOVLW      7
	MOVWF      R12+0
	MOVLW      159
	MOVWF      R13+0
L_music24:
	DECFSZ     R13+0, 1
	GOTO       L_music24
	DECFSZ     R12+0, 1
	GOTO       L_music24
;deber.c,99 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;deber.c,100 :: 		G4;
	MOVLW      7
	MOVWF      R12+0
	MOVLW      159
	MOVWF      R13+0
L_music25:
	DECFSZ     R13+0, 1
	GOTO       L_music25
	DECFSZ     R12+0, 1
	GOTO       L_music25
;deber.c,96 :: 		for(i = 0; i <= 100; i++){
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;deber.c,101 :: 		}
	GOTO       L_music21
L_music22:
;deber.c,103 :: 		break;
	GOTO       L_music7
;deber.c,104 :: 		case 0x02:
L_music26:
;deber.c,105 :: 		for(i = 0; i <= 50; i++){
	CLRF       R1+0
	CLRF       R1+1
L_music27:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__music102
	MOVF       R1+0, 0
	SUBLW      50
L__music102:
	BTFSS      STATUS+0, 0
	GOTO       L_music28
;deber.c,106 :: 		PORTB = 0x01;
	MOVLW      1
	MOVWF      PORTB+0
;deber.c,107 :: 		F4;
	MOVLW      8
	MOVWF      R12+0
	MOVLW      111
	MOVWF      R13+0
L_music30:
	DECFSZ     R13+0, 1
	GOTO       L_music30
	DECFSZ     R12+0, 1
	GOTO       L_music30
	NOP
	NOP
;deber.c,108 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;deber.c,109 :: 		F4;
	MOVLW      8
	MOVWF      R12+0
	MOVLW      111
	MOVWF      R13+0
L_music31:
	DECFSZ     R13+0, 1
	GOTO       L_music31
	DECFSZ     R12+0, 1
	GOTO       L_music31
	NOP
	NOP
;deber.c,105 :: 		for(i = 0; i <= 50; i++){
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;deber.c,110 :: 		}
	GOTO       L_music27
L_music28:
;deber.c,111 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_music32:
	DECFSZ     R13+0, 1
	GOTO       L_music32
	DECFSZ     R12+0, 1
	GOTO       L_music32
	DECFSZ     R11+0, 1
	GOTO       L_music32
	NOP
;deber.c,112 :: 		for(i = 0; i <= 100; i++){
	CLRF       R1+0
	CLRF       R1+1
L_music33:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__music103
	MOVF       R1+0, 0
	SUBLW      100
L__music103:
	BTFSS      STATUS+0, 0
	GOTO       L_music34
;deber.c,113 :: 		PORTB = 0x01;
	MOVLW      1
	MOVWF      PORTB+0
;deber.c,114 :: 		G4;
	MOVLW      7
	MOVWF      R12+0
	MOVLW      159
	MOVWF      R13+0
L_music36:
	DECFSZ     R13+0, 1
	GOTO       L_music36
	DECFSZ     R12+0, 1
	GOTO       L_music36
;deber.c,115 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;deber.c,116 :: 		G4;
	MOVLW      7
	MOVWF      R12+0
	MOVLW      159
	MOVWF      R13+0
L_music37:
	DECFSZ     R13+0, 1
	GOTO       L_music37
	DECFSZ     R12+0, 1
	GOTO       L_music37
;deber.c,112 :: 		for(i = 0; i <= 100; i++){
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;deber.c,117 :: 		}
	GOTO       L_music33
L_music34:
;deber.c,118 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_music38:
	DECFSZ     R13+0, 1
	GOTO       L_music38
	DECFSZ     R12+0, 1
	GOTO       L_music38
	DECFSZ     R11+0, 1
	GOTO       L_music38
	NOP
;deber.c,120 :: 		break;
	GOTO       L_music7
;deber.c,121 :: 		case 0x03:
L_music39:
;deber.c,122 :: 		for(i = 0; i <= 50; i++){
	CLRF       R1+0
	CLRF       R1+1
L_music40:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__music104
	MOVF       R1+0, 0
	SUBLW      50
L__music104:
	BTFSS      STATUS+0, 0
	GOTO       L_music41
;deber.c,123 :: 		PORTB = 0x01;
	MOVLW      1
	MOVWF      PORTB+0
;deber.c,124 :: 		F4;
	MOVLW      8
	MOVWF      R12+0
	MOVLW      111
	MOVWF      R13+0
L_music43:
	DECFSZ     R13+0, 1
	GOTO       L_music43
	DECFSZ     R12+0, 1
	GOTO       L_music43
	NOP
	NOP
;deber.c,125 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;deber.c,126 :: 		F4;
	MOVLW      8
	MOVWF      R12+0
	MOVLW      111
	MOVWF      R13+0
L_music44:
	DECFSZ     R13+0, 1
	GOTO       L_music44
	DECFSZ     R12+0, 1
	GOTO       L_music44
	NOP
	NOP
;deber.c,122 :: 		for(i = 0; i <= 50; i++){
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;deber.c,127 :: 		}
	GOTO       L_music40
L_music41:
;deber.c,128 :: 		Delay_ms(60);
	MOVLW      156
	MOVWF      R12+0
	MOVLW      215
	MOVWF      R13+0
L_music45:
	DECFSZ     R13+0, 1
	GOTO       L_music45
	DECFSZ     R12+0, 1
	GOTO       L_music45
;deber.c,129 :: 		for(i = 0; i <= 100; i++){
	CLRF       R1+0
	CLRF       R1+1
L_music46:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__music105
	MOVF       R1+0, 0
	SUBLW      100
L__music105:
	BTFSS      STATUS+0, 0
	GOTO       L_music47
;deber.c,130 :: 		PORTB = 0x01;
	MOVLW      1
	MOVWF      PORTB+0
;deber.c,131 :: 		G4;
	MOVLW      7
	MOVWF      R12+0
	MOVLW      159
	MOVWF      R13+0
L_music49:
	DECFSZ     R13+0, 1
	GOTO       L_music49
	DECFSZ     R12+0, 1
	GOTO       L_music49
;deber.c,132 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;deber.c,133 :: 		G4;
	MOVLW      7
	MOVWF      R12+0
	MOVLW      159
	MOVWF      R13+0
L_music50:
	DECFSZ     R13+0, 1
	GOTO       L_music50
	DECFSZ     R12+0, 1
	GOTO       L_music50
;deber.c,129 :: 		for(i = 0; i <= 100; i++){
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;deber.c,134 :: 		}
	GOTO       L_music46
L_music47:
;deber.c,135 :: 		Delay_ms(60);
	MOVLW      156
	MOVWF      R12+0
	MOVLW      215
	MOVWF      R13+0
L_music51:
	DECFSZ     R13+0, 1
	GOTO       L_music51
	DECFSZ     R12+0, 1
	GOTO       L_music51
;deber.c,137 :: 		break;
	GOTO       L_music7
;deber.c,138 :: 		case 0x04:
L_music52:
;deber.c,139 :: 		for(i = 0; i <= 50; i++){
	CLRF       R1+0
	CLRF       R1+1
L_music53:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__music106
	MOVF       R1+0, 0
	SUBLW      50
L__music106:
	BTFSS      STATUS+0, 0
	GOTO       L_music54
;deber.c,140 :: 		PORTB = 0x01;
	MOVLW      1
	MOVWF      PORTB+0
;deber.c,141 :: 		F4;
	MOVLW      8
	MOVWF      R12+0
	MOVLW      111
	MOVWF      R13+0
L_music56:
	DECFSZ     R13+0, 1
	GOTO       L_music56
	DECFSZ     R12+0, 1
	GOTO       L_music56
	NOP
	NOP
;deber.c,142 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;deber.c,143 :: 		F4;
	MOVLW      8
	MOVWF      R12+0
	MOVLW      111
	MOVWF      R13+0
L_music57:
	DECFSZ     R13+0, 1
	GOTO       L_music57
	DECFSZ     R12+0, 1
	GOTO       L_music57
	NOP
	NOP
;deber.c,139 :: 		for(i = 0; i <= 50; i++){
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;deber.c,144 :: 		}
	GOTO       L_music53
L_music54:
;deber.c,145 :: 		Delay_ms(20);
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_music58:
	DECFSZ     R13+0, 1
	GOTO       L_music58
	DECFSZ     R12+0, 1
	GOTO       L_music58
	NOP
	NOP
;deber.c,146 :: 		for(i = 0; i <= 100; i++){
	CLRF       R1+0
	CLRF       R1+1
L_music59:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__music107
	MOVF       R1+0, 0
	SUBLW      100
L__music107:
	BTFSS      STATUS+0, 0
	GOTO       L_music60
;deber.c,147 :: 		PORTB = 0x01;
	MOVLW      1
	MOVWF      PORTB+0
;deber.c,148 :: 		G4;
	MOVLW      7
	MOVWF      R12+0
	MOVLW      159
	MOVWF      R13+0
L_music62:
	DECFSZ     R13+0, 1
	GOTO       L_music62
	DECFSZ     R12+0, 1
	GOTO       L_music62
;deber.c,149 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;deber.c,150 :: 		G4;
	MOVLW      7
	MOVWF      R12+0
	MOVLW      159
	MOVWF      R13+0
L_music63:
	DECFSZ     R13+0, 1
	GOTO       L_music63
	DECFSZ     R12+0, 1
	GOTO       L_music63
;deber.c,146 :: 		for(i = 0; i <= 100; i++){
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;deber.c,151 :: 		}
	GOTO       L_music59
L_music60:
;deber.c,152 :: 		Delay_ms(20);
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_music64:
	DECFSZ     R13+0, 1
	GOTO       L_music64
	DECFSZ     R12+0, 1
	GOTO       L_music64
	NOP
	NOP
;deber.c,153 :: 		case 0x05:
L_music65:
;deber.c,154 :: 		for(i = 0; i <= 25; i++){
	CLRF       R1+0
	CLRF       R1+1
L_music66:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__music108
	MOVF       R1+0, 0
	SUBLW      25
L__music108:
	BTFSS      STATUS+0, 0
	GOTO       L_music67
;deber.c,155 :: 		PORTB = 0x01;
	MOVLW      1
	MOVWF      PORTB+0
;deber.c,156 :: 		C4;
	MOVLW      10
	MOVWF      R12+0
	MOVLW      242
	MOVWF      R13+0
L_music69:
	DECFSZ     R13+0, 1
	GOTO       L_music69
	DECFSZ     R12+0, 1
	GOTO       L_music69
	NOP
;deber.c,157 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;deber.c,158 :: 		C4;
	MOVLW      10
	MOVWF      R12+0
	MOVLW      242
	MOVWF      R13+0
L_music70:
	DECFSZ     R13+0, 1
	GOTO       L_music70
	DECFSZ     R12+0, 1
	GOTO       L_music70
	NOP
;deber.c,154 :: 		for(i = 0; i <= 25; i++){
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;deber.c,159 :: 		}
	GOTO       L_music66
L_music67:
;deber.c,160 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_music71:
	DECFSZ     R13+0, 1
	GOTO       L_music71
	DECFSZ     R12+0, 1
	GOTO       L_music71
	NOP
;deber.c,161 :: 		for(i = 0; i <= 25; i++){
	CLRF       R1+0
	CLRF       R1+1
L_music72:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__music109
	MOVF       R1+0, 0
	SUBLW      25
L__music109:
	BTFSS      STATUS+0, 0
	GOTO       L_music73
;deber.c,162 :: 		PORTB = 0x01;
	MOVLW      1
	MOVWF      PORTB+0
;deber.c,163 :: 		G4;
	MOVLW      7
	MOVWF      R12+0
	MOVLW      159
	MOVWF      R13+0
L_music75:
	DECFSZ     R13+0, 1
	GOTO       L_music75
	DECFSZ     R12+0, 1
	GOTO       L_music75
;deber.c,164 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;deber.c,165 :: 		G4;
	MOVLW      7
	MOVWF      R12+0
	MOVLW      159
	MOVWF      R13+0
L_music76:
	DECFSZ     R13+0, 1
	GOTO       L_music76
	DECFSZ     R12+0, 1
	GOTO       L_music76
;deber.c,161 :: 		for(i = 0; i <= 25; i++){
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;deber.c,166 :: 		}
	GOTO       L_music72
L_music73:
;deber.c,167 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_music77:
	DECFSZ     R13+0, 1
	GOTO       L_music77
	DECFSZ     R12+0, 1
	GOTO       L_music77
	NOP
;deber.c,169 :: 		break;
	GOTO       L_music7
;deber.c,171 :: 		case 0x06:
L_music78:
;deber.c,172 :: 		for(i = 0; i <= 25; i++){
	CLRF       R1+0
	CLRF       R1+1
L_music79:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__music110
	MOVF       R1+0, 0
	SUBLW      25
L__music110:
	BTFSS      STATUS+0, 0
	GOTO       L_music80
;deber.c,173 :: 		PORTB = 0x01;
	MOVLW      1
	MOVWF      PORTB+0
;deber.c,174 :: 		G4;
	MOVLW      7
	MOVWF      R12+0
	MOVLW      159
	MOVWF      R13+0
L_music82:
	DECFSZ     R13+0, 1
	GOTO       L_music82
	DECFSZ     R12+0, 1
	GOTO       L_music82
;deber.c,175 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;deber.c,176 :: 		G4;
	MOVLW      7
	MOVWF      R12+0
	MOVLW      159
	MOVWF      R13+0
L_music83:
	DECFSZ     R13+0, 1
	GOTO       L_music83
	DECFSZ     R12+0, 1
	GOTO       L_music83
;deber.c,172 :: 		for(i = 0; i <= 25; i++){
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;deber.c,177 :: 		}
	GOTO       L_music79
L_music80:
;deber.c,178 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_music84:
	DECFSZ     R13+0, 1
	GOTO       L_music84
	DECFSZ     R12+0, 1
	GOTO       L_music84
	NOP
;deber.c,179 :: 		for(i = 0; i <= 75; i++){
	CLRF       R1+0
	CLRF       R1+1
L_music85:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__music111
	MOVF       R1+0, 0
	SUBLW      75
L__music111:
	BTFSS      STATUS+0, 0
	GOTO       L_music86
;deber.c,180 :: 		PORTB = 0x01;
	MOVLW      1
	MOVWF      PORTB+0
;deber.c,181 :: 		E4;
	MOVLW      8
	MOVWF      R12+0
	MOVLW      227
	MOVWF      R13+0
L_music88:
	DECFSZ     R13+0, 1
	GOTO       L_music88
	DECFSZ     R12+0, 1
	GOTO       L_music88
	NOP
	NOP
;deber.c,182 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;deber.c,183 :: 		E4;
	MOVLW      8
	MOVWF      R12+0
	MOVLW      227
	MOVWF      R13+0
L_music89:
	DECFSZ     R13+0, 1
	GOTO       L_music89
	DECFSZ     R12+0, 1
	GOTO       L_music89
	NOP
	NOP
;deber.c,179 :: 		for(i = 0; i <= 75; i++){
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;deber.c,184 :: 		}
	GOTO       L_music85
L_music86:
;deber.c,185 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_music90:
	DECFSZ     R13+0, 1
	GOTO       L_music90
	DECFSZ     R12+0, 1
	GOTO       L_music90
	NOP
;deber.c,186 :: 		for(i = 0; i <= 150; i++){
	CLRF       R1+0
	CLRF       R1+1
L_music91:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__music112
	MOVF       R1+0, 0
	SUBLW      150
L__music112:
	BTFSS      STATUS+0, 0
	GOTO       L_music92
;deber.c,187 :: 		PORTB = 0x01;
	MOVLW      1
	MOVWF      PORTB+0
;deber.c,188 :: 		F4;
	MOVLW      8
	MOVWF      R12+0
	MOVLW      111
	MOVWF      R13+0
L_music94:
	DECFSZ     R13+0, 1
	GOTO       L_music94
	DECFSZ     R12+0, 1
	GOTO       L_music94
	NOP
	NOP
;deber.c,189 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;deber.c,190 :: 		F4;
	MOVLW      8
	MOVWF      R12+0
	MOVLW      111
	MOVWF      R13+0
L_music95:
	DECFSZ     R13+0, 1
	GOTO       L_music95
	DECFSZ     R12+0, 1
	GOTO       L_music95
	NOP
	NOP
;deber.c,186 :: 		for(i = 0; i <= 150; i++){
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;deber.c,191 :: 		}
	GOTO       L_music91
L_music92:
;deber.c,192 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_music96:
	DECFSZ     R13+0, 1
	GOTO       L_music96
	DECFSZ     R12+0, 1
	GOTO       L_music96
	NOP
;deber.c,194 :: 		break;
	GOTO       L_music7
;deber.c,195 :: 		}
L_music6:
	MOVF       FARG_music_note+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_music8
	MOVF       FARG_music_note+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_music26
	MOVF       FARG_music_note+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_music39
	MOVF       FARG_music_note+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_music52
	MOVF       FARG_music_note+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_music65
	MOVF       FARG_music_note+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_music78
L_music7:
;deber.c,196 :: 		}
L_end_music:
	RETURN
; end of _music
