module noteLUT(
    input [7:0] key_code,
    input enable, // Active high
    input [2:0] GLOBAL_octave,
    output [6:0] note
);
    // note_map Values:
    // - 0000 (0): C
    // - 0001 (1): C#
    // - 0010 (2): D
    // - 0011 (3): D#
    // - 0100 (4): E
    // - 0101 (5): F
    // - 0111 (6): F#
    // - 1000 (7): G
    // - 1001 (8): G#
    // - 1010 (9): A
    // - 1011 (10): A#
    // - 1100 (11): B
    // - other: none

    localparam
        NOTE_C = 7'd0,
        NOTE_Csh = 7'd1,
        NOTE_D = 7'd2,
        NOTE_Dsh = 7'd3,
        NOTE_E = 7'd4,
        NOTE_F = 7'd5,
        NOTE_Fsh = 7'd6,
        NOTE_G = 7'd7,
        NOTE_Gsh = 7'd8,
        NOTE_A = 7'd9,
        NOTE_Ash = 7'd10,
        NOTE_B = 7'd11;

    // Note values:
    // Formula: note = note_map[note] + (12 * octave), where octave in [0, 8]
    // - 0000000 (0): C0 <- lowest note
    // - 0000001 (1): C#0
    // - 0000010 (2): D0
    // ...
    // - 0001100 (12): C1
    // - 0001101 (13): C#1
    // - 0001110 (14): D#1
    // ...
    // - 0111100 (60): C5
    // - 0111101 (61): C#5
    // ...
    // - 1100000 (96): C8
    // - 1100001 (97): C#8
    // ...
    // - 1101011 (107): B8 <- highest note

    // Formula: note = note_map[note] + 12 * (offset_octave + GLOBAL_octave - 3), where offset_octave in [0, 8]

    wire [6:0] GLOBAL_octave_sub;
    assign GLOBAL_octave_sub = GLOBAL_octave + 7'd2;

    assign note = (
    (enable == 1'b0) ? 7'b0111111 : (
    (key_code == 8'h15) ? (NOTE_C + 7'd12 * (7'd0 + GLOBAL_octave_sub)): (//   Q  = C (+0)
    (key_code == 8'h1E) ? (NOTE_Csh + 7'd12 * (7'd0 + GLOBAL_octave_sub)): (// 2  = C# (+0) 
    (key_code == 8'h1D) ? (NOTE_D + 7'd12 * (7'd0 + GLOBAL_octave_sub)): (//   W  = D  (+0) 
    (key_code == 8'h26) ? (NOTE_Dsh + 7'd12 * (7'd0 + GLOBAL_octave_sub)): (// 3  = D# (+0)
    (key_code == 8'h24) ? (NOTE_E + 7'd12 * (7'd0 + GLOBAL_octave_sub)): (//   E  = E  (+0)
    (key_code == 8'h2D) ? (NOTE_F + 7'd12 * (7'd0 + GLOBAL_octave_sub)): (//   R  = F  (+0)
    (key_code == 8'h2E) ? (NOTE_Fsh + 7'd12 * (7'd0 + GLOBAL_octave_sub)): (// 5  = F# (+0)
    (key_code == 8'h2C) ? (NOTE_G + 7'd12 * (7'd0 + GLOBAL_octave_sub)): (//   T  = G  (+0)
    (key_code == 8'h36) ? (NOTE_Gsh + 7'd12 * (7'd0 + GLOBAL_octave_sub)): (// 6  = G# (+0)
    (key_code == 8'h35) ? (NOTE_A + 7'd12 * (7'd0 + GLOBAL_octave_sub)): (//   Y  = A  (+0)
    (key_code == 8'h3D) ? (NOTE_Ash + 7'd12 * (7'd0 + GLOBAL_octave_sub)): (// 7  = A# (+0)
    (key_code == 8'h3C) ? (NOTE_B + 7'd12 * (7'd0 + GLOBAL_octave_sub)): (//   U  = B  (+0)
    (key_code == 8'h43) ? (NOTE_C + 7'd12 * (7'd1 + GLOBAL_octave_sub)): (// I    = C  (+1) 
    (key_code == 8'h46) ? (NOTE_Csh + 7'd12 * (7'd1 + GLOBAL_octave_sub)): (// 9  = C# (+1)
    (key_code == 8'h44) ? (NOTE_D + 7'd12 * (7'd1 + GLOBAL_octave_sub)): (// O    = D  (+1)
    (key_code == 8'h45) ? (NOTE_Dsh + 7'd12 * (7'd1 + GLOBAL_octave_sub)): (// 0  = D# (+1)
    (key_code == 8'h4D) ? (NOTE_E + 7'd12 * (7'd1 + GLOBAL_octave_sub)): (// P    = E  (+1)
    (key_code == 8'h54) ? (NOTE_F + 7'd12 * (7'd1 + GLOBAL_octave_sub)): (// [{   = F  (+1)
    (key_code == 8'h55) ? (NOTE_Fsh + 7'd12 * (7'd1 + GLOBAL_octave_sub)): (// += = F# (+1)
    (key_code == 8'h5B) ? (NOTE_G + 7'd12 * (7'd1 + GLOBAL_octave_sub)): (// }]   = G  (+1)
    (key_code == 8'h1A) ? (NOTE_C + 7'd12 * (-7'd1 + GLOBAL_octave_sub)): (// Z   = C  (-1)
    (key_code == 8'h1B) ? (NOTE_Csh + 7'd12 * (-7'd1 + GLOBAL_octave_sub)): (// S = C# (-1)
    (key_code == 8'h22) ? (NOTE_D + 7'd12 * (-7'd1 + GLOBAL_octave_sub)): (// X   = D  (-1)
    (key_code == 8'h23) ? (NOTE_Dsh + 7'd12 * (-7'd1 + GLOBAL_octave_sub)): (// D = D# (-1)
    (key_code == 8'h21) ? (NOTE_E + 7'd12 * (-7'd1 + GLOBAL_octave_sub)): (// C   = E  (-1)
    (key_code == 8'h2A) ? (NOTE_F + 7'd12 * (-7'd1 + GLOBAL_octave_sub)): (// V   = F  (-1)
    (key_code == 8'h34) ? (NOTE_Fsh + 7'd12 * (-7'd1 + GLOBAL_octave_sub)): (// G = F# (-1)
    (key_code == 8'h32) ? (NOTE_G + 7'd12 * (-7'd1 + GLOBAL_octave_sub)): (// B   = G  (-1)
    (key_code == 8'h33) ? (NOTE_Gsh + 7'd12 * (-7'd1 + GLOBAL_octave_sub)): (// H = G# (-1)
    (key_code == 8'h31) ? (NOTE_A + 7'd12 * (-7'd1 + GLOBAL_octave_sub)): (// N   = A  (-1)
    (key_code == 8'h3B) ? (NOTE_Ash + 7'd12 * (-7'd1 + GLOBAL_octave_sub)): (// J = A# (-1)
    (key_code == 8'h3A) ? (NOTE_B + 7'd12 * (-7'd1 + GLOBAL_octave_sub)): (// M   = B  (-1) 
    (key_code == 8'h41) ? (NOTE_C + 7'd12 * (-7'd2 + GLOBAL_octave_sub)): (// <,  = C  (-2)
    (key_code == 8'h4B) ? (NOTE_Csh + 7'd12 * (-7'd2 + GLOBAL_octave_sub)): (// L = C# (-2)
    (key_code == 8'h49) ? (NOTE_D + 7'd12 * (-7'd2 + GLOBAL_octave_sub)): (// >.  = D  (-2)
    (key_code == 8'h4C) ? (NOTE_Dsh + 7'd12 * (-7'd2 + GLOBAL_octave_sub)): (//:; = D# (-2)
    (key_code == 8'h4A) ? (NOTE_E + 7'd12 * (-7'd2 + GLOBAL_octave_sub)) // ?/    = E  (-2) 
    : 7'b0111111 // One above max note value (ie no note)
    ))))))))))))))))))))))))))))))))))))));
endmodule