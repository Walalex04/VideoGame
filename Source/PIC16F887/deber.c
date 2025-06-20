
/*
#define C4 261
#define D4 294
#define E4 329
#define F4 349
#define G4 392
#define A4 440
#define B4 494
#define C5 523
  */
  

#define C4 Delay_us(3831)
#define D4 Delay_us(3401)
#define E4 Delay_us(3039)
#define F4 Delay_us(2865)
#define G4 Delay_us(2551)

#define SLAVE_ADDRESS 0x20
#define _XTAL_FREQ 8000000

void music(char note);

void main() {
     //Define the port B like output
     PORTB = 0x00; //set inital state
     //ANSEL = 0x07; //set RA<3:0> as I/O.
     TRISB = 0x00; //as output
     
     
     //Configurar I2C
     TRISC3_bit = 1;
     TRISA4_bit = 1;
     //Direccion 0x50

     SSPADD = 0xA0;  // Dirección del esclavo
     SSPSTAT = 0x80; // Slew rate off (para 100 kHz)
     SSPCON = 0x36;  // Modo esclavo 7-bit + habilita SSP + CKP
     SSPCON2 = 0x01; // Habilita esclavo
     while(1){
     /*
            // Nota Do5
        musicB(C5 * 100 / 552);  // C5
        Delay_ms(10);

        // Nota La4
        musicB(A4 * 100 / 552);  // A4
        Delay_ms(10);

        // Nota Fa4
        musicB(F4 * 100 / 552);  // F4
        Delay_ms(10);

        // Nota Mi4
        musicB(E4 * 100 / 552);  // E4
        Delay_ms(70);

        */
        
        //Detecto cuando hay un evento
        if(PIR1 & 0x08){
            volatile unsigned char dummy;
            dummy = SSPBUF; // Leer para limpiar
            while (!(SSPSTAT & 0x01)); // Esperar a que BF = 1
            
            if ((SSPSTAT & 0x24) == 0x00) { // D_nA = 0, R_nW = 0
                unsigned char dato = SSPBUF; // Maestro escribe
                   music(dato);
            }

            PIR1 &= ~0x08; // Limpiar SSPIF
        }
     }
}


void music(char note){
     int i;
     switch(note){
         case 0x01:
              for(i = 0; i <= 100; i++){
                 PORTB = 0x01;
                 C4;
                 PORTB = 0x00;
                 C4;
              }
              Delay_ms(10);
              for(i = 0; i <= 100; i++){
                 PORTB = 0x01;
                 D4;
                 PORTB = 0x00;
                 D4;
              }
              Delay_ms(10);
              for(i = 0; i <= 100; i++){
                 PORTB = 0x01;
                 G4;
                 PORTB = 0x00;
                 G4;
              }

              break;
          case 0x02:
              for(i = 0; i <= 50; i++){
                 PORTB = 0x01;
                 F4;
                 PORTB = 0x00;
                 F4;
              }
              Delay_ms(100);
              for(i = 0; i <= 100; i++){
                 PORTB = 0x01;
                 G4;
                 PORTB = 0x00;
                 G4;
              }
              Delay_ms(100);

              break;
          case 0x03:
              for(i = 0; i <= 50; i++){
                 PORTB = 0x01;
                 F4;
                 PORTB = 0x00;
                 F4;
              }
              Delay_ms(60);
              for(i = 0; i <= 100; i++){
                 PORTB = 0x01;
                 G4;
                 PORTB = 0x00;
                 G4;
              }
               Delay_ms(60);

              break;
         case 0x04:
              for(i = 0; i <= 50; i++){
                 PORTB = 0x01;
                 F4;
                 PORTB = 0x00;
                 F4;
              }
              Delay_ms(20);
              for(i = 0; i <= 100; i++){
                 PORTB = 0x01;
                 G4;
                 PORTB = 0x00;
                 G4;
              }
               Delay_ms(20);
         case 0x05:
              for(i = 0; i <= 25; i++){
                 PORTB = 0x01;
                 C4;
                 PORTB = 0x00;
                 C4;
              }
              Delay_ms(10);
              for(i = 0; i <= 25; i++){
                 PORTB = 0x01;
                 G4;
                 PORTB = 0x00;
                 G4;
              }
               Delay_ms(10);

              break;
              
          case 0x06:
              for(i = 0; i <= 25; i++){
                 PORTB = 0x01;
                 G4;
                 PORTB = 0x00;
                 G4;
              }
              Delay_ms(10);
              for(i = 0; i <= 75; i++){
                 PORTB = 0x01;
                 E4;
                 PORTB = 0x00;
                 E4;
              }
               Delay_ms(10);
               for(i = 0; i <= 150; i++){
                 PORTB = 0x01;
                 F4;
                 PORTB = 0x00;
                 F4;
              }
               Delay_ms(10);

              break;
     }
}