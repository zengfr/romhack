""" SwitchTableFixup68k.py
    Use either as a library to fix up an entire binary or on its own to fix
    an individual switch statement.  This has been tested on two types of 
    switch tables: offset tables, and offset table with accompanying value 
    table.  The algorithm may need to be modified depending on types of 68k 
    compilers or optimization levels.
    Usage: Set the effective address to be analyzed on the indirect jump 
    instruction of the switch table and call create_68k_jump_table() or run 
    the script.  get_unanalyzed_jump_tables() can be used to search a binary 
    for a list of unanalyzed jump table addresses for analysis.
"""
import idaapi
import idc

def find_unanalyzed_jump_table(start_ea, end_ea):
    """ Return address of first unanalyzed jump table between start_ea
        and end_ea
    """
    ea = start_ea
    while ea <= end_ea:
        # Find jmp, where first operand == NextHead(jmp_ea).  If no 
        # switch_info_ex_t object at jmp_ea, return jmp_ea

        is_jmp_insn = (idc.GetMnem(ea) == "jmp")
        not_switch_table = (idaapi.get_switch_info_ex(ea) == None)
        next_ea = idc.NextHead(ea, end_ea)
        jmp_target_next_insn = (next_ea == idc.GetOperandValue(ea, 0))

        if is_jmp_insn and jmp_target_next_insn and not_switch_table:
            return ea

        ea = next_ea

    return idc.BADADDR

def _find_switch_attributes(switch_jump_ea):
    """ Return tuple of switch attributes.
        This function will take an effective address for a switch table
        and find attributes associated with the table.  It will check 
        for the presence of a value table and return the address of the 
        beginning of the table and the width of the table elements, if
        present.
        Returns a tuple of: the base address of the offset table, the 
        max offset index for the table, if found, the base address of
        the value table, and the width of the value table elements.
    """
    size = "w"
    value_table_ea = None
    value_table_width = None
    max_offset = None

    if idc.GetMnem(switch_jump_ea) != "jmp":
        return None, None, None, None, None

    prev_ea = idc.PrevHead(switch_jump_ea, 0)

    while idc.GetMnem(prev_ea) != "b":
        Message("%s\n" % idc.GetMnem(prev_ea))
        prev_ea = idc.PrevHead(prev_ea, 0)
    defjump = idc.GetOperandValue(prev_ea, 0)
    
    while idc.GetMnem(prev_ea) != "moveq":
        prev_ea = idc.PrevHead(prev_ea, 0)
        
    # Check for a value table (note this may need to change per compiler)
    ea = idc.NextHead(prev_ea, switch_jump_ea)

    while ea < switch_jump_ea:
        if idc.GetDisasm(ea).split()[0] == "dbls" and idc.GetMnem(idc.PrevHead(ea, 0)) == "cmp":
            print "Found value table signature"
            # Extract the size designation of the comparison
            size = idc.GetDisasm(idc.PrevHead(ea, 0)).split(".")[1].split()[0]
            if size == "w": 
                value_table_width = 2
            elif size == "l":
                value_table_width = 4
            elif size == "b":
                value_table_width = 1
            else:
                value_table_width = None
            break
            
        ea = idc.NextHead(ea, switch_jump_ea)

    table_base = idc.GetOperandValue(switch_jump_ea, 0)
    max_offset = idc.GetOperandValue(prev_ea,0)
    value_table_ea = 2 * (max_offset + 1) + table_base
    return (table_base, max_offset, value_table_ea, value_table_width, defjump)

def _make_offset_table(switch_table_base, size):
    """ Clean up the offset table by making the elements unknown and then 
        into a word.
    """
    for addr in range(switch_table_base, switch_table_base + size * 2, 2):
        idc.MakeUnknown(addr, 2, idc.DOUNK_EXPAND | idc.DOUNK_DELNAMES)
        idc.MakeWord(addr)

def create_68k_jump_table(idiom_ea):
    """ Create a jump table at the current address in the database.
        This function sets the switch idiom attributes for the current address
        in the database.  If switch_base is none, find_switch_attributes() was
        not successful.
    """
    switch_base, max_offset, value_base, value_width, defjump = _find_switch_attributes(idiom_ea)

    if switch_base != None:
        jump_table_size = max_offset + 1
        total_switch_size = 2 * (max_offset + 1)
        switch_base_ea = idc.GetOperandValue(idiom_ea, 0)
        _make_offset_table(switch_base, jump_table_size)
        # create the switch info object
        si = idaapi.switch_info_ex_t()
        si.set_jtable_element_size(2)
        si.startea = idiom_ea
        si.jumps = switch_base
        si.elbase = switch_base
        si.ncases = jump_table_size
        si.regnum = 1 # 1 is IDA's representation of d1
        
        # added by gph
        Message("default jump: %08X\n" % defjump)
        si.flags |= idaapi.SWI_DEFAULT
        si.defjump = defjump
        
        # if we found a value table...
        if value_base != None and value_width != None:
            si.values = value_base
            si.set_vtable_element_size(value_width)
            total_switch_size = jump_table_size * (2 + value_width)
            
        si.flags |= idaapi.SWI_ELBASE | idaapi.SWI_SPARSE
        idaapi.set_switch_info_ex(idiom_ea, si)
        idaapi.create_switch_table(idiom_ea, si)
        idaapi.setFlags(idiom_ea, idaapi.getFlags(idiom_ea) | idaapi.FF_JUMP)
        # go to the end of the switch statement and make an instruction
        idaapi.create_insn(switch_base + total_switch_size)
        return True
    else:
        print "Error: Could not get jump table size."
        return False

if __name__ == "__main__":
    create_68k_jump_table(here())