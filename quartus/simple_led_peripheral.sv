module simple_led_peripheral (
    input  logic        clk,
    input  logic        reset,

    // strobe upon write request, host -> agent
    input  logic        avs_write,

    // 32 bit data, host -> agent 
    input  logic [31:0] avs_writedata,

    // local addressing for data and control registers, host -> agent
    // writeto/readfrom 0x00 - 0x03 has avs_address = 0, 0x04 - 0x07 has avs_address = 1
    input  logic        avs_address, 

    // strobe upon read request, host -> agent
    input  logic        avs_read,

    // 32 bit data, agent -> host
    output logic [31:0] avs_readdata, 

    // output to fpga peripherals - LEDR[7:0] in this case
    output logic [7:0]  leds
);

    logic [7:0] led_data;
    logic       led_enable;

    always_ff @(posedge clk) begin
        if (reset) begin
            led_data   <= 8'd0;
            led_enable <= 1'b0;
        end 
        else if (avs_write) begin
				 case (avs_address)
					  1'b0: led_data   <= avs_writedata[7:0];
					  1'b1: led_enable <= avs_writedata[0];
				 endcase
        end
    end

    always_comb begin
        leds = led_enable ? led_data : 8'd0;
		  avs_readdata = avs_read ? (avs_address ? {{31{1'b0}}, led_enable} : {{24{1'b0}}, led_data}) : 32'b0;
    end

endmodule