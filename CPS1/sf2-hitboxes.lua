sf2-hitboxes.lua

print("Street Fighter II hitbox viewer")
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
	               ["weak"] = {color = 0xFFFF00, fill = 0x40, outline = 0xFF},
	              ["throw"] = {color = 0xFFFF00, fill = 0x40, outline = 0xFF},
	          ["throwable"] = {color = 0xF0F0F0, fill = 0x20, outline = 0xFF},
	      ["air throwable"] = {color = 0x202020, fill = 0x20, outline = 0xFF},
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

local rb, rbs, rw, rws, rd = memory.readbyte, memory.readbytesigned, memory.readword, memory.readwordsigned, memory.readdword

local profile = {
{	games = {"sf2"},
	address = {
		player      = 0xFF83C6,
		projectile  = 0xFF938A,
		screen_left = 0xFF8BD8,
	},
	player_space       = 0x300,
	box_parameter_size = 1,
	box_list = {
		{addr_table = 0xA, id_ptr = 0xD, id_space = 0x04, type = "push"},
		{addr_table = 0x0, id_ptr = 0x8, id_space = 0x04, type = "vulnerability"},
		{addr_table = 0x2, id_ptr = 0x9, id_space = 0x04, type = "vulnerability"},
		{addr_table = 0x4, id_ptr = 0xA, id_space = 0x04, type = "vulnerability"},
		{addr_table = 0x6, id_ptr = 0xB, id_space = 0x04, type = "weak"},
		{addr_table = 0x8, id_ptr = 0xC, id_space = 0x0C, type = "attack"},
	},
},
{	games = {"sf2ce", "sf2hf"},
	address = {
		player      = 0xFF83BE,
		projectile  = 0xFF9376,
		screen_left = 0xFF8BC4,
	},
	player_space       = 0x300,
	box_parameter_size = 1,
	box_list = {
		{addr_table = 0xA, id_ptr = 0xD, id_space = 0x04, type = "push"},
		{addr_table = 0x0, id_ptr = 0x8, id_space = 0x04, type = "vulnerability"},
		{addr_table = 0x2, id_ptr = 0x9, id_space = 0x04, type = "vulnerability"},
		{addr_table = 0x4, id_ptr = 0xA, id_space = 0x04, type = "vulnerability"},
		--{addr_table = 0x6, id_ptr = 0xB, id_space = 0x04, type = "weak"}, --present but nonfunctional
		{addr_table = 0x8, id_ptr = 0xC, id_space = 0x0C, type = "attack"},
	},
},
{	games = {"ssf2t"},
	address = {
		player      = 0xFF844E,
		projectile  = 0xFF97A2,
		screen_left = 0xFF8ED4,
		stage       = 0xFFE18A,
	},
	player_space       = 0x400,
	box_parameter_size = 1,
	box_list = {
		{addr_table = 0x8, id_ptr = 0xD, id_space = 0x04, type = "push"},
		{addr_table = 0x0, id_ptr = 0x8, id_space = 0x04, type = "vulnerability"},
		{addr_table = 0x2, id_ptr = 0x9, id_space = 0x04, type = "vulnerability"},
		{addr_table = 0x4, id_ptr = 0xA, id_space = 0x04, type = "vulnerability"},
		{addr_table = 0x6, id_ptr = 0xC, id_space = 0x10, type = "attack"},
	},
},
{	games = {"ssf2"},
	address = {
		player      = 0xFF83CE,
		projectile  = 0xFF96A2,
		screen_left = 0xFF8DD4,
		stage       = 0xFFE08A,
	},
	player_space       = 0x400,
	box_parameter_size = 1,
	box_list = {
		{addr_table = 0x8, id_ptr = 0xD, id_space = 0x04, type = "push"},
		{addr_table = 0x0, id_ptr = 0x8, id_space = 0x04, type = "vulnerability"},
		{addr_table = 0x2, id_ptr = 0x9, id_space = 0x04, type = "vulnerability"},
		{addr_table = 0x4, id_ptr = 0xA, id_space = 0x04, type = "vulnerability"},
		{addr_table = 0x6, id_ptr = 0xC, id_space = 0x0C, type = "attack"},
	},
},
{	games = {"hsf2"},
	address = {
		player      = 0xFF833C,
		projectile  = 0xFF9554,
		screen_left = 0xFF8CC2,
		stage       = 0xFF8B64,
	},
	char_mode          = 0x32A,
	player_space       = 0x400,
	box_parameter_size = 2,
	box_list = {
		{addr_table = 0xA, id_ptr = 0xD, id_space = 0x08, type = "push"},
		{addr_table = 0x0, id_ptr = 0x8, id_space = 0x08, type = "vulnerability"},
		{addr_table = 0x2, id_ptr = 0x9, id_space = 0x08, type = "vulnerability"},
		{addr_table = 0x4, id_ptr = 0xA, id_space = 0x08, type = "vulnerability"},
		{addr_table = 0x6, id_ptr = 0xB, id_space = 0x08, type = "weak"},
		{addr_table = 0x8, id_ptr = 0xC, id_space = 0x14, type = "attack"},
	},
	match_active = function()
		return rw(0xFF8004) == 0x08
	end,
},
}

for _, game in ipairs(profile) do
	game.match_active = game.match_active or function()
		return bit.band(rw(0xFF8008), 0x08) > 0
	end
end

for _, box in pairs(boxes) do
	box.fill    = bit.lshift(box.color, 8) + (globals.no_alpha and 0x00 or box.fill)
	box.outline = bit.lshift(box.color, 8) + (globals.no_alpha and 0xFF or box.outline)
end

local game, frame_buffer, throw_buffer
local NUMBER_OF_PLAYERS = 2
local MAX_PROJECTILES   = 8
local MAX_BONUS_OBJECTS = 16
local DRAW_DELAY        = 1
if fba then
	DRAW_DELAY = DRAW_DELAY + 1
end
emu.registerfuncs = fba and memory.registerexec --0.0.7+


--------------------------------------------------------------------------------
-- prepare the hitboxes

local get_box_parameters = {
	[1] = function(box)
		box.val_x  = rbs(box.address + 0)
		box.val_x2 =  rb(box.address + 5)
		if box.val_x2 >= 0x80 and box.type == "attack" then
			box.val_x = -box.val_x2
		end
		box.val_y  = rbs(box.address + 1)
		box.rad_x  =  rb(box.address + 2)
		box.rad_y  =  rb(box.address + 3)
	end,

	[2] = function(box)
		box.val_x = rws(box.address + 0)
		box.val_y = rws(box.address + 2)
		box.rad_x =  rw(box.address + 4)
		box.rad_y =  rw(box.address + 6)
	end,
}


local process_box_type = {
	["vulnerability"] = function(obj, box)
	end,

	["attack"] = function(obj, box)
		if obj.projectile then
			box.type = "proj. attack"
		elseif rb(obj.base + 0x03) == 0 then
			return false
		end
	end,

	["push"] = function(obj, box)
		if obj.projectile then
			box.type = "proj. vulnerability"
		end
	end,

	["weak"] = function(obj, box)
		if (game.char_mode and rb(obj.base + game.char_mode) ~= 0x4)
			or rb(obj.animation_ptr + 0x15) ~= 2 then
			return false
		end
	end,

	["throw"] = function(obj, box)
		get_box_parameters[2](box)
		if box.val_x == 0 and box.val_y == 0 and box.rad_x == 0 and box.rad_y == 0 then
			return false
		end

		if box.clear then
			for offset = 0, 6, 2 do
				memory.writeword(box.address + offset, 0) --bad
			end
		end

		box.val_x  = obj.pos_x + box.val_x * (obj.flip_x == 1 and -1 or 1)
		box.val_y  = obj.pos_y - box.val_y
		box.left   = box.val_x - box.rad_x
		box.right  = box.val_x + box.rad_x
		box.top    = box.val_y - box.rad_y
		box.bottom = box.val_y + box.rad_y
	end,

	["throwable"] = function(obj, box)
		if (rb(obj.animation_ptr + 0x8) == 0 and
			rb(obj.animation_ptr + 0x9) == 0 and
			rb(obj.animation_ptr + 0xA) == 0) or
			rb(obj.base + 0x3) == 0x0E or
			rb(obj.base + 0x3) == 0x14 or
			rb(obj.base + 0x143) > 0 or
			rb(obj.base + 0x1BF) > 0 or
			rb(obj.base + 0x1A1) > 0 then
			return false
		elseif rb(obj.base + 0x181) > 0 then
			box.type = "air throwable"
		end

		box.rad_x  = rw(box.address + 0)
		box.rad_y  = rw(box.address + 2)
		box.val_x  = obj.pos_x
		box.val_y  = obj.pos_y - box.rad_y/2
		box.left   = box.val_x - box.rad_x
		box.right  = box.val_x + box.rad_x
		box.top    = obj.pos_y - box.rad_y
		box.bottom = obj.pos_y
	end,
}


local define_box = function(obj, box_entry)
	local box = {
		type = box_entry.type,
		id = rb(obj.animation_ptr + box_entry.id_ptr),
	}

	if box.id == 0 or process_box_type[box.type](obj, box) == false then
		return nil
	end

	local addr_table = obj.hitbox_ptr + rws(obj.hitbox_ptr + box_entry.addr_table)
	box.address = addr_table + box.id * box_entry.id_space
	get_box_parameters[game.box_parameter_size](box)

	box.val_x  = obj.pos_x + box.val_x * (obj.flip_x == 1 and -1 or 1)
	box.val_y  = obj.pos_y - box.val_y
	box.left   = box.val_x - box.rad_x
	box.right  = box.val_x + box.rad_x
	box.top    = box.val_y - box.rad_y
	box.bottom = box.val_y + box.rad_y

	return box
end


local define_throw_box = function(obj, box_entry)
	local box = {
		type = box_entry.type,
		address = obj.base + box_entry.param_offset,
		clear = box_entry.clear,
	}

	if process_box_type[box.type](obj, box) == false then
		return nil
	end

	return box
end


local update_object = function(f, obj)
	obj.pos_x         = rws(obj.base + 0x06) - f.screen_left
	obj.pos_y         = rws(obj.base + 0x0A)
	obj.pos_y         = emu.screenheight() - (obj.pos_y - 0x0F) + f.screen_top
	obj.flip_x        = rb(obj.base + 0x12)
	obj.animation_ptr = rd(obj.base + 0x1A)
	obj.hitbox_ptr    = rd(obj.base + 0x34)

	for _, box_entry in ipairs(game.box_list) do
		table.insert(obj, define_box(obj, box_entry))
	end
	return obj
end


local read_projectiles = function(f)
	for i = 1, MAX_PROJECTILES do
		local obj = {base = game.address.projectile + (i-1) * 0xC0}
		if rw(obj.base) == 0x0101 then
			obj.projectile = true
			table.insert(f, update_object(f, obj))
		end
	end

	for i = 1, MAX_BONUS_OBJECTS do
		local obj = {base = game.address.projectile + (MAX_PROJECTILES + i-1) * 0xC0}
		if bit.band(0xFF00, rw(obj.base)) == 0x0100 then
			obj.bonus = true
			table.insert(f, update_object(f, obj))
		end
	end
end


local adjust_delay = function(stage_address)
	if fba then
		return emu.sourcename() == "CPS2" and 0 or 1
	elseif not stage_address then
		return 0
	end
	local stage_lag = {
		[0x0] = 0, --Ryu
		[0x1] = 0, --E.Honda
		[0x2] = 0, --Blanka
		[0x3] = 0, --Guile
		[0x4] = 0, --Ken
		[0x5] = 0, --Chun Li
		[0x6] = 0, --Zangief
		[0x7] = 0, --Dhalsim
		[0x8] = 0, --Dictator
		[0x9] = 0, --Sagat
		[0xA] = 1, --Boxer*
		[0xB] = 0, --Claw
		[0xC] = 1, --Cammy*
		[0xD] = 1, --T.Hawk*
		[0xE] = 0, --Fei Long
		[0xF] = 1, --Dee Jay*
	}
	return stage_lag[bit.band(rw(stage_address), 0xF)]
end


local update_hitboxes = function()
	if not game then
		return
	end
	local effective_delay = DRAW_DELAY + adjust_delay(game.address.stage)
	for f = 1, effective_delay do
		frame_buffer[f] = copytable(frame_buffer[f+1])
	end

	frame_buffer[effective_delay+1] = {match_active = game.match_active()}
	local f = frame_buffer[effective_delay+1]

	f.screen_left = rws(game.address.screen_left)
	f.screen_top  = rws(game.address.screen_left + 0x4)

	for p = 1, NUMBER_OF_PLAYERS do
		local player = {base = game.address.player + (p-1) * game.player_space}
		if rb(player.base) > 0 then
			table.insert(f, update_object(f, player))
			local tb = throw_buffer[player.base]
			table.insert(player, tb[1])
			for frame = 1, #tb-1 do
				tb[frame] = tb[frame+1]
			end
			table.remove(tb)
		end
	end
	read_projectiles(f)

	--f = frame_buffer[effective_delay]
	for _, obj in ipairs(f or {}) do
		if obj.projectile or obj.bonus then
			break
		end
		table.insert(obj, define_throw_box(obj, {param_offset = 0x6C, type = "throwable"}))
		if not emu.registerfuncs then
			table.insert(obj, define_throw_box(obj, {param_offset = 0x64, type = "throw", clear = true}))
		end
	end

	f.max_boxes = 0
	for _, obj in ipairs(f or {}) do
		f.max_boxes = math.max(f.max_boxes, #obj)
	end
end

emu.registerafter( function()
	update_hitboxes()
end)


--------------------------------------------------------------------------------
-- draw the hitboxes

local draw_hitbox = function(hb)
	if not hb or
		(not globals.draw_pushboxes and hb.type == "push") or
		(not globals.draw_throwable_boxes and (hb.type == "throwable" or hb.type == "air throwable")) then
		return
	end

	if globals.draw_mini_axis then
		gui.drawline(hb.val_x, hb.val_y-globals.mini_axis_size, hb.val_x, hb.val_y+globals.mini_axis_size, boxes[hb.type].outline)
		gui.drawline(hb.val_x-globals.mini_axis_size, hb.val_y, hb.val_x+globals.mini_axis_size, hb.val_y, boxes[hb.type].outline)
	end

	gui.box(hb.left, hb.top, hb.right, hb.bottom, boxes[hb.type].fill, boxes[hb.type].outline)
end


local draw_axis = function(obj)
	gui.drawline(obj.pos_x, obj.pos_y-globals.axis_size, obj.pos_x, obj.pos_y+globals.axis_size, globals.axis_color)
	gui.drawline(obj.pos_x-globals.axis_size, obj.pos_y, obj.pos_x+globals.axis_size, obj.pos_y, globals.axis_color)
	--gui.text(obj.pos_x, obj.pos_y, string.format("%06X", obj.base)) --debug
end


local render_hitboxes = function()
	gui.clearuncommitted()

	local f = frame_buffer[1]
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


gui.register( function()
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

local initialize_wps = function()
	for _, addr in ipairs(globals.watchpoints or {}) do
		memory.registerwrite(addr, nil)
	end
	globals.watchpoints = {}
end


local initialize_fb = function()
	frame_buffer = {}
	for f = 1, DRAW_DELAY + 3 do
		frame_buffer[f] = {}
	end
end


local initialize_throw_buffer = function()
	throw_buffer = {}
	for p = 1, NUMBER_OF_PLAYERS do
		throw_buffer[game.address.player + (p-1) * game.player_space] = {}
	end
end


get_thrower = function(f)
	local base = bit.band(0xFFFFFF, memory.getregister("m68000.a6"))
	for _, obj in ipairs(f) do
		if base == obj.base then
			return obj
		end
	end
end


local set_wp = function()
	local f = frame_buffer[DRAW_DELAY]
	local obj = get_thrower(f)
	if not f.match_active or not obj then
		return
	end
	table.insert(throw_buffer[obj.base], define_throw_box(obj, {param_offset = 0x64, type = "throw"}) or nil)
end


local throw_watch = {
	["sf2ce"] = 0xFF0A3A,
	["sf2hf"] = 0xFF001C,
	["ssf2"]  = 0xFF0A48,
	["ssf2t"] = 0xFF0A4E,
	["hsf2"]  = 0xFF0CD0,
}


local whatgame = function()
	print()
	game = nil
	initialize_fb()
	initialize_wps()
	for _, module in ipairs(profile) do
		for _, shortname in ipairs(module.games) do
			if emu.romname() == shortname or emu.parentname() == shortname then
				print("drawing hitboxes for " .. emu.gamename())
				game = module
				initialize_throw_buffer()
				local wp = throw_watch[shortname]
				if not emu.registerfuncs then
					return
				elseif wp then
					memory.registerwrite(wp, 1, set_wp)
					table.insert(globals.watchpoints, wp)
				elseif shortname == "sf2" then --in WW, throws will have the rad_y of the previous throw
					for p = 1, NUMBER_OF_PLAYERS do
						wp = game.address.player + (p-1) * game.player_space + 0x6A
						memory.registerwrite(wp, 2, set_wp)
						table.insert(globals.watchpoints, wp)
					end
				end
				return
			end
		end
	end
	print("unsupported game: " .. emu.gamename())
end


savestate.registerload(function()
	initialize_fb()
end)


emu.registerstart(function()
	whatgame()
end)