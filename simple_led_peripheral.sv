module simple_led_peripheral (
    input  logic        clk,
    input  logic        reset,

    input  logic        avs_write,
    input  logic [31:0] avs_writedata,

    output logic [7:0]  leds
);

    always_ff @(posedge clk) begin
        if (reset)
            leds <= 8'd0;
        else if (avs_write)
            leds <= avs_writedata[7:0];
    end

endmodule