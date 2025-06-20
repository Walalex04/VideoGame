#line 1 "C:/Users/wal26/OneDrive/Documentos/Universidad/sistemas-embebidos/taller_en_grupo/Source/PIC16F887/deber.c"
#line 23 "C:/Users/wal26/OneDrive/Documentos/Universidad/sistemas-embebidos/taller_en_grupo/Source/PIC16F887/deber.c"
void music(char note);

void main() {

 PORTB = 0x00;

 TRISB = 0x00;



 TRISC3_bit = 1;
 TRISA4_bit = 1;


 SSPADD = 0xA0;
 SSPSTAT = 0x80;
 SSPCON = 0x36;
 SSPCON2 = 0x01;
 while(1){
#line 62 "C:/Users/wal26/OneDrive/Documentos/Universidad/sistemas-embebidos/taller_en_grupo/Source/PIC16F887/deber.c"
 if(PIR1 & 0x08){
 volatile unsigned char dummy;
 dummy = SSPBUF;
 while (!(SSPSTAT & 0x01));

 if ((SSPSTAT & 0x24) == 0x00) {
 unsigned char dato = SSPBUF;
 music(dato);
 }

 PIR1 &= ~0x08;
 }
 }
}


void music(char note){
 int i;
 switch(note){
 case 0x01:
 for(i = 0; i <= 100; i++){
 PORTB = 0x01;
  Delay_us(3831) ;
 PORTB = 0x00;
  Delay_us(3831) ;
 }
 Delay_ms(10);
 for(i = 0; i <= 100; i++){
 PORTB = 0x01;
  Delay_us(3401) ;
 PORTB = 0x00;
  Delay_us(3401) ;
 }
 Delay_ms(10);
 for(i = 0; i <= 100; i++){
 PORTB = 0x01;
  Delay_us(2551) ;
 PORTB = 0x00;
  Delay_us(2551) ;
 }

 break;
 case 0x02:
 for(i = 0; i <= 50; i++){
 PORTB = 0x01;
  Delay_us(2865) ;
 PORTB = 0x00;
  Delay_us(2865) ;
 }
 Delay_ms(100);
 for(i = 0; i <= 100; i++){
 PORTB = 0x01;
  Delay_us(2551) ;
 PORTB = 0x00;
  Delay_us(2551) ;
 }
 Delay_ms(100);

 break;
 case 0x03:
 for(i = 0; i <= 50; i++){
 PORTB = 0x01;
  Delay_us(2865) ;
 PORTB = 0x00;
  Delay_us(2865) ;
 }
 Delay_ms(60);
 for(i = 0; i <= 100; i++){
 PORTB = 0x01;
  Delay_us(2551) ;
 PORTB = 0x00;
  Delay_us(2551) ;
 }
 Delay_ms(60);

 break;
 case 0x04:
 for(i = 0; i <= 50; i++){
 PORTB = 0x01;
  Delay_us(2865) ;
 PORTB = 0x00;
  Delay_us(2865) ;
 }
 Delay_ms(20);
 for(i = 0; i <= 100; i++){
 PORTB = 0x01;
  Delay_us(2551) ;
 PORTB = 0x00;
  Delay_us(2551) ;
 }
 Delay_ms(20);
 case 0x05:
 for(i = 0; i <= 25; i++){
 PORTB = 0x01;
  Delay_us(3831) ;
 PORTB = 0x00;
  Delay_us(3831) ;
 }
 Delay_ms(10);
 for(i = 0; i <= 25; i++){
 PORTB = 0x01;
  Delay_us(2551) ;
 PORTB = 0x00;
  Delay_us(2551) ;
 }
 Delay_ms(10);

 break;

 case 0x06:
 for(i = 0; i <= 25; i++){
 PORTB = 0x01;
  Delay_us(2551) ;
 PORTB = 0x00;
  Delay_us(2551) ;
 }
 Delay_ms(10);
 for(i = 0; i <= 75; i++){
 PORTB = 0x01;
  Delay_us(3039) ;
 PORTB = 0x00;
  Delay_us(3039) ;
 }
 Delay_ms(10);
 for(i = 0; i <= 150; i++){
 PORTB = 0x01;
  Delay_us(2865) ;
 PORTB = 0x00;
  Delay_us(2865) ;
 }
 Delay_ms(10);

 break;
 }
}
