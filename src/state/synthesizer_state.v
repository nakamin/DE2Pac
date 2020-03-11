module synthesizer_state(
    // General inputs
    input clock,
    input [17:0] SW,
    input load, // Active high
    input resetn, // Active low
    
    // Key inputs
    input key1_on,
    input [7:0] key1_code,
    input key2_on,
    input [7:0] key2_code,

    // Global outputs
    output reg [2:0] GLOBAL_octave,

    // OSC A outputs
    output reg [2:0] OSCA_wave,
    output reg [1:0] OSCA_unison,
    output reg [6:0] OSCA_detune,
    output reg [7:0] OSCA_finetune,
    output reg [4:0] OSCA_semitone,
    output reg [2:0] OSCA_octave,
    output reg [6:0] OSCA_panning,
    output reg [6:0] OSCA_volume,
    output reg [1:0] OSCA_output,

    // OSC A outputs
    output reg [2:0] OSCB_wave,
    output reg [1:0] OSCB_unison,
    output reg [6:0] OSCB_detune,
    output reg [7:0] OSCB_finetune,
    output reg [4:0] OSCB_semitone,
    output reg [2:0] OSCB_octave,
    output reg [6:0] OSCB_panning,
    output reg [6:0] OSCB_volume,
    output reg [1:0] OSCB_output,

    // ASDR outputs
    output reg [11:0] ADSR1_attack,
    output reg [11:0] ASDR1_decay,
    output reg [6:0] ADSR1_sustain,
    output reg [11:0] ADSR1_release,
    output reg [3:0] ADSR1_target,
    output reg [3:0] ADSR1_parameter,
    output reg [6:0] ADSR1_amount
);
    // Module selection types
    localparam 
        SELECT_OSCA = 3'b000,
        SELECT_OSCB = 3'b001,
        SELECT_ASDR1 = 3'b010;

    // Oscillator selection types
    localparam
        SELECT_OSC_WAVE = 4'b0000,
        SELECT_OSC_UNISON = 4'b0001,
        SELECT_OSC_DETUNE = 4'b0010,
        SELECT_OSC_FINETUNE = 4'b0011,
        SELECT_OSC_SEMITONE = 4'b0100,
        SELECT_OSC_OCTAVE = 4'b0101,
        SELECT_OSC_PANNING = 4'b0110,
        SELECT_OSC_VOLUME = 4'b0111,
        SELECT_OSC_OUTPUT = 4'b1000;

    // ADSR selection types
    localparam
        SELECT_ADSR_ATTACK = 4'b0000,
        SELECT_ADSR_DECAY = 4'b0001,
        SELECT_ADSR_SUSTAIN = 4'b0010,
        SELECT_ADSR_RELEASE = 4'b0011,
        SELECT_ADSR_TARGET = 4'b0100,
        SELECT_ADSR_PARAM = 4'b0101,
        SELECT_ADSR_AMOUNT = 4'b0110;

    // Selection wires
    wire [2:0] module_select;
    assign module_select = SW[17:15];

    wire [3:0] parameter_select;
    assign parameter_select = SW[14:11];

    wire [10:0] curr_selection;
    assign curr_selection = SW[10:0];

    initial begin
        GLOBAL_octave = 3'b100;

        OSCA_wave = 3'b000;
        OSCA_unison = 2'b00;
        OSCA_detune = 7'b0110010;
        OSCA_finetune = 8'b01100101;
        OSCA_semitone = 5'b01101;
        OSCA_octave = 3'b100;
        OSCA_panning = 7'b0110011;
        OSCA_volume = 7'b1100101;
        OSCA_output = 2'b01;

        OSCB_wave = 3'b000;
        OSCB_unison = 2'b00;
        OSCB_detune = 7'b0110010;
        OSCB_finetune = 8'b01100101;
        OSCB_semitone = 5'b01101;
        OSCB_octave = 3'b100;
        OSCB_panning = 7'b0110011;
        OSCB_volume = 7'b1100101;
        OSCB_output = 2'b01;

        // TODO: these are guessed, pick some nice default values
        ADSR1_attack = 4'b0100;
        ASDR1_decay = 4'b0100;
        ADSR1_sustain = 4'b1111;
        ADSR1_release = 4'b0100;
        ADSR1_target = 2'b00;
        ADSR1_parameter = 4'b000;
        ADSR1_amount = 7'b1100101;
    end

    always @(posedge clock) begin
        // Load values
        if (load) begin
            case(module_select)
                SELECT_OSCA: begin
                    case(parameter_select)
                        SELECT_OSC_WAVE: OSCA_wave <= curr_selection[2:0];
                        SELECT_OSC_UNISON: OSCA_unison <= curr_selection[1:0];
                        SELECT_OSC_DETUNE: OSCA_detune <= curr_selection[6:0];
                        SELECT_OSC_FINETUNE: OSCA_finetune <= curr_selection[7:0];
                        SELECT_OSC_SEMITONE: OSCA_semitone <= curr_selection[4:0];
                        SELECT_OSC_OCTAVE: OSCA_octave <= curr_selection[2:0];
                        SELECT_OSC_PANNING: OSCA_panning <= curr_selection[6:0];
                        SELECT_OSC_VOLUME: OSCA_volume <= curr_selection[6:0];
                        SELECT_OSC_OUTPUT: OSCA_output <= curr_selection[1:0];
                    endcase
                end
                SELECT_OSCB: begin
                    case(parameter_select)
                        SELECT_OSC_WAVE: OSCB_wave <= curr_selection[2:0];
                        SELECT_OSC_UNISON: OSCB_unison <= curr_selection[1:0];
                        SELECT_OSC_DETUNE: OSCB_detune <= curr_selection[6:0];
                        SELECT_OSC_FINETUNE: OSCB_finetune <= curr_selection[7:0];
                        SELECT_OSC_SEMITONE: OSCB_semitone <= curr_selection[4:0];
                        SELECT_OSC_OCTAVE: OSCB_octave <= curr_selection[2:0];
                        SELECT_OSC_PANNING: OSCB_panning <= curr_selection[6:0];
                        SELECT_OSC_VOLUME: OSCB_volume <= curr_selection[6:0];
                        SELECT_OSC_OUTPUT: OSCB_output <= curr_selection[1:0];
                    endcase
                end
                SELECT_ASDR1: begin
                    case(parameter_select)
                        SELECT_ADSR_ATTACK: ADSR1_attack <= curr_selection[3:0];
                        SELECT_ADSR_DECAY: ASDR1_decay <= curr_selection[3:0];
                        SELECT_ADSR_SUSTAIN: ADSR1_sustain <= curr_selection[3:0];
                        SELECT_ADSR_RELEASE: ADSR1_release <= curr_selection[3:0];
                        SELECT_ADSR_TARGET: ADSR1_target <= curr_selection[3:0];
                        SELECT_ADSR_PARAM: ADSR1_parameter <= curr_selection[3:0];
                        SELECT_ADSR_AMOUNT: ADSR1_amount <= curr_selection[6:0];
                    endcase
                end
            endcase 
        end
    end

    // Global octave counter
    always @(posedge key1_on) 
    begin
        if (key1_on) begin
            // Up arrow and < 6 (+3)
            if (key1_code == 8'hE075 & GLOBAL_octave < 3'b110) begin
                GLOBAL_octave <= GLOBAL_octave + 1'b1;
            end
            // Down arrow and > 0 (-3)
            else if (key1_code == 8'hE072 & GLOBAL_octave > 3'b000) begin
                GLOBAL_octave <= GLOBAL_octave - 1'b1; 
            end
        end
    end
endmodule