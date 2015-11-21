#include <allegro5/allegro.h>
#include <allegro5/allegro_image.h>

#include <stdio.h>
#include <stdbool.h>

#include "constants.h"

int executeFade(ALLEGRO_DISPLAY *display)
{
    ALLEGRO_BITMAP *buffer = NULL;
    buffer = al_create_bitmap(SCREEN_WIDHT, SCREEN_HEIGHT);

    fadeout(display, buffer, 3);
    fadein(buffer, 3);

    al_destroy_bitmap(buffer);
    return 0;
}

void fadeout(ALLEGRO_DISPLAY *display, ALLEGRO_BITMAP *buffer, int speed)
{
    al_set_target_bitmap(buffer);
    al_draw_bitmap(al_get_backbuffer(display), 0, 0, 0);
    al_set_target_bitmap(al_get_backbuffer(display));

    if (speed <= 0)
    {
        speed = 1;
    }
    else if (speed > 15)
    {
        speed = 15;
    }

    int alfa;
    for (alfa = 0; alfa <= 255; alfa += speed)
    {
        al_clear_to_color(al_map_rgba(0, 0, 0, 0));
        al_draw_tinted_bitmap(buffer, al_map_rgba(255 - alfa, 255 - alfa, 255 - alfa, alfa), 0, 0, 0);
        al_flip_display();
        al_rest(0.005); // Não é necessário caso haja controle de FPS
    }
}

void fadein(ALLEGRO_BITMAP *buffer, int speed)
{
    if (speed < 0)
    {
        speed = 1;
    }
    else if (speed > 15)
    {
        speed = 15;
    }

    int alfa;
    for (alfa = 0; alfa <= 255; alfa += speed)
    {
        al_clear_to_color(al_map_rgb(0, 0, 0));
        al_draw_tinted_bitmap(buffer, al_map_rgba(alfa, alfa, alfa, alfa), 0, 0, 0);
        al_flip_display();
        al_rest(0.005); // Não é necessário caso haja controle de FPS
    }
}
