
PROJECT_NAME=ice40k-zpu

SOURCES=icestick_top.v zpu_core.v zpu_core_rom.v internal_ram.v

BLIF=$(PROJECT_NAME).blif
BT=$(PROJECT_NAME).bt
BIN=$(PROJECT_NAME).bin
PCF=icestick.pcf


YOSYS=../yosys/yosys
ARACHE=../arachne-pnr/bin/arachne-pnr
ICEPACK=../icestorm/icepack/icepack
ICEPROG=../icestorm/iceprog/iceprog

VERILATOR=../verilator/bin/verilator

$(BIN): $(BT)
	$(ICEPACK) $(BT) $(BIN) >> $(PROJECT_NAME).log

$(BT): $(BLIF) $(PCF)
	$(ARACHE) -d 1k -p $(PCF) $(BLIF) -o $(BT) >> $(PROJECT_NAME).log

$(BLIF): $(SOURCES)
	$(YOSYS) -p "synth_ice40 -top top -blif $(BLIF)" $(SOURCES) > $(PROJECT_NAME).log

debug: $(SOURCES)
	$(VERILATOR) -cc $(SOURCES) -Mdir build
clean:
	rm $(BLIF) $(BT) $(BIN) $(PROJECT_NAME).log

run: $(BIN)
	$(ICEPROG) $(BIN)