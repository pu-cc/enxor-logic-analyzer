## project
TOP = Logic_Analyzer_Top
#TOP = demo_top

## tools
CC     = iverilog
VVP    = vvp
YOSYS  = yosys
PR     = /home/patrick/Bin/EasyConvert/p_r.exe
OFL    = openFPGALoader
WINE   = wine64
RM     = rm -rf

## default flags
PRFLAGS = -lib ccag -m_spi 0 +sp -gCP

synth:
	$(YOSYS) -ql log/$@.log -p 'tcl tcl/$@.tcl $(TOP) src'

impl:
	$(WINE) $(PR) -i src/$(TOP)_synth.v -o $(TOP) $(PRFLAGS) > log/$@.log

jtag:
	$(OFL) -b gatemate_evb_jtag $(TOP)_00.cfg

jtag-flash:
	$(OFL) -b gatemate_evb_jtag -f --verify $(TOP)_00.cfg

clean:
	$(RM) log/*.log
	$(RM) src/*_synth.v
	$(RM) *.TXT
	$(RM) *.refwire
	$(RM) *.refparam
	$(RM) *.refcomp
	$(RM) *.pos
	$(RM) *.pathes
	$(RM) *.path_struc
	$(RM) *.net
	$(RM) *.id
	$(RM) *.PRN
	$(RM) *_00.V
	$(RM) *.used
	$(RM) *.SDF
	$(RM) *.place
	$(RM) *.pin
	$(RM) *.cfg*
	$(RM) *.cdf
