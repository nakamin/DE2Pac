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

	I2C_SDAT,

	AUD_XCK,
	AUD_DACDAT,

	I2C_SCLK,

	// -- PS2 --
    PS2_KBCLK,
	PS2_KBDAT
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

    inout I2C_SDAT;

    output AUD_XCK;
    output AUD_DACDAT;

    output I2C_SCLK;

    // -------------------------
    // --- Wire Declarations ---
    // -------------------------

    wire audio_in_available;
    wire [31:0]	left_channel_audio_in;
    wire [31:0]	right_channel_audio_in;
    wire read_audio_in;

    wire audio_out_allowed;
    wire [31:0]	left_channel_audio_out;
    wire [31:0]	right_channel_audio_out;
    wire write_audio_out;

    wire key1_on;
    wire key2_on;
    wire [7:0] key1_code;
    wire [7:0] key2_code;

    // -----------------------
    // --- Temp Sound Test ---
    // -----------------------
    // TODO: remove this stuff
    reg [18:0] delay_cnt;
    wire [18:0] delay;
    reg snd;

    always @(posedge CLOCK_50)
        if(delay_cnt == delay) begin
            delay_cnt <= 0;
            snd <= !snd;
    	end else delay_cnt <= delay_cnt + 1;

    assign delay = {SW[3:0], 15'd3000};

    wire [31:0] sound = (SW == 0) ? 0 : snd ? 32'd5000000 << SW[17:16] : -32'd5000000 << SW[17:16];
    assign read_audio_in = audio_in_available & audio_out_allowed;

    assign left_channel_audio_out = sound;
    assign right_channel_audio_out = sound;
    assign write_audio_out = audio_in_available & audio_out_allowed;

    // --------------------------
    // --- Temp Keyboard Test ---
    // --------------------------
    // TODO: remove this stuff
	assign LEDG[7:0] = scan_code;
	assign LEDR[1] = key1_on;
	assign LEDR[0] = key2_on;
	assign LEDR[17:10] = key1_code;
	assign LEDR[9:2] = key2_code;

    // -------------------
    // --- Synthesizer ---
    // -------------------
    // TODO: implement


    // ----------------
    // --- VGA View ---
    // ----------------
    // TODO: implement


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
    reg [31:0] VGA_CLKo;
    wire keyboard_sysclk;
    assign keyboard_sysclk = VGA_CLKo[12];
    wire [7:0] scan_code;

    always @(posedge CLOCK_50)
    begin
        VGA_CLKo <= VGA_CLKo + 1;
    end

    ps2_keyboard keyboard(
        .iCLK_50(CLOCK_50),
        .ps2_dat(PS2_KBDAT), // PS2 bus data
        .ps2_clk(PS2_KBCLK), // PS2 bus clock
        .sys_clk(keyboard_sysclk), // System clock
        .reset(KEY[3]), // System reset, active low TODO: convert to use resetn
        .reset1(KEY[2]), // Keyboard reset, active low TODO: convert to use resetn
        .scandata(scan_code), // Scan code
        .key1_on(key1_on), // Key1 trigger
        .key2_on(key2_on), // Key2 trigger
        .key1_code(key1_code), // Key1 code
        .key2_code(key2_code) // Key2 code
    );

endmodule
