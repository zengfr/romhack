import idaapi
import struct

def accept_file(li, n):
	if n > 0:
		return 0

	li.seek(0x100)
	if li.read(7) != "NEO-GEO":
		return 0

	return "NeoGeo 68k loader"

def name_long(ea, name):
	idaapi.set_name(ea, name)
	idaapi.doDwrd(ea, 4)
	idaapi.set_offset(ea, 0, 0)

def load_file(li, neflags, format):
	if format != "NeoGeo 68k loader":
		return 0

	idaapi.set_processor_type("68000", SETPROC_ALL | SETPROC_FATAL)

	idaapi.add_segm(0, 0x000000, 0x0FFFFF, "ROM", "CODE")
	idaapi.add_segm(0, 0x100000, 0x10F2FF, "WRAM", "DATA")
	idaapi.add_segm(0, 0x10F300, 0x10FFFF, "BIOSRAM", "DATA")
	idaapi.add_segm(0, 0x200000, 0x2FFFFF, "PORT", "DATA")
	idaapi.add_segm(0, 0x300000, 0x3FFFFF, "IO", "DATA")
	idaapi.add_segm(0, 0x400000, 0x401FFF, "PALETTES", "DATA")
	idaapi.add_segm(0, 0x800000, 0xBFFFFF, "MEMCARD", "DATA")
	idaapi.add_segm(0, 0xC00000, 0xC1FFFF, "SYSROM", "DATA")
	idaapi.add_segm(0, 0xD00000, 0xD0FFFF, "BRAM", "DATA")

	li.seek(0, 2)
	size = li.tell()
	li.seek(0)
	file_data = li.read(size)
	idaapi.mem2base(file_data, 0, 0x100000)
	
	name_long(0x000000, "InitSP")
	name_long(0x000004, "InitPC")

	idaapi.do_unknown(0x3C0000, 1)
	idaapi.doByte(0x3C0000, 1)
	idaapi.set_name(0x3C0000, "REG_VRAMADDR")
	#idaapi.set_cmt(0x3C0000, "Pouet.", 1)

	return 1