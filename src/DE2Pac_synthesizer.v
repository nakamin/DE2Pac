module DE2Pac_synthesizer (
	// Inputs
	CLOCK_50,
	CLOCK_27,
	KEY,

	AUD_ADCDAT,

	// Bidirectionals
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,

	I2C_SDAT,

	// Outputs
	AUD_XCK,
	AUD_DACDAT,

	I2C_SCLK,
	SW,

	// -- PS2 --
    PS2_KBCLK,
	PS2_KBDAT,

	// -- HEX --
    HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7,
	
	LEDG,
	LEDR
);

    // -- PS2 --
    inout PS2_KBCLK;
    inout PS2_KBDAT;

    wire key1_on;
    wire key2_on;
    wire [7:0] key1_code;
    wire [7:0] key2_code;

	// -- HEX --
    output [6:0] HEX0;
    output [6:0] HEX1;
    output [6:0] HEX2;
    output [6:0] HEX3;
    output [6:0] HEX4;
    output [6:0] HEX5;
    output [6:0] HEX6;
    output [6:0] HEX7;

	output [8:0] LEDG;
	output [17:0] LEDR;
/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input				CLOCK_50;
input				CLOCK_27;
input		[3:0]	KEY;
input		[17:0]	SW;

input				AUD_ADCDAT;

// Bidirectionals
inout				AUD_BCLK;
inout				AUD_ADCLRCK;
inout				AUD_DACLRCK;

inout				I2C_SDAT;

// Outputs
output				AUD_XCK;
output				AUD_DACDAT;

output				I2C_SCLK;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
wire				audio_in_available;
wire		[31:0]	left_channel_audio_in;
wire		[31:0]	right_channel_audio_in;
wire				read_audio_in;

wire				audio_out_allowed;
wire		[31:0]	left_channel_audio_out;
wire		[31:0]	right_channel_audio_out;
wire				write_audio_out;

// Internal Registers

reg [18:0] delay_cnt;
wire [18:0] delay;
reg snd;

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

always @(posedge CLOCK_50)
	if(delay_cnt == delay) begin
		delay_cnt <= 0;
		snd <= !snd;
	end else delay_cnt <= delay_cnt + 1;

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign delay = {SW[3:0], 15'd3000};

wire [31:0] sound = (SW == 0) ? 0 : snd ? 32'd5000000 << SW[17:16] : -32'd5000000 << SW[17:16];


assign read_audio_in			= audio_in_available & audio_out_allowed;

assign left_channel_audio_out	= sound;
assign right_channel_audio_out	= sound;
assign write_audio_out			= audio_in_available & audio_out_allowed;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

Audio_Controller Audio_Controller (
	// Inputs
	.CLOCK_50						(CLOCK_50),
	.reset						(~KEY[0]),

	.clear_audio_in_memory		(),
	.read_audio_in				(read_audio_in),
	
	.clear_audio_out_memory		(),
	.left_channel_audio_out		(left_channel_audio_out),
	.right_channel_audio_out	(right_channel_audio_out),
	.write_audio_out			(write_audio_out),

	.AUD_ADCDAT					(AUD_ADCDAT),

	// Bidirectionals
	.AUD_BCLK					(AUD_BCLK),
	.AUD_ADCLRCK				(AUD_ADCLRCK),
	.AUD_DACLRCK				(AUD_DACLRCK),


	// Outputs
	.audio_in_available			(audio_in_available),
	.left_channel_audio_in		(left_channel_audio_in),
	.right_channel_audio_in		(right_channel_audio_in),

	.audio_out_allowed			(audio_out_allowed),

	.AUD_XCK					(AUD_XCK),
	.AUD_DACDAT					(AUD_DACDAT),

);

avconf avc (
	.I2C_SCLK					(I2C_SCLK),
	.I2C_SDAT					(I2C_SDAT),
	.CLOCK_50					(CLOCK_50),
	.reset						(~KEY[0])
);

// --- Temp Keyboard Test ---
    // TODO: remove this stuff
    // HexDecoder h0(
    //     .in((key1_on) ? key1_code[3:0] : 4'b0),
    //     .out(HEX0)
    // );
    // HexDecoder h1(
    //     .in((key1_on) ? key1_code[7:4] : 4'b0),
    //     .out(HEX1)
    // );
    // HexDecoder h2(
    //     .in((key2_on) ? key2_code[3:0] : 4'b0),
    //     .out(HEX2)
    // );
    // HexDecoder h3(
    //     .in((key2_on) ? key2_code[7:4] : 4'b0),
    //     .out(HEX3)
    // );
	assign LEDG[7:0] = scan_code;
	assign LEDR[1] = key1_on;
	assign LEDR[0] = key2_on;
	assign LEDR[17:10] = key1_code;
	assign LEDR[9:2] = key2_code;

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
        .reset(KEY[3]), // System reset, active low
        .reset1(KEY[2]), // Keyboard reset, active low
        .scandata(scan_code), // Scan code
        .key1_on(key1_on), // Key1 trigger
        .key2_on(key2_on), // Key2 trigger
        .key1_code(key1_code), // Key1 code
        .key2_code(key2_code) // Key2 code
    );

endmodule
