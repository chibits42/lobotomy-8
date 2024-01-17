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

    output reg [7:0] out,
);

    always @ (posedge clk & ce) begin
        if (!dir & c)
            out <= out + 1;
        else if (dir & c)
            out <= out - 1;
        else if (rst)
            out <= 'h00;
    end
endmodule

module tape (
    input wire clk,

    input wire p_clk,
    input wire p_rst,
    input wire p_c,
    input wire p_dir,
    input wire p_ce,
    
    input wire b_clk,
    input wire b_rst,
    input wire b_c,
    input wire b_dir,
    input wire b_ce,

    input wire we,
    input wire ce,
    input wire oe,

    output reg [7:0] out,
);

    reg [7:0] p_out;
    reg [7:0] b_out;

    counter ptr (
        p_clk, p_rst, p_c, p_dir, p_ce, p_out
    );

    counter bfr (
        b_clk, b_rst, b_c, b_dir, b_ce, b_out
    );

    ram r (
        clk, p_out, b_out, we, ce, oe, out
    );

    always @ (posedge clk) begin
        p_clk <= clk;
        b_clk <= clk;
    end
endmodule
