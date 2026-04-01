# Simple MIDI bridge

_testing without midi is not sustainable. crashing out on filter cutoff keybinds_

Thanks to [Go MIDI library](https://gitlab.com/gomidi/midi), I can now transport MIDI over UDP

`lsynth` will be refactored to interpret these MIDI messages.

### Basic MIDI support
1. Note ON / OFF with velocity
2. CC (Control Change) for knobs and stuff.


