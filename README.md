# advanced-ele
Repository for the course of Advanced Electronics (Unito Physics Department)


# Repo download 

```
linux% git config --global user.name "Your Name"
linux% git config --global user.email you@your.address
```

```
linux% git clone https://github.com/argiro/advanced-ele
```

# UNIX setup

```
linux% source ~/local/xilinx/Vivado/2015.4/settings.(c)sh
```


# FPGA

1. go to your project dir, e.g. 1.inverter [cd 1.inverter]

2. copy common code into your project dir [cp ../../common/synpr .]

3. create area [make area]

4. build project [make flow]