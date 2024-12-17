mkdir reports
mkdir netlists
mkdir SDC
mkdir SDF
mkdir logs
dc_shell -f syn_script.tcl | tee -i logs/syn.log
