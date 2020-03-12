module Debouncer1Bit(clock, in, out);
    input clock;
    input in;
    output reg out;

    wire [27:0] count_init;
    reg [27:0] count;

    assign count_init = 28'b0000000001111010000100100000 - 1'b1;

    wire pulse;
    assign pulse = (count == 28'b0000000000000000000000000000) ? 1'b1 : 1'b0;

    initial
    begin
        out = in; 
    end

    always @ (posedge clock)
    begin
        if (count == 28'b0000000000000000000000000000)
            count <= count_init;
        else
            count <= count - 1'b1;
    end

    always @ (posedge pulse)
    begin
        out <= in;
    end
endmodule