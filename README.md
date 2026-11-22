# Trabalho-2-DCC148

# Turn-Based Tower-Defense(ish)

## A ideia por por trás do jogo

Neste jogo baseado em turnos, o jogador controla um personagem principal ("torre") e invoca unidades secundárias usando pontos de energia para atacar seu inimigo e defender sua torre, com o objetivo de derrotar a torre do inimigo.

### Interface

- Cada unidade é representada com 2 elementos superiores:
	- um representando os pondos de energia, do lado esquerdo (representação numérica);
	- um representando os pontos de vida, do lado direito (representação visual).

## Funcionalidades

### Energia

Ao final de cada turno, a torre recebe uma quantidade de energia inversamente proporcional à quantidade de unidades invocadas, para simular um comportamento de compartilhamento de energia.

Esse comportamento não limita a quantidade de unidades invocadas, apenas a geração de energia.

Cada unidade recebe um ponto de energia por turno, e é mostrado na interface a porcentagem de energia em relação à quantidade de energia necessária para usarem sua habilidade.

### Pontos de Vida

São representados como corações de cor variável, alternando entre cheios, meio-preenchidos e vazios.

Um coração vazio equivale a zero pontos de vida, um coração vermelho completo equivale a dois pontos de vida, um coração prateado completo equivale a quatro pontos de vida e um coração dourado completo equivale a 6 pontos de vida. Os corações preenchidos pela metade representam os estados intermediarios, sendo vermelho equivalente a 1, prateado equivalente a 3 e dourado equivalente a 5.

### Dano

Cada unidade invocada possui dois tipos de ataque:

- Ataque básico:
	- utilizado em todos os momentos em que a energia estiver abaixo de 100%;
	- possui valor de um ponto de dano;
- Habilidade:
	- utilizado automaticamente quando um ataque é desferido enquanto a unidade possui 100% de energia;
	- consome a energia da unidade ao ser utilizado;
	- possui efeitos extras;

### Câmera

A câmera focaliza na unidade sendo controlada no momento, e pode ser controlada manualmente com o uso da tecla Shift acompanhada das teclas direcionais.

### Controles

- Teclas direcionais: Seleção de direção durante a fase de movimentação das unidades;
- Enter: encerra a fase atual do turno;
- Esc: retorna para a tela principal / encerra o jogo;
- Botões 1, 2 e 3: Selecionam o tipo de unidade durante a fase de invocação;
- Shift: enquanto pressionado, habilita o controle manual da câmera do jogo.

## Tipos de Unidades:
### Tower:
- Imóvel;
- Resistência a dano; (todo dano recebido é reduzido a um ponto de dano)
- Invoca as outras unidades;
### Sword:
- Maior quantidade de pontos de vida iniciais;
- Menor quantidade de pontos de dano;
- Habilidade recupera pontos de vida;
### Bow:
- Menor quantidade de pontos de vida iniciais;
- Quantidade média de pontos de dano;
- Habilidade possui o menor custo;
### Mage:
- Quantidade média de pontos de vida;
- Maior quantidade de pontos de dano;
- Habilidade aumenta de custo a cada uso e o dano aumenta proporcionalmente;

## Game-Loop

### Jogo
- Cada jogador começa o jogo possuindo uma torre, com uma quantidade determinada de energia inicial;
- O jogo alterna as ações de cada jogador, dando a cada um um turno de controle, até o fim do jogo.

### Turno
Os turnos são separados em 2 fases: Invocação e Movimentação
- Invocação:
A primeira fase do turno, onde o jogador seleciona o tipo de unidade que deseja invocar. Cada tipo de unidade possui mecânicas diferentes e custos de energia diferentes.
- Movimentação:
Após encerrar a fase de invocação, é realizado o controle de cada uma das unidades invocadas, selecionando uma direção de ação.
	- Caso haja uma unidade inimiga na direção escolhida, dentro do limite de alcance da unidade, a mesma é atacada.
	- Caso contrário a unidade se move na direção escolhida.
- Após o turno de movimentação, a energia a ser gerada para a torre e as unidades é contabilizada.

## Creditos:

- Código fonte, Projeto Godot, Planejamento, Conceito, Testes, Implementação:
	- Bruno dos Santos Silva ([B4Hive](https://github.com/B4Hive))

- Sprites de personagens:
	- FreeGameAssets - CraftPix - [Link 1](https://free-game-assets.itch.io/free-tiny-hero-sprites-pixel-art), [Link 2](https://free-game-assets.itch.io/free-tiny-pixel-hero-sprites-with-melee-attacks), [Link 3](https://free-game-assets.itch.io/free-tiny-pixel-hero-sprites-with-bow-attacks)

- Sprites de interface de usuário:
	- Snoblin - [Link](https://snoblin.itch.io/animated-hud-pixel-rpg)

- Sprites de TileMap:
	- SnowHex - [Link](https://snowhex.itch.io/pixel-plains)

- Música, Efeitos Sonoros e Fonte:
	- SOUNDS MUSIC AND FONTS - [Link](https://brackeysgames.itch.io/brackeys-platformer-bundle)

		- Effeitos Sonoros: Brackeys, Asbjørn Thirslund

		- Musica: Brackeys, Sofia Thirslund

		- Fonte: Jayvee Enaguas - HarvettFox96 - [link](https://www.dafont.com/pixel-operator.font?l[]=10&l[]=1)

## TODO:
- Missing projectiles
	- Didn't had time to add them...
- Missing more sound effects and more music
    - Missing combat music and more sound effects for things like walking and other stuff...
- Missing help
	- I wanted to add a help screen, couldn't make it in time...
