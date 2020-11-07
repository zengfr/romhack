beatemup-hitboxes.lua mame-rr-original

print("CPS-2 beat 'em up hitbox viewer")
print("November 11, 2011")
print("http://code.google.com/p/mame-rr/wiki/Hitboxes")
print("Lua hotkey 1: toggle blank screen")
print("Lua hotkey 2: toggle object axis")
print("Lua hotkey 3: toggle hitbox axis")

local boxes = {
	      ["vulnerability"] = {color = 0x7777FF, fill = 0x40, outline = 0xFF},
	             ["attack"] = {color = 0xFF0000, fill = 0x40, outline = 0xFF},
	["proj. vulnerability"] = {color = 0x00FFFF, fill = 0x40, outline = 0xFF},
	       ["proj. attack"] = {color = 0xFF66FF, fill = 0x40, outline = 0xFF},
}

local globals = {
	axis_color     = 0xFFFFFFFF,
	blank_color    = 0xFFFFFFFF,
	axis_size      = 12,
	mini_axis_size = 2,
	blank_screen   = false,
	draw_axis      = true,
	draw_mini_axis = false,
	no_alpha       = false, --fill = 0x00, outline = 0xFF for all box types
}

--------------------------------------------------------------------------------
-- game-specific modules

--invulnerable: if > 0, don't draw blue
--alive: if == 0, don't draw blue
--hp: if < 0, don't draw blue
--harmless: never draw red
--active: if none == 0, don't draw red

local profile = {
{	game = "ffight",
	address = {
		screen_left = 0xFF8412,
		game_phase  = 0xFF8622,
	},
	offset = {
		flip_x = 0x2E,
		pos_x  = 0x06,
	},
	objects = {
		{address = 0xFF8568, number = 0x0F, space = 0xC0, hp = 0x18}, --players and enemies
		{address = 0xFF90A8, number = 0x06, space = 0xC0, projectile = true}, --weapons
		{address = 0xFF9528, number = 0x08, space = 0xC0, hp = 0x18}, --bosses and enemies
		{address = 0xFFB2E8, number = 0x10, space = 0xC0, hp = 0x18, projectile = true}, --containers
		{address = 0xFFBEE8, number = 0x0A, space = 0xC0, projectile = true}, --items
	},
	box = {
		radius_read = memory.readword,
		val_x = 0x0, val_y = 0x2, rad_x = 0x4, rad_y = 0x6,
		radscale = 1,
	},
	box_list = {
		{anim_ptr = 0x24, addr_table = 0x02, id_ptr = 0x04, id_space = 0x08, type = "vulnerability"},
		{anim_ptr = 0x24, addr_table = 0x00, id_ptr = 0x05, id_space = 0x10, type = "attack"},
	},
	id_read = memory.readbytesigned,
	box_address = function(obj, box, box_entry)
		local address = memory.readdword(obj.base + 0x38)
		address = address + memory.readwordsigned(address + box_entry.addr_table)
		return address + box.id * box_entry.id_space
	end,
},
{	game = "dino",
	address = {
		screen_left = 0xFF8744,
		game_phase  = 0xFF0A4B,
	},
	offset = {
		flip_x = 0x24,
		pos_x  = 0x08,
		pos_z  = 0x10,
	},
	objects = {
		{address = 0xFF8874, number = 0x18, space = 0x0C0, active = {0x14,0x16,0x4C,0xB0}, projectile = true}, --items
		{address = 0xFFB274, number = 0x03, space = 0x180, alive = 0x6C, invulnerable = 0x118}, --players
		{address = 0xFFB6F4, number = 0x18, space = 0x0C0, alive = 0x6C, projectile = true}, --etc
		{address = 0xFFC8F4, number = 0x18, space = 0x0E0, alive = 0x6C}, --enemies
	},
	box = {
		radius_read = memory.readword,
		val_x = 0x4, val_y = 0x8, rad_x = 0x6, rad_y = 0xA,
		radscale = 2,
	},
	box_list = {
		{id_ptr = 0x48, type = "vulnerability", special_offset = 0x2},
		{id_ptr = 0x48, type = "vulnerability", special_offset = 0xE},
		{id_ptr = 0x49, type = "attack", special_offset = 0x2},
	},
	id_read = memory.readbyte,
	exist_val = 0x0101,
	box_address = function(obj, box, box_entry)
		local address = memory.readdword(obj.base + 0x44)
		if address == 0x106000 then --dinosaurs
			address = address + memory.readword(address + box.id * 2)
			if not box_entry.special_offset or (memory.readword(address) == 0 and box_entry.special_offset > 0x2) then
				return nil
			end
			return address + box_entry.special_offset
		end
		return address + box.id * 0xC --everything else
	end,
},
{	game = "punisher",
	address = {
		camera_mode = 0xFF5BD3,
		screen_left = {[1] = 0xFF7376, [88] = 0xFF747C},
		game_phase  = 0xFF4E81,
	},
	offset = {
		flip_x = 0x07,
		pos_x  = 0x20,
		pos_z  = 0x28,
		hitbox_ptr = 0x30,
	},
	objects = {
		{address = 0xFF8E68, number = 0x02, space = 0x100}, --players
		{address = 0xFF9068, number = 0x20, space = 0x0C0, projectile = true}, --shots
		{address = 0xFFA868, number = 0x10, space = 0x0C0, hp = 0x36, alive = 0x16, active = 0x1A}, --enemies
		{address = 0xFFB468, number = 0x19, space = 0x0C0, active = {0x1C,0x86}, projectile = true}, --big items
		{address = 0xFFC728, number = 0x38, space = 0x0C0, alive = 0x0A, projectile = true}, --shots & small items
	},
	box = {
		radius_read = memory.readword,
		val_x = 0x4, val_y = 0x8, rad_x = 0x6, rad_y = 0xA,
		radscale = 2,
	},
	box_list = {
		{id_ptr = 0x3E, type = "vulnerability"},
		{id_ptr = 0x3C, type = "attack"},
	},
	id_read = memory.readword,
	box_address = function(obj, box, box_entry)
		local address = memory.readdword(obj.base + 0x30) + box.id
		if memory.readword(obj.base + 0x1A) == 0x2C and box.type == "proj. attack" then --lasers
			obj.box_count = memory.readword(address)
			obj.dx        = memory.readwordsigned(address + 0x2) * (obj.flip_x > 0 and -1 or 1)
			obj.dy        = memory.readwordsigned(address + 0x4)
			for n = 1, obj.box_count do
				local box = {
					type = box.type,
					left   = obj.pos_x + obj.dx * (n-1),
					top    = obj.pos_y - obj.dy * (n-1), 
					right  = obj.pos_x + obj.dx * n,
					bottom = obj.pos_y - obj.dy * n,
				}
				box.val_x = (box.left + box.right)/2
				box.val_y = (box.top + box.bottom)/2
				table.insert(obj, box)
			end
			return nil
		end
		return address
	end,
},
{	game = "avsp",
	address = {
		screen_left = 0xFF8288,
		game_phase  = 0xFFEE0A,
	},
	offset = {
		flip_x = 0x0F,
		pos_x  = 0x10,
		hitbox_ptr = 0x50,
	},
	objects = {
		{address = 0xFF8380, number = 0x03, space = 0x100}, --players
		{address = 0xFF8680, number = 0x18, space = 0x080, projectile = true}, --player projectiles
		{address = 0xFF9280, number = 0x18, space = 0x0C0, hp = 0x40}, --enemies
		{address = 0xFFA480, number = 0x18, space = 0x080, projectile = true}, --enemy projectiles
		{address = 0xFFB080, number = 0x3C, space = 0x080, harmless = true, projectile = true}, --etc.
	},
	box = {
		radius_read = memory.readbyte,
		val_x = 0x0, val_y = 0x1, rad_x = 0x2, rad_y = 0x3,
		radscale = 1,
	},
	box_list = {
		{anim_ptr = 0x1C, addr_table = 0x00, id_ptr = 0x08, id_space = 0x08, type = "vulnerability"},
		{anim_ptr = 0x1C, addr_table = 0x02, id_ptr = 0x09, id_space = 0x10, type = "attack"},
	},
	id_read = memory.readbyte,
	box_address = function(obj, box, box_entry)
		local address = memory.readdword(obj.base + 0x50)
		address = address + memory.readwordsigned(address + box_entry.addr_table)
		return address + box.id * box_entry.id_space
	end,
},
{	game = "ddtod",
	address = {
		screen_left = 0xFF8630,
		game_phase  = 0xFF805F,
	},
	offset = {
		flip_x = 0x3C,
		pos_x  = 0x08,
		pos_z  = 0x10,
	},
	objects = {
		{address = 0xFF86C8, number = 0x04, space = 0x100}, --players
		{address = 0xFF8AC8, number = 0x18, space = 0x060, projectile = true}, --player projectiles
		{address = 0xFFA5C8, number = 0x18, space = 0x0C0, alive = 0x62}, --enemies
		{address = 0xFFB7C8, number = 0x20, space = 0x060, projectile = true}, --enemy projectiles
		{address = 0xFFDFC8, number = 0x10, space = 0x080, alive = 0x62, projectile = true}, --items
		{address = 0xFFE7C8, number = 0x10, space = 0x080, projectile = true}, --chests, signs
	},
	box = {
		radius_read = memory.readword,
		val_x = 0x4, val_y = 0x8, rad_x = 0x6, rad_y = 0xA,
		radscale = 1,
	},
	box_list = {
		{addr_table = 0x130E52, id_ptr = 0x22, type = "vulnerability"},
		{addr_table = 0x131F92, id_ptr = 0x24, type = "attack"},
	},
	id_read = memory.readword,
	box_address = function(obj, box, box_entry)
		local base_offset = {
			["ddtodj"]   = -0x948, --940412
			["ddtodjr2"] = -0x818, --940113
			["ddtodjr1"] = -0x810, --940125
			["ddtodh"]   = -0x0DC, --940412
			["ddtodur1"] = -0x046, --940113
			["ddtodu"]   = -0x03E, --940125
			["ddtoda"]   = -0x012, --940113
			["ddtodd"]   =  0x000, --940412
			["ddtodhr2"] =  0x054, --940113
			["ddtodhr1"] =  0x05C, --940125
			["ddtodr1"]  =  0x130, --940113
		}
		return box_entry.addr_table + (base_offset[emu.romname()] or 0) + box.id
	end,
},
{	game = "ddsom",
	address = {
		camera_mode = 0xFF8036,
		screen_left = {[0] = 0xFF8506, [1] = 0xFF8556},
		game_phase  = 0xFF8043,
	},
	offset = {
		flip_x = 0x2C,
		pos_x  = 0x08,
		pos_z  = 0x10,
	},
	objects = {
		{address = 0xFF85DE, number = 0x04, space = 0x200, invulnerable = 0x196}, --players
		{address = 0xFF90DE, number = 0x10, space = 0x060, addr_table = 0x11EFA2, projectile = true}, --player projectiles
		{address = 0xFFA99E, number = 0x18, space = 0x0C0, alive = 0x62}, --enemies
		{address = 0xFFBC5E, number = 0x20, space = 0x060, projectile = true}, --enemy projectiles
		--{address = 0xFFE2DE, number = 0x10, space = 0x060, projectile = true}, --items
		{address = 0xFFEEDE, number = 0x10, space = 0x080, projectile = true}, --chests, signs
	},
	box = {
		radius_read = memory.readbyte,
		val_x = 0x0, val_y = 0x2, rad_x = 0x1, rad_y = 0x3,
		radscale = 1,
	},
	box_list = {
		{addr_table = 0x118FD4, id_ptr = 0x38, type = "vulnerability"},
		{addr_table = 0x119214, id_ptr = 0x3A, type = "attack"},
	},
	id_read = memory.readbyte,
	box_address = function(obj, box, box_entry)
		local base_offset = {
			["ddsomh"]   = 0x0000, --960223
			["ddsomb"]   = 0x0000, --960223
			["ddsomjr1"] = 0x1952, --960206
			["ddsomur1"] = 0x1D18, --960209
			["ddsoma"]   = 0x215A, --960619
			["ddsomj"]   = 0x215A, --960619
			["ddsomu"]   = 0x215A, --960619
			["ddsomud"]  = 0x215A, --960619
			["ddsomr3"]  = 0x2AAA, --960208
			["ddsomr2"]  = 0x2BA8, --960209
			["ddsomr1"]  = 0x301A, --960223
			["ddsom"]    = 0x3026, --960619
		}
		local address
		if obj.address then --player projectiles
			address = obj.address + (base_offset[emu.romname()] or 0)
		else
			address = memory.readdword(box_entry.addr_table + (base_offset[emu.romname()] or 0) + memory.readbyte(obj.base + 0x2E) * 4)
		end
		return address + box.id * 8
	end,
},
{	game = "batcir",
	address = {
		screen_left = 0xFF5840,
		game_phase  = 0xFF5997,
	},
	offset = {
		flip_x = 0x07,
		pos_x  = 0x20,
		pos_z  = 0x28,
	},
	objects = {
		{address = 0xFF8268, number = 0x04, space = 0x140, invulnerable = 0xA4}, --players
		{address = 0xFF8768, number = 0x20, space = 0x0C0, projectile = true}, --player projectiles
		{address = 0xFF9F68, number = 0x14, space = 0x0C0, hp = 0x82}, --enemies
		{address = 0xFFAE68, number = 0x10, space = 0x0C0, projectile = true}, --enemy projectiles
		{address = 0xFFBA68, number = 0x10, space = 0x0C0, projectile = true}, --containers
		{address = 0xFFC668, number = 0x20, space = 0x0C0, projectile = true}, --enemy projectiles
		{address = 0xFFDE68, number = 0x08, space = 0x0C0, projectile = true}, --items
		{address = 0xFFE468, number = 0x20, space = 0x0C0, projectile = true}, --items
	},
	box = {
		radius_read = memory.readword,
		val_x = 0x4, val_y = 0x8, rad_x = 0x6, rad_y = 0xA,
		radscale = 2,
	},
	box_list = {
		{id_ptr = 0x40, type = "vulnerability"},
		{id_ptr = 0x42, type = "attack"},
	},
	id_read = memory.readword,
	box_address = function(obj, box, box_entry)
		return 0x370000 + box.id
	end,
},
}

--------------------------------------------------------------------------------
-- post-process modules

for game in ipairs(profile) do
	local g = profile[game]
	g.box.offset_read = g.box.radius_read == memory.readbyte and memory.readbytesigned or memory.readwordsigned
	g.offset.pos_y = g.offset.pos_x + 0x4
	g.exist_val = g.exist_val or 0x0100
	for entry in ipairs(g.objects) do
		if type(g.objects[entry].active) == "number" then
			g.objects[entry].active = {g.objects[entry].active}
		end
	end
	if type(g.address.screen_left) ~= "table" then
		g.address.screen_left = {g.address.screen_left}
	end
end

for _, box in pairs(boxes) do
	box.fill    = bit.lshift(box.color, 8) + (globals.no_alpha and 0x00 or box.fill)
	box.outline = bit.lshift(box.color, 8) + (globals.no_alpha and 0xFF or box.outline)
end

local game, framebuffer
local DRAW_DELAY = 1
if fba then
	DRAW_DELAY = DRAW_DELAY + 1
end


--------------------------------------------------------------------------------
-- prepare the hitboxes

local set_box_center = {
	function(obj, box)
		return
			obj.pos_x + box.val_x * (obj.flip_x > 0 and -1 or 1),
			obj.pos_y - box.val_y
	end,

	function(obj, box)
		return
			obj.pos_x + (box.val_x + box.rad_x) * (obj.flip_x > 0 and -1 or 1),
			obj.pos_y - (box.val_y + box.rad_y)
	end,
}


local function define_box(obj, box_entry)
	local box = {type = box_entry.type}

	local base_id = box_entry.anim_ptr and memory.readdword(obj.base + box_entry.anim_ptr) or obj.base
	box.id = game.id_read(base_id + box_entry.id_ptr)

	if base_id == 0 or box.id <= 0 or 
		(obj.invulnerable and box.type == "vulnerability") or
		(obj.harmless and box.type == "attack") then
		return nil
	elseif obj.projectile then
		box.type = (box.type == "vulnerability" and "proj. vulnerability") or box.type
		box.type = (box.type == "attack" and "proj. attack") or box.type
	end

	box.address = game.box_address(obj, box, box_entry)
	if not box.address then
		return nil
	end

	box.rad_x = game.box.radius_read(box.address + game.box.rad_x)/game.box.radscale
	box.rad_y = game.box.radius_read(box.address + game.box.rad_y)/game.box.radscale
	box.val_x = game.box.offset_read(box.address + game.box.val_x)
	box.val_y = game.box.offset_read(box.address + game.box.val_y)

	box.val_x, box.val_y = set_box_center[game.box.radscale](obj, box)
	box.left   = box.val_x - box.rad_x
	box.right  = box.val_x + box.rad_x
	box.top    = box.val_y - box.rad_y
	box.bottom = box.val_y + box.rad_y

	return box
end


local function update_object(f, obj)
	obj.flip_x = memory.readbyte(obj.base + game.offset.flip_x)
	obj.pos_z  = game.offset.pos_z and memory.readwordsigned(obj.base + game.offset.pos_z) or 0
	obj.pos_x  = memory.readwordsigned(obj.base + game.offset.pos_x) - f.screen_left
	obj.pos_y  = memory.readwordsigned(obj.base + game.offset.pos_y) + obj.pos_z
	obj.pos_y  = emu.screenheight() - (obj.pos_y - 0x0F) + f.screen_top

	for entry in ipairs(game.box_list) do
		table.insert(obj, define_box(obj, game.box_list[entry]))
	end
	return obj
end

local function inactive(base, active)
	for _, offset in ipairs(active) do
		if memory.readword(base + offset) > 0 then
			return false
		end
	end
	return true
end


local function update_hitboxes()
	if not game then
		return
	end
	for f = 1, DRAW_DELAY do
		framebuffer[f] = copytable(framebuffer[f+1])
	end

	framebuffer[DRAW_DELAY+1] = {game_active = memory.readbyte(game.address.game_phase) > 0}
	local f = framebuffer[DRAW_DELAY+1]
	if not f.game_active then
		return
	end

	local camera_mode = game.address.camera_mode and memory.readbyte(game.address.camera_mode) or 1
	if not game.address.screen_left[camera_mode] then
		camera_mode = 1
	end
	f.screen_left = memory.readwordsigned(game.address.screen_left[camera_mode])
	f.screen_top  = memory.readwordsigned(game.address.screen_left[camera_mode] + 0x4)

	for _, set in ipairs(game.objects) do
		for n = 1, set.number do
			local obj = {base = set.address + (n-1) * set.space}
			if memory.readwordsigned(obj.base) >= game.exist_val then
				obj.projectile = set.projectile
				obj.invulnerable = (set.hp and memory.readwordsigned(obj.base + set.hp) < 0) or
					(set.alive and memory.readword(obj.base + set.alive) == 0) or
					(set.invulnerable and memory.readword(obj.base + set.invulnerable) > 0)
				obj.harmless = set.harmless or (set.active and inactive(obj.base, set.active))
				obj.addr_table = set.addr_table
				table.insert(f, update_object(f, obj))
				if obj.box_count then
					f.box_count = obj.box_count
				end
			end
		end
	end
end


emu.registerafter( function()
	update_hitboxes()
end)


--------------------------------------------------------------------------------
-- draw the hitboxes

local function draw_hitbox(hb)
	if not hb then
		return
	end

	if globals.draw_mini_axis then
		gui.drawline(hb.val_x, hb.val_y-globals.mini_axis_size, hb.val_x, hb.val_y+globals.mini_axis_size, boxes[hb.type].outline)
		gui.drawline(hb.val_x-globals.mini_axis_size, hb.val_y, hb.val_x+globals.mini_axis_size, hb.val_y, boxes[hb.type].outline)
	end

	gui.box(hb.left, hb.top, hb.right, hb.bottom, boxes[hb.type].fill, boxes[hb.type].outline)
end

local function draw_axis(obj)
	gui.drawline(obj.pos_x, obj.pos_y-globals.axis_size, obj.pos_x, obj.pos_y+globals.axis_size, globals.axis_color)
	gui.drawline(obj.pos_x-globals.axis_size, obj.pos_y, obj.pos_x+globals.axis_size, obj.pos_y, globals.axis_color)
	--gui.text(obj.pos_x, obj.pos_y, string.format("%06X", obj.base)) --debug
end


local function render_hitboxes()
	gui.clearuncommitted()

	local f = framebuffer[1]
	if not f.game_active then
		return
	end

	if globals.blank_screen then
		gui.box(0, 0, emu.screenwidth(), emu.screenheight(), globals.blank_color)
	end

	for entry = 1, f.box_count or #game.box_list do
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
	print((globals.blank_screen and "activated" or "deactivated") .. " blank screen mode")
end)


input.registerhotkey(2, function()
	globals.draw_axis = not globals.draw_axis
	render_hitboxes()
	print((globals.draw_axis and "showing" or "hiding") .. " object axis")
end)


input.registerhotkey(3, function()
	globals.draw_mini_axis = not globals.draw_mini_axis
	render_hitboxes()
	print((globals.draw_mini_axis and "showing" or "hiding") .. " hitbox axis")
end)


--------------------------------------------------------------------------------
-- initialize on game startup

local function initialize_fb()
	framebuffer = {}
	for f = 1, DRAW_DELAY + 1 do
		framebuffer[f] = {}
	end
end


local function whatgame()
	print()
	game = nil
	initialize_fb()
	for _, module in ipairs(profile) do
		if emu.romname() == module.game or emu.parentname() == module.game then
			print("drawing hitboxes for " .. emu.gamename())
			game = module
			return
		end
	end
	print("not prepared for " .. emu.gamename())
end


savestate.registerload(function()
	initialize_fb()
end)


emu.registerstart( function()
	whatgame()
end)