// dsd8_top.v -- system top level
// Owner: shared (whole team integrates this together)
// Spec: Section 5.1. Port list is FROZEN -- do not rename or resize.

module dsd8_top (
    input  wire       clk,
    input  wire       rst_n,       // synchronous, active low
    input  wire [7:0] switches,    // board slide switches  -> port 0x00
    input  wire [4:0] buttons,     // {btnU,btnD,btnL,btnR,btnC} -> port 0x01
    output wire [7:0] leds,        // board LEDs             <- port 0x02
    output wire [6:0] seg,         // seven-segment segments <- port 0x10
    output wire [3:0] an,          // seven-segment digit enables
    output wire       halted       // asserted after HLT retires
);

    // ---- Wires between CPU and Instruction Memory ----
    wire [8:0]  imem_addr;
    wire [15:0] imem_data;

    // ---- Wires between CPU and I/O Bus ----
    wire [7:0]  io_port;
    wire [7:0]  io_wdata;
    wire [7:0]  io_rdata;
    wire        io_rd;
    wire        io_wr;
    wire        io_ready;

    // ---- Board peripherals from I/O Bus ----
    wire [7:0]  seg_value;
    wire [7:0]  seg_enable;

    // ---- Instruction Memory ----
    instr_memory u_imem (
        .clk  (clk),
        .addr (imem_addr),
        .data (imem_data)
    );

    // ---- CPU Core ----
    dsd8_cpu u_cpu (
        .clk             (clk),
        .rst_n           (rst_n),
        .imem_addr       (imem_addr),
        .imem_data       (imem_data),
        .io_port         (io_port),
        .io_wdata        (io_wdata),
        .io_rdata        (io_rdata),
        .io_rd           (io_rd),
        .io_wr           (io_wr),
        .io_ready        (io_ready),
        .halted          (halted),
        .retire          (),
        .retire_pc       (),
        .retire_ir       (),
        .retire_rf_we    (),
        .retire_rf_addr  (),
        .retire_rf_data  (),
        .retire_mem_we   (),
        .retire_mem_addr (),
        .retire_mem_data (),
        .retire_flags    ()
    );

    // ---- I/O Bus ----
    io_bus u_io_bus (
        .clk           (clk),
        .rst_n         (rst_n),
        .io_port       (io_port),
        .io_wdata      (io_wdata),
        .io_rdata      (io_rdata),
        .io_rd         (io_rd),
        .io_wr         (io_wr),
        .io_ready      (io_ready),
        .switches      (switches),
        .buttons       (buttons),
        .leds          (leds),
        .seg_value     (seg_value),
        .seg_enable    (seg_enable),
        .periph_port   (),
        .periph_wdata  (),
        .periph_rdata  (8'h00),
        .periph_rd     (),
        .periph_wr     (),
        .periph_ready  (1'b1)
    );

    // ---- Seven-Segment Display Multiplexing ----
    reg [17:0] refresh_counter;
    always @(posedge clk) begin
        if (!rst_n) refresh_counter <= 18'h0;
        else        refresh_counter <= refresh_counter + 18'h1;
    end

    wire [1:0] active_digit = refresh_counter[17:16];
    reg [3:0]  digit_val;
    reg        digit_en;

    always @(*) begin
        case (active_digit)
            2'b00: begin
                digit_val = seg_value[3:0];
                digit_en  = seg_enable[0];
            end
            2'b01: begin
                digit_val = seg_value[7:4];
                digit_en  = seg_enable[1];
            end
            2'b10: begin
                digit_val = 4'h0;
                digit_en  = seg_enable[2];
            end
            2'b11: begin
                digit_val = 4'h0;
                digit_en  = seg_enable[3];
            end
        endcase
    end

    function [6:0] hex2seg(input [3:0] d);
        case (d)
            4'h0: hex2seg = 7'b1000000;
            4'h1: hex2seg = 7'b1111001;
            4'h2: hex2seg = 7'b0100100;
            4'h3: hex2seg = 7'b0110000;
            4'h4: hex2seg = 7'b0011001;
            4'h5: hex2seg = 7'b0010010;
            4'h6: hex2seg = 7'b0000010;
            4'h7: hex2seg = 7'b1111000;
            4'h8: hex2seg = 7'b0000000;
            4'h9: hex2seg = 7'b0010000;
            4'hA: hex2seg = 7'b0001000;
            4'hB: hex2seg = 7'b0000011;
            4'hC: hex2seg = 7'b1000110;
            4'hD: hex2seg = 7'b0100001;
            4'hE: hex2seg = 7'b0000110;
            4'hF: hex2seg = 7'b0001110;
        endcase
    endfunction

    assign seg = digit_en ? hex2seg(digit_val) : 7'b1111111;

    reg [3:0] an_out;
    always @(*) begin
        if (!rst_n) begin
            an_out = 4'b1111;
        end else begin
            case (active_digit)
                2'b00: an_out = digit_en ? 4'b1110 : 4'b1111;
                2'b01: an_out = digit_en ? 4'b1101 : 4'b1111;
                2'b10: an_out = digit_en ? 4'b1011 : 4'b1111;
                2'b11: an_out = digit_en ? 4'b0111 : 4'b1111;
            endcase
        end
    end

    assign an = an_out;

endmodule
