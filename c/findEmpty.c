#include <iostream>
#include <fstream>
#include <cstdlib>
#include <iomanip>
#include <vector>

using size_type = std::vector<unsigned char>::size_type;

int main(int argc, char** argv) {
	size_type minimum = 2048;
	if(argc < 2) {
		std::cerr << "Usage: ./findempty <file> [minimum=2048]" << std::endl;
		return 1;
	}
	if(argc > 2) {
		minimum = atoi(argv[2]);
	}

	std::ifstream file(argv[1], std::ios::binary | std::ios::ate);
	if(!file.good()) {
		std::cerr << "Invalid file \"" << argv[1] << "\"." << std::endl;
		return 1;
	}
	std::vector<unsigned char> rom(file.tellg());
	file.seekg(0);
	for(size_type i = 0; i < rom.size(); ++i) rom[i] = file.get();

	size_type location = 0, counter = 0;
	for(size_type i = 0; i < rom.size(); ++i) {
		if(rom[i]) {
			if(counter >= minimum) {
				std::cout <<std::hex<<std::setfill('0')<< "0x" << std::setw(8) << location+1 << ": "
				          <<std::dec<<std::setfill('\0') << counter << "\n";
			}
			counter = 0;
			location = i;
		} else ++counter;
	}	