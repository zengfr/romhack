#include <iostream>
#include <fstream>
#include <ios>
#include <iomanip>
#include <deque>
#include <vector>

/*
 * PrintMemory:
 * print memory contents surrounding an address range
 * in a human readable format
 */
void PrintMemory(std::ifstream& f, std::streamoff begin, std::streamoff end) {
	std::streamoff dump_b = begin - (begin & 0xF);
	std::streamoff dump_e = end   - (end   & 0xF);

	f.seekg(dump_b);
	std::cout << std::hex << std::uppercase << std::setfill('0');
	std::cout << "(Location: 0x" << std::setw(8) << begin << " - 0x" << std::setw(8) << end << ")\n";

	for(std::streamoff dump = dump_b; dump <= dump_e; dump += 0x10) {
		std::string ascii;
		std::cout << "0x" << std::setw(8) << dump << ":";
		for(unsigned char i = 0; i < 16 && f.good(); ++i) {

			if(dump+i == begin)      std::cout << "[";
			else if(dump+i-1 == end) std::cout << "]";
			else                     std::cout << " ";

			unsigned char c = f.get();
			std::cout << std::setw(2) << (unsigned short)c;
			ascii += c > 31 && c < 127 ? c : '.'; // Readable ASCII characters
		}
		std::cout << "    " << ascii << "\n";
	}
	std::cout << std::flush;
}

/*
 * Match:
 * matches a pattern of differences with a queue
 *
 */
bool Match(std::vector<int>& diff, std::deque<unsigned char> bytes) {
	if(bytes.size()-1 != diff.size()) return false;
	if(diff.size() == 0) return false;
	unsigned char byte = bytes.front();
	unsigned char next = byte;
	for(unsigned i = 0; i < diff.size(); ++i) {
		bytes.pop_front();
		next = byte + diff[i];
		byte = next;
		if(next != bytes.front()) return false;
	}
	return true;
}

int main(int argc, char** argv) {
	
	if(argc < 3) {
		std::cout << "Usage: ./diffind <file> <pattern>" << std::endl;
		return 1;
	}

	std::ifstream file(argv[1],std::ios::binary);

	std::deque<unsigned char> source;
	std::vector<int> target;

	std::string target_str(argv[2]);
	if(target_str.length() < 2) {
		std::cout << "Pattern needs to be atleast 2 characters or more" << std::endl;
	}

	char c = target_str[0];
	for(unsigned i = 1; i < target_str.length(); ++i) {
		target.push_back(target_str[i] - c);
		c = target_str[i];
	}	
	std::streamoff start = 0;
	while(file.good()) {
		source.push_back(file.get());
		if(source.size() > target_str.length()) { ++start; source.pop_front(); }
		if(Match(target,source)) {
			std::streamoff prev = file.tellg();
			PrintMemory(file, start, start + target.size());
			file.clear(std::ios::eofbit); file.seekg(prev);
		}
	}

	return 0;
}