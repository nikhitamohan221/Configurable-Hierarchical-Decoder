// ============================================================
// Module   : tb_configurable_decoder
// Purpose  : Testbench for configurable_decoder
//            Tests 2-to-4, 3-to-8, 4-to-16 modes + edge cases
// ============================================================
`timescale 1ns/1ps

module tb_configurable_decoder;

    // --------------------------------------------------------
    // Testbench signals
    // --------------------------------------------------------
    reg  [3:0]  data_in;
    reg  [1:0]  mode_sel;
    reg         enable;
    wire [15:0] decode_out;

    // --------------------------------------------------------
    // Instantiate DUT
    // --------------------------------------------------------
    configurable_decoder uut (
        .data_in   (data_in),
        .mode_sel  (mode_sel),
        .enable    (enable),
        .decode_out(decode_out)
    );

    // --------------------------------------------------------
    // Test sequence
    // --------------------------------------------------------
    initial begin
        // Initialize signals
        enable   = 0;
        mode_sel = 2'b00;
        data_in  = 4'b0000;

        // Open VCD file for waveform analysis
        $dumpfile("decoder_waveform.vcd");
        $dumpvars(0, tb_configurable_decoder);

        $display("=== Configurable Hierarchical Decoder Testbench ===");
        $display("Time\tMode\tEnable\tDataIn\tDecodeOut");
        $display("---------------------------------------------------");

        // ------------------------------------------------
        // Test Case 1: Verify disable functionality
        // ------------------------------------------------
        $display("\n--- Test 1: Disabled Decoder ---");
        enable   = 0;
        mode_sel = 2'b00;
        data_in  = 4'b0011;
        #10;
        $display("%0t\t%2b\t%b\t%b\t%b",
                  $time, mode_sel, enable, data_in, decode_out);
        check_output(16'b0000_0000_0000_0000, "Disabled");

        // ------------------------------------------------
        // Test Case 2: 2-to-4 decoder mode
        // ------------------------------------------------
        $display("\n--- Test 2: 2-to-4 Decoder Mode ---");
        enable   = 1;
        mode_sel = 2'b00;
        test_2to4_mode();

        // ------------------------------------------------
        // Test Case 3: 3-to-8 decoder mode
        // ------------------------------------------------
        $display("\n--- Test 3: 3-to-8 Decoder Mode ---");
        mode_sel = 2'b01;
        test_3to8_mode();

        // ------------------------------------------------
        // Test Case 4: 4-to-16 decoder mode
        // ------------------------------------------------
        $display("\n--- Test 4: 4-to-16 Decoder Mode ---");
        mode_sel = 2'b10;
        test_4to16_mode();

        // ------------------------------------------------
        // Test Case 5: Invalid mode selection (2'b11)
        // ------------------------------------------------
        $display("\n--- Test 5: Invalid Mode (11) ---");
        mode_sel = 2'b11;
        data_in  = 4'b1111;
        #10;
        $display("%0t\t%2b\t%b\t%b\t%b",
                  $time, mode_sel, enable, data_in, decode_out);
        check_output(16'b0000_0000_0000_0000, "Invalid Mode");

        $display("\n\n=== All Tests Completed Successfully ===");
        #100 $finish;
    end

    // --------------------------------------------------------
    // Task: test_2to4_mode
    // Tests all 4 input combinations for 2-to-4 decoder
    // Only data_in[1:0] is relevant; [3:2] are ignored
    // --------------------------------------------------------
    task test_2to4_mode;
        begin
            data_in = 4'b0000; #10;
            $display("%0t\t%2b\t%b\t%b\t%b",
                      $time, mode_sel, enable, data_in, decode_out);
            check_output(16'b0000_0000_0000_0001, "2-to-4: 00");

            data_in = 4'b0001; #10;
            $display("%0t\t%2b\t%b\t%b\t%b",
                      $time, mode_sel, enable, data_in, decode_out);
            check_output(16'b0000_0000_0000_0010, "2-to-4: 01");

            data_in = 4'b0010; #10;
            $display("%0t\t%2b\t%b\t%b\t%b",
                      $time, mode_sel, enable, data_in, decode_out);
            check_output(16'b0000_0000_0000_0100, "2-to-4: 10");

            data_in = 4'b0011; #10;
            $display("%0t\t%2b\t%b\t%b\t%b",
                      $time, mode_sel, enable, data_in, decode_out);
            check_output(16'b0000_0000_0000_1000, "2-to-4: 11");
        end
    endtask

    // --------------------------------------------------------
    // Task: test_3to8_mode
    // Tests selected input combinations for 3-to-8 decoder
    // --------------------------------------------------------
    task test_3to8_mode;
        begin
            data_in = 4'b0000; #10;
            $display("%0t\t%2b\t%b\t%b\t%b",
                      $time, mode_sel, enable, data_in, decode_out);
            check_output(16'b0000_0000_0000_0001, "3-to-8: 000");

            data_in = 4'b0011; #10;
            $display("%0t\t%2b\t%b\t%b\t%b",
                      $time, mode_sel, enable, data_in, decode_out);
            check_output(16'b0000_0000_0000_1000, "3-to-8: 011");

            data_in = 4'b0110; #10;
            $display("%0t\t%2b\t%b\t%b\t%b",
                      $time, mode_sel, enable, data_in, decode_out);
            check_output(16'b0000_0000_0100_0000, "3-to-8: 110");

            data_in = 4'b0111; #10;
            $display("%0t\t%2b\t%b\t%b\t%b",
                      $time, mode_sel, enable, data_in, decode_out);
            check_output(16'b0000_0000_1000_0000, "3-to-8: 111");
        end
    endtask

    // --------------------------------------------------------
    // Task: test_4to16_mode
    // Tests selected input combinations for 4-to-16 decoder
    // --------------------------------------------------------
    task test_4to16_mode;
        begin
            data_in = 4'b0000; #10;
            $display("%0t\t%2b\t%b\t%b\t%b",
                      $time, mode_sel, enable, data_in, decode_out);
            check_output(16'b0000_0000_0000_0001, "4-to-16: 0000");

            data_in = 4'b0101; #10;
            $display("%0t\t%2b\t%b\t%b\t%b",
                      $time, mode_sel, enable, data_in, decode_out);
            check_output(16'b0000_0000_0010_0000, "4-to-16: 0101");

            data_in = 4'b1010; #10;
            $display("%0t\t%2b\t%b\t%b\t%b",
                      $time, mode_sel, enable, data_in, decode_out);
            check_output(16'b0000_0100_0000_0000, "4-to-16: 1010");

            data_in = 4'b1111; #10;
            $display("%0t\t%2b\t%b\t%b\t%b",
                      $time, mode_sel, enable, data_in, decode_out);
            check_output(16'b1000_0000_0000_0000, "4-to-16: 1111");
        end
    endtask

    // --------------------------------------------------------
    // Task: check_output
    // Compares actual vs expected output and reports PASS/FAIL
    // FIX: input port width for test_name changed to [127:0]
    //      to safely hold long string literals
    // --------------------------------------------------------
    task check_output;
        input [15:0]  expected;
        input [127:0] test_name;   // BUG FIX: was [80:0], too narrow for long strings
        begin
            if (decode_out !== expected) begin
                $display("ERROR in %s: Expected %b, Got %b",
                          test_name, expected, decode_out);
                $finish;
            end else begin
                $display("PASS: %s", test_name);
            end
        end
    endtask

endmodule
