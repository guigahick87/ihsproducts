#include <allegro5/allegro5.h>
#include <stdio.h>
#include <stdlib.h>

#include "util.h"
#include "menu.h"

ALLEGRO_DISPLAY* display;

void init(void)
{
    if (!al_init())
        abort_game("Failed to initialize allegro");

    if (!al_init_image_addon())
        abort_game("Failed to initialize allegro_image");

    if (!al_install_audio())
        abort_game("Failed to install audio");

    if (!al_init_acodec_addon())
        abort_game("Failed to initialize audio codecs");

    if (!al_reserve_samples(1))
        abort_game("Failed to allocate audio channels");

     if (!al_init_ttf_addon())
        abort_game("Failed to initialize allegro_ttf");

    if (!al_install_keyboard())
        abort_game("Failed to install keyboard");

    al_set_new_display_flags(ALLEGRO_WINDOWED);
    display = al_create_display(640, 480);
    if (!display)
        abort_game("Failed to create display");

    al_set_window_title(display, "Brega Hero");
}

void game_loop(void)
{
    executeMenu(display);
}

int main(int argc, char* argv[])
{
    init();
    game_loop();
}
