# Trabalho-2-DCC148
## Auto-Chess with Tower Defense mechanics
My idea is making a game where the player "buys" units of 3 different types and has the option of manually controlling them in combat or auto-combat, and maybe mix up features from tower defense games.
## Unit types:
| Unit Type | Range | Survivability | Damage | Extra Info |
|:-:|:-:|:-:|:-:|:-:|
| Soldier | Melee | High HP | Low Damage | Mobility |
| Archer | Ranged | Low HP | High Damage | Raw Damage |
| Mage | Medium Range | Medium HP | Medium Damage | Healing and Status Effects |
## Core Mecanics
- The player and it's opponent each own a tower, which they have to protect
- At the beggining of each round, the player selects which units it wants to aquire, provided they have resources to obtain them, and place them on the game board.
    - If a unit is placed ~~adjacent to~~ on top of another of the same type, they merge and become stronger
- After the units are positioned, the player has the option of controling each one individually, until every unit on they own has completed a set of actions:
    - Move to another tile of the map
        - Select a target tile within range to move to
        - If a unit moves to a tile occupied by another of the same type, they merge and become stronger
    - Perform an attack against another unit
        - Select one of the available abilities, among basic attack, special attack and ultimate attack, and select the target tile
    - Those actions can be skipped
- If the player prefers, they will have the option of handing the control of the units to the game's algorythm, which will automatically move and attack the closest enemy
- The same steps are then performed by the opponent, controlled by the game's engine
- The towers can be upgraded, giving them ability to attack nearby enemy units, regenerate health, etc
- The game loop continues until one of the towers' HP reaches zero
## Requirements
1. Tela inicial com opção de iniciar o jogo;
2. Uso de animação de sprites e tiles;
3. Algum uso de animação geral que não envolva sprites;
4. Detecção e tratamento de colisão (via Godot ou manualmente);
4. Presença de áudio e elementos de interface (HUD);
6. Controle de câmera:
A câmera não deve ser estática, mas o deslocamento da câmera pode ser contínuo ou não;
7. Objetivo a ser alcançado:
Pode ser completar um conjunto de fases, derrotar um conjunto de inimigos ou algum outro objetivo que dê sentido ao jogo;
8. Tela de créditos contendo informações sobre o grupo e sobre eventuais fontes de assets utilizados.

| # | Requirement | Plan | Execution
:-:|:-:|:-:|:-:
1 | Tela Inicial | Uma cena separada | NYI
2 | Sprites animados e Tiles | OK | NYI
3 | Animação (não sprite) | Animações dos projéteis | NYI
4 | Colisão | OK | NYI
5 | Áudio & HUD | Áudio vai ser chato, HUD OK | NYI
6 | Câmera | Zoom in/out, Foco no personagem | NYI
7 | Objetivo | OK | NYI
8 | Créditos | OK | NYI

-# "OK" é porque é óbvio que eu vou usar