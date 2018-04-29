

## 100 MHz clock
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name clk -waveform {0.000 5.000} -add [get_ports clk]


## reset
set_property -dict {PACKAGE_PIN D9 IOSTANDARD LVCMOS33} [get_ports rst]




## PMOD JA header mapping

set_property -dict { PACKAGE_PIN D13   IOSTANDARD LVCMOS33 } [get_ports segA  ]
set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports segB  ]
set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports segC  ]
set_property -dict { PACKAGE_PIN B11   IOSTANDARD LVCMOS33 } [get_ports segD  ]
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports segE  ]
set_property -dict { PACKAGE_PIN A11   IOSTANDARD LVCMOS33 } [get_ports segF  ]
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports segG  ]
set_property -dict { PACKAGE_PIN D12   IOSTANDARD LVCMOS33 } [get_ports segDP ]

