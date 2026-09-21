# BLOOPIES TAP! 🌴

A complete, offline-first, one-finger reaction game for **Godot 4.4.1** and Android. Tap friendly BLOOPIES as they pop out of a lively island, collect fruit, build character combos, and leave the silly traps alone. The project uses original, clearly identified placeholder artwork and contains no ads, purchases, account, network gameplay, dialogue, narration, lyrics, or third-party creative assets.

## First playable version

1. Open the repository in Godot **4.4.1** and run the project.
2. Choose **PLAY** for Tropical Beach, or **LEVELS** to pick an unlocked location.
3. Tap a BLOOPIE before it hides. A tap scores once; expired BLOOPIES reset the combo.
4. Do **not** tap coconuts, crabs, or the harmless cartoon pirate barrel. A trap costs one heart.
5. Tap fruit for two points. The 30-second round also ends if all three hearts are lost.

The HUD shows score, combo, lives, and time. A round earns one star below 15 points, two from 15–27, and three at 28+. Three lifetime stars unlock BLOOPIES Island; eight unlock the Floating House placeholder level. Best score, best combo, stars, levels, and audio switches are stored in `user://bloopies_tap_save.json`.

## Controls and display

- Android: one-finger taps through `InputEventScreenTouch`.
- Desktop testing: left-click uses the same hit area and score lock.
- Reference canvas: portrait **720 × 1280**, scaled with `canvas_items` for phones and tablets such as Galaxy Tab S6 Lite.
- Every target has a generous 156 × 170-ish collision capsule. There is no hover-dependent behavior.
- The renderer is lightweight OpenGL compatibility, with no heavy shaders.

## Invisible 4 × 4 spawn system

`Game/SpawnPoints` contains exactly 16 reusable `Marker2D` nodes. They correspond to four logical rows and four logical columns, but are deliberately offset into palm leaves, windows, flowers, crates, rocks, bridges, pier posts, and boat areas. **No grid is drawn.** Each `SpawnPoint` exposes a human-readable `location_hint`.

`SpawnManager` chooses only unoccupied points, marks them occupied, and releases them on tap/expiry. Its list-based implementation has no hard-coded 16-point assumption: a future 5 × 5 scene can supply 25 markers without modifying gameplay code. Eight pooled target nodes are reused instead of repeatedly constructing gameplay scenes.

## Difficulty and round pacing

Configuration lives in `scripts/difficulty_manager.gd`:

| Round time | Concurrent | Appearance | Traps | Fruit | Wave spacing |
|---|---:|---:|---:|---:|---:|
| 0–10 s | 1 | 0.90 s | 8% | 9% | 0.72 s |
| 10–20 s | 1–2 | 0.68 s | 14% | 12% | 0.55 s |
| 20–30 s | 1–3 | 0.48 s | 20% | 16% | 0.40 s |

Edit the dictionaries returned by `DifficultyManager.settings()` to rebalance the game. The lower duration remains above the requested reasonable ~0.45-second floor. Occupancy prevents overlapping interactions.

## Combos and specials

- Three consecutive successes display **SUPER COMBO**.
- At five or more, BLOOPIE taps score ×2.
- At ten, **BLOOPIES FEVER** runs for four seconds: three possible targets, cheerful overlay/particles, ×3 scoring, faster music hook, and no traps.
- Three consecutive taps of the same character trigger its data-defined special and a +3 bonus:
  - **BUBO — EAR FLAP BONUS:** celebratory character-color burst.
  - **LUNA — FLOWER SHOWER:** pink flower-like particles.
  - **ZIPP — INVENTOR BOOST:** slows round time briefly.
  - **GLOP — FRUIT FRENZY:** adds bonus fruit waves.
  - **KRAK — PIRATE TREASURE:** creates a tappable +5 treasure.
  - **NANO — DRONE SCAN:** announces/highlights the next valid-target moment.

Specials are short and never pause the round.

## Project structure

```text
project.godot                 portrait/runtime/autoload settings
export_presets.cfg            package and Android debug export
scenes/
  main_menu.tscn              title, play, levels, audio settings
  level_select.tscn           star-gated locations
  game.tscn                   HUD, 16 natural points, active round
  result_screen.tscn          score summary and navigation
  bloopie.tscn                pooled touch target
  spawn_point.tscn            reusable logical point
  trap.tscn / bonus.tscn      reusable scene variants
scripts/
  game_manager.gd             round loop, scoring, feedback, specials
  spawn_manager.gd            free-point selection and pooling
  difficulty_manager.gd       three pacing stages
  combo_manager.gd            general and character combo history
  character_database.gd       single source of BLOOPIE presentation data
  bloopie.gd                  touch-once/expiry behavior
  trap.gd / bonus.gd          extensible target types
  ui_manager.gd               HUD updates
  audio_manager.gd            independent music/SFX hooks
  save_manager.gd             local JSON progression
assets/
  characters/                 six transparent placeholder SVG sprites
  backgrounds/                three original placeholder environments
  audio/ effects/ ui/         drop-in production asset locations
```

## Replacing character placeholders

There are exactly six permanent BLOOPIES: Bubo, Luna, Zipp, Glop, Krak, and Nano. Their complete definitions are centralized in `scripts/character_database.gd`, including `id`, `display_name`, `sprite`, `tap_animation`, `tap_sound`, `special_combo`, `particle_effect`, and theme color.

To use official transparent PNG/WebP art:

1. Add the file under `assets/characters/`.
2. Change only that character's `sprite` value in `character_database.gd` (or replace the matching SVG while preserving its path).
3. Keep transparent padding reasonably tight around the figure.
4. Run the project. No spawn, touch, score, or combo code changes are required.

The prototype SVGs literally include a source comment identifying them as placeholders. They are original geometric stand-ins, not final character artwork.

## Replacing island backgrounds

- Replace `assets/backgrounds/level1.svg` and `level2.svg` with official portrait PNG/WebP assets, then update the corresponding paths in `game_manager.gd` and scene previews if the extension changes.
- `level3.svg` is conspicuously labeled **FLOATING HOUSE PLACEHOLDER**. It is not a canonical redesign. Replace it when the approved Floating House artwork is supplied.
- Keep the subject framing compatible with 720 × 1280 and preserve clear contrast around the 16 targets.
- Move `SpawnPoint` markers in `scenes/game.tscn` to match natural hiding places in the official background. Their node order can continue to represent the logical grid.

## Adding a level (and optional 5 × 5 layout)

1. Add a portrait background under `assets/backgrounds/`.
2. Add level metadata/button copy and an unlock rule in `level_select.gd`/`save_manager.gd`.
3. Select its background in `game_manager.gd`.
4. For a unique map, duplicate `game.tscn` and position 16 `SpawnPoint` markers in environmental hiding places.
5. For 5 × 5, create 25 markers. `SpawnManager.initialize()` discovers all child points automatically; free-point selection, occupancy, and overlap prevention continue to work unchanged.

## Original audio integration

Audio buses are independently controlled by Music and SFX switches. The prototype deliberately ships silent rather than bundling questionable media. Add commissioned/original streams in `assets/audio/`, assign background/ambience to `AudioManager.music_player`, and implement the ID-to-stream hook in `play_character()`. Fever already raises music pitch and respects the music switch. Do not add spoken dialogue or lyrical music.

## Build the APK entirely through GitHub

No PC is required:

1. Upload/push this repository to GitHub from a browser or Android Git client.
2. Open the repository's **Actions** tab.
3. Select **Build Android APK** and tap **Run workflow** (pushes and pull requests also build automatically).
4. The workflow installs Java 17, Godot **4.4.1** with matching export templates, and the Android 35 platform, Build Tools 35.0.0, and Platform Tools. It writes Godot's editor settings with the detected Android SDK and Java SDK paths, creates an ephemeral `debug.keystore` in the project root with alias `androiddebugkey` and the standard non-production debug password, verifies the key and complete preset, performs a verbose headless import, and exports the package `com.bloopiesworld.bloopiestap`.
5. Open the completed workflow run, scroll to **Artifacts**, and download **`Bloopies-Tap-Android`**.
6. Unzip it to obtain **`BloopiesTap-debug.apk`**. Android may ask permission to install apps from the browser/files app.

Godot 4.4 requires the `keystore/debug`, `keystore/debug_user`, and `keystore/debug_password` export options to be either all populated or all empty. This repository populates all three for CI: the preset points to the generated project-root `debug.keystore`, while the workflow creates the matching `androiddebugkey` alias with password `android`. The generated key and `build/` directory are ignored by Git. This disposable key is only for debug APKs; production Play Store publishing should use an encrypted repository secret and a permanent release key.

The workflow explicitly configures Godot's `export/android/android_sdk_path` and `export/android/java_sdk_path` editor settings; merely exporting `ANDROID_HOME` is not sufficient for reliable headless preset validation. Before export it prints tool versions and paths, verifies `adb`, `aapt2`, the `apksigner` tool, `android.jar`, the debug keystore, and `android_debug.apk`, and starts only the lightweight ADB server. No emulator is started and no connected device is required to build an APK. Verbose Godot output is enabled so any future preset error includes its underlying tool diagnostics.

## Asset and performance notes

All currently visible art is temporary original SVG placeholder art. Level 3 explicitly avoids asserting an official Floating House design. The runtime pools characters/traps/bonuses, uses small tweens and simple rectangles for particles, and avoids per-frame node creation except brief tap feedback. For a production pass, add original audio, official transparent BLOOPIE renders, and approved location paintings without changing the gameplay systems.
