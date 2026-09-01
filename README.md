# roblox-tower-defense

Tower Defense converted from the existing Roblox Studio place file into a
[Rojo](https://github.com/rojo-rbx/rojo) 7.7.0 project.

## Getting Started

To build the place from source, use:

```bash
rojo build default.project.json -o "roblox-tower-defense.rbxlx"
```

Open `roblox-tower-defense.rbxlx` in Roblox Studio, then start the Rojo server:

```bash
rojo serve default.project.json
```

## Syncing From Studio

This repo includes `syncback.project.json`, which was used to pull the existing
Studio place into the `src` tree:

```bash
rojo syncback syncback.project.json --input "C:\Users\mchen\roblox-projects\TowerDefense.rbxl" --non-interactive
```

After syncing, rebuild or serve with `default.project.json`.
