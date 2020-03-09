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
* **detune:** 7 bit (0%-100%), default 50%
    * only use the first 101 numbers, where 0%=0000000
* **finetune**: 8 bit (-100 cent, ..., 0 cent, ..., +100 cent), default 0 cent
    * only use the first 201 numbers, where -100 cent = 00000000
* **semitone:** 5 bit (-12, ..., -1, 0, +1 , ..., +12), default: 0
    * only use first 25 numbers, where -12=00000
* **octave:** 3 bit (-3, -2, -1, 0, +1, +2, +3), default: 0
    * only use first 7 numbers, where -3=000
* **panning:** 7 bit (-50L, ..., -1L, 0C, +1R, ..., +50R): default: OC
    * only use first 101 numbers, where -50L=0000000, 0C=0110010, +50L=1100101
* **volume:** 7 bit (0%-100%), default 100%
    * only use first 101 numbers, where 0%=0000000
* **output:** 2 bit, default master
    * 00: master
    * 01: filter (if implemented)
    * other: master

## ADSR Envelope
* **attack:** 12 bit, (0ms-4095ms) default 000001100100 (100ms)
    * the decimal value of the number corresponds to the number of milliseconds
    * 000000000000 (0ms), 111111111111 (4095ms = 4.095s)
* **decay:** 12 bit, (0ms-4095ms) default 000001100100 (100ms)
    * the decimal value of the number corresponds to the number of milliseconds
    * 000000000000 (0ms), 111111111111 (4095ms = 4.095s)
* **sustain:** 7 bit (0%-100%), default 100%
    * only use first 101 numbers, where 0%=0000000
* **release:** 12 bit, (0ms-4095ms) default 000001100100 (100ms)
    * the decimal value of the number corresponds to the number of milliseconds
    * 000000000000 (0ms), 111111111111 (4095ms = 4.095s)
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
