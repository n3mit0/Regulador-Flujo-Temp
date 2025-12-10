module top(
    input           col_clk,
    input           sys_rst_n,
    inout           dht11,

    output [7:0]    temp_out,
    output [7:0]    hum_out
);

wire sys_clk = col_clk;
wire [15:0] TempHumi;

dht11 dht11_inst(
    .TempHumi(TempHumi),
    .clk(sys_clk),
    .rst_n(sys_rst_n),
    .dht11(dht11)
);

// Separar temperatura y humedad
wire [7:0] temp = TempHumi[15:8];
wire [7:0] hum  = TempHumi[7:0];

assign temp_out = temp;
assign hum_out = hum;

endmodule
