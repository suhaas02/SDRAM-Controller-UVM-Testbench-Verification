verdiSetActWin -dock widgetDock_<Message>
simSetSimulator "-vcssv" -exec "/home1/BPRN08/VegiJ/SDRAM/sim/simv" -args \
           "-a vcs.log -cm_dir ./mem_cov2 +ntb_random_seed_automatic +UVM_TESTNAME=write_read_test"
debImport "-dbdir" "/home1/BPRN08/VegiJ/SDRAM/sim/simv.daidir"
debLoadSimResult /home1/BPRN08/VegiJ/SDRAM/sim/wave2.fsdb
wvCreateWindow
verdiWindowResize -win $_Verdi_1 "298" "63" "900" "700"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBSelect "top.DUT" -win $_nTrace1
debExit
