module ps2_keyboard(input	iCLK_50,
                    inout ps2_dat,
                    input ps2_clk,
                    input sys_clk,
                    input reset,
                    input reset1,
                    output reg[7:0]scandata,
                    output reg key1_on,
                    output reg key2_on,
                    output reg [7:0]key1_code,
                    output reg [7:0]key2_code);


////////////Keyboard Initially/////////
reg [10:0] MCNT;
always @(negedge reset or posedge sys_clk)
begin
    if (!reset)
        MCNT = 0;
    else if (MCNT < 500)
        MCNT = MCNT+1;
        //		else if (!is_key && (key1_code! = keycode_o))
        //			MCNT = 0;
        end
    
    ///// sequence generator /////
    //	reg	[7:0]	revcnt;
    wire rev_tr = (MCNT<12)?1:0;
    
    //	always @(posedge rev_tr or posedge ps2_clk)
    //	begin
    //		if (rev_tr)
    //			revcnt = 0;
    //		else if (revcnt > = 10)
    //			revcnt = 0;
    //		else
    //			revcnt = revcnt+1;
    //	end
    
    //////KeyBoard serial data in /////
    //	reg [9:0]keycode_o;
    //	always @(posedge ps2_clk) begin
    //		case (revcnt[3:0])
    //		1:keycode_o[0] = ps2_dat;
    //		2:keycode_o[1] = ps2_dat;
    //		3:keycode_o[2] = ps2_dat;
    //		4:keycode_o[3] = ps2_dat;
    //		5:keycode_o[4] = ps2_dat;
    //		6:keycode_o[5] = ps2_dat;
    //		7:keycode_o[6] = ps2_dat;
    //		8:keycode_o[7] = ps2_dat;
    //		endcase
    //	end
    wire [7:0]rc  = keycode_o;
    wire HOST_ACK = (revcnt == 10)?~(rc[7]^rc[6]^rc[5]^rc[4]^rc[3]^rc[2]^rc[1]^rc[0]) :1;
    //////////PS2 InOut/////////
    //	assign   ps2_dat = (HOST_ACK)?1'bz:1'b0;
    
    
    ///////KeyBoard Scan-Code trigger//////
    reg keyready;
    always @(posedge rev_tr or negedge ps2_clk) begin
        if (rev_tr)
            keyready = 0;
        else if (revcnt[3:0] == 10)
            keyready = 1;
        else
            keyready = 0;
    end
    /////////////////////////////////////Key1-Key2 Output///////////////////////////
    wire is_key = (
    (keycode_o == 8'h15) ? 1: (// Q
    (keycode_o == 8'h1E) ? 1: (// 2
    (keycode_o == 8'h1D) ? 1: (// W
    (keycode_o == 8'h26) ? 1: (// 3
    (keycode_o == 8'h24) ? 1: (// E
    (keycode_o == 8'h2D) ? 1: (// R
    (keycode_o == 8'h2E) ? 1: (// 5
    (keycode_o == 8'h2C) ? 1: (// T
    (keycode_o == 8'h36) ? 1: (// 6
    (keycode_o == 8'h35) ? 1: (// Y
    (keycode_o == 8'h3D) ? 1: (// 7
    (keycode_o == 8'h3C) ? 1: (// U
    (keycode_o == 8'h43) ? 1: (// I
    (keycode_o == 8'h46) ? 1: (// 9
    (keycode_o == 8'h44) ? 1: (// O
    (keycode_o == 8'h45) ? 1: (// 0
    (keycode_o == 8'h4D) ? 1: (// P
    (keycode_o == 8'h54) ? 1: (// [{
    (keycode_o == 8'h55) ? 1: (// + = 
    (keycode_o == 8'h5B) ? 1: (// }]
    (keycode_o == 8'h1A) ? 1: (// Z
    (keycode_o == 8'h1B) ? 1: (// S
    (keycode_o == 8'h22) ? 1: (// X
    (keycode_o == 8'h23) ? 1: (// D
    (keycode_o == 8'h21) ? 1: (// C
    (keycode_o == 8'h2A) ? 1: (// V
    (keycode_o == 8'h34) ? 1: (// G
    (keycode_o == 8'h32) ? 1: (// B
    (keycode_o == 8'h33) ? 1: (// H
    (keycode_o == 8'h31) ? 1: (// N
    (keycode_o == 8'h3B) ? 1: (// J
    (keycode_o == 8'h3A) ? 1: (// M
    (keycode_o == 8'h41) ? 1: (// <,
    (keycode_o == 8'h4B) ? 1: (// L
    (keycode_o == 8'h49) ? 1: (// >.
    (keycode_o == 8'h4C) ? 1: (// :;
    (keycode_o == 8'h4A) ? 1: (// ?/
    (keycode_o == 8'h75) ? 1: (// Up Arrow
    (keycode_o == 8'h72) ? 1: 0 // Down Arrow
    ))))))))))))))))))))))))))))))))))))))
    );
    
    //////////////key1 & key2 Assign///////////
    wire keyboard_off = ((MCNT == 200) || (!reset1))?0:1;
    
    always @(posedge keyready) scandata = keycode_o;
    
    always @(negedge keyboard_off  or posedge keyready)
    begin
        if (!keyboard_off)
        begin
            key1_on   = 0;
            key2_on   = 0;
            key1_code = 8'hf0;
            key2_code = 8'hf0;
        end
        else if (scandata == 8'hf0)
        begin
            if (keycode_o == key1_code)
            begin
                key1_code = 8'hf0;
                key1_on   = 0;
            end
            else if (keycode_o == key2_code)
            begin
                key2_code = 8'hf0;
                key2_on   = 0;
            end
                end
                else if (is_key)
                begin
                if ((!key1_on) && (key2_code! = keycode_o))
                begin
                    key1_on   = 1;
                    key1_code = keycode_o;
                end
                else if ((!key2_on) && (key1_code! = keycode_o))
                begin
                    key2_on   = 1;
                    key2_code = keycode_o;
                end
                    end
                    end
                    
                    
                    reg       ps2_clk_in,ps2_clk_syn1,ps2_dat_in,ps2_dat_syn1;
                    wire      clk,ps2_dat_syn0,ps2_clk_syn0;
                    //tristate output control for PS2_DAT and PS2_CLK;
                    assign ps2_clk_syn0 = ps2_clk;
                    assign ps2_dat_syn0 = ps2_dat;
                    
                    //clk division, derive a 97.65625KHz clock from the 50MHz source;
                    reg [8:0] clk_div;
                    always@(posedge iCLK_50)
                    begin
                        clk_div <= clk_div+1;
                    end
                    
                    assign clk = clk_div[8];
                    //multi-clock region simple synchronization
                    always@(posedge clk)
                    begin
                        ps2_clk_syn1 <= ps2_clk_syn0;
                        ps2_clk_in   <= ps2_clk_syn1;
                        ps2_dat_syn1 <= ps2_dat_syn0;
                        ps2_dat_in   <= ps2_dat_syn1;
                    end
                    reg [7:0]	keycode_o;
                    reg	[7:0]	revcnt;
                    
                    always @(posedge ps2_clk_in or negedge keyboard_off)
                    begin
                        if (!keyboard_off)
                            revcnt = 0;
                        else if (revcnt > = 10)
                            revcnt = 0;
                        else
                            revcnt = revcnt+1;
                    end
                    
                    always @(posedge ps2_clk_in)
                    begin
                        case (revcnt[3:0])
                            1:keycode_o[0] = ps2_dat_in;
                            2:keycode_o[1] = ps2_dat_in;
                            3:keycode_o[2] = ps2_dat_in;
                            4:keycode_o[3] = ps2_dat_in;
                            5:keycode_o[4] = ps2_dat_in;
                            6:keycode_o[5] = ps2_dat_in;
                            7:keycode_o[6] = ps2_dat_in;
                            8:keycode_o[7] = ps2_dat_in;
                        endcase
                    end
                    endmodule
