# Trabalho-2-DCC148
## Auto-Chess with Tower Defense mechanics
My idea is making a game where the player "buys" units of 3 different types and has the option of manually controlling them in combat or auto-combat, and maybe mix up features from tower defense games.
## Unit types:
| Unit Type | Range        | Survivability | Damage        | Extra Info   |
|:---------:|:------------:|:-------------:|:-------------:|:------------:|
| Soldier   | Melee        | High HP       | Low Damage    | Self-Healing |
| Archer    | Ranged       | Low HP        | Medium Damage | Raw Damage   |
| Mage      | Medium Range | Medium HP     | High Damage   | High Cost    |
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

| # | Requirement | Plan |
|:-:|:------------------------:|:-----------------------------------:|
| 1 | Tela Inicial             | Needs fixing on positioning         |
| 2 | Sprites animados e Tiles | Done                                |
| 3 | Animação (não sprite)    | lerp on camera, projectiles missing |
| 4 | Colisão                  | Done                                |
| 5 | Áudio & HUD              | Missing some                        |
| 6 | Câmera                   | Done                                |
| 7 | Objetivo                 | In Progress                         |
| 8 | Créditos                 | In Progress                         |

## Credits

- Made by B4Hive (Bruno dos Santos Silva)

- CHARACTER SPRITES by FreeGameAssets - CraftPix - [Link 1](https://free-game-assets.itch.io/free-tiny-hero-sprites-pixel-art), [Link 2](https://free-game-assets.itch.io/free-tiny-pixel-hero-sprites-with-melee-attacks), [Link 3](https://free-game-assets.itch.io/free-tiny-pixel-hero-sprites-with-bow-attacks)

- UI SPRITES by Snoblin - [Link](https://snoblin.itch.io/animated-hud-pixel-rpg)

- TILEMAP by SnowHex - [Link](https://snowhex.itch.io/pixel-plains)

- SOUNDS MUSIC AND FONTS - [Link](https://brackeysgames.itch.io/brackeys-platformer-bundle)

    - SOUNDS by Brackeys, Asbjørn Thirslund

    - MUSIC by Brackeys, Sofia Thirslund

    - FONTS by Jayvee Enaguas - HarvettFox96 - [link](https://www.dafont.com/pixel-operator.font?l[]=10&l[]=1)

# TODO:
- Missing projectiles
- Missing more sound effects and more music
- Missing help