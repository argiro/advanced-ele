
## 100 MHz clock
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name clk -waveform {0.000 5.000} -add [get_ports clk]


## reset
set_property -dict {PACKAGE_PIN D9 IOSTANDARD LVCMOS33} [get_ports rst]


## standard LEDs
set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33}  [get_ports {count_LED[0]} ]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33}  [get_ports {count_LED[1]} ]
set_property -dict {PACKAGE_PIN T9 IOSTANDARD LVCMOS33}  [get_ports {count_LED[2]} ]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {count_LED[3]} ]


## RGB LED for carry
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports carry_LED]
#set_property -dict {PACKAGE_PIN F6 IOSTANDARD LVCMOS33} [get_ports ...]
#set_property -dict {PACKAGE_PIN G6 IOSTANDARD LVCMOS33} [get_ports ...]
