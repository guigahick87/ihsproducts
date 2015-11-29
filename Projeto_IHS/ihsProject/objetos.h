#ifndef OBJETOS_H_INCLUDED
#define OBJETOS_H_INCLUDED

// -------- ARQUIVO OBJETOS --------
    enum IDS {JOGADOR, PROJETIL, INIMIGOS, ESTRELA};

    struct NaveEspacial
    {
        int ID;
        int x;
        int y;
        int vidas;
        int velocidade;
        int borda_x;
        int borda_y;
        int pontos;
    };

    struct Projeteis
    {
        int ID;
        int x;
        int y;
        int velocidade;
        bool ativo;
    };

    struct Cometas
    {
        int ID;
        int x;
        int y;
        int velocidade;
        int borda_x;
        int borda_y;
        int ativo;
    };

    struct Estrelas
    {
        int ID;
        int x;
        int y;
        int velocidade;
    };

    typedef struct Sprite {
        ALLEGRO_BITMAP *sprite;
        float x, y;
    } Sprite;
// ---------------------------------

#endif // OBJETOS_H_INCLUDED
