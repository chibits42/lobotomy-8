`include "mem.sv"

module control (
    input wire clk;
    input wire en;
    input reg [2:0] op; 
)

    wire p_rst;
    wire b_rst;
    reg [7:0] out;
    wire plus;
    wire minus;
    wire prev;
    wire next;
    wire outp;
    wire write;
    wire load;

    // microinstruction counter
    counter uinstr (

    );

    tape t (
        clk, p_rst, b_rst, out, plus, minus, prev, next, outp, write, load
    );

    always @ (negedge clk & en) begin
        if (op = 1) // +
            
    end

endmodule
