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
Playing chords and switching over different waveforms (will fix audio recording later):

https://github.com/user-attachments/assets/9961babe-d6a5-460e-be49-4de19af703cc


### Keybinds:
| Key | Action |
|-----|--------|
| **A–;** | Play notes (white keys row) |
| **W, E, T, Y, U, O, P** | Play sharps/flats (black keys row) |
| **Z / X** | Shift octave **down / up** |
| **1–4** | Switch waveform:<br>1️⃣ Sine · 2️⃣ Square · 3️⃣ Saw · 4️⃣ Triangle |
| **\[ / \]** | **Decrease / Increase** filter cutoff frequency |

> 💡 *Tip:* You can hold multiple keys to do chords and test out polyphony.

### To do:
- **synth non-negotiables**
    - Oscillators ✅
    - OSC visualizer (oscilloscope) ✅
    - ADSR (per active oscillator) ✅
    - Filter (at least a LPF) ✅
    - Mixer (might not be needed, unless, I push for multi-osc)
    - Polyphony ✅
- **maybes**
    - Mod Env
    - LFOs
- **really down the line stuff**
    - MIDI or equivalent file processing
    - adapter to a piano roll UI
