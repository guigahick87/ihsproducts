#ifndef UTIL_H_INCLUDED
#define UTIL_H_INCLUDED

enum gameStates{
    Menu = 1,
    Game
};
typedef enum gameStates GameState;

void abort_game(const char* message);

#endif // UTIL_H_INCLUDED
