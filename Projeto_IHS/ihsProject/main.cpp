#include <allegro5/allegro.h>
#include <allegro5/allegro_native_dialog.h>
#include <allegro5/allegro_primitives.h>
#include <allegro5/allegro_image.h>
#include <allegro5/allegro_font.h>
#include <allegro5/allegro_ttf.h>
#include <cstdlib>
#include <ctime>
#include "objetos.h"

#define MAX_SPRITES 16

// -------- VARIÁVEIS GLOBAIS --------
const int largura_t = 800;
const int altura_t = 600;
const int FPS = 30;
const int NUM_BALAS = 5;
const int NUM_COMETAS = 10;
const int NUM_ESTRELAS = 100;

Sprite spriteAnimadaEnemy[MAX_SPRITES];
int contSpritesEnemy = 0;
int currentSpriteEnemy = 0;

Sprite spriteAnimadaNave[MAX_SPRITES];
int contSpritesNave = 0;
int currentSpriteNave = 0;

enum TECLAS {CIMA, BAIXO, ESQUERDA, DIREITA, SPACE, ENTER};
// -----------------------------------

// -------- PROTÓTIPOS --------
void InitNave (NaveEspacial &nave);
void DesenhaNave (NaveEspacial &nave);
void MoveNaveCima (NaveEspacial &nave);
void MoveNaveBaixo (NaveEspacial &nave);
void MoveNaveDireita (NaveEspacial &nave);
void MoveNaveEsquerda (NaveEspacial &nave);

void InitBalas (Projeteis balas[], int tamanho);
void atiraBalas (Projeteis balas[], int tamanho, NaveEspacial nave);
void atualizaBalas (Projeteis balas[], int tamanho);
void DesenhaBalas (Projeteis balas[], int tamanho);
void BalaColidida(Projeteis balas[], int b_tamanho, Cometas cometas[], int c_tamanho, NaveEspacial &nave);

void InitCometas (Cometas cometas[], int tamanho);
void LiberaCometas (Cometas cometas[], int tamanho);
void AtualizarCometas (Cometas cometas[], int tamanho);
void DesenhaCometas (Cometas cometas[], int tamanho);
void CometaColidido (Cometas cometas[], int c_tamanho, NaveEspacial &nave);

void InitPlano_1(Estrelas estrelas_p1[], int tamanho);
void InitPlano_2(Estrelas estrelas_p2[], int tamanho);
void InitPlano_3(Estrelas estrelas_p3[], int tamanho);
void AtualizarPlano_1(Estrelas estrelas_p1[], int tamanho);
void AtualizarPlano_2(Estrelas estrelas_p2[], int tamanho);
void AtualizarPlano_3(Estrelas estrelas_p3[], int tamanho);
void DesenharPlano_1(Estrelas estrelas_p1[], int tamanho);
void DesenharPlano_2(Estrelas estrelas_p2[], int tamanho);
void DesenharPlano_3(Estrelas estrelas_p3[], int tamanho);

void add_spritesEnemy(ALLEGRO_BITMAP *parent);
void add_spritesNave(ALLEGRO_BITMAP *parent);
// ----------------------------

int main()
{
    // -------- VARIÁVEIS DO JOGO --------
        ALLEGRO_EVENT_QUEUE *fila_eventos = NULL;
        ALLEGRO_TIMER *timer = NULL;
        ALLEGRO_BITMAP *background = NULL;
        ALLEGRO_BITMAP *enemySprite = NULL;
        ALLEGRO_BITMAP *naveSprite = NULL;
        ALLEGRO_FONT *font14 = NULL;

        bool fim = false;
        bool desenha = true;
        bool game_over = false;
        bool teclas[] = {false, false, false, false, false, false};
    // -----------------------------------

    // -------- INICIALIZAÇÃO DE OBJETOS --------
        NaveEspacial nave;
        Projeteis balas[NUM_BALAS];
        Cometas cometas[NUM_COMETAS];

        Estrelas estrelas_p1[NUM_ESTRELAS];
        Estrelas estrelas_p2[NUM_ESTRELAS];
        Estrelas estrelas_p3[NUM_ESTRELAS];
    // ------------------------------------------

    // -------- INICIALIZAÇÃO DA ALLEGRO E DO DISPLAY --------
        ALLEGRO_DISPLAY *display = NULL;

        if(!al_init())
        {
            al_show_native_message_box(NULL, "AVISO!", "ERRO!", "ERRO AO INICIALIZAR A ALLEGRO!", NULL, ALLEGRO_MESSAGEBOX_ERROR);
            return -1;
        }

        display = al_create_display(largura_t, altura_t);
        if(!display)
        {
            al_show_native_message_box(NULL, "AVISO!", "ERRO!", "ERRO AO CRIAR DISPLAY!", NULL, ALLEGRO_MESSAGEBOX_ERROR);
            return -1;
        }

    // -------------------------------------------------------

    // -------- INICIALIZAÇÃO DA ADDONS E INSTALAÇOES --------
        al_init_image_addon();
        al_init_primitives_addon();
        al_install_keyboard();
        al_init_font_addon();
        al_init_ttf_addon();
    // -------------------------------------------------------

    // -------- CRIAÇÃO DA FILA E DEMAIS DISPOSITIVOS --------
        fila_eventos = al_create_event_queue();
        timer = al_create_timer(1.0 / FPS);
        background = al_load_bitmap("background.jpg");
        enemySprite = al_load_bitmap("enemy.png");
        naveSprite = al_load_bitmap("nave.png");
        font14 = al_load_font("font.ttf", 22, NULL);
    // -------------------------------------------------------

    // -------- REGISTRO DE SOURCES --------
        al_register_event_source(fila_eventos, al_get_display_event_source(display));
        al_register_event_source(fila_eventos, al_get_keyboard_event_source());
        al_register_event_source(fila_eventos, al_get_timer_event_source(timer));
    // -------------------------------------

    // -------- FUNÇÕES INICIAIS --------
        al_set_window_title(display, "ihs project");
        srand(time(NULL));

        InitNave(nave);
        InitBalas(balas, NUM_BALAS);
        InitCometas(cometas, NUM_COMETAS);

        InitPlano_1(estrelas_p1, NUM_ESTRELAS);
        InitPlano_2(estrelas_p2, NUM_ESTRELAS);
        InitPlano_3(estrelas_p3, NUM_ESTRELAS);

        add_spritesEnemy(enemySprite);
        add_spritesNave(naveSprite);
    // ----------------------------------

    // -------- LOOP PRINCIPAL --------

        al_start_timer(timer);

        while(!fim)
        {
            ALLEGRO_EVENT ev;
            al_wait_for_event(fila_eventos, &ev);

            // -------- EVENTOS E LÓGICA DO JOGO --------
                if(ev.type == ALLEGRO_EVENT_DISPLAY_CLOSE)
                {
                    fim = true;
                }
                else if(ev.type == ALLEGRO_EVENT_KEY_DOWN)
                {
                    switch(ev.keyboard.keycode)
                    {
                        case ALLEGRO_KEY_ESCAPE:
                            fim = true;
                            break;
                        case ALLEGRO_KEY_UP:
                            teclas[CIMA] = true;
                            break;
                        case ALLEGRO_KEY_DOWN:
                            teclas[BAIXO] = true;
                            break;
                        case ALLEGRO_KEY_RIGHT:
                            teclas[DIREITA] = true;
                            break;
                        case ALLEGRO_KEY_LEFT:
                            teclas[ESQUERDA] = true;
                            break;
                        case ALLEGRO_KEY_SPACE:
                            teclas[SPACE] = true;
                            atiraBalas(balas, NUM_BALAS, nave);
                            break;
                        case ALLEGRO_KEY_ENTER:
                            teclas[ENTER] = true;
                            break;
                    }
                }
                else if(ev.type == ALLEGRO_EVENT_KEY_UP)
                {
                    switch(ev.keyboard.keycode)
                        {
                            case ALLEGRO_KEY_UP:
                                teclas[CIMA] = false;
                                break;
                            case ALLEGRO_KEY_DOWN:
                                teclas[BAIXO] = false;
                                break;
                            case ALLEGRO_KEY_RIGHT:
                                teclas[DIREITA] = false;
                                break;
                            case ALLEGRO_KEY_LEFT:
                                teclas[ESQUERDA] = false;
                                break;
                            case ALLEGRO_KEY_ENTER:
                                teclas[ENTER] = false;
                        }
                }
                else if(ev.type == ALLEGRO_EVENT_TIMER)
                {
                    desenha = true;

                    if(teclas[CIMA])
                        MoveNaveCima(nave);
                    if(teclas[BAIXO])
                        MoveNaveBaixo(nave);
                    if(teclas[DIREITA])
                        MoveNaveDireita(nave);
                    if(teclas[ESQUERDA])
                        MoveNaveEsquerda(nave);
                    if(teclas[SPACE])
                        atualizaBalas(balas, NUM_BALAS);

                    if(!game_over)
                    {
                        AtualizarPlano_1(estrelas_p1, NUM_ESTRELAS);
                        AtualizarPlano_2(estrelas_p2, NUM_ESTRELAS);
                        AtualizarPlano_3(estrelas_p3, NUM_ESTRELAS);

                        LiberaCometas(cometas, NUM_COMETAS);
                        AtualizarCometas(cometas, NUM_COMETAS);
                        BalaColidida(balas, NUM_BALAS, cometas, NUM_COMETAS, nave);
                        CometaColidido(cometas, NUM_COMETAS, nave);

                        if(nave.vidas <= 0)
                           game_over = true;
                    }
                }

            // ------------------------------------------

            // -------- DESENHO --------
                if(desenha && al_is_event_queue_empty(fila_eventos))
                {
                    desenha = false;

                    if(!game_over)
                    {
                        al_draw_tinted_bitmap(background, al_map_rgba(255, 255, 255, 255), 0, 0, 0);

                        DesenharPlano_1(estrelas_p1, NUM_ESTRELAS);
                        DesenharPlano_2(estrelas_p2, NUM_ESTRELAS);
                        DesenharPlano_3(estrelas_p3, NUM_ESTRELAS);

                        DesenhaNave(nave);
                        DesenhaBalas(balas, NUM_BALAS);
                        DesenhaCometas(cometas, NUM_COMETAS);

                        al_draw_textf(font14, al_map_rgb(255, 255, 255), 0, 0, NULL, "VIDAS: %d  /  PONTOS: %d", nave.vidas, nave.pontos);
                    }
                    else if(game_over)
                    {
                        al_draw_textf(font14, al_map_rgb(255, 255, 255), largura_t / 2, altura_t / 2, ALLEGRO_ALIGN_CENTRE,
                        "Fim de jogo. Seus pontos: %d. Tecle ENTER para jogar novamente ou ESC para sair do jogo", nave.pontos);

                        if(teclas[ENTER])
                        {
                            InitNave(nave);
                            InitBalas(balas, NUM_BALAS);
                            InitCometas(cometas, NUM_COMETAS);

                            InitPlano_1(estrelas_p1, NUM_ESTRELAS);
                            InitPlano_2(estrelas_p2, NUM_ESTRELAS);
                            InitPlano_3(estrelas_p3, NUM_ESTRELAS);

                            game_over = false;
                        }
                    }

                    al_flip_display();
                    al_clear_to_color(al_map_rgb(0, 0, 0));
                }

            // -------------------------

        }

    // --------------------------------

    // -------- FINALIZAÇÃO DO PROGRAMA --------
        al_destroy_bitmap(background);
        al_destroy_bitmap(enemySprite);
        al_destroy_bitmap(naveSprite);
        al_destroy_font(font14);
        al_destroy_display(display);
        al_destroy_timer(timer);
        al_destroy_event_queue(fila_eventos);
    // -----------------------------------------

    return 0;
}

// -------- DEFINIÇÃO DE FUNÇÕES E PROCEDIMENTOS --------

    // -------- NAVE --------
    void InitNave (NaveEspacial &nave)
    {
        nave.x = 20;
        nave.y = altura_t / 2;
        nave.ID = JOGADOR;
        nave.vidas = 3;
        nave.velocidade = 7;
        nave.borda_x = 6;
        nave.borda_y = 7;
        nave.pontos = 0;
    }

    void DesenhaNave(NaveEspacial &nave)
    {
        currentSpriteNave++;
        if (currentSpriteNave == contSpritesNave)
            currentSpriteNave = 0;

        al_draw_bitmap(spriteAnimadaNave[currentSpriteNave].sprite, nave.x - 45, nave.y - 15, 0);
    }

    void MoveNaveCima (NaveEspacial &nave)
    {
        nave.y -= nave.velocidade;

        if(nave.y < 20)
        {
            nave.y = 20;
        }
    }

    void MoveNaveBaixo (NaveEspacial &nave)
    {
        nave.y += nave.velocidade;

        if(nave.y > altura_t - 17)
        {
            nave.y = altura_t - 17;
        }
    }

    void MoveNaveDireita (NaveEspacial &nave)
    {
        nave.x += nave.velocidade;

        if(nave.x > largura_t / 2)
        {
            nave.x = largura_t / 2;
        }
    }

    void MoveNaveEsquerda (NaveEspacial &nave)
    {
        nave.x -= nave.velocidade;

        if(nave.x < 12)
        {
            nave.x = 12;
        }
    }
    // ----------------------

    // -------- PROJETEIS --------
    void InitBalas (Projeteis balas[], int tamanho)
    {
        for(int i = 0; i < tamanho; i++)
        {
            balas[i].ID = PROJETIL;
            balas[i].velocidade = 10;
            balas[i].ativo = false;
        }
    }

    void atiraBalas (Projeteis balas[], int tamanho, NaveEspacial nave)
    {
        for(int i = 0; i < tamanho; i++)
        {
            if(!balas[i].ativo)
            {
                balas[i].x = nave.x + 15;
                balas[i].y = nave.y;
                balas[i].ativo = true;
                break;
            }
        }
    }

    void atualizaBalas (Projeteis balas[], int tamanho)
    {
        for(int i = 0; i < tamanho; i++)
        {
            if(balas[i].ativo)
            {
                balas[i].x += balas[i].velocidade;

                if(balas[i].x > largura_t)
                    balas[i].ativo = false;
            }
        }
    }

    void DesenhaBalas (Projeteis balas[], int tamanho)
    {
        for(int i = 0; i < tamanho; i++)
        {
            if(balas[i].ativo)
            {
                al_draw_filled_circle(balas[i].x, balas[i].y, 2, al_map_rgb(255, 255, 255));
            }
        }
    }

    void BalaColidida(Projeteis balas[], int b_tamanho, Cometas cometas[], int c_tamanho, NaveEspacial &nave)
    {
        for(int i = 0; i < b_tamanho; i++)
        {
            if(balas[i].ativo)
            {
                for(int j = 0; j < c_tamanho; j++)
                {
                    if(cometas[j].ativo)
                    {
                        if(balas[i].x > (cometas[j].x - cometas[j].borda_x) &&
                            balas[i].x < (cometas[j].x + cometas[j].borda_x) &&
                            balas[i].y > (cometas[j].y - cometas[j].borda_y) &&
                            balas[i].y < (cometas[j].y + cometas[j].borda_y))
                            {
                                balas[i].ativo = false;
                                cometas[j].ativo = false;

                                nave.pontos++;
                            }
                    }
                }
            }
        }
    }
    // ---------------------------

    // -------- COMETAS --------
    void InitCometas (Cometas cometas[], int tamanho)
    {
        for(int i = 0; i < tamanho; i++)
        {
            cometas[i].ID = INIMIGOS;
            cometas[i].velocidade = 5;
            cometas[i].borda_x = 18;
            cometas[i].borda_y = 18;
            cometas[i].ativo = false;
        }
    }

    void LiberaCometas (Cometas cometas[], int tamanho)
    {
        for(int i = 0; i < tamanho; i++)
        {
            if(!cometas[i].ativo)
            {
                if(rand() % 500 == 0)
                {
                    cometas[i].x = largura_t;
                    cometas[i].y = 30 + rand() % (altura_t - 60);
                    cometas[i].ativo = true;
                    break;
                }
            }
        }
    }

    void AtualizarCometas (Cometas cometas[], int tamanho)
    {
        for(int i = 0; i < tamanho; i++)
        {
            if(cometas[i].ativo)
            {
                cometas[i].x -= cometas[i].velocidade;
            }
        }
    }

    void DesenhaCometas (Cometas cometas[], int tamanho)
    {
        currentSpriteEnemy++;
        if (currentSpriteEnemy == contSpritesEnemy)
            currentSpriteEnemy = 0;

        for(int i = 0; i < tamanho; i++)
        {
            if(cometas[i].ativo)
            {
                al_draw_bitmap(spriteAnimadaEnemy[currentSpriteEnemy].sprite, cometas[i].x - cometas[i].borda_x, cometas[i].y - cometas[i].borda_y, 0);
            }
        }
    }

    void CometaColidido (Cometas cometas[], int c_tamanho, NaveEspacial &nave)
    {
        for(int i = 0; i < c_tamanho; i++)
        {
            if(cometas[i].ativo)
            {
                if(((cometas[i].x - cometas[i].borda_x) < (nave.x + nave.borda_x)) &&
                    ((cometas[i].x + cometas[i].borda_x) > (nave.x - nave.borda_x)) &&
                    ((cometas[i].y - cometas[i].borda_y) < (nave.y + nave.borda_y)) &&
                    ((cometas[i].y + cometas[i].borda_y) > (nave.y - nave.borda_y)))
                    {
                        cometas[i].ativo = false;
                        nave.vidas--;
                    }
                else if(cometas[i].x < 0)
                {
                    cometas[i].ativo = false;
                    nave.vidas--;
                }
            }
        }
    }
    // ---------------------------

    // -------- PLANOS DE FUNDO --------
    void InitPlano_1(Estrelas estrelas_p1[], int tamanho)
    {
        for(int i = 0; i < tamanho; i++)
        {
            estrelas_p1[i].ID = ESTRELA;
            estrelas_p1[i].x = 5 + rand() % (largura_t - 10);
            estrelas_p1[i].y = 5 + rand() % (altura_t - 10);
            estrelas_p1[i].velocidade = 8;
        }
    }

    void InitPlano_2(Estrelas estrelas_p2[], int tamanho)
    {
        for(int i = 0; i < tamanho; i++)
        {
            estrelas_p2[i].ID = ESTRELA;
            estrelas_p2[i].x = 5 + rand() % (largura_t - 10);
            estrelas_p2[i].y = 5 + rand() % (altura_t - 10);
            estrelas_p2[i].velocidade = 3;
        }
    }

    void InitPlano_3(Estrelas estrelas_p3[], int tamanho)
    {
        for(int i = 0; i < tamanho; i++)
        {
            estrelas_p3[i].ID = ESTRELA;
            estrelas_p3[i].x = 5 + rand() % (largura_t - 10);
            estrelas_p3[i].y = 5 + rand() % (altura_t - 10);
            estrelas_p3[i].velocidade = 1;
        }

    }

    void AtualizarPlano_1(Estrelas estrelas_p1[], int tamanho)
    {
        for(int i = 0; i < tamanho; i++)
        {
            estrelas_p1[i].x -= estrelas_p1[i].velocidade;

            if(estrelas_p1[i].x < 0)
                estrelas_p1[i].x = largura_t;
        }
    }

    void AtualizarPlano_2(Estrelas estrelas_p2[], int tamanho)
    {
        for(int i = 0; i < tamanho; i++)
        {
            estrelas_p2[i].x -= estrelas_p2[i].velocidade;

            if(estrelas_p2[i].x < 0)
                estrelas_p2[i].x = largura_t;
        }
    }

    void AtualizarPlano_3(Estrelas estrelas_p3[], int tamanho)
    {
        for(int i = 0; i < tamanho; i++)
        {
            estrelas_p3[i].x -= estrelas_p3[i].velocidade;

            if(estrelas_p3[i].x < 0)
                estrelas_p3[i].x = largura_t;
        }
    }

    void DesenharPlano_1(Estrelas estrelas_p1[], int tamanho)
    {
        for(int i = 0; i < tamanho; i++)
        {
            al_draw_pixel(estrelas_p1[i].x, estrelas_p1[i].y, al_map_rgb(255, 255, 255));
        }
    }

    void DesenharPlano_2(Estrelas estrelas_p2[], int tamanho)
    {
        for(int i = 0; i < tamanho; i++)
        {
            al_draw_pixel(estrelas_p2[i].x, estrelas_p2[i].y, al_map_rgb(255, 255, 255));
        }
    }

    void DesenharPlano_3(Estrelas estrelas_p3[], int tamanho)
    {
        for(int i = 0; i < tamanho; i++)
        {
            al_draw_pixel(estrelas_p3[i].x, estrelas_p3[i].y, al_map_rgb(255, 255, 255));
        }
    }
    // ---------------------------------

    // -------- SPRITES --------
    void add_spritesEnemy(ALLEGRO_BITMAP *parent)
    {
        int xAux = 0;
        int yAux = 0;
        for (int i = 0; i < 6; i++)
        {
            ALLEGRO_BITMAP *spr = al_create_sub_bitmap(parent,xAux, yAux, 40, 30);
            yAux += 30;
            Sprite s;
            if (contSpritesEnemy < MAX_SPRITES) {
                s.sprite = spr;
                s.x = 0;
                s.y = altura_t - 30;
                spriteAnimadaEnemy[contSpritesEnemy] = s;
                contSpritesEnemy++;
            }
        }
    }

    void add_spritesNave(ALLEGRO_BITMAP *parent)
    {
        int xAux = 0;
        int yAux = 0;
        for (int i = 0; i < 4; i++)
        {
            ALLEGRO_BITMAP *spr = al_create_sub_bitmap(parent,xAux, yAux, 64, 29);
            yAux += 29;
            Sprite s;
            if (contSpritesNave < MAX_SPRITES) {
                s.sprite = spr;
                s.x = 0;
                s.y = altura_t - 29;
                spriteAnimadaNave[contSpritesNave] = s;
                contSpritesNave++;
            }
        }
    }
    // ---------------------------------

// ---------------------------------------------------
