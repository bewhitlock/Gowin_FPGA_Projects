#include <iostream>
#include <cstdlib>
#include <getopt.h>

int main(int argc, char *argv[]) {

    char *cArg = nullptr;
    char *vArg = nullptr;

    // Parse command line options using getopt()
    int opt;
    while ((opt = getopt(argc, argv, "c:v:")) != -1) { 
        switch (opt) {
            case 'c':
                cArg = optarg;
                break;
            case 'v':
                vArg = optarg;
                break;
            default:
                std::cerr << "Usage: " << argv[0] << " -c <file> -v <file>" << std::endl;
                return 1;
        }
    }

    // Check if -c and -v were provided
    if (!cArg || !vArg) {
        std::cerr << "Error: Both -c and -v options must be provided." << std::endl;
        return 1;
    }

    // Step 1: Run Yosys in batch mode
    std::string yosys_command = "yosys -p \"read_verilog " + std::string(vArg) + "; synth_gowin -json compiled.json\"";
    int return_code1 = system(yosys_command.c_str());
    if (return_code1 == 0) {
        std::cout << "Yosys completed successfully." << std::endl;
    } else {
        std::cerr << "Error running Yosys." << std::endl;
        return 1;
    }

    // Step 2: Run nextpnr
    std::string command2 = "nextpnr-himbaechel --json compiled.json --write output.json --device GW2A-LV18PG256C8/I7 --vopt family=GW2A-18C --vopt cst=" + std::string(cArg); // place using cst file
    int return_code2 = system(command2.c_str());
    if (return_code2 == 0) {
        std::cout << "Placement successful." << std::endl;
    } else {
        std::cerr << "Error in placement." << std::endl;
        return 1;
    }

    // Step 3: Run gowin_pack
    int return_code3 = system("gowin_pack --device GW2A-18 output.json"); // pack the output
    if (return_code3 == 0) {
        std::cout << "Packing successful." << std::endl;
    } else {
        std::cerr << "Error in packing." << std::endl;
        return 1;
    }

    //step 4: remove all intermediary files
        int return_code4 = system("rm compiled.json output.json"); // pack the output
    if (return_code4 == 0) {
        std::cout << "removed intermediarys succesfully" << std::endl;
    } else {
        std::cerr << "Error in removing intermediarys" << std::endl;
        return 1;
    }

    return 0;
}
