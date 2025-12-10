`timescale 1ns/1ps

module top_tb;

    reg col_clk;
    reg sys_rst_n;
    wire dht11;   // inout, pero no lo usamos en el TB

    wire [7:0] temp_out;
    wire [7:0] hum_out;

    // Instanciamos el módulo top
    top uut (
        .col_clk(col_clk),
        .sys_rst_n(sys_rst_n),
        .dht11(dht11),
        .temp_out(temp_out),
        .hum_out(hum_out)
    );

    // Generación del reloj de 25 MHz → periodo 40ns
    initial begin
        col_clk = 0;
        forever #20 col_clk = ~col_clk;
    end

    // Reset
    initial begin
        sys_rst_n = 0;
        #200;
        sys_rst_n = 1;
    end

    // Estímulos
    initial begin
        //#300;  // esperar reset

        // Caso 1: 26°C, 64% 
        force uut.dht11_inst.TempHumi = {8'd26, 8'd64};
        #200;
        $display("Temp=%0d°C  Hum=%0d%%", temp_out, hum_out);
        
        // Caso 2: 18°C, 55% 
        force uut.dht11_inst.TempHumi = {8'd18, 8'd55};
        #200;
        $display("CASE 2  Temp=%0d°C  Hum=%0d%%", temp_out, hum_out);

        // Caso 3: 30°C, 70% 
        force uut.dht11_inst.TempHumi = {8'd30, 8'd70};
        #200;
        $display("CASE 3  Temp=%0d°C  Hum=%0d%%", temp_out, hum_out);
        $finish;
    end

    // Archivo VCD
    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);
        $dumpvars(0, uut);
        $dumpvars(0, uut.dht11_inst);
    end

endmodule
