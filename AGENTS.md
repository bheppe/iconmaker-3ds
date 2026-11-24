# AGENTS.md

Context for AI coding agents (Claude Code, Codex, ...) working on this repo.
Read it before changing anything; the README is for users, this is for you.

## What this is

- **Icon Maker**: a Nintendo 3DS app that makes HOME Menu forwarders (CIAs)
  for GBA games (start [gpSP 3D](https://github.com/bheppe/gpsp-3d)) and SNES
  games (start [Snes9x 3D](https://github.com/bheppe/snes9x_3ds)), on the
  3DS itself. Target: usable on an **Old 3DS**.
- Until gpSP 3D v0.1.7 (Icon Maker 0.2.0) it lived in gpSP 3D's repo as
  `iconmaker/`. Its history was moved here with `git filter-repo`; commit
  references like `bheppe/gpsp-3d#20` point at that repo.
- Maintainer: bheppe. Contributors: michvllni (CI, Icon Maker pictures, speed,
  box art). Releases go out through GitHub Releases, gpSP 3D's
  Universal-Updater store (built in the gpSP 3D repo from this repo's
  releases), Reddit and Discord.

## Layout

| Path | What |
|---|---|
| `source/main.c` | the app: game list, My icons, settings, the systems table (`systems[]`) |
| `source/fwdcia.c`, `banner.c` | patch a template CIA on the 3DS (title ID, SMDH, banner, forwarder slot, every hash) |
| `source/pngshrink.c`, `jpegshrink.c` | covers decoded small while read (libpng / libjpeg) |
| `source/boxart.c`, `netget.c` | box art download: libretro's No-Intro list, CRC32, libretro-thumbnails (libcurl) |
| `source/deficon.c` | the cartridge icons made from a game's name |
| `forwarder/` | the tiny program every forwarder CIA runs (from gpSP 3D's `gpsp3ds/forwarder`) |
| `uikit/` | software UI on the bottom screen (`ui.c`, fonts in `ui_font.c`), from gpSP 3D's `gpsp3ds/source` |
| `tools/make_font.py` | makes `uikit/ui_font.c` from the Inter fonts |
| `tools/make_banner3d.py` | makes the 3D HOME Menu banners (needs pycgfx; run on a PC) |
| `res/` | app icon and banners, template banner, chime, `app.rsf`, `gpsp3d-icon.png` (the template forwarder's icon) |
| `data/` | the template CIAs, made by `build-iconmaker.sh` (not in git) |
| `test/` | `fwdtest.c` + `verify.py` (forwarder CIA checked like the 3DS does), `pngtest.c`, `jpegtest.c`, `boxarttest.c` |
| `docker/` | the build image and `ci-build.sh` (what CI runs) |
| `ROADMAP.md` | what's done, in testing, planned; update it with every change |

## Building

devkitARM (devkitPro) with `3ds-dev` plus these portlibs: `3ds-curl` (box
art), `3ds-libjpeg-turbo` and `3ds-libpng`. Also `bannertool` and `makerom` on
the PATH.

```
bash build-iconmaker.sh   # -> out/iconmaker.cia, iconmaker.3dsx, template-gpsp3d.cia
bash docker/ci-build.sh   # the same + the forwarder test, as CI does
make TIMING=1             # a timing variant (after build-iconmaker.sh made data/)
```

- The build image is `docker/iconmaker-devcontainer.Dockerfile` (devkitARM
  pinned by digest). `docker/build-image.sh` names it by the Dockerfile's hash.
- `ci-build.sh` fails without libcurl on purpose: without it box art can't be
  downloaded (the 3DS's own HTTPS can't reach GitHub).
- There's no devkitPro in most agent sandboxes. A syntax check with a plain
  `arm-none-eabi-gcc -fsyntax-only` against libctru headers catches most
  mistakes; say clearly that it wasn't built or run on hardware.
- The PC tests (`test/`) build with the host's gcc, libpng, libjpeg and
  libcurl.

## Versions and releases

- The version is in two places that must agree with the release tag:
  `ICONMAKER_VERSION` in `source/main.c` and `-major/-minor/-micro` in
  `build-iconmaker.sh`. `release.yml` refuses a tag that disagrees. Tags are
  `vX.Y.Z`, three numbers only (the CIA version can't hold four).
- Bump the CIA version whenever the app changes, or the update won't install
  over the old one.
- Publishing a GitHub release ("Set as the latest release" ticked) runs
  `release.yml`: it builds, uploads `iconmaker.cia` and `iconmaker.3dsx` and
  adds an FBI QR code to the notes. Keep those asset names: gpSP 3D's store
  and `releases/latest/download` links depend on them.
- Every push to `main` refreshes the **nightly** pre-release (CI).
- Title IDs (unique IDs): Icon Maker `0xF3D01`, forwarder template `0xF3D00`
  (Icon Maker gives each forwarder its own). gpSP 3D is `0xBAC81`, Snes9x 3D
  `0x38A71`.
- Settings stay in `sdmc:/3ds/gpsp3d/` (`iconmaker.cfg`, box art lists), as
  before the move: don't move them without a migration.

## 3DS rules learned the hard way

These all broke something on real hardware at least once.

**Forwarders**
- The forwarder's slot (`fwd_slot` in `forwarder/source/main.c`, magic
  `GP3D-FWD-SLOT-1`) and `source/fwdcia.c` must agree on its layout. Change
  both together; installed forwarders keep the old program.
- The template is unencrypted and uncompressed so it can be patched on the
  3DS. Its banner picture is noise so any picture fits in its place.
- Reinstalling a forwarder with different contents at the same title and
  version fails with `C8E083FC` (AM: already exists); Icon Maker deletes the
  old title and retries.

**HOME Menu banners** (`tools/make_banner3d.py`, `source/banner.c`)
- A banner is a CBMD (0x88 header) + LZ11-compressed CGFX + CWAV (its offset
  at 0x84).
- Sound: **stereo PCM16 CWAV at 32 kHz**. Mono played as a 4.4 kHz beeping.
- CGFX that the real HOME Menu accepts (pycgfx output needs these, see
  `hardware_fixes()`): every mesh bound to its bone (`mesh_node_name`), no
  skinning, every material textured (a textureless one crashed HOME), matte
  materials, animations with translation, rotation and scale. Rounded
  outlines in the geometry and tiles without sides froze HOME when animated:
  the tile is a box, corners rounded by the label texture's alpha.
- SMDH flags `0x125` (visible, allow 3D, record usage, extended banner),
  at 0x2028. The HOME Menu caches banners per title and version.
- Two templates: 3D (`fwd_gpsp3d_3d.bin`) and flat (`fwd_gpsp3d.bin`). Both
  need the chime. A game's own `.banner` picture always uses the flat one.

**Old 3DS performance and memory**
- 268 MHz ARM11, no hardware divide, small caches. Measure (`make TIMING=1`)
  before and after; report numbers.
- Covers are read a piece at a time and shrunk while read; never load a whole
  picture into memory.

**System services**
- The 3DS's own HTTPS (`httpc`) can't talk to github.com (TLS too old). Use
  libcurl + mbedTLS, with `socInit` only for the request (`netget.c`).

**Touch UI**
- Menu taps act when the finger lifts without moving (dragging the list must
  not change settings).
- Tabs size to their labels; check text widths with the real fonts
  (`uikit/ui_font.c`).

## How to work here

- **Commits**: author `bheppe <52939532+bheppe@users.noreply.github.com>`
  unless you are a contributor committing as yourself. A `Co-Authored-By:`
  line for the AI is fine; **no session links** (`Claude-Session:` etc.) in
  commit messages.
- **Small, testable steps.** The maintainer tests on an Old 3DS. Say exactly
  what to test, with exact buttons and tabs (e.g. **L** on the Games tab) and
  exact commands.
- **Writing style** (README, ROADMAP, release notes, UI text): plain, short
  sentences, exact setting names, no hype. UI strings must fit the 320x240
  bottom screen.
- **Settings** live in `sdmc:/3ds/gpsp3d/iconmaker.cfg`. Add new keys to both
  load and save, with safe defaults for old files.
- **ROADMAP.md**: add a row for every change (what, who asked, status
  🧪 testing / ✅ done / 📋 planned).
- **Credits**: name who asked for or reported something (Reddit/Discord/GitHub
  handle) in ROADMAP and release notes.
- **PRs**: describe what changed, measured before/after numbers where speed
  matters, what was tested on which hardware, and what wasn't.
- **References**: issues and PRs from before the move are in
  `bheppe/gpsp-3d`; write them as full references (`bheppe/gpsp-3d#20`).

## Licenses

Icon Maker, the forwarder and the UI kit: GPL-2.0-or-later (`COPYING`).
`source/stb_image.h`: MIT or public domain. Inter font: OFL 1.1
(`res/Inter-LICENSE.txt`). Keep third-party notices when moving code.
