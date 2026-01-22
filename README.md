# hvcc drumlogue Examples

This repository provides Pure Data patches for [hvcc_drumlogue](https://github.com/boochow/hvcc_drumlogue).

## How to Use

If you want to try the pre-built samples, you can download the binaries from the Releases page.

To build or modify patches yourself, follow these steps:

1. **Install Prerequisites:**  
   Install hvcc, the logue SDK, and [hvcc_drumlogue](https://github.com/boochow/hvcc_drumlogue).

2. **Clone the Repository:**  
   Clone this repository to your local machine:
   
   ```bash
   git clone https://github.com/boochow/drumlogue_hvcc_examples
   cd drumlogue_hvcc_examples
   ```
   
3. **Edit the Makefile:**  
   Edit the `Makefile` so that `PLATFORMDIR` points to your logue SDK installation:
   
   ```
   PLATFORMDIR ?= $(HOME)/logue-sdk/platform
   ```
4. **Build the Units:**  
   To build all units, run:
   ```bash
   make
   ```
   
5. **Build a specific unit (optional):**
   The Pure Data patches are located in the `pd/` directory. To build a single unit, specify the patch name without its extension:
   
   ```bash
   make MonoSynth
   ```

## Patch Descriptions

### Synth

- **MonoSynth.pd** 
  A monaural virtual analog synthesizer.
- **PCM-Mono-Loop.pd** 
  A basic sample player.
- **PCM-Stereo.pd** 
  A player for stereo sample data.
- **SamplePerc.pd** 
  Percussion synthesizer using a sampled audio oscillator.

### Delay FX

- **MonoDelay.pd** 
  A simple monaural delay.
- **Multitap.pd** 
  A triple-tap delay.

### Reverb FX

- **HvReverb.pd** 
  The reverb patch from [heavylib](https://github.com/Wasted-Audio/heavylib).
- **Rev2.pd** 
  The reverb patch included in Pure Data Vanilla.
