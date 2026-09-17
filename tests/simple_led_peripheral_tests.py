import cocotb

from cocotb.clock import Clock
from cocotb.triggers import RisingEdge


@cocotb.test()
async def test_simple_led_peripheral(dut):

    # Start a 50 MHz clock.
    # 20 ns period = 50 MHz.
    c = Clock(dut.clk, 20, unit="ns")
    cocotb.start_soon(c.start())

    # Reset the peripheral

    dut.reset.value = 1
    dut.avs_write.value = 0
    dut.avs_address.value = 0
    dut.avs_writedata.value = 0
    dut.avs_read.value = 0

    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    # hold reset for 2 rising edges 

    dut.reset.value = 0

    await RisingEdge(dut.clk)

    # After reset:
    # led_data   = 0 
    # led_enable = 0
    # therefore leds = 0
    assert dut.leds.value == 0

    # Write LED data = 0x55

    dut.avs_address.value = 0
    dut.avs_writedata.value = 0x55
    dut.avs_write.value = 1

    await RisingEdge(dut.clk)

    # End the write transaction.
    dut.avs_write.value = 0

    await RisingEdge(dut.clk)

    # LEDs should still be off because led_enable is still 0.
    assert dut.leds.value == 0

    # Enable LEDs

    dut.avs_address.value = 1
    dut.avs_writedata.value = 1
    dut.avs_write.value = 1

    await RisingEdge(dut.clk)

    dut.avs_write.value = 0

    await RisingEdge(dut.clk)

    # led_enable is now 1,
    # so LEDs should show the stored LED data.
    assert dut.leds.value == 0x55

    # Disable LEDs

    dut.avs_address.value = 1
    dut.avs_writedata.value = 0
    dut.avs_write.value = 1

    await RisingEdge(dut.clk)

    dut.avs_write.value = 0

    await RisingEdge(dut.clk)
    
    assert dut.leds.value == 0

    # Read from Data Register - 0x55 from before should still be stored here
    dut.avs_address.value = 0
    dut.avs_read.value = 1

    await(RisingEdge(dut.clk))

    assert dut.avs_readdata.value == 0x55
