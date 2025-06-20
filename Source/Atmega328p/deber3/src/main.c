
#include <avr/io.h>
#include <util/delay.h>

#include "function.h"

#define PULSADOR_OK 0 // PUERTO C
#define PULSADOR_UP 1
#define PULSADOR_DOWN 2

/*Comunicacion I2C*/
#define SLAVE_ADDR 0x20
#define F_CPU 8000000
#define SCL_CLOCK 100000

void TWI_init();
void TWI_start();
void TWI_write_address(uint8_t address);
void TWI_write_data(uint8_t data);
void TWI_stop();

struct Levels
{
    int velocity;
    char first_section;
    char second_section;
    char third_section;
};

int main()
{
    DDRB = 0xFF; // rows
    DDRD = 0xFF; // columns

    char display[8] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

    char displayGameOver[] = {
        0x00, 0x7E, 0x50, 0x50, 0x50, 0x70, 0x00, 0x00, //P
        0x00, 0x7E, 0x52, 0x52, 0x52, 0x52, 0x00, 0x00, //E
        0x00, 0x7E, 0x58, 0x54, 0x52, 0x70, 0x00, 0x00, //R
        0x00, 0x7E, 0x7E, 0x42, 0x42, 0x42, 0x3C, 0x00, //D
        0x00, 0x42, 0x42, 0x7E, 0x7E, 0x42, 0x42, 0x00, //I
        0x00, 0x72, 0x72, 0x5A, 0x5A, 0x4E, 0x4E, 0x00, //S
        0x00, 0x40, 0x40, 0x7E, 0x7E, 0x40, 0x40, 0x00, //T
        0x00, 0x7E, 0x52, 0x52, 0x52, 0x52, 0x00, 0x00, //E
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

    char displayBienvenido[] = {
        0x00, 0x7E, 0x7E, 0x5A, 0x5A, 0x66, 0x00, 0x00, //B
        0x00, 0x42, 0x42, 0x7E, 0x7E, 0x42, 0x42, 0x00, //I
        0x00, 0x7E, 0x52, 0x52, 0x52, 0x52, 0x00, 0x00, //E
        0x00, 0x7E, 0x60, 0x30, 0x1C, 0x06, 0x7E, 0x00, //N
        0x00, 0x38, 0x04, 0x02, 0x02, 0x04, 0x38, 0x00, //V
        0x00, 0x7E, 0x52, 0x52, 0x52, 0x52, 0x00, 0x00, //E
        0x00, 0x7E, 0x60, 0x30, 0x1C, 0x06, 0x7E, 0x00, //N
        0x00, 0x42, 0x42, 0x7E, 0x7E, 0x42, 0x42, 0x00, //I
        0x00, 0x7E, 0x7E, 0x42, 0x42, 0x42, 0x3C, 0x00, //D
        0x00, 0x3C, 0x42, 0x42, 0x42, 0x42, 0x3C, 0x00, //O
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

    };

    char displayWIN[] = {
        0x00, 0x7E, 0x04, 0x08, 0x04, 0x7E, 0x00, 0x00, //W
        0x00, 0x42, 0x42, 0x7E, 0x7E, 0x42, 0x42, 0x00, //I
        0x00, 0x7E, 0x60, 0x30, 0x1C, 0x06, 0x7E, 0x00, //N
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

    };

    char displayLevel1[] = {
        0x00, 0x00, 0x22, 0x7E, 0x02, 0x00, 0x00, 0x00};

    char displayLeve2[] = {
        0x00, 0x00, 0x42, 0x46, 0x4A, 0x32, 0x00, 0x00};

    char displayLevel3[] = {
        0x00, 0x00, 0x49, 0x49, 0x49, 0x36, 0x00, 0x00};

    int index_frame = 0; // indica cuando se actualiza el display
    // dependiendo del nivel sera menor el maximo que puede alcanzar
    char index_column = 0; // El programa principal se encargara de modificar el display (se evita tiempo perdidos graficando)
    char level = 1;
    char move_height = 1;
    char dentro = 0;
    char game_over = 1;
    int pos = 0;
    int index_i2c = 2000;
    char state_game = 0; // El estado del juego en el que se encuentra

    // Se definen todos los 3 niveles

    const struct Levels LEVEL1 = {300, 5, 4, 3};
    const struct Levels LEVEL2 = {150, 5, 3, 2};
    const struct Levels LEVEL3 = {100, 4, 2, 1};

    struct Levels playing;

    TWI_init();
    while (1)
    {

        // update display
        PORTD = 1 << index_column;
        PORTB = ~(display[7 - index_column]); // empiza por la derecha (mas legible)
        index_column = index_column >= 7 ? 0 : index_column + 1;

        switch (state_game)
        {
        case 1: // Estado de juego activadp

            // Dependiendo del nivel tendra un sonido u otro
            if (game_over == 1)
            {
                if (playing.velocity == LEVEL1.velocity)
                {
                    if (index_i2c >= 500) // No se esta trabajando con interrupciones asi q es necesario para que no haya
                    // desbordamiento
                    {
                        TWI_start();
                        TWI_write_address(0xA0); // Dirección del esclavo (ejemplo: 0x50 << 1)
                        TWI_write_data(0x02);    // Enviar un byte cualquiera
                        TWI_stop();
                        index_i2c = 0;
                    }
                }
                else if (playing.velocity == LEVEL2.velocity)
                {
                    if (index_i2c >= 500) // No se esta trabajando con interrupciones asi q es necesario para que no haya
                    // desbordamiento
                    {
                        TWI_start();
                        TWI_write_address(0xA0); // Dirección del esclavo (ejemplo: 0x50 << 1)
                        TWI_write_data(0x03);    // Enviar un byte cualquiera
                        TWI_stop();
                        index_i2c = 0;
                    }
                }
                else if (playing.velocity == LEVEL3.velocity)
                {
                    if (index_i2c >= 500) // No se esta trabajando con interrupciones asi q es necesario para que no haya
                    // desbordamiento
                    {
                        TWI_start();
                        TWI_write_address(0xA0); // Dirección del esclavo (ejemplo: 0x50 << 1)
                        TWI_write_data(0x04);    // Enviar un byte cualquiera
                        TWI_stop();
                        index_i2c = 0;
                    }
                }
            }

            /**
         Control del videojuego
         */
            // Esta parte del codigo aseguro que el pulsado haya sido soltado (se puede cambiar con interrupciones)
            if (PINC & (1 << PULSADOR_OK) && dentro == 0)
            {
                game_over = add_element(display, move_height);
                index_frame = 0; // Se reestablece la pantalla
                move_height++;   // VALIDAR LUEGO
                dentro = 1;
            }
            if (!(PINC & (1 << PULSADOR_OK)))
            {
                dentro = 0;
            }

            /*
            Actualizamos el status, comprobar si perdio o no
            y se actualiza el display
            */

            if (dentro == 0 && game_over == 1 && index_frame >= playing.velocity)
            {
                pos = 0;
                if (move_height <= 2)
                {
                    move_element(display, move_height, playing.first_section);
                }
                else if (move_height >= 6)
                {
                    move_element(display, move_height, playing.third_section);
                }
                else
                {
                    move_element(display, move_height, playing.second_section);
                }

                if (move_height == 8)
                {
                    state_game = 3;
                    pos = 0;
                    index_frame = 0;
                }

                index_frame = 0;
            }
            if (dentro == 0 && game_over == -1 && index_frame >= 100)
            {
                if (index_i2c >= 400) // No se esta trabajando con interrupciones asi q es necesario para que no haya
                    // desbordamiento
                    {
                        TWI_start();
                        TWI_write_address(0xA0); // Dirección del esclavo (ejemplo: 0x50 << 1)
                        TWI_write_data(0x06);    // Enviar un byte cualquiera
                        TWI_stop();
                        index_i2c = 0;
                    }
                move_string(display, displayGameOver, sizeof(displayGameOver), &pos);
                index_frame = 0;
            }
            break;

        case 0: // Inicio de juego
            /*Enviamos la senal para musica de inicio*/

            if (index_i2c >= 500) // No se esta trabajando con interrupciones asi q es necesario para que no haya
            // desbordamiento
            {
                TWI_start();
                TWI_write_address(0xA0); // Dirección del esclavo (ejemplo: 0x50 << 1)
                TWI_write_data(0x01);    // Enviar un byte cualquiera
                TWI_stop();
                index_i2c = 0;
            }
            if (PINC & (1 << PULSADOR_OK) && dentro == 0)
            {
                index_frame = 0; // Se reestablece la pantalla
                dentro = 1;
                pos = 0;        // Se cambia solo una vez por lo que control no se ocupara
                _delay_ms(100); // Para que pueda retornar (Se puede cambiar con interrupciones)
            }

            if (dentro == 1)
            {
                if ((PINC & (1 << PULSADOR_UP)) && level <= 3)
                {
                    level++;
                    _delay_ms(100);
                }
                else if ((PINC & (1 << PULSADOR_DOWN)) && level >= 1)
                {
                    level--;
                    _delay_ms(100);
                }

                for (int i = 0; i < 8; i++)
                {
                    if (level == 1)
                    {
                        display[i] = displayLevel1[i];
                    }
                    else if (level == 2)
                    {
                        display[i] = displayLeve2[i];
                    }
                    else if (level == 3)
                    {
                        display[i] = displayLevel3[i];
                    }
                }

                if (PINC & (1 << PULSADOR_OK) && dentro == 1)
                {
                    // Se selecciona el metodo de juego
                    state_game = 1;
                    pos = 0;
                    index_frame = 0;
                    for (int i = 0; i < 8; i++)
                    {
                        display[i] = 0;
                    }

                    if (level == 1)
                    {
                        playing = LEVEL1;
                    }
                    else if (level == 2)
                    {
                        playing = LEVEL2;
                    }
                    else if (level == 3)
                    {
                        playing = LEVEL3;
                    }
                }
            }

            if (index_frame >= 200 && dentro == 0)
            {

                move_string(display, displayBienvenido, sizeof(displayBienvenido), &pos);
                index_frame = 0;
            }

            break;

        case 3:
            // Caso 3 cuando gano
            if (index_i2c >= 300) // No se esta trabajando con interrupciones asi q es necesario para que no haya
                    // desbordamiento
                    {
                        TWI_start();
                        TWI_write_address(0xA0); // Dirección del esclavo (ejemplo: 0x50 << 1)
                        TWI_write_data(0x05);    // Enviar un byte cualquiera
                        TWI_stop();
                        index_i2c = 0;
                    }
            if (index_frame >= 100)
            {
                move_string(display, displayWIN, sizeof(displayWIN), &pos);
                index_frame = 0;
                break;
            }
        }

        // cuando haya cambio de estado, reiniciar todas las variables
        _delay_us(300);
        index_frame++;
        index_i2c++;
    }
}

// Funciones para la comunicacion I2C

void TWI_init(void)
{
    // Fórmula: SCL freq = F_CPU / (16 + 2*TWBR*Prescaler)
    TWSR = 0x00;                           // Prescaler = 1
    TWBR = ((F_CPU / SCL_CLOCK) - 16) / 2; // TWBR para 100kHz con F_CPU = 16MHz
    TWCR = (1 << TWEN);                    // Habilitar TWI
}

void TWI_start(void)
{
    TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN); // Enviar condición START
    while (!(TWCR & (1 << TWINT)))
        ; // Esperar que se complete
}

void TWI_write_address(uint8_t address)
{
    TWDR = address & 0xFE; // Dirección + bit de escritura (0)
    TWCR = (1 << TWINT) | (1 << TWEN);
    while (!(TWCR & (1 << TWINT)))
        ;
}

void TWI_write_data(uint8_t data)
{
    TWDR = data;
    TWCR = (1 << TWINT) | (1 << TWEN);
    while (!(TWCR & (1 << TWINT)))
        ;
}
void TWI_stop(void)
{
    TWCR = (1 << TWINT) | (1 << TWEN) | (1 << TWSTO); // Enviar condición STOP
    _delay_us(10);                                    // Pequeña espera para garantizar que se complete
}