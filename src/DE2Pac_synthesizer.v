module DE2Pac_synthesizer (
    // -- Clock --
    CLOCK_50,

    // -- Key --
	KEY,

    // -- Switch --
    SW,

    // -- LED --
	LEDG,
	LEDR,

    // -- HEX --
    HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7,

    // -- Audio --
	AUD_ADCDAT,
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,
	AUD_XCK,
	AUD_DACDAT,

    // -- I2C --
	I2C_SDAT,
	I2C_SCLK,

	// -- PS2 --
    PS2_KBCLK,
	PS2_KBDAT,

    // -- VGA --
    VGA_R,
    VGA_B,
    VGA_G,
    VGA_HS,
    VGA_VS,
    VGA_BLANK_N,
    VGA_SYNC_N,
    VGA_CLK
);
    // -----------------------
    // --- IO Declarations ---
    // -----------------------
    // -- Clock --
    input CLOCK_50;

    // -- Key --
    input [3:0] KEY;

    // -- Switch --
    input [17:0] SW;

    // -- PS2 --
    inout PS2_KBCLK;
    inout PS2_KBDAT;

    // -- LED --
	output [8:0] LEDG;
	output [17:0] LEDR;

	// -- HEX --
    output [6:0] HEX0;
    output [6:0] HEX1;
    output [6:0] HEX2;
    output [6:0] HEX3;
    output [6:0] HEX4;
    output [6:0] HEX5;
    output [6:0] HEX6;
    output [6:0] HEX7;

    // -- Audio --
    input AUD_ADCDAT;
    inout AUD_BCLK;
    inout AUD_ADCLRCK;
    inout AUD_DACLRCK; // Output clock of audio stream, runs at 48kHz in our project
    output AUD_XCK;
    output AUD_DACDAT;

    // -- I2C --
    inout I2C_SDAT;
    output I2C_SCLK;

    // -- VGA --
    output VGA_CLK;   				//	VGA Clock
	output VGA_HS;					//	VGA H_SYNC
	output VGA_VS;					//	VGA V_SYNC
	output VGA_BLANK_N;				//	VGA BLANK
	output VGA_SYNC_N;				//	VGA SYNC
	output [9:0] VGA_R;   			//	VGA Red[9:0]
	output [9:0] VGA_G;	 			//	VGA Green[9:0]
	output [9:0] VGA_B;   			//	VGA Blue[9:0]

    // -------------------------
    // --- Wire Declarations ---
    // -------------------------
    wire audio_in_available;
    wire [16:0]	left_channel_audio_in;
    wire [16:0]	right_channel_audio_in;
    wire read_audio_in;

    wire audio_out_allowed;
    wire [16:0]	left_channel_audio_out;
    wire [16:0]	right_channel_audio_out;
    wire write_audio_out;

    wire key1_on;
    wire key2_on;
    wire [7:0] key1_code;
    wire [7:0] key2_code;

    // -------------
    // --- State ---
    // -------------
    wire load;
    assign load = ~(KEY[0] & KEY[1] & KEY[2] & KEY[3]);
    
    wire [2:0] GLOBAL_octave;

    wire [2:0] OSCA_wave;
    wire [1:0] OSCA_unison;
    wire [6:0] OSCA_detune;
    wire [7:0] OSCA_finetune;
    wire [4:0] OSCA_semitone;
    wire [2:0] OSCA_octave;
    wire [6:0] OSCA_panning;
    wire [6:0] OSCA_volume;
    wire [1:0] OSCA_output;

    wire [2:0] OSCB_wave;
    wire [1:0] OSCB_unison;
    wire [6:0] OSCB_detune;
    wire [7:0] OSCB_finetune;
    wire [4:0] OSCB_semitone;
    wire [2:0] OSCB_octave;
    wire [6:0] OSCB_panning;
    wire [6:0] OSCB_volume;
    wire [1:0] OSCB_output;

    wire [11:0] ADSR1_attack;
    wire [11:0] ASDR1_decay;
    wire [6:0] ADSR1_sustain;
    wire [11:0] ADSR1_release;
    wire [3:0] ADSR1_target;
    wire [3:0] ADSR1_parameter;
    wire [6:0] ADSR1_amount;
    
    synthesizer_state state(
        // Inputs
        .clock(CLOCK_50),
        .SW(SW[17:0]),
        .load(load),
        .resetn(1'b1), // TODO: unhardcode

        .key1_on(key1_on),
        .key1_code(key1_code),
        .key2_on(key2_on),
        .key2_code(key2_code),

        // Outputs
        .GLOBAL_octave(GLOBAL_octave),

        .OSCA_wave(OSCA_wave),
        .OSCA_unison(OSCA_unison),
        .OSCA_detune(OSCA_detune),
        .OSCA_finetune(OSCA_finetune),
        .OSCA_semitone(OSCA_semitone),
        .OSCA_octave(OSCA_octave),
        .OSCA_panning(OSCA_panning),
        .OSCA_volume(OSCA_volume),
        .OSCA_output(OSCA_output),

        .OSCB_wave(OSCB_wave),
        .OSCB_unison(OSCB_unison),
        .OSCB_detune(OSCB_detune),
        .OSCB_finetune(OSCB_finetune),
        .OSCB_semitone(OSCB_semitone),
        .OSCB_octave(OSCB_octave),
        .OSCB_panning(OSCB_panning),
        .OSCB_volume(OSCB_volume),
        .OSCB_output(OSCB_output),

        .ADSR1_attack(ADSR1_attack),
        .ASDR1_decay(ASDR1_decay),
        .ADSR1_sustain(ADSR1_sustain),
        .ADSR1_release(ADSR1_release),
        .ADSR1_target(ADSR1_target),
        .ADSR1_parameter(ADSR1_parameter),
        .ADSR1_amount(ADSR1_amount)
    );

    // -------------------
    // --- Synthesizer ---
    // -------------------
    // TODO: implement


    // ----------------
    // --- VGA View ---
    // ----------------
    vga_adapter VGA(
			.resetn(1), // HARDCODE always on, never resets
			.clock(CLOCK_50),
			.colour(3'b100), // HARDCODE red boi
			.x(7'd80), // HARDCODE
			.y(6'd60), // HARDCODE
			.plot(1'b1), // HARDCODE always on
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";


    // ------------------------
    // --- Audio Controller ---
    // ------------------------
    // (adapted from Audio Controller demo project)
    Audio_Controller Audio_Controller (
        // Inputs
        .CLOCK_50 (CLOCK_50),
        .reset (~KEY[0]), // TODO: convert to use resetn

        .clear_audio_in_memory (),
        .read_audio_in (read_audio_in),
        
        .clear_audio_out_memory (),
        .left_channel_audio_out	(left_channel_audio_out),
        .right_channel_audio_out (right_channel_audio_out),
        .write_audio_out (write_audio_out),

        .AUD_ADCDAT (AUD_ADCDAT),

        // Bidirectionals
        .AUD_BCLK (AUD_BCLK),
        .AUD_ADCLRCK (AUD_ADCLRCK),
        .AUD_DACLRCK (AUD_DACLRCK),


        // Outputs
        .audio_in_available (audio_in_available),
        .left_channel_audio_in (left_channel_audio_in),
        .right_channel_audio_in (right_channel_audio_in),

        .audio_out_allowed (audio_out_allowed),

        .AUD_XCK (AUD_XCK),
        .AUD_DACDAT (AUD_DACDAT)
    );

    // -----------------------------------------------
    // --- Audio and Video-in Configuration Module ---
    // -----------------------------------------------
    // (adapted from Audio Controller demo project)
    avconf avc (
        .I2C_SCLK (I2C_SCLK),
        .I2C_SDAT (I2C_SDAT),
        .CLOCK_50 (CLOCK_50),
        .reset (~KEY[0]) // TODO: convert to use resetn
    );

	// -------------------------
    // --- PS2 Keyboard Scan ---
    // -------------------------
    // (adapted from DE2_115_Synthesizer demo project)
    wire key1_on_raw;
    wire key2_on_raw;

    reg [31:0] VGA_CLKo;
    wire keyboard_sysclk;
    assign keyboard_sysclk = VGA_CLKo[12];
    wire [7:0] scan_code;

    always @(posedge CLOCK_50)
    begin
        VGA_CLKo <= VGA_CLKo + 1;
    end

    // Debounce key1_on signal
    Debouncer1Bit d1b_key1_on(
        .clock(CLOCK_50),
        .in(key1_on_raw),
        .out(key1_on)
    );

    // Debounce key2_on signal
    Debouncer1Bit d1b_key2_on(
        .clock(CLOCK_50),
        .in(key2_on_raw),
        .out(key2_on)
    );

    ps2_keyboard keyboard(
        .iCLK_50(CLOCK_50),
        .ps2_dat(PS2_KBDAT), // PS2 bus data
        .ps2_clk(PS2_KBCLK), // PS2 bus clock
        .sys_clk(keyboard_sysclk), // System clock
        .reset(KEY[3]), // System reset, active low TODO: convert to use resetn
        .reset1(KEY[2]), // Keyboard reset, active low TODO: convert to use resetn
        .scandata(scan_code), // Scan code
        .key1_on(key1_on_raw), // Key1 trigger
        .key2_on(key2_on_raw), // Key2 trigger
        .key1_code(key1_code), // Key1 code
        .key2_code(key2_code) // Key2 code
    );

    // ========================
    // === TESTS AREA BELOW ===
    // ========================

    // ---------------------
    // --- Note LUT Test ---
    // ---------------------
    // TODO: remove this stuff
    wire [6:0] note;

    assign LEDG[6:0] = note;
    // assign LEDR[0] = key1_on;
    // assign LEDR[17:10] = key1_code;
    // assign LEDR[3:1] = GLOBAL_octave;

    noteLUT nlut(
        .key_code(key1_code),
        .enable(key1_on),
        .GLOBAL_octave(GLOBAL_octave),
        .note(note)
    );

// 18-0
    wire [27:0] init_counter;
    // assign LEDR[17:0] = init_counter[17:0];
    frequencyLUT flut(
        .note(note),
        .init_counter(init_counter)
    );

    wire freqClk;
    frequencyClockGenerator fClkGen(
        .CLOCK_50(CLOCK_50),
        .note(note),
        .pulse(freqClk)
    );

    // assign LEDG[7] = freqClk;


    reg snd;

    // initial
    // begin
    //     snd = 1'b0;
    // end

    // always @ (posedge freqClk)
    // begin
    //     snd <= 1'b1 - snd;
    // end

    reg [3:0] count;
    always @ (posedge freqClk)
    begin
        count <= count + 1'b1;
    end

    // assign LEDG[7] = snd;
    assign LEDR[3:0] = count;

    // wire [15:0] sound = snd ? 16'b1 : -16'b1;
    // assign left_channel_audio_out = sound;
    // assign right_channel_audio_out = sound;



    // -----------------------
    // --- Temp Sound Test ---
    // -----------------------
    // TODO: remove this stuff
    // reg [18:0] delay_cnt;
    // wire [18:0] delay;
    // reg snd;

    // wire [27:0] count_init;
    // reg [27:0] count;
    // reg [15:0] ampl;

    // assign count_init = 28'b0000000001111010000100100000 - 1'b1;
    // wire pulse = (count == 28'b0000000000000000000000000000) ? 1'b1 : 1'b0;

    // always @ (posedge CLOCK_50)
    // begin
    //     if (count == 0)
    //         count <= count_init;
    //     else
    //         count <= count - 1'b1;
    // end

    // always @ (posedge pulse)
    // begin
    //     if (~KEY[0]) ampl <= 0;
    //     else if (~SW[0]) ampl <= ampl + 1'b1;
    // end

    // HexDecoder h0(
    //     .in(ampl[3:0]),
    //     .out(HEX0)
    // );

    // HexDecoder h1(
    //     .in(ampl[7:4]),
    //     .out(HEX1)
    // );

    // HexDecoder h2(
    //     .in(ampl[11:8]),
    //     .out(HEX2)
    // );

    // HexDecoder h3(
    //     .in(ampl[15:12]),
    //     .out(HEX3)
    // );

    // always @(posedge CLOCK_50)
    //     if(delay_cnt == delay) begin
    //         delay_cnt <= 0;
    //         snd <= !snd;
    // 	end else delay_cnt <= delay_cnt + 1;

    // assign delay = {4'b1111, 15'd3000};

    // wire [31:0] sound = snd ? ampl : -ampl;

    // assign read_audio_in = audio_in_available & audio_out_allowed;
    // assign left_channel_audio_out = sound;
    // assign right_channel_audio_out = sound;
    // assign write_audio_out = audio_in_available & audio_out_allowed;

    // --------------------------
    // --- Temp Keyboard Test ---
    // --------------------------
    // TODO: remove this stuff
	// assign LEDG[7:0] = scan_code;
	// assign LEDR[0] = key1_on;
	// assign LEDR[1] = key2_on;
	// assign LEDR[17:10] = key1_code;
	// assign LEDR[9:2] = key2_code;

    // ----------------------
    // --- Temp state test --
    // ----------------------
    // TODO: remove this stuff
    // assign LEDG[2:0] = GLOBAL_octave;
    // assign LEDG[5:3] = OSCA_wave;

    // assign LEDR[3] = (key1_on & key1_code == 8'h75) ? 1 : 0; // Up arrow
    // assign LEDR[2] = (key1_on & key1_code == 8'h72) ? 1 : 0; // Down arrow
endmodule
