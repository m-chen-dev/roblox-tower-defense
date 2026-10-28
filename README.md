# roblox-tower-defense

## General Info

This game is a tower defense game that I built in Roblox Studio with the Lua programming language.

It includes the following features:
* Enemies of various archetypes that spawn each wave; each enemy has health and pathfinding capabilities, and its stats increase as waves progress
* Tower placement system with towers that have the ability to track and fire at enemies, as well as upgrade and selling mechanics
* A game over state when enemies reach the base
* UI to support many of the game's mechanics (UI that indicates base health, wave number, current cash, intermission, etc.)

I used Rojo to convert it from a .rbxl file to a Visual Studio Code project so that I could publish it on GitHub. Most, if not all of the source code in the place file should have been transferred properly.

## Prerequisites
* **Rojo** - You can install it [here](https://rojo.space/docs/v7/getting-started/installation/)
* **Roblox Studio** - You can install it [here](https://create.roblox.com/docs/studio/setup)

## Building It Yourself
1. **Clone this repository**
    ```bash
    git clone https://github.com/m-chen-dev/roblox-tower-defense roblox-tower-defense
    cd roblox-tower-defense
    ```
2. **Convert to Roblox Studio place file**
    ```bash
    rojo build -o TowerDefense.rbxl
    ```
    *You can replace TowerDefense with another name if you want*
3. **Launch** - You can double click on it or right click on it and click open to launch/open the rbxl file