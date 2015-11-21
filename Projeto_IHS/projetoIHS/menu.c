#include <allegro5/allegro5.h>
#include <allegro5/allegro_font.h>
#include <allegro5/allegro_ttf.h>
#include <stdio.h>
#include <stdlib.h>

#include "fade.h"
#include "util.h"

bool menuDone;
ALLEGRO_EVENT_QUEUE* eventMenuQueue;
ALLEGRO_TIMER* timer;

ALLEGRO_BITMAP *background = NULL;
ALLEGRO_FONT *font = NULL;

void initMenu(void)
{
    timer = al_create_timer(1.0 / 60);
    if (!timer)
        abort_game("Failed to create timer");

    background = al_load_bitmap("background.jpg");
    if (!background)
    {
        abort_game("Failed to load background");
    }

    eventMenuQueue = al_create_event_queue();
    if (!eventMenuQueue)
        abort_game("Failed to create event queue");

    font = al_load_ttf_font("font.ttf", 48, 0);
    if (!font)
        abort_game("failed to load font");

    al_register_event_source(eventMenuQueue, al_get_keyboard_event_source());
    al_register_event_source(eventMenuQueue, al_get_timer_event_source(timer));

    menuDone = false;
}

void shutdownMenu(void)
{
    if (timer)
        al_destroy_timer(timer);

    if (background)
        al_destroy_bitmap(background);

    if (eventMenuQueue)
        al_destroy_event_queue(eventMenuQueue);

    if (font)
        al_destroy_font(font);
}

void menuLoop(ALLEGRO_DISPLAY* display)
{
    bool redraw = true;
    al_start_timer(timer);

    while (!menuDone) {
        ALLEGRO_EVENT event;
        al_wait_for_event(eventMenuQueue, &event);

         if (event.type == ALLEGRO_EVENT_TIMER) {
            redraw = true;
            //update_logic();
        }
        else if (event.type == ALLEGRO_EVENT_KEY_DOWN) {
            if (event.keyboard.keycode == ALLEGRO_KEY_ESCAPE) {
                menuDone = true;
            }
            if (event.keyboard.keycode == ALLEGRO_KEY_SPACE) {
                executeFade(display);
                al_flush_event_queue(eventMenuQueue);
            }
            //get_user_input();
        }

        if (redraw && al_is_event_queue_empty(eventMenuQueue)) {
            redraw = false;
            al_clear_to_color(al_map_rgb(0, 0, 0));
            al_draw_tinted_bitmap(background, al_map_rgba(255, 255, 255, 255), 0, 0, 0);
            al_draw_text(font, al_map_rgb(0, 0, 0), 0, 0, 0, "BREGA HERO");
            //update_graphics();
            al_flip_display();
        }
    }
}

void executeMenu(ALLEGRO_DISPLAY* display)
{
    initMenu();
    menuLoop(display);
    shutdownMenu();
}
