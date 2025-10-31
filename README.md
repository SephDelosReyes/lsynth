# l(ua)synth
---
_a noob attempt to make a game engine spew out a toy synth while learning how to Lua_
### Goals:
1. Make a toy synth without going into VST specs or low-level OS audio shit
2. Learn audio maths
3. Re-learn my maths
4. Learn Lua
5. Make something really cool

### How to run:
1. Install [LÖVE](https://love2d.org/#download) and add to path
2. Clone this repo
3. In terminal execute `love .`

### Screen captures
- Switching over different waveforms
[cap](captures/screen-cap.mp4)
### Keybinds:
| Key | Action |
|-----|--------|
| **A–;** | Play notes (white keys row) |
| **W, E, T, Y, U, O, P** | Play sharps/flats (black keys row) |
| **Z / X** | Shift octave **down / up** |
| **1–4** | Switch waveform:<br>1️⃣ Sine · 2️⃣ Square · 3️⃣ Saw · 4️⃣ Triangle |

> 💡 *Tip:* You can hold multiple keys to do chords and test out polyphony.

### To do:
- **synth non-negotiables**
    - Oscillators
    - OSC visualizer (oscilloscope)
    - ADSR (per active oscillator)
    - Filter (at least a LPF)
    - Mixer
    - Polyphony
- **maybes**
    - Mod Env
    - LFOs
- **really down the line stuff**
    - MIDI or equivalent file processing
    - adapter to a piano roll UI
