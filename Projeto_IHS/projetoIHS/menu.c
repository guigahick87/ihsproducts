#include <allegro5/allegro5.h>
#include <allegro5/allegro_font.h>
#include <allegro5/allegro_ttf.h>
#include <allegro5/allegro_audio.h>
#include <allegro5/allegro_acodec.h>

#include <stdio.h>
#include <stdlib.h>

#include "fade.h"
#include "util.h"

const char MENU_BACKGROUND_PATH[] = "background.jpg";
const char GAME_BACKGROUND_PATH[] = "background2.jpg";
GameState gState;

bool menuDone;
ALLEGRO_EVENT_QUEUE* eventMenuQueue;
ALLEGRO_TIMER* timer;
ALLEGRO_DISPLAY* display;
ALLEGRO_BITMAP *background = NULL;
ALLEGRO_FONT *font = NULL;
ALLEGRO_AUDIO_STREAM *music = NULL;

void initMenu(void)
{
    timer = al_create_timer(1.0 / 60);
    if (!timer)
        abort_game("Failed to create timer");

    background = al_load_bitmap(MENU_BACKGROUND_PATH);
    if (!background)
        abort_game("Failed to load background");

    eventMenuQueue = al_create_event_queue();
    if (!eventMenuQueue)
        abort_game("Failed to create event queue");

    font = al_load_ttf_font("font.ttf", 48, 0);
    if (!font)
        abort_game("failed to load font");

    music = al_load_audio_stream("musica.ogg", 4, 1024);
    if (!music)
        abort_game("failed to load audio");

    al_register_event_source(eventMenuQueue, al_get_keyboard_event_source());
    al_register_event_source(eventMenuQueue, al_get_timer_event_source(timer));

    menuDone = false;
    gState = Menu;
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

    if (music)
        al_destroy_audio_stream(music);
}

void menuLoop()
{
    bool redraw = true;
    al_start_timer(timer);

    al_attach_audio_stream_to_mixer(music, al_get_default_mixer());
    al_set_audio_stream_playing(music, true);
    al_set_audio_stream_playmode(music, ALLEGRO_PLAYMODE_LOOP);

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
            if (event.keyboard.keycode == ALLEGRO_KEY_DOWN) {
                changeGameState(Game);
            }
            if (event.keyboard.keycode == ALLEGRO_KEY_UP){
                changeGameState(Menu);
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

void executeMenu(ALLEGRO_DISPLAY* _display)
{
    display = _display;
    initMenu();
    menuLoop(display);
    shutdownMenu();
}

void changeGameState(GameState state)
{
    gState = state;
    al_destroy_bitmap(background);
    switch(gState)
    {
        case Game:
                background = al_load_bitmap(GAME_BACKGROUND_PATH);
            break;
        case Menu:
                background = al_load_bitmap(MENU_BACKGROUND_PATH);
            break;
    }
    executeFade(display, background);
    al_flush_event_queue(eventMenuQueue);
}
