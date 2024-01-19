module ram (
    input wire clk,

    input wire [7:0] addr,
    input wire [7:0] data,

    input wire we,
    input wire ce,
    input wire oe,

    output reg [7:0] dout,
);

    reg [7:0] mem ['hff];

    integer i;

    initial begin
        for (i = 0; i <= 'hff; i = i + 1)
            mem[i] = 0;
    end

    always @ (posedge clk & ce) begin
        if (we)
            mem[addr] <= data;
        if (!we & oe)
            dout <= mem[addr];
    end
endmodule 

module counter (
    input wire clk,
    input wire rst,
    input wire c,
    input wire dir,
    input wire ce,

    input wire [7:0] inp,
    input wire load,

    output reg [7:0] out,
);

    initial begin
        out <= 0;
    end



    always @ (posedge clk & ce) begin
        if (!dir & c)
            out <= out + 1;
        else if (dir & c)
            out <= out - 1;
        else if (rst)
            out <= 'h00;
        
        if (load)
            out <= inp;
    end
endmodule

module tape (
    input wire dclk,

    input wire p_rst,
    // input wire p_c,
    // input wire p_dir,
    // input wire p_ce,
    
    input wire b_rst,
    // input wire b_c,
    // input wire b_dir,
    // input wire b_ce,

    // input wire we,
    // input wire ce,
    // input wire oe,

    output reg [7:0] out,

    input wire plus,
    input wire minus,
    input wire prev,
    input wire next,
    input wire outp,
    input wire write,
    input wire load,
);

    reg [7:0] p_out;
    reg [7:0] b_out;

    reg [7:0] r_out;

    counter ptr (
        dclk, p_rst, next | prev, prev, next | prev | load, out, load, p_out
    );

    counter bfr (
        dclk, b_rst, plus | minus, minus, plus | minus | load, out, load, b_out
    );

    ram r (
        dclk, p_out, b_out, write, plus | minus | outp | write, outp, out
    );
endmodule


module control (
    input wire clk,
    input wire en,
    input reg [2:0] op, 
    output reg [7:0] outreg,
);

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

    wire ui_rst;
    wire ui_c;
    wire ui_en;
    reg [7:0] ui_out;

    // microinstruction counter
    counter uinstr (
        clk, ui_rst, ui_c, 0, ui_en, 0, 0, ui_out,
    );

    tape t (
        clk, p_rst, b_rst, out, plus, minus, prev, next, outp, write, load
    );

    always @ (negedge clk & en) begin
        if (op === 7)
            outp <= 1;
            outreg <= out;
            
    end

endmodule
