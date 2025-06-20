

/*S

Se definiran todos

*/

void move_element(char *matriz_visual, char heigth, char len_block);
char add_element(char *matriz_visual, char heigth);
void move_string(char *matriz_visual, char *words, uint16_t len, int *pos);
/**
 * char * matriz_visual: Puntero a la direccion de memoria del inicio del arreglo
 * char heigth: Posicion donde estara el bloque
 * len_block: la anchura del block
 */
void move_element(char *matriz_visual, char heigth, char len_block)
{

    /*
        Se supone que solo se considerara la columna heigth de la matriz
        No se considerara colisiones, por lo que se tendra que tener en cuenta eso
        fuera de la funcion

        Unicamente se modificara la matriz para que se modifique

        Se supone que en la fila establecida, unicamente tendra un bit donde ya se encontraba antes

    */
    char dim_block = 1;

    char state = 0; // 1 primera parte, 2 segunda y 3 tercera

    for (char i = 0; i <= 7; i++)
    {
        if (state == 0)
        {
            if ((i == 0) && (matriz_visual[i] & (1 << heigth)))
            {
                state = 1;
            }
            else if ((matriz_visual[i] & (1 << heigth)))
            {

                state = 2;
            }
            else
            {
                if (i == 7)
                {
                    state = 3;
                }
            }
        }

        switch (state)
        {
        case 1:
            if (!(matriz_visual[i + 1] & (1 << heigth)))
            {
                matriz_visual[i] &= ~(1 << heigth);
            }
            break;

        case 2:
            matriz_visual[i - 1] |= 1 << heigth;
            dim_block++;
            if (dim_block > len_block)
            {
                matriz_visual[i] &= ~(1 << heigth);
                state = 4; // break
            }

            break;

        case 3:
            matriz_visual[i] |= 1 << heigth;
            break;
        }
    }
}

/**
 * Esta funcion agrega el elemento cuando se haya pulsado
 * matriz: puntero de la matriz
 * height: altura
 *
 * regresa el status del juego -1 FAllo; 1 VALIDO
 */
char add_element(char *matriz_visual, char heigth)
{

    /*
    En el instante que se pulso leemos las matriz que contiene todos los elementos
    de los datos, lo cual sabremos exactamente la posicion y si fallo o no

    SE TOMARA COMO VALIDA SI ALMENOS UN PUNTO SE ENCUENTRA DISPONIBLE
    */

    char valida = -1;
    for (int i = 0; i <= 7; i++)
    {

        matriz_visual[i] |= ((matriz_visual[i] & (1 << heigth)) >> 1);
        matriz_visual[i] &= ~(1 << heigth);

        if ((matriz_visual[i] & (1 << (heigth - 1))) && (matriz_visual[i] & (1 << (heigth - 2))))
        {
            valida = 1;
        }

        if (heigth == 1)
        {
            valida = 1;
        }
    }

    return valida;
}

/**
 * Esta funcion mueve de izquiera a derecha el texto que se quiere mostrar
 * matriz_visual es el puntero del array donde se tiene los datos a mostrar
 * words es el puntero de lo que se va a mostrar
 * len es la dimension del array (el mensaje)
 * i es la direccion del anterior punto de inicio
 */
void move_string(char *matriz_visual, char *words, uint16_t len, int *pos)
{

    /*
    Se supone que al llamar la funcion ya se manejaron los tiempos, por lo que solo se actualizara la informacion
    no se considerara funcion sobre manejos de estado
    */

    for (int j = 0; j <= 7; j++)
    {

        matriz_visual[j] = words[((*pos) + j) % len];
    }
    *pos = *pos + 1;
}