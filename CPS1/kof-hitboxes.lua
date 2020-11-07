print("NeoGeo King of Fighters hitbox viewer")
print("February 20, 2012")
print("http://code.google.com/p/mame-rr/wiki/Hitboxes")
print("Lua hotkey 1: toggle blank screen")
print("Lua hotkey 2: toggle object axis")
print("Lua hotkey 3: toggle hitbox axis")
print("Lua hotkey 4: toggle pushboxes")
print("Lua hotkey 5: toggle throwable boxes")

local boxes = {
	      ["vulnerability"] = {color = 0x7777FF, fill = 0x40, outline = 0xFF},
	             ["attack"] = {color = 0xFF0000, fill = 0x40, outline = 0xFF},
	["proj. vulnerability"] = {color = 0x00FFFF, fill = 0x40, outline = 0xFF},
	       ["proj. attack"] = {color = 0xFF66FF, fill = 0x40, outline = 0xFF},
	               ["push"] = {color = 0x00FF00, fill = 0x20, outline = 0xFF},
	              ["guard"] = {color = 0xCCCCFF, fill = 0x40, outline = 0xFF},
	              ["throw"] = {color = 0xFFFF00, fill = 0x40, outline = 0xFF},
	         ["axis throw"] = {color = 0xFFAA00, fill = 0x40, outline = 0xFF}, --kof94, kof95
	          ["throwable"] = {color = 0xF0F0F0, fill = 0x20, outline = 0xFF},
}

local globals = {
	axis_color           = 0xFFFFFFFF,
	blank_color          = 0xFFFFFFFF,
	axis_size            = 12,
	mini_axis_size       = 2,
	blank_screen         = false,
	draw_axis            = true,
	draw_mini_axis       = false,
	draw_pushboxes       = true,
	draw_throwable_boxes = false,
	no_alpha             = false, --fill = 0x00, outline = 0xFF for all box types
}

--------------------------------------------------------------------------------
-- game-specific modules

local rb, rbs, rw, rws, rd, fc = memory.readbyte, memory.readbytesigned, memory.readword, memory.readwordsigned, memory.readdword, emu.framecount
local game, frame_buffer, throw_buffer
local any_true, process_throw, define_box, gr
local a,v,p,g,t = "attack","vulnerability","proj. vulnerability","guard","throw"

local profile = {
{	games = {"kof94"},
	address = {
		game_phase   = 0x1090B3,
		screen_left  = 0x10904C,
		screen_top   = 0x10905C,
		obj_ptr_list = 0x1097A6,
	},
	offset = {status = 0x7A},
	box_types = {a,g,v,v,a},
	unthrowable = function(obj) return any_true({
		bit.btst(5, rb(obj.base + 0xE3)) > 0,
		rd(obj.base + 0xAA) > 0,
		bit.btst(3, rb(obj.base + 0x7B)) > 0,
	}) end,
	special_throws = {
		{subroutine = 0x00DD40, range_offset = 0x50, lsr = 1}, --heidern 63214+C
		{subroutine = 0x00F516, range_offset = 0x50, lsr = 1}, --ralf 41236+D
		{subroutine = 0x010704, range_offset = 0x50, lsr = 1}, --clark 41236+D
		{subroutine = 0x010F46, range_offset = 0x6C, lsr = 1}, --clark DM
		{subroutine = 0x0188A0, range_offset = 0x4E, lsr = 0}, --daimon 6123+D
		{subroutine = 0x01955E, range_offset = 0x4E, lsr = 0}, --daimon 632146+C
		{subroutine = 0x019EB2, range_offset = 0x6A, lsr = 0}, --daimon DM
		{subroutine = 0x029142, range_offset = 0x40}, --takuma 63214+D 
		{subroutine = 0x02ACF0, range_offset = 0x40}, --yuri 623+P
		table_base = 0x06C0F0,
	},
	breakpoints = {
		{pc = 0x00A3DA, func = function() process_throw({ --ground throw
			type = "throw", 
			range = rb(gr("a0") + 0x2)})
		end},
		{pc = 0x00A410, func = function() process_throw({ --air throw
			type = "throw", 
			range = rb(gr("a0") + 0x2), 
			air = true})
		end},
		{pc = 0x00786C, func = function() process_throw({ --special move
			type = "axis throw", 
			ptr = gr("a0")})
		end},
	},
},
{	games = {"kof95"},
	address = {game_phase = 0x10B088},
	box_types = {a,g,v,v,a},
	unthrowable = function(obj) return any_true({
		bit.btst(5, rb(obj.base + 0xE3)) > 0,
		rd(obj.base + 0xAA) > 0,
		bit.btst(3, rb(obj.base + 0x7D)) > 0,
	}) end,
	special_throws = {
		{subroutine = 0x00E834, range_offset = 0x50, lsr = 1}, --heidern 63214+C
		{subroutine = 0x01014A, range_offset = 0x50, lsr = 1}, --ralf 41236+D
		{subroutine = 0x0115AE, range_offset = 0x50, lsr = 1}, --clark 41236+D
		{subroutine = 0x0120FC, range_offset = 0x6C, lsr = 1}, --clark DM
		{subroutine = 0x01AE82, range_offset = 0x4E, lsr = 0}, --daimon 6123+D
		{subroutine = 0x01BB68, range_offset = 0x4E, lsr = 0}, --daimon 632146+C
		{subroutine = 0x01CBEA, range_offset = 0x6A, lsr = 0}, --daimon DM
		{subroutine = 0x01195A, range_offset = 0x1A, delay = 0x7C}, --clark 41236+C 
		{subroutine = 0x02EB72, range_offset = 0x12}, --takuma 63214+D 
		{subroutine = 0x0304F2, range_offset = 0x40}, --yuri 41236+A
		{subroutine = 0x030872, range_offset = 0x12}, --yuri 41236+C 
		table_base = 0x079FC0,
	},
	breakpoints = {
		{pc = 0x00A62A, func = function() process_throw({ --ground throw
			type = "throw", 
			range = rb(gr("a0") + 0x2)})
		end},
		{pc = 0x00A660, func = function() process_throw({ --air throw
			type = "throw", 
			range = rb(gr("a0") + 0x2), air = true})
		end},
		{pc = 0x00758C, func = function() process_throw({ --cmd throw (opponent-independent range)
			type = "axis throw", 
			ptr = gr("a0")})
		end},
		{pc = 0x0077DC, func = function() process_throw({ --cmd throw (opponent-dependent range)
			type = "axis throw", 
			ptr = gr("a0")})
		end},
	},
},
{	games = {"kof96"},
	address = {game_phase = 0x10B08E},
	box_types = {
		v,v,v,v,v,v,v,v,g,g,v,a,a,a,a,a,
		a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,
		a,a,a,a,a,a,a,a,a,a,a,a,g,g,p,p,
		p,p,p,p
	},
},
{	games = {"kof97"},
	address = {game_phase = 0x10B092},
	box_types = {
		v,v,v,v,v,v,v,v,v,g,g,a,a,a,a,a,
		a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,
		a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,
		a,a,a,a,a,a,a,g,g,p,p,p,p,p,p
	},
},
{	games = {"kof98"},
	address = {game_phase = 0x10B094},
	box_types = {
		v,v,v,v,v,v,v,v,v,g,g,a,a,a,a,a,
		a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,
		a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,
		a,a,a,a,a,a,a,g,g,p,p,p,p,p,p
	},
},
{	games = {"kof99", "kof2000"},
	address = {game_phase = 0x10B048},
	box_types = {
		v,v,v,v,v,v,v,v,v,g,g,a,a,a,a,a,
		a,a,a,a,a,a,v,a,a,a,a,a,a,a,a,a,
		a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,
		a,a,a,a,a,a,a,g,g,p,p,p,p,p,p
	},
},
{	games = {"kof2001", "kof2002"},
	address = {game_phase = 0x10B056},
	box_types = {
		v,v,v,v,v,v,v,v,v,g,g,a,a,a,a,a,
		a,a,a,a,a,a,v,a,a,a,a,a,a,a,a,a,
		a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,
		a,a,a,a,a,a,a,g,g,p,p,p,p,p,p
	},
},
}


--------------------------------------------------------------------------------
-- post-process modules

for game in ipairs(profile) do
	local g = profile[game]
	g.number_players = 2
	g.ground_level   = 16
	g.address.player = 0x108100
	g.address.screen_left  = g.address.screen_left  or g.address.game_phase + 0x038
	g.address.screen_top   = g.address.screen_top   or g.address.game_phase + 0x040
	g.address.obj_ptr_list = g.address.obj_ptr_list or g.address.game_phase + 0xE90
	g.offset = g.offset or {}
	g.offset.player_space = g.offset.player_space or 0x200
	g.offset.pos_x  = g.offset.pos_x  or 0x18
	g.offset.pos_y  = g.offset.pos_y  or 0x26
	g.offset.flip_x = g.offset.flip_x or 0x31
	g.offset.status = g.offset.status or 0x7C
	g.box_list = {
		{offset = 0xA4, type = "push"},
		{offset = 0x9F, type = "undefined", active_bit = 3},
		{offset = 0x9A, type = "undefined", active_bit = 2},
		{offset = 0x95, type = "undefined", active_bit = 1},
		{offset = 0x90, type = "undefined", active_bit = 0},
	}
	g.insert_throwable = g.special_throws and function(obj) --kof94 ~ kof95
		obj.air = bit.btst(0, rb(obj.base + 0xE1))
		obj.throw_ptr = (rd(obj.base + 0x1A0))
		obj.opp_id = rw(rd(obj.base + 0xB6) + 0x182)
		if g.unthrowable(obj) then
			return
		end
		local range = {
			x = rw(obj.throw_ptr + 0x0E + obj.air * 2),
			y = rw(obj.throw_ptr + 0x12),
		}
		local box = {
			type   = "throwable",
			val_x   = obj.pos_x,
			left   = obj.pos_x - range.x,
			right  = obj.pos_x + range.x,
			bottom = obj.pos_y + range.y * obj.air,
		}
		box.top = box.bottom - range.y * 2
		box.val_y = (box.top + box.bottom)/2
		return box
	end or 
	function(obj) --kof96 ~ kof2002
		return define_box(obj, {offset = 0x18D, type = "throwable"})
	end
end

for _, box in pairs(boxes) do
	box.fill    = bit.lshift(box.color, 8) + (globals.no_alpha and 0x00 or box.fill)
	box.outline = bit.lshift(box.color, 8) + (globals.no_alpha and 0xFF or box.outline)
end
boxes["undefined"] = {}

emu.update_func = fba and emu.registerafter or emu.registerbefore
emu.registerfuncs = fba and memory.registerexec --0.0.7+


--------------------------------------------------------------------------------
-- functions referenced in the modules

any_true = function(condition)
	for n = 1, #condition do
		if condition[n] == true then return true end
	end
end


bit.btst = function(bit_number, value)
	return bit.band(bit.lshift(1, bit_number), value)
end


gr = function(register)
	return memory.getregister("m68000." .. register)
end


local get_thrower = function()
	local base = bit.band(gr("a4"), 0xFFFFFF)
	for _, obj in ipairs(frame_buffer) do
		if base == obj.base then
			return obj
		end
	end
end


process_throw = function(box) --kof94 ~ kof95
	local obj = get_thrower()
	if not box.range then --special move
		for _, move in ipairs(game.special_throws) do
			if box.ptr == move.subroutine then
				box.range = rw(move.subroutine + move.range_offset)
				if move.lsr then --opponent-dependent range
					obj.opp_id = rw(rd(obj.base + 0xB6) + 0x182)
					box.range = box.range + bit.rshift(rw(game.special_throws.table_base + obj.opp_id), move.lsr)
				elseif move.delay and rbs(obj.base + move.delay) > 0 then
					return
				end
				break
			end
		end
	end
	if not box.range then --non-throw specials
		return
	end
	box.left   = obj.pos_x
	box.right  = obj.pos_x - box.range * obj.flip_x
	box.top    = obj.pos_y - (box.air and 0 or rw(obj.throw_ptr + 0x12) * 2)
	box.bottom = obj.pos_y
	box.val_x  = (box.left + box.right)/2
	box.val_y  = (box.top + box.bottom)/2

	throw_buffer[obj.base] = box
end


--------------------------------------------------------------------------------
-- prepare the hitboxes

local type_check = {
	["undefined"] = function(obj, box_entry, box)
		if bit.btst(box_entry.active_bit, obj.status) == 0 then
			return true
		end
		box.type = game.box_types[box.id] or "undefined"
		if box.type == "attack" then
			if box_entry.active_bit == 1 then
				return true --"ghost boxes"?
			elseif obj.projectile then
				box.type = "proj. attack"
			end
		end
	end,

	["push"] = function(obj, box_entry, box)
		if box.id == 0xFF or obj.projectile then
			return true
		end
	end,

	["throw"] = function(obj, box_entry, box)
		box.id = rb(obj.base + box_entry.id)
		if box.id == 0 then
			return true
		elseif box.clear then
			memory.writebyte(obj.base + box_entry.id, 0) --bad
		end
	end,

	["throwable"] = function(obj, box_entry, box)
		return any_true({
			bit.btst(5, rb(obj.base + 0xE3)) > 0,
			rb(obj.base + 0x1D4) > 0,
			rbs(obj.base + 0x18D) < 0,
			bit.band(3, rb(obj.base + 0x7E)) == 1,
		})
	end,
}


define_box = function(obj, box_entry)
	local box = {
		address = obj.base + box_entry.offset,
		type = box_entry.type,
		clear = box_entry.clear,
	}
	box.id = rb(box.address)

	if type_check[box.type](obj, box_entry, box) then
		return nil
	end

	box.rad_x = rb (box.address + 0x3)
	box.rad_y = rb (box.address + 0x4)
	box.val_x = rbs(box.address + 0x1)
	box.val_y = rbs(box.address + 0x2)
	if box.rad_x == 0 and box.rad_y == 0 and box.val_x == 0 and box.val_y == 0 then
		return nil
	end

	box.val_x  = obj.pos_x + box.val_x * obj.flip_x
	box.val_y  = obj.pos_y + box.val_y
	box.left   = box.val_x - box.rad_x
	box.right  = box.val_x + box.rad_x - 1
	box.top    = box.val_y - box.rad_y
	box.bottom = box.val_y + box.rad_y - 1

	return box
end


local update_object = function(f, obj)
	obj.pos_x = rws(obj.base + game.offset.pos_x) - f.screen_left
	obj.pos_y = rws(obj.base + game.offset.pos_y) - game.ground_level
	obj.flip_x = bit.btst(0, rb(obj.base + game.offset.flip_x)) > 0 and -1 or 1
	obj.status = rb(obj.base + game.offset.status)
	for _, box_entry in ipairs(game.box_list) do
		table.insert(obj, define_box(obj, box_entry))
	end

	if obj.projectile then
		return obj
	end
	table.insert(obj, game.insert_throwable(obj) or nil)
	if emu.registerfuncs then --throw_buffer is only good if wps/bps available
		table.insert(obj, throw_buffer[obj.base] or nil)
		throw_buffer[obj.base] = nil
	else
		table.insert(obj, define_box(obj, 
			{offset = 0x188, id = 0x192, type = "throw", clear = true}))
	end
	return obj
end


local read_projectiles = function(f)
	local offset = 0
	while true do
		local obj = {base = rw(game.address.obj_ptr_list + offset)}
		obj.projectile = true
		if obj.base == 0 or rws(bit.bor(0x100000, obj.base) + 0x6) < 0 then
			return
		end
		for _, old_obj in ipairs(f) do
			if obj.base == bit.band(old_obj.base, 0xFFFF) then
				return
			end
		end
		obj.base = bit.bor(0x100000, obj.base)
		table.insert(f, update_object(f, obj))
		offset = offset + 2
	end
end


local bios_test = function(address)
	local ram_value = rw(address)
	for _, test_value in ipairs({0x5555, 0xAAAA, bit.band(0xFFFF, address)}) do
		if ram_value == test_value then
			return true
		end
	end
end


local update_hitboxes = function()
	frame_buffer = {match_active = game and not bios_test(game.address.player) and rb(game.address.game_phase) > 0}
	local f = frame_buffer

	if not f.match_active then
		return
	end

	f.screen_left = rws(game.address.screen_left) + (320 - emu.screenwidth()) / 2 --fba removes the side margins for some games
	f.screen_top  = rws(game.address.screen_top)

	for p = 1, game.number_players do
		local player = {base = game.address.player + game.offset.player_space * (p-1)}
		table.insert(f, update_object(f, player))
	end
	read_projectiles(f)

	f.max_boxes = 0
	for _, obj in ipairs(f or {}) do
		f.max_boxes = math.max(f.max_boxes, #obj)
	end
end


emu.update_func( function()
	globals.register_count = (globals.register_count or 0) + 1
	globals.last_frame = globals.last_frame or fc()
	if globals.register_count == 1 then
		update_hitboxes()
	end
	if globals.last_frame < fc() then
		globals.register_count = 0
	end
	globals.last_frame = fc()
end)


--------------------------------------------------------------------------------
-- draw the hitboxes

local draw_hitbox = function(hb)
	if not hb or any_true({
		not globals.draw_pushboxes and hb.type == "push",
		not globals.draw_throwable_boxes and hb.type == "throwable",
		}) then return
	end

	if globals.draw_mini_axis then
		gui.drawline(hb.val_x, hb.val_y-globals.mini_axis_size, hb.val_x, hb.val_y+globals.mini_axis_size, boxes[hb.type].outline)
		gui.drawline(hb.val_x-globals.mini_axis_size, hb.val_y, hb.val_x+globals.mini_axis_size, hb.val_y, boxes[hb.type].outline)
		--gui.text(hb.val_x, hb.val_y, string.format("%02X", hb.id or 0xFF)) --debug
	end

	gui.box(hb.left, hb.top, hb.right, hb.bottom, boxes[hb.type].fill, boxes[hb.type].outline)
end


local draw_axis = function(obj)
	gui.drawline(obj.pos_x, obj.pos_y-globals.axis_size, obj.pos_x, obj.pos_y+globals.axis_size, globals.axis_color)
	gui.drawline(obj.pos_x-globals.axis_size, obj.pos_y, obj.pos_x+globals.axis_size, obj.pos_y, globals.axis_color)
	--gui.text(obj.pos_x, obj.pos_y, string.format("%06X", obj.base)) --debug
	--gui.text(obj.pos_x, obj.pos_y-0x08, string.format("%08X", obj.hitbox_ptr)) --debug
end


local render_hitboxes = function()
	gui.clearuncommitted()

	local f = frame_buffer
	if not f.match_active then
		return
	end

	if globals.blank_screen then
		gui.box(0, 0, emu.screenwidth(), emu.screenheight(), globals.blank_color)
	end

	for entry = 1, f.max_boxes or 0 do
		for _, obj in ipairs(f) do
			draw_hitbox(obj[entry])
		end
	end

	if globals.draw_axis then
		for _, obj in ipairs(f) do
			draw_axis(obj)
		end
	end
end


gui.register(function()
	render_hitboxes()
end)


--------------------------------------------------------------------------------
-- hotkey functions

input.registerhotkey(1, function()
	globals.blank_screen = not globals.blank_screen
	render_hitboxes()
	emu.message((globals.blank_screen and "activated" or "deactivated") .. " blank screen mode")
end)


input.registerhotkey(2, function()
	globals.draw_axis = not globals.draw_axis
	render_hitboxes()
	emu.message((globals.draw_axis and "showing" or "hiding") .. " object axis")
end)


input.registerhotkey(3, function()
	globals.draw_mini_axis = not globals.draw_mini_axis
	render_hitboxes()
	emu.message((globals.draw_mini_axis and "showing" or "hiding") .. " hitbox axis")
end)


input.registerhotkey(4, function()
	globals.draw_pushboxes = not globals.draw_pushboxes
	render_hitboxes()
	emu.message((globals.draw_pushboxes and "showing" or "hiding") .. " pushboxes")
end)


input.registerhotkey(5, function()
	globals.draw_throwable_boxes = not globals.draw_throwable_boxes
	render_hitboxes()
	emu.message((globals.draw_throwable_boxes and "showing" or "hiding") .. " throwable boxes")
end)


--------------------------------------------------------------------------------
-- initialize on game startup

local initialize_bps = function()
	for _, pc in ipairs(globals.breakpoints or {}) do
		memory.registerexec(pc, nil)
	end
	globals.breakpoints = {}
	if globals.watchpoint then
		memory.registerwrite(globals.watchpoint, nil)
	end
	globals.watchpoint = nil
end


local set_wp = function()
	local f = frame_buffer
	local obj = get_thrower()
	if not f.match_active or not obj then
		return
	end
	local box = define_box(obj, {offset = 0x188, id = 0x192, type = "throw"})
	throw_buffer[obj.base] = box
end


local throw_watch = {
	["kof96"]   = 0x10E70D,
	["kof97"]   = 0x10EBDD,
	["kof98"]   = 0x10EBDF,
	["kof99"]   = 0x10EB41,
	["kof2000"] = 0x10EB93,
	["kof2001"] = 0x10E809,
	["kof2002"] = 0x10E7B5,
}


local whatgame = function()
	print()
	game = nil
	frame_buffer, throw_buffer = {}, {}
	initialize_bps()
	for _, module in ipairs(profile) do
		for _, shortname in ipairs(module.games) do
			if emu.romname() == shortname or emu.parentname() == shortname then
				print("drawing hitboxes for " .. emu.gamename())
				game = module
				local wp = throw_watch[shortname]
				if emu.registerfuncs and wp then
					memory.registerwrite(wp, 1, set_wp)
					globals.watchpoint = wp
				end
				if not game.breakpoints then
					return
				elseif not emu.registerfuncs then
					print("(FBA-rr 0.0.7+ can show throwboxes for " .. emu.romname() .. ".)")
					return
				end
				for _, bp in ipairs(game.breakpoints) do
					memory.registerexec(bp.pc, bp.func)
					table.insert(globals.breakpoints, bp.pc)
				end
				return
			end
		end
	end
	print("unsupported game: " .. emu.gamename())
end


savestate.registerload(function()
	frame_buffer, throw_buffer = {}, {}
end)


emu.registerstart(function()
	whatgame()
end)