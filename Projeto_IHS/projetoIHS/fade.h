#ifndef FADE_H_INCLUDED
#define FADE_H_INCLUDED

bool executeFade(ALLEGRO_DISPLAY *display, ALLEGRO_BITMAP *bitmap);
void fadeout(ALLEGRO_DISPLAY *display, ALLEGRO_BITMAP *buffer, int speed);
void fadein(ALLEGRO_BITMAP *buffer, int speed);

#endif // FADE_H_INCLUDED
