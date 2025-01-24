# Gowin_FPGA_Projects

This repository will include my personal projects/code. Feel free to comment, or give feedback on my work! 

The tool is called synth 20k. It uses a variety of open-source tools and works just like a macro. It just takes a single verilog file, and a constraints file, then it will spit out a file called "pack.fs" which you can upload to your primer 20k using openFPGALoader. 

The whole workflow for what this program does can be found in synth20k/yosys_workflow.txt. Project Apycula also has a far more in-depth review of these individual tools if you need to do something more specific.

https://github.com/YosysHQ/apicula/wiki

In order to use synth 20k, you need the following. Yosys, apycula Nextpnr_Himbaechel, gowin_pack, and openFPGALoader is recomended to program the FPGA. 

installation:
Follow the tutorial from Project Apycula to get the preresiquites:
https://github.com/YosysHQ/apicula

Once you have all the required tools, use a c++ compiler to create the executable from the source code. After that, make sure to move that file into your PATH. Now, you should be good to go!

Currently there are only two arguments for the verilog and constraints file, but soon I plan to add more functionality by creating some optional arguments which will get passed to the tools for more specific issues, as right now there are many issues with using the default settings for everything.


Usage:
1. Create bitstream file: synth20k -v verilog_file.v -c constraints_file.cst
2. Load bitstream file onto fpga: 

**Plug FPGA into your computer and run:

openFPGALoader -b tangprimer20k pack.fs

