
create_clock -period 10000.000 -name BTN -add [get_ports BTN]

## reset (slide switch)
#set_property -dict { PACKAGE_PIN A8  IOSTANDARD LVCMOS33}  [get_ports rst]

## BCD counter clock

# use SW[0]
#set_property -dict { PACKAGE_PIN C11 IOSTANDARD LVCMOS33}  [get_ports BTN]

# use BTN[0]
#set_property -dict { PACKAGE_PIN D9   IOSTANDARD LVCMOS33} [get_ports BTN]

# use BTN[1]
set_property -dict { PACKAGE_PIN C9   IOSTANDARD LVCMOS33} [get_ports rst]


# use BTN[2]
#set_property -dict { PACKAGE_PIN B9   IOSTANDARD LVCMOS33} [get_ports BTN]


# use BTN[3]
set_property -dict { PACKAGE_PIN B8   IOSTANDARD LVCMOS33} [get_ports BTN]





## PMOD JA header mapping

set_property -dict { PACKAGE_PIN D13   IOSTANDARD LVCMOS33 } [get_ports segA  ]
set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports segB  ]
set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports segC  ]
set_property -dict { PACKAGE_PIN B11   IOSTANDARD LVCMOS33 } [get_ports segD  ]
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports segE  ]
set_property -dict { PACKAGE_PIN A11   IOSTANDARD LVCMOS33 } [get_ports segF  ]
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports segG  ]
set_property -dict { PACKAGE_PIN D12   IOSTANDARD LVCMOS33 } [get_ports segDP ]

