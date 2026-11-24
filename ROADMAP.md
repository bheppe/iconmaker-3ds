# Icon Maker roadmap

What's been reported, what's done, and what's next. Reports come from
[Issues](https://github.com/bheppe/iconmaker-3ds/issues), the Reddit thread and
Discord. Up to 0.2.0, Icon Maker was released with gpSP 3D; its older rows
are copied from [gpSP 3D's roadmap](https://github.com/bheppe/gpsp-3d/blob/main/ROADMAP.md),
and their `#` numbers are issues and PRs there.

**Status key:** ✅ done · 🧪 done, needs testing on real hardware · 🔧 next up · 📋 planned · 💤 later / big project

## Released

| Version (gpSP 3D) | Change | Asked by | Status |
|---|---|---|---|
| 0.1.3 (v0.1.3) | **Icon Maker**: HOME Menu icons for GBA games made on the 3DS, no PC; own or generated icon and banner, a whole folder at once, delete from the app | bheppe | ✅ |
| 0.1.3 (v0.1.3) | **SNES games too**, opened in Snes9x 3D (v1.61-layers6+); SNES cartridge icon, GBA/SNES tags in My icons; GBA + SNES app icon and banner | bheppe | ✅ |
| 0.1.4 (v0.1.5) | **Accented letters** (Pokémon no longer shows "Pok??mon") | PJ_MJ (Discord) | 🧪 |
| 0.1.4 (v0.1.5) | **Banner style** (SELECT): 3D (the default), blue background, or no background | PJ_MJ (Discord), bheppe | ✅ |
| 0.1.4 (v0.1.5) | **3D HOME Menu banners** for Icon Maker and every game icon: the icon on a turning, bobbing tile, the name under it, a soft chime | bheppe | ✅ tested on Old 3DS |
| 0.1.5 (v0.1.6) | **JPEG pictures, any size, pad or crop** (X on the Games tab) ([bheppe/gpsp-3d#17](https://github.com/bheppe/gpsp-3d/issues/17), [#18](https://github.com/bheppe/gpsp-3d/pull/18)) | michvllni (GitHub) | ✅ |
| 0.1.7 (v0.1.6, Nov 1) | **Faster previews, covers of any size** ([bheppe/gpsp-3d#19](https://github.com/bheppe/gpsp-3d/issues/19), [#20](https://github.com/bheppe/gpsp-3d/pull/20)) | michvllni (GitHub) | ✅ |
| 0.1.7 (v0.1.6, Nov 1) | **Custom banners back**: a game's own `.banner` picture always wins, also with 3D chosen | Surge And Finn (Discord) | ✅ |
| 0.1.7 (v0.1.6, Nov 1) | **Chime on flat banners** too (they were silent) | Surge And Finn (Discord) | ✅ |
| 0.1.7 (v0.1.6, Nov 1) | **Remaking an icon with the other banner type** failed (C8E083FC): the old icon is now replaced | Surge And Finn (Discord) | ✅ |
| 0.2.0 (v0.1.7) | **Box art download** (L on the Games tab; L on a folder: every game without a picture) from libretro-thumbnails (no account), found in libretro's No-Intro list by file name or CRC32 (a zip's from the zip), other regions tried when its own has none | Gaming4LifeDE, Surge, Finn (Discord) | ✅ |
| 0.2.0 (v0.1.7) | Ready-to-show copies of the thumbnails (saved at 128 px on the shorter side), so making a whole folder stays fast | michvllni (GitHub) | 🧪 |
| 0.2.0 (v0.1.7) | **Box art folder**: `boxart_dir=` in `iconmaker.cfg` (next to the game by default) | michvllni (GitHub) | ✅ |
| 0.2.0 (v0.1.7) | **Your own box art libraries** (ROM hacks, translations): `boxart_source=` lines in `iconmaker.cfg`, laid out like libretro-thumbnails with a `list.txt` of CRC32s; tried before libretro | michvllni (GitHub) | ✅ |

## Next

| Change | Asked by | Status |
|---|---|---|
| **Own repo**: Icon Maker moved from gpSP 3D to [bheppe/iconmaker-3ds](https://github.com/bheppe/iconmaker-3ds) with its history, tags, releases, CI and nightly builds | bheppe, michvllni | ✅ |
| Custom banner sounds (`Game.banner.wav`) | Surge And Finn (Discord) | 📋 next |
| Community art repo for original icons and banners (no copies of official box art) | | 📋 |

**Systems as plugins** (icons for other 3DS apps' games; the first is rmxp3ds, RPG Maker XP games)

| Change | Asked by | Status |
|---|---|---|
| **System files**: the systems come from `sdmc:/3ds/iconmaker/systems/*.cfg` (up to 16) as well as the built-in GBA and SNES; a file with a built-in system's name replaces it; a bad file is skipped and listed under the games; the header shows the installed systems' tags; box art per system (`boxart=`) | michvllni (GitHub) | 🧪 |
| **Games found by each system's `extensions=`**; a `.zip` goes to the system with the extension of its first file, else to the first with `.zip`; texts say "games" and the intro lists each system's app | michvllni (GitHub) | 🧪 |
| **Folder games** (`folder_game=`): a folder holding `Game.ini` is one game, named from `title_from=` (UTF-8 only, else the folder's name); the forwarder gets the folder's path; tapping its icon opens it as a folder | michvllni (GitHub) | 🧪 |
| **Pictures for folder games**: `<folder>.png` next to it, or `icon.png` / `banner.png` in it | michvllni (GitHub) | 📋 |
| **Default icons** `icon=generic` (a tile with the name) and `icon=<png>` | michvllni (GitHub) | 📋 |

## Later

| Plan | Asked by | Status |
|---|---|---|
| DS game forwarders (nds-bootstrap) | | 💤 |
