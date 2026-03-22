// ============================================================
// @ AUTHOR : Ganta V.S Nikhita , Gajji Sahasra , Mudavath Harika
//configurable_decoder
// Module: decoder_2to4
// Description: 2-to-4 line decoder with active-high enable
// ============================================================
module decoder_2to4 (
    input  [1:0] data_in,
    input        enable,
    output reg [3:0] decode_out
);
    always @(*) begin
        if (!enable) begin
            decode_out = 4'b0000;
        end else begin
            case (data_in)
                2'b00: decode_out = 4'b0001;
                2'b01: decode_out = 4'b0010;
                2'b10: decode_out = 4'b0100;
                2'b11: decode_out = 4'b1000;
                default: decode_out = 4'b0000;
            endcase
        end
    end
endmodule


// ============================================================
// Module: decoder_3to8
// Description: 3-to-8 line decoder with active-high enable
// ============================================================
module decoder_3to8 (
    input  [2:0] data_in,
    input        enable,
    output reg [7:0] decode_out
);
    always @(*) begin
        if (!enable) begin
            decode_out = 8'b0000_0000;
        end else begin
            case (data_in)
                3'b000: decode_out = 8'b0000_0001;
                3'b001: decode_out = 8'b0000_0010;
                3'b010: decode_out = 8'b0000_0100;
                3'b011: decode_out = 8'b0000_1000;
                3'b100: decode_out = 8'b0001_0000;
                3'b101: decode_out = 8'b0010_0000;
                3'b110: decode_out = 8'b0100_0000;
                3'b111: decode_out = 8'b1000_0000;
                default: decode_out = 8'b0000_0000;
            endcase
        end
    end
endmodule


// ============================================================
// Module: decoder_4to16
// Description: 4-to-16 line decoder with active-high enable
// ============================================================
module decoder_4to16 (
    input  [3:0] data_in,
    input        enable,
    output reg [15:0] decode_out
);
    always @(*) begin
        if (!enable) begin
            decode_out = 16'b0000_0000_0000_0000;
        end else begin
            case (data_in)
                4'b0000: decode_out = 16'b0000_0000_0000_0001;
                4'b0001: decode_out = 16'b0000_0000_0000_0010;
                4'b0010: decode_out = 16'b0000_0000_0000_0100;
                4'b0011: decode_out = 16'b0000_0000_0000_1000;
                4'b0100: decode_out = 16'b0000_0000_0001_0000;
                4'b0101: decode_out = 16'b0000_0000_0010_0000;
                4'b0110: decode_out = 16'b0000_0000_0100_0000;
                4'b0111: decode_out = 16'b0000_0000_1000_0000;
                4'b1000: decode_out = 16'b0000_0001_0000_0000;
                4'b1001: decode_out = 16'b0000_0010_0000_0000;
                4'b1010: decode_out = 16'b0000_0100_0000_0000;
                4'b1011: decode_out = 16'b0000_1000_0000_0000;
                4'b1100: decode_out = 16'b0001_0000_0000_0000;
                4'b1101: decode_out = 16'b0010_0000_0000_0000;
                4'b1110: decode_out = 16'b0100_0000_0000_0000;
                4'b1111: decode_out = 16'b1000_0000_0000_0000;
                default: decode_out = 16'b0000_0000_0000_0000;
            endcase
        end
    end
endmodule


// ============================================================
// Module: configurable_decoder
// Description: Top-level decoder that selects between 2-to-4,
//              3-to-8, or 4-to-16 mode via mode_sel[1:0].
//
//   mode_sel = 2'b00 → 2-to-4  (uses data_in[1:0], out[3:0]  in LSBs)
//   mode_sel = 2'b01 → 3-to-8  (uses data_in[2:0], out[7:0]  in LSBs)
//   mode_sel = 2'b10 → 4-to-16 (uses data_in[3:0], out[15:0])
//   mode_sel = 2'b11 → reserved, output = 16'b0
//
// All sub-decoders run in parallel; only the selected one is
// enabled. The output is zero-padded into the 16-bit bus.
// ============================================================
module configurable_decoder (
    input  [3:0] data_in,
    input  [1:0] mode_sel,
    input        enable,
    output [15:0] decode_out
);

    // Internal wires for sub-decoder outputs
    wire [3:0]  decode_2to4_out;
    wire [7:0]  decode_3to8_out;
    wire [15:0] decode_4to16_out;

    // Enable signals — only the selected decoder is enabled
    wire enable_2to4, enable_3to8, enable_4to16;

    assign enable_2to4  = enable & (mode_sel == 2'b00);
    assign enable_3to8  = enable & (mode_sel == 2'b01);
    assign enable_4to16 = enable & (mode_sel == 2'b10);

    // Instantiate 2-to-4 decoder (structural instantiation)
    decoder_2to4 u_decoder_2to4 (
        .data_in   (data_in[1:0]),
        .enable    (enable_2to4),
        .decode_out(decode_2to4_out)
    );

    // Instantiate 3-to-8 decoder (structural instantiation)
    decoder_3to8 u_decoder_3to8 (
        .data_in   (data_in[2:0]),
        .enable    (enable_3to8),
        .decode_out(decode_3to8_out)
    );

    // Instantiate 4-to-16 decoder (structural instantiation)
    decoder_4to16 u_decoder_4to16 (
        .data_in   (data_in),
        .enable    (enable_4to16),
        .decode_out(decode_4to16_out)
    );

    // Output selection with explicit zero-padding for narrower decoders
    // FIX: explicit {12'b0, ...} and {8'b0, ...} padding instead of
    //      implicit width extension, and added explicit default for 2'b11.
    assign decode_out = (mode_sel == 2'b00) ? {12'b0, decode_2to4_out}  :
                        (mode_sel == 2'b01) ? {8'b0,  decode_3to8_out}  :
                        (mode_sel == 2'b10) ? decode_4to16_out           :
                        16'b0;  // 2'b11: reserved — explicit zero output

endmodule
