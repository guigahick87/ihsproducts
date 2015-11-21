#include <allegro5/allegro5.h>
#include <stdio.h>
#include <stdlib.h>

void abort_game(const char* message)
{
    printf("%s \n", message);
    exit(1);
}
