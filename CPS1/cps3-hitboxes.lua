print("CPS-3 fighting game hitbox viewer")
print("October 27, 2011")
print("http://code.google.com/p/mame-rr/")
print("Lua hotkey 1: toggle blank screen")
print("Lua hotkey 2: toggle object axis")
print("Lua hotkey 3: toggle hitbox axis")
print("Lua hotkey 4: toggle pushboxes")
print("Lua hotkey 5: toggle throwable boxes")

local boxes = {
	      ["vulnerability"] = {color = 0x7777FF, fill = 0x40, outline = 0xFF},
	 ["ext. vulnerability"] = {color = 0x0000FF, fill = 0x40, outline = 0xFF}, --extended limbs during attacks
	             ["attack"] = {color = 0xFF0000, fill = 0x40, outline = 0xFF},
	["proj. vulnerability"] = {color = 0x00FFFF, fill = 0x40, outline = 0xFF},
	       ["proj. attack"] = {color = 0xFF66FF, fill = 0x40, outline = 0xFF},
	               ["push"] = {color = 0x00FF00, fill = 0x20, outline = 0xFF},
	              ["throw"] = {color = 0xFFFF00, fill = 0x40, outline = 0xFF},
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
	no_alpha             = true, --fill = 0x00, outline = 0xFF for all box types
}

--------------------------------------------------------------------------------
-- game-specific modules

local DRAW_DELAY    = 1
local GROUND_OFFSET = -23
local MAX_OBJECTS   = 30
local game
local projectile_type = {
	            ["attack"] = "proj. attack",
	     ["vulnerability"] = "proj. vulnerability",
	["ext. vulnerability"] = "proj. vulnerability",
}

local any_true = function(condition)
	for n = 1, #condition do
		if condition[n] == true then return true end
	end
end


local profile = {
{	games = {"sfiii"},
	player = {0x0200D18C, 0x200D564}, --0x3D8
	object = {initial = 0x0201DE04, index = 0x0205DF0A},
	screen = {x = 0x0201BF0C, y = 0x0201BF10},
	match  = 0x02012C54,
	scale  = 0x0201BE3E,
	char_id = 0x334,
	ptr = {
		valid_object = 0x258,
		{offset = 0x270, type = "push"},
		{offset = 0x268, type = "throwable"},
		{offset = 0x258, type = "vulnerability", number = 5},
		{offset = 0x260, type = "attack", initial = 2, number = 3},
		{offset = 0x260, type = "throw"},
	},
},

{	games = {"sfiii2"},
	player = {0x0200E504, 0x200E910}, --0x40C
	object = {initial = 0x02024210, index = 0x02064316},
	screen = {x = 0x0202225C, y = 0x02022260},
	match  = 0x02014298,
	scale  = 0x0202218E,
	char_id = 0x358,
	ptr = {
		valid_object = 0x260,
		{offset = 0x294, type = "push"},
		{offset = 0x280, type = "throwable"},
		{offset = 0x260, type = "vulnerability", number = 4},
		{offset = 0x268, type = "ext. vulnerability", number = 2},
		{offset = 0x288, type = "attack", number = 2},
		{offset = 0x278, type = "throw"},
	},
},

{	games = {"sfiii3"},
	player = {0x02068C6C, 0x2069104}, --0x498
	object = {initial = 0x02028990, index = 0x02068A96},
	screen = {x = 0x02026CB0, y = 0x02026CB4},
	match  = 0x020154A6,
	scale  = 0x0200DCBA,
	char_id = 0x3C0,
	ptr = {
		valid_object = 0x2A0,
		{offset = 0x2D4, type = "push"},
		{offset = 0x2C0, type = "throwable"},
		{offset = 0x2A0, type = "vulnerability", number = 4},
		{offset = 0x2A8, type = "ext. vulnerability", number = 4},
		{offset = 0x2C8, type = "attack", number = 4},
		{offset = 0x2B8, type = "throw"},
	},
},

{	games = {"redearth"},
	player = {0x0206A784, 0x206AA04}, --0x280
	scale  = 0x02051BA6,

	match_active = function()
		local state = memory.readdword(0x020606DC)
		return state == 0x00020003 or state == 0x00020004 or state == 0x00020005
	end,

	get_screen = function(f)
		--f.screen_x = memory.readwordsigned(0x0207BAE4)
		--f.screen_y = memory.readwordsigned(0x0207BAE8)
		f.screen_x = memory.readwordsigned(0x02051CA4)
		f.screen_y = memory.readbyte(0x02051CA6 + 1)
	end,

	define_box = function(f, obj, offset, type)
		local box = {hitbox_ptr = memory.readword(obj.hitbox_ptr + 2*offset)}
		if box.hitbox_ptr == 0 then
			return
		elseif obj.projectile then
			type = projectile_type[type] or type
		end
		box.type = type
		box.hitbox_ptr = box.hitbox_ptr + bit.lshift(offset, 7)
		box.hitbox_ptr = 0x6768000 + bit.lshift(obj.char_id, 14) + bit.lshift(box.hitbox_ptr, 4)

		box.hval  = f.scale * memory.readwordsigned(box.hitbox_ptr + 0x0)
		box.vval  = f.scale * memory.readwordsigned(box.hitbox_ptr + 0x2)
		box.hrad  = f.scale * memory.readbyte(box.hitbox_ptr + 0x4)
		box.vrad  = f.scale * memory.readbyte(box.hitbox_ptr + 0x5)

		if box.hval == 0 and box.vval == 0 and box.hrad == 0 and box.vrad == 0 then
			return
		elseif obj.box_scale then
			box.hval = bit.arshift(box.hval * obj.box_scale, 6)
			box.hrad = bit.arshift(box.hrad * obj.box_scale, 6)
		end

		box.hval   = obj.pos_x - box.hval * (obj.flip_x > 0 and -1 or 1)
		box.vval   = obj.pos_y - box.vval
		box.left   = box.hval - box.hrad
		box.right  = box.hval + box.hrad
		box.top    = box.vval - box.vrad
		box.bottom = box.vval + box.vrad

		table.insert(obj, box)
	end,

	update_game_object = function(f, obj)
		if memory.readbyte(obj.base) == 0 then --invalid objects
			return
		end

		obj.pos_x = memory.readwordsigned(obj.base + 0x0C)
		obj.pos_y = memory.readwordsigned(obj.base + 0x10)
		obj.pos_x = f.scale * ( obj.pos_x - f.screen_x)
		obj.pos_y = f.scale * (-obj.pos_y - f.screen_y + 0x1DC + GROUND_OFFSET)
		--obj.pos_y = f.scale * (-obj.pos_y + f.screen_y + emu.screenheight() + GROUND_OFFSET)
		obj.flip_x = memory.readbytesigned(obj.base + 0x62)
		obj.char_id = memory.readword(obj.base + 0x4A)

		obj.hitbox_ptr = bit.lshift(obj.char_id, 9) + memory.readword(obj.base + 0x88)
		obj.hitbox_ptr = 0x6748000 + bit.lshift(obj.hitbox_ptr, 4)
		if memory.readbyte(obj.base + 0x66) > 0 then
			obj.box_scale = memory.readbyte(obj.base + 0x68)
		end

		game.define_box(f, obj, 3, "push")
		game.define_box(f, obj, 0, "vulnerability")
		game.define_box(f, obj, 1, "vulnerability")
		game.define_box(f, obj, 2, "vulnerability")
		game.define_box(f, obj, 4, "throw")
		game.define_box(f, obj, 5, "throw")
		game.define_box(f, obj, 6, "attack")
		game.define_box(f, obj, 7, "attack")

		table.insert(f, obj)
	end,

	read_misc_objects = function(f)
		local ptr_base = {0x0206A39C, 0x206A41C} --0x80
		for p = 1, #ptr_base do
			for n = 0, memory.readbyte(0x0206A394 + p-1) do
				local obj = {projectile = true}
				obj.base = memory.readdword(ptr_base[p] + n*4)
				if obj.base == 0 then
					break
				end
				game.update_game_object(f, obj)
			end
		end
	end,

	read_throws = function(f)
		for _, obj in ipairs(f or {}) do
			if obj.projectile then
				break
			end
			obj.throw_range = memory.readwordsigned(obj.base + 0x27E)
			if obj.throw_range > 0 then
				memory.writeword(obj.base + 0x27E, 0)
				obj.throw_flip_x = memory.readbytesigned(obj.base + 0xA4)
				local box = {
					left   = obj.pos_x,
					right  = obj.pos_x + f.scale * obj.throw_range * obj.throw_flip_x,
					top    = obj.pos_y - f.scale * 0x40,
					bottom = obj.pos_y,
					type = "throw",
				}
				box.hval = (box.left + box.right)/2
				box.vval = (box.bottom + box.top)/2
				table.insert(obj, box)
			end
		end
	end,

	breakpoints = {
		{pc = 0x06042E48, cmd = "maincpu.pw@(r4+27e)=r5"}, --ground throw
	},
},
}

--------------------------------------------------------------------------------
-- post-process modules

for g in ipairs(profile) do
local g = profile[g]
if string.find(g.games[1], "sfiii") then
	for _, box in ipairs(g.ptr) do
		box.initial = box.initial or 1
		box.number  = box.number  or 1
	end

	g.match_active = function()
		return memory.readdword(g.match) > 0x00010000 and memory.readword(g.match) ~= 0x0009
	end

	g.get_screen = function(f)
		f.screen_x = memory.readwordsigned(game.screen.x)
		f.screen_y = memory.readwordsigned(game.screen.y)
	end

	g.define_box = function(f, obj, ptr, type)
		if obj.friends > 1 then --Yang SA3
			if type ~= "attack" then
				return
			end
		elseif obj.projectile then
			type = projectile_type[type] or type
		end

		local box = {
			left   = f.scale * -memory.readwordsigned(ptr + 0x0),
			right  = f.scale * -memory.readwordsigned(ptr + 0x2),
			bottom = f.scale * -memory.readwordsigned(ptr + 0x4),
			top    = f.scale * -memory.readwordsigned(ptr + 0x6),
			type   = type,
		}

		if box.left == 0 and box.right == 0 and box.top == 0 and box.bottom == 0 then
			return
		elseif obj.flip_x == 0 then
			box.left  = -box.left
			box.right = -box.right
		end

		box.left   = box.left   + obj.pos_x
		box.right  = box.right  + box.left
		box.bottom = box.bottom + obj.pos_y
		box.top    = box.top    + box.bottom
		box.hval   = (box.left + box.right)/2
		box.vval   = (box.bottom + box.top)/2

		table.insert(obj, box)
	end

	g.update_game_object = function(f, obj)
		if memory.readdword(obj.base + game.ptr.valid_object) == 0 then --invalid objects
			return
		end

		obj.friends = memory.readbyte(obj.base + 0x1)
		obj.flip_x = memory.readbytesigned(obj.base + 0x0A)
		obj.pos_x = memory.readwordsigned(obj.base + 0x64)
		obj.pos_y = memory.readwordsigned(obj.base + 0x68)
		obj.pos_x =  obj.pos_x - f.screen_x + emu.screenwidth()/2
		obj.pos_y = -obj.pos_y + f.screen_y + emu.screenheight() + GROUND_OFFSET
		obj.char_id = memory.readword(obj.base + game.char_id)

		for _, box in ipairs(game.ptr) do
			for i = box.initial, box.number do
				game.define_box(f, obj, memory.readdword(obj.base + box.offset) + (i-1)*8, box.type)
			end
		end

		table.insert(f, obj)
	end

	g.read_misc_objects = function(f)
		-- This function reads all game objects other than the two player characters.
		-- This includes all projectiles and even Yang's Seiei-Enbu shadows.

		-- The game uses the same structure all over the place and groups them
		-- into lists with each element containing an index to the next element
		-- in that list. An index of -1 signals the end of the list.

		-- I believe there are at least 7 lists (0-6) but it seems everything we need
		-- (and lots we don't) is in list 3.
		local list = 3
		local obj_index = memory.readwordsigned(game.object.index + (list * 2))
			
		local obj_slot = 1
		while obj_slot <= MAX_OBJECTS and obj_index ~= -1 do
			local obj = {base = game.object.initial + bit.lshift(obj_index, 11), projectile = obj_slot}
			game.update_game_object(f, obj)

			-- Get the index to the next object in this list.
			obj_index = memory.readwordsigned(obj.base + 0x1C)
			obj_slot = obj_slot + 1
		end
	end

	g.read_throws = function(f) end

	end
end

for _,box in pairs(boxes) do
	box.fill    = bit.lshift(box.color, 8) + (globals.no_alpha and 0x00 or box.fill)
	box.outline = bit.lshift(box.color, 8) + (globals.no_alpha and 0xFF or box.outline)
end

local frame_buffer = {}

--------------------------------------------------------------------------------
-- prepare the hitboxes

local update_hitboxes = function()
	for f = 1, DRAW_DELAY do
		frame_buffer[f] = copytable(frame_buffer[f+1])
	end

	frame_buffer[DRAW_DELAY+1] = {match_active = game and game.match_active()}
	local f = frame_buffer[DRAW_DELAY+1]

	if not f.match_active then
		return
	end

	game.get_screen(f)
	f.scale = memory.readwordsigned(mame and 0x040C006E or game.scale) --FBA can't read from 04xxxxxx
	f.scale = 0x40/(f.scale > 0 and f.scale or 1)

	for p = 1, #game.player do
		local player = {base = game.player[p]}
		game.update_game_object(f, player)
	end
	game.read_misc_objects(f)

	f = frame_buffer[DRAW_DELAY]
	game.read_throws(f)

	f.max_boxes = 0
	for _, obj in ipairs(f) do
		f.max_boxes = math.max(f.max_boxes, #obj)
	end
end


emu.registerafter(function()
	update_hitboxes()
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
		gui.drawline(hb.hval, hb.vval-globals.mini_axis_size, hb.hval, hb.vval+globals.mini_axis_size, boxes[hb.type].outline)
		gui.drawline(hb.hval-globals.mini_axis_size, hb.vval, hb.hval+globals.mini_axis_size, hb.vval, boxes[hb.type].outline)
	end

	gui.box(hb.left, hb.top, hb.right, hb.bottom, boxes[hb.type].fill, boxes[hb.type].outline)
end


local draw_axis = function(obj)
	gui.drawline(obj.pos_x, obj.pos_y-globals.axis_size, obj.pos_x, obj.pos_y+globals.axis_size, globals.axis_color)
	gui.drawline(obj.pos_x-globals.axis_size, obj.pos_y, obj.pos_x+globals.axis_size, obj.pos_y, globals.axis_color)
	--gui.text(obj.pos_x+4, obj.pos_y-0x08, string.format("%08X", obj.base))
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

local initialize_fb = function()
	for f = 1, DRAW_DELAY+1 do
		frame_buffer[f] = {}
	end
end


local whatgame = function()
	print()
	game = nil
	initialize_fb()
	for _, module in ipairs(profile) do
		for _, shortname in ipairs(module.games) do
			if emu.romname() == shortname or emu.parentname() == shortname then
				print("drawing hitboxes for: " .. emu.gamename())
				game = module
				if game.breakpoints then
					if not mame then
						print("(MAME-rr can show throwboxes with this script.)")
						return
					end
					print("Copy this line into the MAME-rr debugger to show throwboxes:") print()
					local bpstring = ""
					for _, bp in ipairs(game.breakpoints) do
						bpstring = bpstring .. string.format("bp %08X, 1, {%s; g}; ", bp.pc, bp.cmd)
					end
					print(bpstring:sub(1, -3))
				end
				return
			end
		end
	end
	print("not prepared for: " .. emu.gamename())
end


savestate.registerload(function()
	initialize_fb()
end)


emu.registerstart(function()
	whatgame()
end)