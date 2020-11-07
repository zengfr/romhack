#include <iostream>
#include <fstream>
#include <cstdlib>
#include <iomanip>
#include <vector>
#include <stdio.h>
#include "findempty.h"

#include <libgen.h>
//using namespace std;
using size_type = std::vector<unsigned char>::size_type;
void show(size_type location, short hex, size_type counter)
{
	std::cout << std::hex << std::setfill('0') << "0x" << std::setw(8) << location + 1 << " - "
			  << std::hex << std::setfill('0') << "0x" << std::setw(8) << location + counter << "\t"
			  << std::setfill('\0') << std::setw(4) << std::setiosflags(std::ios::uppercase) << std::hex << std::setfill('0') << std::setw(2) << hex << "\t"
			  << std::hex << std::setfill('\0') << std::setw(8) << counter << "\t"
			  << std::dec << std::setfill('\0') << std::setw(8) << counter << "\n";
}
void showline(int width)
{
	std::cout << std::setfill('-') << std::setw(width) << "-"
			  << "\n";
}
void showFormat(int width, short hex)
{
	std::cout << std::setfill('\0') << std::setw(8 + 2) << "start"
			  << " - "
			  << std::setfill('\0') << std::setw(8 + 2) << "end"
			  << "\t"
			  << std::setfill('\0') << std::setw(4) << "type"
			  << "\t"
			  << std::setfill('\0') << std::setw(8) << "hexCount"
			  << "\t"
			  << std::setfill('\0') << std::setw(8) << "decCount"
			  << "\t"
			  << std::hex << std::setfill('0') << std::setw(2) << hex
			  << "\n";
	showline(width);
}

int doSearch(char **argv, short hex, size_type minimum, int width)
{
	std::ifstream file(argv[1], std::ios::binary | std::ios::ate);
	if (!file.good())
	{
		std::cerr << "error: Invalid file \"" << argv[1] << "\"." << std::endl;
		return 1;
	}

	std::vector<unsigned char> rom(file.tellg());
	file.seekg(0);
	for (size_type i = 0; i < rom.size(); ++i)
	{
		rom[i] = file.get();
	}
	showline(width);
	showFormat(width, hex);
	size_type location = 0, counter = 0;
	for (size_type i = 0; i < rom.size(); ++i)
	{
		if (rom[i] != hex)
		{
			if (counter >= minimum)
			{
				show(location, hex, counter);
			}
			counter = 0;
			location = i;
		}
		else
		{
			++counter;
		}
	}
	file.close();
	return 0;
}


int find(char **argv, size_type minimum, int width)
{
	int rtn = 0;
	rtn += doSearch(argv, 0x00, minimum, width);
	rtn += doSearch(argv, 0xFF, minimum, width);
	rtn += doSearch(argv, 0x20, minimum, width);
	rtn += doSearch(argv, 0xA0, minimum, width);
	return rtn;
}

int main(int argc, char **argv)
{
	int rtn = 0;
	size_type minimum = 1024;
	int width = 68;
	showline(width);
	std::cout << "FindEmpty v1.2" << std::endl;
	std::cout << "Author:zengfr" << std::endl;
	std::cout << "Github:https://github.com/zengfr/romhack" << std::endl;
	std::cout << "Gitee :https://gitee.com/zengfr/romhack" << std::endl;
	showline(width);
	if (argc < 2)
	{
		std::cerr << "Usage  : ./findempty <file> [minimum=1024]" << std::endl;
		std::cout << "Cmd    :findempty.exe fullFilePath findMinCount" << std::endl;
		std::cout << "Example:findempty.exe dino.rom 1024" << std::endl;
		return 1;
	}
	if (argc > 2)
	{
		minimum = atoi(argv[2]);
	}
	if (minimum < 2)
		minimum = 2;
	if (minimum > 0xffff)
		minimum = 0xffff;
	std::cout << "Type:00 FF 20 A0 MinCount:" << minimum << " File:" << basename(argv[1]) << std::endl;
	rtn += find(argv, minimum, width);
	return rtn;
}
