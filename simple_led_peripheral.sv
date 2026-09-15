// avs_address - local addressing for data and control registers 
// avs_address = 0 when write comes into 0x00-0x03, avs_address = 1 when write comes into 0x04-0x08

// avs_write - strobe upon write event

// avs_writedata - 32 bit data coming in from HPS 

module simple_led_peripheral (
    input  logic        clk,
    input  logic        reset,

    input  logic        avs_address, 
    input  logic        avs_write,
    input  logic [31:0] avs_writedata,

    output logic [7:0]  leds
);

    logic [7:0] led_data;
    logic       led_enable;

    always_ff @(posedge clk) begin
        if (reset) begin
            led_data   <= 8'd0;
            led_enable <= 1'b0;
        end else if (avs_write) begin
            case (avs_address)
                1'b0: led_data   <= avs_writedata[7:0];
                1'b1: led_enable <= avs_writedata[0];
            endcase
        end
    end

    always_comb begin
        leds = led_enable ? led_data : 8'd0;
    end

endmodule