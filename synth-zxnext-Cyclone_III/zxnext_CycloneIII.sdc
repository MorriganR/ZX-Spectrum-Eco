set_time_format -unit ns -decimal_places 3

derive_clock_uncertainty

create_clock -name {CLK25} -period 40.000 -waveform { 0.000 20.000 } [get_ports { CLK25 }]

derive_pll_clocks -create_base_clocks

set_false_path -from [get_clocks {CLK25}] -to [get_ports {LEDG*}]
#set_false_path -from [get_clocks {pll_a_inst|altpll_component|auto_generated|pll1|clk[2]}] -to [get_ports {PMODB*}]
