module frequencyClockGenerator(CLOCK_50, note, pulse);
    input CLOCK_50;
    input [6:0] note;
    output pulse;

    wire [27:0] count_init;
    reg [27:0] count;

    frequencyLUT flut(
        .note(note),
        .init_counter(count_init)
    );

    // assign count_init = 28'b0101111101011110000100000000 - 1'b1;

    initial
    begin
        count = 28'b0;
    end

    assign pulse = (count == 28'b0) ? 1'b1 : 1'b0;

    always @ (posedge CLOCK_50)
    begin
        // Stop clock
        if (count_init == 28'b0)
        begin
            count <= count_init;
        end
        else if (count == 28'b0)
            count <= count_init;
        else 
            count <= count - 1'b1;

        // if (count == 28'b0)
        //     count <= count_init;
        // else 
        //     count <= count - 1'b1;
    end

endmodule