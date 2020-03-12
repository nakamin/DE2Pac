# Module Parameter Descriptions

Below is an outline of all the parameters for the modules

## OSC A/OSC B
* **wave:** 3 bit, default: sine wave
    * 000: sine wave
    * 001: square wave
    * 010: triangle wave
    * 011: saw wave
    * other: sine wave
    
    (might add more in the future)
* **unison:** 2 bit (1-4), default 1
* **detune:** 7 bit (0%-100%), default 50% (‭0110010)
    * only use the first 101 numbers, where 0%=0000000
* **finetune**: 8 bit (-100 cent, ..., 0 cent, ..., +100 cent), default 0 cent (01100101)
    * only use the first 201 numbers, where -100 cent = 00000000
* **semitone:** 5 bit (-12, ..., -1, 0, +1 , ..., +12), default: 0 (01101)
    * only use first 25 numbers, where -12=00000
* **octave:** 3 bit (-3, -2, -1, 0, +1, +2, +3), default: 0 (011)
    * only use first 7 numbers, where -3=000
* **panning:** 7 bit (-50L, ..., -1L, 0C, +1R, ..., +50R): default: OC (0110011)
    * only use first 101 numbers, where -50L=0000000, 0C=0110010, +50L=1100101
* **volume:** 7 bit (0%-100%), default 100% (1100101‬)
    * only use first 101 numbers, where 0%=0000000
* **output:** 2 bit, default master (01)
    * 00: none,
    * 01: master
    * 10: filter (if implemented)
    * other: master

## ADSR Envelope
* **attack:** 4 bit
* **decay:** 4 bit
* **sustain:** 4 bit
* **release:** 4 bit
* **target:** 2 bit, default none (00)
    * 00: none
    * 01: OSC A
    * 10: OSC B
    * 11: Filter (if implemented)
* **parameter**: 4 bit, default none (00)
    * **If target = OSC A or OSC B:**
        * 0000: none
        * 0001: detune
        * 0010: finetune
        * 0011: panning
        * 0100: volume
        * other: none
    * **If target = Filter (if implemented):**
        * 0000: none
        * 0001: cutoff
        * 0010: resonance
        * other: none
    * **otherwise:**
        * XXXX = none
* **amount:** 7 bit (0%-100%), default 100% (1100101)
    * only use first 101 numbers, where 0%=0000000

## LFO Filter (if implemented, probably won't be)
* **rate:** 7 bit, default 110 (6Hz)
    * the decimal value of the number corresponds to the rate of the LFO (in Hertz)
    * 0000000 (0Hz), 1111111 (123 Hz)
* **shape:** 3 bit, default: sine wave
    * 000: sine wave
    * 001: square wave
    * 010: triangle wave
    * 011: saw wave
    * other: sine wave
    
    (might add more in the future)
* **target:** 4 bit, default none
    * 00: none
    * 01: OSC A
    * 10: OSC B
    * 11: Filter (if implemented)
* **parameter**: 4 bit, default none
    * **If target = OSC A or OSC B:**
        * 0000: none
        * 0001: detune
        * 0010: finetune
        * 0011: panning
        * 0100: volume
        * other: none
    * **If target = Filter (if implemented):**
        * 0000: none
        * 0001: cutoff
        * 0010: resonance
        * other: none
    * **otherwise:**
        * XXXX = none
* **amount:** 7 bit (0%-100%), default 100%
    * only use first 101 numbers, where 0%=0000000

## Filter (if implemented)
* *Note:* it will be implemented before LFO, if we do end up doing it
* **type:** 3 bit, default lowpass
    * 00: lowpass
    * 01: highpass
    * 10: bandpass
    * other: lowpass
* **cutoff:** 7 bit (0%-100%), default 100%
    * only use first 101 numbers, where 0%=0000000
* **resonance:** 7 bit (0%-100%), default 0%
    * only use first 101 numbers, where 0%=0000000
* **output:** 2 bit, default master (this is here for expandability purposes)
    * 00: master
    * other: master


## Other (Global) Parameters
* **octave:** 3 bit (-3, -2, -1, 0, +1, +2, +3), default: 0 (011)
    * only use first 7 numbers, where -3=000
    * This octave the octave offset of the keyboard input itself

## Input Parameters
* **SW[17:15]:** select module
    * 000: OSC A
    * 001: OSC B
    * 010: ADSR
    * 011: LFO (if implemented)
    * 100: Filter (if implemented)
    * otherwise: no module selection
* **SW[14:11]:** select parameter
    * **OSC A / OSC B:**
        * 0000: wave
        * 0001: unison
        * 0010: detune
        * 0011: finetune
        * 0100: semitone
        * 0101: octave
        * 0110: panning
        * 0111: volume
        * 1000: output
    * **ADSR:**
        * 0000: attack
        * 0001: decay
        * 0010: sustain
        * 0011: release
        * 0100: target
        * 0101: param
        * 0110: amount
        * otherwise: no parameter selection
    * **LFO (if implemented):**
        * 0000: rate
        * 0001: offset
        * 0010: wave
        * 0011: target
        * 0100: param
        * 0101: amount
        * otherwise: no parameter selection
    * **Filter (if implemented):**
        * 0000: type
        * 0001: resonance
        * 0011: output
        * otherwise: no parameter selection
* **SW[10:0]:** used for loading values into currently selected parameter
* **KEY[3:0]:** pressing any one of them will load the value into the currently selected parameter's register

