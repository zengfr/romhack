print("On-screen info display for fighting games")
print("October 13, 2011")
print("http://code.google.com/p/mame-rr/")
print("Lua hotkey 1: toggle numbers")
print("Lua hotkey 2: toggle bars")

--------------------------------------------------------------------------------
-- user configuration

local c = { --colors
	bg            = {fill   = 0x00000040, outline  = 0x000000FF},
	stun_level    = {normal = 0xFF0000FF, overflow = 0xFFAAAAFF},
	stun_timeout  = {normal = 0xFFFF00FF, overflow = 0xFFA000FF},
	stun_duration = {normal = 0x00C0FFFF, overflow = 0xA0FFFFFF},
	stun_grace    = {normal = 0x00FF00FF, overflow = 0xFFFFFFFF},

	green  = 0x00FF00FF,
	yellow = 0xFFFF00FF,
	pink   = 0xFFB0FFFF,
	gray   = 0xCCCCFFFF,
	cyan   = 0x00FFFFFF,
}

local show_numbers = true
local show_bars    = true

--------------------------------------------------------------------------------
-- game-specific modules

local game, show_OSD, player

local rb, rw, rd = memory.readbyte, memory.readword, memory.readdword
local rbs, rws, rds = memory.readbytesigned, memory.readwordsigned, memory.readdwordsigned


local function any_true(condition)
	for n = 1, #condition do
		if condition[n] == true then return true end
	end
end


local get_state = function(t)
	for _, set in ipairs(t) do
		if set.condition == true or set.condition == nil then
			return set.state, set.val, set.max
		end
	end
end


local profile = {
	{	games = {"sf2"},
		player = 0xFF83C6, space = 0x300, 
		offset = {grace = 0x1F0, char_id = 0x291},
		show_OSD = function()
			return bit.band(rw(0xFF8008), 0x08) > 0
		end,
		show_life = function()
			return rw(0xFF89CA) < 0xC --bonus stage
		end,
		show_super = function() return false end,
	},
	{	games = {"sf2ce","sf2hf"},
		player = 0xFF83BE, space = 0x300, 
		offset = {grace = 0x1F0, char_id = 0x291},
		show_OSD = function()
			return bit.band(rw(0xFF8008), 0x08) > 0
		end,
		show_life = function()
			return rw(0xFF89BE) < 0xC --bonus stage
		end,
		show_super = function() return false end,
	},
	{	games = {"ssf2"},
		player = 0xFF83CE,
		offset = {grace = 0x1F2, char_id = 0x391},
		show_OSD = function()
			return bit.band(rw(0xFF8008), 0x08) > 0
		end,
		show_life = function()
			return rw(0xFF8BCE) < 0x10 --bonus stage
		end,
		show_super = function() return false end,
	},
	{	games = {"ssf2t"},
		player = 0xFF844E,
		offset = {grace = 0x1F2, char_id = 0x391},
		stun_limit_base = {
			["ssf2t"] = 0x07F1C6, ["ssf2ta"] = 0x07F1C6, ["ssf2tur1"] = 0x07F1C6, 
				["ssf2xjd"] = 0x07F1C6, ["ssf2xj"] = 0x07F1C6, --940223
			["ssf2tu"] = 0x07F1C6, --940323
		},
		show_OSD = function()
			return bit.band(rw(0xFF8008), 0x08) > 0
		end,
		show_life = function() return true end,
		show_super = function(p)
			return rb(p.base + 0x3B6) == 0 and rb(p.base + 0x3BD) == 0
		end,
	},
	{	games = {"hsf2"},
		player = 0xFF833C,
		offset = {grace = 0x1F2, char_id = 0x32B},
		stun_limit_base = {
			["hsf2"] = 0x06D830, ["hsf2a"] = 0x06D830, ["hsf2d"] = 0x06D830, --040202
			["hsf2j"] = 0x06D828, --031222
		},
		show_OSD = function()
			return rw(0xFF8004) == 0x8
		end,
		show_life = function() return true end,
		show_super = function(p)
			return rb(p.base + 0x32A) == 0 and rb(p.base + 0x32B) < 0x10
		end,
	},
	{	games = {"dstlk"},
		player = 0xFF8388, 
		text = {
			life  = {offset = 0x042, max = 144, pos_X = 0x14, pos_Y = 0x0A, color = c.green},
			super = {offset = 0x1D4, max =  80, pos_X = 0x94, pos_Y = 0xD4, color = c.yellow, 
				align = "align outer"},
		},
		show_OSD = function() return any_true({
			rd(0xFF8004) == 0x40000 and bit.band(rd(0xFF8008), 0x8FFFF) == 0x80000,
		}) end,
	},
	{	games = {"nwarr"},
		player = 0xFF8388, space = 0x500, 
		text = {
			life  = {offset = 0x042, max = 144, pos_X = 0x12, pos_Y = 0x0E, color = c.green},
			super = {offset = 0x1D4, max = 112, pos_X = 0x0E, pos_Y = 0x34, color = c.yellow, 
				align = "align outer"},
		},
		show_OSD = function() return any_true({
			rd(0xFF8004) == 0x40000 and bit.band(rd(0xFF8008), 0x8FFFF) == 0x80000,
			rw(0xFF8000) >= 0x0E and rd(0xFF8004) == 0,
		}) end,
	},
	{	games = {"vsav"},
		player = 0xFF8400, 
		text = {
			life  = {max = 144, pos_X = 0x20, pos_Y = 0x08, color = c.green, 
				val = function(p) return rw(p.base + 0x052)%144 end},
			super = {offset = 0x10A, max = 144, pos_X = 0x06, pos_Y = 0xD8, color = c.yellow, 
				align = "align outer"},
			dark_force = {offset = 0x176, max = 112, pos_X = 0x60, pos_Y = 0x20, color = c.gray, 
				condition = function(p) return rb(p.base + 0x110) > 0 end},
		},
		show_OSD = function() return rw(0xFFF000) == 0x0101 end,
	},
	{	games = {"vhunt2","vsav2"},
		player = 0xFF8400, 
		text = {
			life  = {max = 144, pos_X = 0x20, pos_Y = 0x08, color = c.green, 
				val = function(p) return rw(p.base + 0x052)%144 end},
			super = {offset = 0x10A, max = 144, pos_X = 0x06, pos_Y = 0xD8, color = c.yellow, 
				align = "align outer"},
			dark_force_change = {offset = 0x176, max = 112, pos_X = 0x60, pos_Y = 0x08, align = "align outer", 
				color = c.gray, condition = function(p) return rb(p.base + 0x110) > 0 end},
			dark_force_power = {offset = 0x1C4, max = 112, pos_X = 0x60, pos_Y = 0x20, 
				color = c.yellow, condition = function(p) return rw(p.base + 0x1C2) > 0 end},
		},
		show_OSD = function() return rw(0xFFF000) == 0x0101 end,
	},
	{	games = {"sfa"},
		player = 0xFF8400, nplayers = 3, 
		text = {
			life  = {offset = 0x040, max = 144, pos_X = 0x10, pos_Y = 0x0A, color = c.green},
			super = {offset = 0x0BE, max = 144, pos_X = 0x1C, pos_Y = 0xD8, color = c.yellow},
		},
		stun_bar = {
			pos_X = 0x0E, pos_Y = 0x26, length = 0x40, height = 0x04,
			level = function(p) return rb(p.base + 0x137), rb(p.base + 0x13A) end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rw(p.base + 0x02C), max = 180, condition = rb(p.base + 0x6) == 0x12},
				{state = "precountdown", val = 0, max = 210, condition = rb(p.base + 0x13B) > 0},
				{state = "normal", val = rb(p.base + 0x136), max = 210},
			}) end,
		},
		show_OSD = function() return any_true({
			rd(0xFF8004) == 0x40000 and rd(0xFF8008) == 0x40000,
			rw(0xFF8008) == 0x2 and rw(0xFF800A) > 0,
		}) end,
	},
	{	games = {"sfa2","sfz2al"},
		player = 0xFF8400, nplayers = 3, 
		text = {
			life  = {offset = 0x050, max = 144, pos_X = 0x20, pos_Y = 0x0A, color = c.green},
			super = {offset = 0x09E, max = 144, pos_X = 0x1C, pos_Y = 0xD8, color = c.yellow, 
				condition = function(p) return rb(p.base + 0xB1) == 0 end},
		},
		stun_bar = {
			pos_X = 0x0E, pos_Y = 0x26, length = 0x40, height = 0x04, 
			level = function(p) return rb(p.base + 0x137), rb(p.base + 0x13A) end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rw(p.base + 0x03A), max = 180, condition = rb(p.base + 0x6) == 0x12},
				{state = "precountdown", val = 0, max = 210, condition = rb(p.base + 0x13B) > 0},
				{state = "normal", val = rb(p.base + 0x136), max = 210},
			}) end,
		},
		show_OSD = function() return rb(0xFFCB01) > 0 and bit.band(rb(0xFFCB02), 0x08) > 0 end,
	},
	{	games = {"sfa3"},
		player = 0xFF8400, nplayers = 4, 
		text = {
			life  = {offset = 0x050, max = 144, pos_X = 0x84, pos_Y = 0x08, color = c.green},
			super = {offset = 0x11E, max = 144, pos_X = 0x66, pos_Y = 0xCA, color = c.yellow, 
				condition = function(p) return rb(p.base + 0x15E) == 0 end},
		},
		stun_bar = {
			pos_X = 0x10, pos_Y = 0x24, length = 0x40, height = 0x04, 
			level = function(p) return rb(p.base + 0x2CC), rb(p.base + 0x2CD) end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rw(p.base + 0x03A), max = 180, 
					condition = rw(p.base + 0x6) == 0x0200 and rb(p.base + 0x2CA) > 0},
				{state = "precountdown", val = 0, max = 180, condition = rb(p.base + 0x2CE) > 0},
				{state = "normal", val = rb(p.base + 0x2CB), max = 180},
			}) end,
		},
		show_OSD = function() return rb(0xFFD601) > 0 end,
		special = function(p)
			if not (rb(p.base + 0x15E) > 0 or player[3].active or player[4].active) then
				p.text.guard = {X = 0x28, Y = 0x1A, color = c.gray}
				p.text.guard.limit = rb(p.base + 0x24C)
				p.text.guard.val = p.text.guard.limit - rb(p.base + 0x24D) .. "/" .. p.text.guard.limit
				p.text.guard.X = p.text.guard.X + math.floor(p.text.guard.limit/4)*4
			end

			if rb(p.base + 0x102) == 0x1C then
				p.text.claw = {X = 0, Y = 0xB8, color = c.pink, val = "-", align = "align outer"}
				if rb(p.base + 0x6A) > 0 then
					p.text.claw.val = 0xFF0000 + rw(p.base + 0x28)
					p.text.claw.val = rb(p.text.claw.val + 0x6C)
				end
				p.text.claw.val = "claw: " .. p.text.claw.val .. "/8"
				p.text.mask = {X = 0, Y = 0xC0, color = c.pink, val = "-", align = "align outer"}
				if rb(p.base + 0x6B) > 0 then
					p.text.mask.val = 0xFF0000 + rw(p.base + 0x2A)
					p.text.mask.val = rb(p.text.mask.val + 0x6C)
				end
				p.text.mask.val = "mask: " .. p.text.mask.val .. "/32"
			end

			p.combo = rb(p.base + 0x5E)
			p.flip = not any_true({
				rw(p.base + 0x06) ~= 0x0202, --reeling
				rb(p.base + 0x54) > 0x08, --reel type
				rb(p.base + 0x31) == 0, --airborne
				rb(p.base + 0x2CE) > 0,
				rb(p.base + 0x26A) > 0,
				rb(p.base + 0x26B) > 0,
				rb(0xFF810E) > 0,
				rb(0xFF810D) > 0,
				rb(0xFF808A) > 0,
			})
			p.combo_old, p.flip_old = p.combo_old or p.combo, p.flip_old or p.flip
			if p.flip then
				p.text.flip = {X = game.text.life.pos_X - 0x8, Y = game.text.life.pos_Y, val = "!"}
			end
			if p.combo < 2 then
				p.pseudocombo = false
			elseif p.combo > p.combo_old and p.flip_old then
				p.pseudocombo = true
			end
			if p.pseudocombo then
				p.text.pseudocombo = {X = -0x90 + (p.side < 0 and 0xC or 0) + (p.side * string.len(p.combo) * 8), 
					Y = 0x30, val = "*"}
			end
			p.combo_old, p.flip_old = p.combo, p.flip
		end,
	},
	{	games = {"ringdest"},
		player = 0xFF8000,
		text = {
			life = {offset = 0x02C, max = 278, pos_X = 0x4, pos_Y = 0x30, color = c.green, 
				align = "align outer"},
		},
		stun_bar = {
			pos_X = 0x18, pos_Y = 0x0C, length = 0x40, height = 0x04, 
			level = function(p) return rw(p.base + 0x0AC), rw(p.base + 0x0CC) end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rw(p.base + 0x0CE), max = 180, 
					condition = rw(p.base + 0x0AA) > 0 and rw(p.base + 0x0CE) > 0},
				{state = "precountdown", val = 0, max = 80, condition = rw(p.base + 0x0AA) > 0},
				{state = "grace", val = rw(p.base + 0x108), max = 360, condition = rw(p.base + 0x108) > 0},
				{state = "normal", val = rw(p.base + 0x0AE), max = 80},
			}) end,
		},
		show_OSD = function()
			return rws(0xFF72D2) > 0
		end,
		special = function(p)
			p.text.rage_level = 
				{X = 0x9C, Y = 0xCA, val = rw(p.base + 0xB4), max = rw(p.base + 0xC6)}
			p.bar.rage_level = {X = 0x18, Y = 0xCC, length = 0x80, height = 0x04, color = c.stun_level, 
				data = p.text.rage_level}
			p.text.rage_timeout = {X = 0x9C, Y = 0xD2}
			p.bar.rage_timeout = {X = 0x18, Y = 0xD0, length = 0x80, height = 0x04, data = p.text.rage_timeout}
			p.text.rage_level.display = p.text.rage_level.val
			if rw(p.base + 0xB0) == 1 then
				p.bar.rage_timeout.color = c.stun_duration
				p.text.rage_timeout.val = rw(p.base + 0xB6)
				p.text.rage_timeout.max = 440
				p.text.rage_level.val = p.text.rage_level.max
				p.text.rage_level.display = "-"
			else
				p.bar.rage_timeout.color = c.stun_timeout
				p.text.rage_timeout.val = rw(p.base + 0xB2)
				p.text.rage_timeout.max = 1000
			end
			p.text.rage_level.display = p.text.rage_level.display .. "/" .. p.text.rage_level.max
		end,
	},
	{	games = {"cybots"},
		player = 0xFF81A0,
		text = {
			life  = {offset = 0x044, max = 152, pos_X = 0xA2, pos_Y = 0x18, color = c.green},
			super = {offset = 0x394, max =  63, pos_X = 0x88, pos_Y = 0xD6, color = c.yellow, 
				read = rb, align = "align outer"},
			boost = {offset = 0x16A, max =  29, pos_X = 0xA2, pos_Y = 0x20, color = c.gray, read = rb},
			arm   = {offset = 0x16C, max =  48, pos_X = 0x3C, pos_Y = 0x10, color = c.pink, read = rb},
			gun   = {offset = 0x16E, max =  48, pos_X = 0x80, pos_Y = 0x10, read = rb},
		},
		show_OSD = function() return any_true({
			bit.band(memory.readdword(0xFF8008), 0x10FFFF) == 0x100000,
		}) end,
	},
	{	games = {"sgemf"},
		player = 0xFF8400,
		text = {
			life  = {offset = 0x040, max = 144, pos_X = 0x00, pos_Y = 0x20, color = c.green, 
				align = "align outer"},
			super = {offset = 0x195, max =  96, pos_X = 0x2E, pos_Y = 0x28, color = c.yellow, 
				read = rb, align = "align outer"},
			red    = {offset = 0x1A2, max = 96, pos_X = 0x98, pos_Y = 0xD8, color = c.gray},
			yellow = {offset = 0x1A4, max = 96, pos_X = 0x60, pos_Y = 0xD8, color = c.gray},
			blue   = {offset = 0x1A6, max = 96, pos_X = 0x28, pos_Y = 0xD8, color = c.gray},
		},
		stun_bar = {
			pos_X = 0x68, pos_Y = 0x08, length = 0x40, height = 0x04, 
			level = function(p) return rb(p.base + 0x17F), rb(p.base + 0x19E) end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rb(p.base + 0x146), max = 180, condition = rb(p.base + 0x146) > 0},
				{state = "grace", val = rb(p.base + 0x147), max = 60, condition = rb(p.base + 0x147) > 0},
				{state = "normal", val = rb(p.base + 0x19F), max = 180},
			}) end,
		},
		show_OSD = function() return any_true({
			rd(0xFF8004) == 0x40000 and rd(0xFF8008) == 0x40000,
			rw(0xFF8008) == 0x2 and rw(0xFF800A) > 0,
		}) end,
	},
	{	games = {"xmcota"},
		player = 0xFF4000,
		text = {
			life  = {offset = 0x190, max = 143, pos_X = 0x24, pos_Y = 0x00, color = c.green, 
				align = "align outer"},
			super = {offset = 0x194, max = 142, pos_X = 0x24, pos_Y = 0x08, color = c.yellow, 
				align = "align outer"},
		},
		stun_bar = {
			pos_X = 0x10, pos_Y = 0xD0, length = 0x40, height = 0x04, 
			level = function(p)
				return rb(p.base + 0x0B9), rw(game.stun_limit_base[emu.romname()] + rw(p.base + 0x050))
			end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rw(p.base + 0x0FC), max = 150, 
					condition = rb(p.base + 0x13A) > 0 and rb(p.base + 0x140) > 0},
				{state = "precountdown", val = 0, max = 180, condition = rb(p.base + 0x13A) > 0},
				{state = "grace", val = rb(p.base + 0x140), max = 180, condition = rb(p.base + 0x140) > 0},
				{state = "normal", val = rb(p.base + 0x0BA), max = 180},
			}) end,
		},
		stun_limit_base = {
			["xmcotajr"] = 0x0B7DF4, --941208
			["xmcotaa"] = 0x0C10C2, ["xmcotaj3"] = 0x0C10C2, --941217
			["xmcotaj2"] = 0x0C125C, --941219
			["xmcotaj1"] = 0x0C128A, --941222
			["xmcota"] = 0x0C1DAE, ["xmcotad"] = 0x0C1DAE, ["xmcotahr1"] = 0x0C1DAE, 
				["xmcotaj"] = 0x0C1DAE, ["xmcotau"] = 0x0C1DAE, --950105
			["xmcotah"] = 0x0C1DE4, --950331
		},
		show_OSD = function()
			return bit.band(rb(0xFF488F), 0xF) < 0xC
		end,
	},
	{	games = {"msh"},
		player = 0xFF4000,
		text = {
			life  = {offset = 0x190, max = 144, pos_X = 0x04, pos_Y = 0x00, color = c.green, 
				align = "align outer"},
			super = {offset = 0x194, max = 144, pos_X = 0x04, pos_Y = 0x08, color = c.yellow,
				align = "align outer"},
		},
		stun_bar = {
			pos_X = 0x18, pos_Y = 0x24, length = 0x40, height = 0x04, 
			level = function(p)
				return rb(p.base + 0x0B9), rw(game.stun_limit_base[emu.romname()] + rw(p.base + 0x050))
			end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rw(p.base + 0x0FC), max = 150, 
					condition = rb(p.base + 0x13A) > 0 and rb(p.base + 0x140) > 0},
				{state = "precountdown", val = 0, max = 180, condition = rb(p.base + 0x13A) > 0},
				{state = "grace", val = rb(p.base + 0x140), max = 180, condition = rb(p.base + 0x140) > 0},
				{state = "normal", val = rb(p.base + 0x0BA), max = 180},
			}) end,
		},
		stun_limit_base = {
			["msh"] = 0x09F34A, ["msha"] = 0x09F34A, ["mshjr1"] = 0x09F34A, 
				["mshud"] = 0x09F34A, ["mshu"] = 0x09F34A, --951024
			["mshb"] = 0x09F47C, ["mshh"] = 0x09F47C, ["mshj"] = 0x09F47C, --951117
		},
		show_OSD = function()
			return rd(0xFF8FA2) == 0xFF4000
		end,
	},
	{	games = {"xmvsf"},
		player = 0xFF4000,
		text = {
			life  = {offset = 0x210, max = 144, pos_X = 0x04, pos_Y = 0x04, color = c.green,
				align = "align outer"},
			super = {offset = 0x212, max = 144, pos_X = 0x0C, pos_Y = 0xD8, color = c.yellow,
				align = "align outer"},
		},
		stun_bar = {
			pos_X = 0x18, pos_Y = 0x2A, length = 0x40, height = 0x04, 
			level = function(p)
				return rb(p.base + 0x0B9), rw(game.stun_limit_base[emu.romname()] + rw(p.base + 0x052))
			end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rw(p.base + 0x138), max = 150, 
					condition = rb(p.base + 0x135) > 0 and rb(p.base + 0x136) > 0},
				{state = "precountdown", val = 0, max = 180, condition = rb(p.base + 0x135) > 0},
				{state = "grace", val = rb(p.base + 0x136), max = 180, condition = rb(p.base + 0x136) > 0},
				{state = "normal", val = rb(p.base + 0x0BA), max = 180},
			}) end,
		},
		stun_limit_base = {
			["xmvsfjr2"] = 0x08BAFE, --960909
			["xmvsfar2"] = 0x08BB38, ["xmvsfr1"] = 0x08BB38, ["xmvsfjr1"] = 0x08BB38, --960910
			["xmvsf"] = 0x08BC6C, ["xmvsfh"] = 0x08BC6C, ["xmvsfj"] = 0x08BC6C, 
				["xmvsfu1d"] = 0x08BC6C, ["xmvsfur1"] = 0x08BC6C, --961004
			["xmvsfar1"] = 0x08BC6C, --960919
			["xmvsfa"] = 0x08BC9A, ["xmvsfb"] = 0x08BC9A, ["xmvsfu"] = 0x08BC9A, --961023
		},
		show_OSD = function()
			return rw(0xFFFA9C) == 0x87
		end,
	},
	{	games = {"mshvsf"},
		player_ptr = 0xFF48C8, space = 0x8, 
		text = {
			life  = {offset = 0x250, max = 144, pos_X = 0x04, pos_Y = 0x22, color = c.green, 
				align = "align outer"},
			super = {offset = 0x252, max = 144, pos_X = 0x10, pos_Y = 0xD8, color = c.yellow},
		},
		stun_bar = {
			pos_X = 0x18, pos_Y = 0x24, length = 0x40, height = 0x04, 
			level = function(p)
				return rb(p.base + 0x0B9), rw(game.stun_limit_base[emu.romname()] + rw(p.base + 0x052))
			end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rw(p.base + 0x138), max = 150, 
					condition = rb(p.base + 0x135) > 0 and rb(p.base + 0x136) > 0},
				{state = "precountdown", val = 0, max = 180, condition = rb(p.base + 0x135) > 0},
				{state = "grace", val = rb(p.base + 0x136), max = 180, condition = rb(p.base + 0x136) > 0},
				{state = "normal", val = rb(p.base + 0x0BA), max = 180},
			}) end,
		},
		stun_limit_base = {
			["mshvsfa1"] = 0x138C3E, --970620
			["mshvsf"] = 0x138C90, ["mshvsfa"] = 0x138C90, ["mshvsfb1"] = 0x138C90, 
				["mshvsfh"] = 0x138C90, ["mshvsfj2"] = 0x138C90, 
				["mshvsfu1"] = 0x138C90, ["mshvsfu1d"] = 0x138C90, --970625
			["mshvsfj1"] = 0x138F06, --970702
			["mshvsfj"] = 0x138F92, --970707
			["mshvsfu"] = 0x138F74, ["mshvsfb"] = 0x138F74, --970827
		},
		show_OSD = function()
			return rw(0xFFFBB8) == 0xBF
		end,
	},
	{	games = {"mvsc"},
		player_ptr = 0xFF40C8, space = 0x8, 
		text = {
			life  = {offset = 0x270, max = 144, pos_X = 0x04, pos_Y = 0x06, color = c.green,
				align = "align outer"},
			super = {offset = 0x272, max = 144, pos_X = 0x20, pos_Y = 0xCA, color = c.yellow, 
				align = "align outer"},
		},
		stun_bar = {
			pos_X = 0x12, pos_Y = 0x28, length = 0x40, height = 0x04, 
			level = function(p)
				return rb(p.base + 0x0C9), rw(game.stun_limit_base[emu.romname()] + rw(p.base + 0x052))
			end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rw(p.base + 0x148), max = 150, 
					condition = rb(p.base + 0x145) > 0 and rb(p.base + 0x146) > 0},
				{state = "precountdown", val = 0, max = 60, condition = rb(p.base + 0x145) > 0},
				{state = "grace", val = rb(p.base + 0x146), max = 180, condition = rb(p.base + 0x146) > 0},
				{state = "normal", val = rb(p.base + 0x0CA), max = 60},
			}) end,
		},
		stun_limit_base = {
			["mvscur1"] = 0x0E6A8E, --971222
			["mvscar1"] = 0x0E6BDC, ["mvscr1"] = 0x0E6BDC, ["mvscjr1"] = 0x0E6BDC, --980112
			["mvsc"] = 0x0E7CD6, ["mvsca"] = 0x0E7CD6, ["mvscb"] = 0x0E7CD6, 
				["mvsch"] = 0x0E7CD6, ["mvscj"] = 0x0E7CD6, 
				["mvscud"] = 0x0E7CD6, ["mvscu"] = 0x0E7CD6, --980123
		},
		show_OSD = function()
			return rw(0xFFF640) == 0xBF
		end,
	},
	{	games = {"sfiii"},
		player = 0x0200D18C, space = 0x3D8, 
		text = {
			life  = {offset = 0x09E, pos_X = 0x2C, pos_Y = 0x20, color = c.green,
				align = "align outer", max = function(p) return rw(p.base + 0x09C) end},
			stun  = {pos_X = 0x3C, pos_Y = 0x20, color = c.pink, 
				val = function(p) return rw(rd(p.base + 0x36C) + 0x08) end, 
				max = function(p) return rw(rd(p.base + 0x36C) + 0x02) end,
				condition = function(p) return rw(0x0201DC80 + rb(p.base + 0x002) * 0x18 + 0xE) == 0 end},
			stun_duration = {pos_X = 0x3C, pos_Y = 0x20, color = c.cyan, 
				val = function(p) return rw(rd(p.base + 0x36C) + 0x04) end, max = 150,
				condition = function(p) return rw(0x0201DC80 + rb(p.base + 0x002) * 0x18 + 0xE) > 0 end},
			stun_recovery = {pos_X = 0x5C, pos_Y = 0x20, color = c.gray, 
				val = function(p) return rd(rd(p.base + 0x36C) + 0x0C) end},
			super = {pos_X = 0x0C, pos_Y = 0xD8, color = c.yellow, align = "align outer", 
				val = function(p) return rw(rd(p.base + 0x364) + 0x0C) end, 
				max = function(p) return rw(rd(p.base + 0x364) + 0x08) end},
		},
		char_offset = 0x334, charge_chars = {
			[0x01] = {3}, --Alex
			[0x09] = {0, 2}, --Oro
		}, 
		charge_base = 0x0201AE98, charge_space = 0x540, 
		match_status = 0x02012C54,
	},
	{	games = {"sfiii2"},
		player = 0x0200E504, space = 0x40C, 
		text = {
			life  = {offset = 0x09E, pos_X = 0x04, pos_Y = 0x08, color = c.green,
				align = "align outer", max = function(p) return rw(p.base + 0x09C) end},
			stun  = {pos_X = 0x3C, pos_Y = 0x20, color = c.pink, 
				val = function(p) return rw(rd(p.base + 0x390) + 0x08) end, 
				max = function(p) return rw(rd(p.base + 0x390) + 0x02) end,
				condition = function(p) return rw(0x02024084 + rb(p.base + 0x002) * 0x18 + 0xE) == 0 end},
			stun_duration = {pos_X = 0x3C, pos_Y = 0x20, color = c.cyan, 
				val = function(p) return rw(rd(p.base + 0x390) + 0x04) end, max = 150,
				condition = function(p) return rw(0x02024084 + rb(p.base + 0x002) * 0x18 + 0xE) > 0 end},
			stun_recovery = {pos_X = 0x5C, pos_Y = 0x20, color = c.gray, 
				val = function(p) return rd(rd(p.base + 0x390) + 0x0C) end},
			super = {pos_X = 0x10, pos_Y = 0xD8, color = c.yellow, align = "align outer", 
				val = function(p) return rw(rd(p.base + 0x388) + 0x18) end, 
				max = function(p) return rw(rd(p.base + 0x388) + 0x14) end},
			damage_bonus  = {pos_X = 0x04, pos_Y = 0x2E, align = "align outer", 
				val = function(p) return "dmg +" .. rw(p.base + 0x3D2) end, 
				condition = function(p) return rw(p.base + 0x3D2) > 0 end},
			stun_bonus    = {pos_X = 0x04, pos_Y = 0x36, align = "align outer", 
				val = function(p) return "stn +" .. rw(p.base + 0x3D6) end,
				condition = function(p) return rw(p.base + 0x3D6) > 0 end},
			defense_bonus = {pos_X = 0x28, pos_Y = 0x08, align = "align outer", 
				val = function(p) return "def +" .. rw(p.base + 0x3D8) end,
				condition = function(p) return rw(p.base + 0x3D8) > 0 end},
			juggle = {pos_X = 0x04, pos_Y = 0x00, color = c.cyan, 
				val = function(p) return "J" .. rw(p.base + 0x35C) end},
		},
		char_offset = 0x358, charge_chars = {
			[0x01] = {3, 4}, --Alex
			[0x09] = {0, 2}, --Oro
			[0x0D] = {0, 1, 3}, --Urien
		}, 
		charge_base = 0x02020F88, charge_space = 0x620, 
		match_status = 0x02014298,
	},
	{	games = {"sfiii3"},
		player = 0x02068C6C, space = 0x498, 
		text = {
			life  = {offset = 0x09E, pos_X = 0x28, pos_Y = 0x08, color = c.green,
				align = "align outer", max = function(p) return rw(p.base + 0x09C) end},
			stun  = {pos_X = 0x3C, pos_Y = 0x20, color = c.pink, 
				val = function(p) return rw(rd(p.base + 0x3F8) + 0x08) end, 
				max = function(p) return rw(rd(p.base + 0x3F8) + 0x02) end,
				condition = function(p) return rw(0x02028808 + rb(p.base + 0x002) * 0x18 + 0xE) == 0 end},
			stun_duration = {pos_X = 0x3C, pos_Y = 0x20, color = c.cyan, 
				val = function(p) return rw(rd(p.base + 0x3F8) + 0x04) end, max = 150,
				condition = function(p) return rw(0x02028808 + rb(p.base + 0x002) * 0x18 + 0xE) > 0 end},
			stun_recovery = {pos_X = 0x5C, pos_Y = 0x20, color = c.gray, 
				val = function(p) return rd(rd(p.base + 0x3F8) + 0x0C) end},
			super = {pos_X = 0x10, pos_Y = 0xD8, color = c.yellow, align = "align outer", 
				val = function(p) return rw(rd(p.base + 0x3F0) + 0x18) end, 
				max = function(p) return rw(rd(p.base + 0x3F0) + 0x16) end},
			damage_bonus  = {pos_X = 0x2C, pos_Y = 0x20, align = "align outer", 
				val = function(p) return "dmg +" .. rw(p.base + 0x43A) end, 
				condition = function(p) return rw(p.base + 0x43A) > 0 end},
			stun_bonus    = {pos_X = 0x2C, pos_Y = 0x28, align = "align outer", 
				val = function(p) return "stn +" .. rw(p.base + 0x43E) end,
				condition = function(p) return rw(p.base + 0x43E) > 0 end},
			defense_bonus = {pos_X = 0x28, pos_Y = 0x00, align = "align outer", 
				val = function(p) return "def +" .. rw(p.base + 0x440) end,
				condition = function(p) return rw(p.base + 0x440) > 0 end},
			juggle = {pos_X = 0x04, pos_Y = 0x00, color = c.cyan, 
				val = function(p) return "J" .. rw(p.base + 0x3C4) end},
		},
		char_offset = 0x3C0, charge_chars = {
			[0x01] = {3, 4}, --Alex
			[0x09] = {0, 2}, --Oro
			[0x0D] = {0, 1, 3}, --Urien
			[0x10] = {0}, --Chun Li
			[0x12] = {0, 1}, --Q
			[0x14] = {0, 1, 2}, --Remy
		}, 
		charge_base = 0x020259D4, charge_space = 0x620, 
		match_status = 0x020154A6,
	},
	{	games = {"kof94"},
		player = 0x108100, space = 0x200, 
		text = {
			life  = {offset = 0x120, max = 207, pos_X = 0x10, pos_Y = 0x00, color = c.green},
			super = {offset = 0x118, max = 127, pos_X = 0x5C, pos_Y = 0xD6, color = c.yellow, 
				align = "align outer"},
			super_timeout = {offset = 0x150, max = 600, pos_X = 0x5C, pos_Y = 0xCE, color = c.pink,
				condition = function(p) return rw(p.base + 0x118) == 127 end, align = "align outer"},
		},
		stun_bar = {
			pos_X = 0x0E, pos_Y = 0x22, length = 0x40, height = 0x04,
			level = function(p) return rb(p.base + 0x124), 50 end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rw(p.base + 0x12A), max = 120, 
					condition = rw(p.base + 0x124) == 0 and rw(p.base + 0x164) > 0},
				{state = "precountdown", val = 0, max = 60, condition = rw(p.base + 0x124) == 0},
				{state = "grace", val = rw(p.base + 0x12C), max = 60, condition = rw(p.base + 0x12C) > 0},
				{state = "normal", val = 0, max = 60},
			}) end,
		},
		show_OSD = function()
			return bit.band(rb(0x108832), 0x01) == 0 and rw(0x10882E) > 0 and bit.band(rb(0x108785), 0x02) == 0
		end,
	},
	{	games = {"kof95"},
		player = 0x108100, space = 0x200, 
		text = {
			life  = {offset = 0x120, max = 207, pos_X = 0x10, pos_Y = 0x00, color = c.green},
			super = {offset = 0x118, max = 127, pos_X = 0x6C, pos_Y = 0xD6, color = c.yellow, 
				align = "align outer"},
			super_timeout = {offset = 0x150, max = 900, pos_X = 0x6C, pos_Y = 0xCE, color = c.pink,
				condition = function(p) return rw(p.base + 0x118) == 127 end, align = "align outer"},
		},
		stun_bar = {
			pos_X = 0x0E, pos_Y = 0x2A, length = 0x40, height = 0x04,
			level = function(p) return rb(p.base + 0x124), 50 end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rw(p.base + 0x12A), max = 120, 
					condition = rw(p.base + 0x124) == 0 and rw(p.base + 0x164) > 0},
				{state = "precountdown", val = 0, max = 60, condition = rw(p.base + 0x124) == 0},
				{state = "grace", val = rw(p.base + 0x12C), max = 60, condition = rw(p.base + 0x12C) > 0},
				{state = "normal", val = 0, max = 60},
			}) end,
		},
		show_OSD = function()
			return bit.band(rb(0x10A83A), 0x01) == 0 and rw(0x10A836) > 0 and bit.band(rb(0x10A785), 0x02) == 0
		end,
	},
	{	games = {"kof96"},
		player = 0x108100, space = 0x200, 
		text = {
			life  = {offset = 0x138, max = 103, pos_X = 0x10, pos_Y = 0x00, color = c.green},
			guard = {offset = 0x146, max = 103, pos_X = 0x38, pos_Y = 0x00, color = c.gray},
			super = {offset = 0x0E8, max = 128, pos_X = 0x64, pos_Y = 0xD6, color = c.yellow, 
				read = rb, align = "align outer"},
			super_timeout = {offset = 0x0EA, max = 64, pos_X = 0x64, pos_Y = 0xCE, color = c.pink,
				condition = function(p) return rw(p.base + 0x0EA) > 0 end, read = rb, align = "align outer"},
		},
		stun_bar = {
			pos_X = 0x0E, pos_Y = 0x2A, length = 0x40, height = 0x04,
			level = function(p) return rw(p.base + 0x13E), 103 end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rb(p.base + 0x0D3), max = 240, 
					condition = rb(p.base + 0x12E) == 0x04 and rb(p.base + 0x0D3) > 0 and rb(p.base + 0x0D3) < 240},
				{state = "precountdown", val = 0, max = 120, condition = rb(p.base + 0x12D) > 0},
				{state = "grace", val = rb(p.base + 0x145), max = 60, condition = rb(p.base + 0x0E1) == 0x01},
				{state = "normal", val = rw(p.base + 0x176), max = 120},
			}) end,
		},
		show_OSD = function()
			return bit.band(rb(0x10A83A), 0x80) == 0 and rb(0x10A83C) > 0 and bit.band(rb(0x10A785), 0x02) == 0
		end,
	},
	{	games = {"kof97"},
		player = 0x108100, space = 0x200, 
		text = {
			life  = {offset = 0x138, max = 103, pos_X = 0x10, pos_Y = 0x00, color = c.green},
			guard = {offset = 0x146, max = 103, pos_X = 0x38, pos_Y = 0x00, color = c.gray},
			super = {offset = 0x0E8, max = 128, pos_X = 0x6C, pos_Y = 0xD6, color = c.yellow, 
				read = rb, align = "align outer"},
			super_timeout = {offset = 0x0EA, max = 64, pos_X = 0x6C, pos_Y = 0xC4, color = c.pink,
				condition = function(p) return rw(p.base + 0x0EA) > 0 end, read = rb, align = "align outer"},
		},
		stun_bar = {
			pos_X = 0x0E, pos_Y = 0x24, length = 0x40, height = 0x04,
			level = function(p) return rw(p.base + 0x13E), 103 end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rb(p.base + 0x0D3), max = 240, 
					condition = rb(p.base + 0x12E) == 0x04 and rb(p.base + 0x0D3) > 0 and rb(p.base + 0x0D3) < 240},
				{state = "precountdown", val = 0, max = 120, condition = rb(p.base + 0x12D) > 0},
				{state = "grace", val = rb(p.base + 0x145), max = 60, condition = rb(p.base + 0x0E1) == 0x01},
				{state = "normal", val = rw(p.base + 0x176), max = 120},
			})
			end,
		},
		show_OSD = function()
			return bit.band(rb(0x10A83E), 0x80) == 0 and rb(0x10A840) > 0 and bit.band(rb(0x10A788), 0x02) == 0
		end,
	},
	{	games = {"kof98"},
		player = 0x108100, space = 0x200, 
		text = {
			life  = {offset = 0x138, max = 103, pos_X = 0x10, pos_Y = 0x00, color = c.green},
			guard = {offset = 0x146, max = 103, pos_X = 0x38, pos_Y = 0x00, color = c.gray},
			super = {offset = 0x0E8, pos_X = 0x6C, pos_Y = 0xD6, color = c.yellow, 
				max = function(p)
					return rb(p.base + 0x1D5) == 0 and 128 or 160 --adv: 128; ex: 160
				end, read = rb, align = "align outer"},
			super_timeout = {offset = 0x0EA, max = 64, pos_X = 0x6C, pos_Y = 0xC4, color = c.pink,
				condition = function(p) return rw(p.base + 0x0EA) > 0 end, read = rb, align = "align outer"},
		},
		stun_bar = {
			pos_X = 0x0E, pos_Y = 0x2A, length = 0x40, height = 0x04,
			level = function(p) return rw(p.base + 0x13E), 103 end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rb(p.base + 0x0D3), max = 240, 
					condition = rb(p.base + 0x12E) == 0x04 and rb(p.base + 0x0D3) > 0 and rb(p.base + 0x0D3) < 240},
				{state = "precountdown", val = 0, max = 120, condition = rb(p.base + 0x12D) > 0},
				{state = "grace", val = rb(p.base + 0x145), max = 240, condition = rb(p.base + 0x0E1) == 0x01},
				{state = "normal", val = rw(p.base + 0x176), max = 120},
			})
			end,
		},
		show_OSD = function()
			return bit.band(rb(0x10A83E), 0x80) == 0 and rb(0x10A840) > 0 and bit.band(rb(0x10A788), 0x02) == 0
		end,
	},
	{	games = {"kof99"},
		player = 0x108100, space = 0x200, 
		text = {
			life  = {offset = 0x138, max = 101, pos_X = 0x10, pos_Y = 0x00, color = c.green},
			guard = {offset = 0x146, max = 101, pos_X = 0x38, pos_Y = 0x00, color = c.gray},
			super = {offset = 0x0E8, max = 144, pos_X = 0x4C, pos_Y = 0x30, color = c.yellow, read = rb},
		},
		stun_bar = {
			pos_X = 0x02, pos_Y = 0x24, length = 0x38, height = 0x04,
			level = function(p) return rw(p.base + 0x13E), 101 end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rb(p.base + 0x0D3), max = 240, 
					condition = rb(p.base + 0x12E) == 0x04 and rb(p.base + 0x0D3) > 0 and rb(p.base + 0x0D3) < 240},
				{state = "precountdown", val = 0, max = 120, condition = rb(p.base + 0x12D) > 0},
				{state = "grace", val = rb(p.base + 0x145), max = 240, condition = rb(p.base + 0x0E1) == 0x01},
				{state = "normal", val = 0, max = 120},
			})
			end,
		},
		show_OSD = function()
			return bit.band(rb(0x10A7EA), 0x80) == 0 and rb(0x10A7EC) > 0 and bit.band(rb(0x10A788), 0x02) == 0
		end,
	},
	{	games = {"kof2000"},
		player = 0x108100, space = 0x200, 
		text = {
			life  = {offset = 0x138, max = 102, pos_X = 0x10, pos_Y = 0x00, color = c.green},
			guard = {offset = 0x146, max = 102, pos_X = 0x38, pos_Y = 0x00, color = c.gray},
			super = {offset = 0x0E8, max = 144, pos_X = 0x4C, pos_Y = 0x30, color = c.yellow, read = rb},
		},
		stun_bar = {
			pos_X = 0x02, pos_Y = 0x24, length = 0x40, height = 0x04,
			level = function(p) return rw(p.base + 0x13E), 102 end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rb(p.base + 0x0D3), max = 240, 
					condition = rb(p.base + 0x12E) == 0x04 and rb(p.base + 0x0D3) > 0 and rb(p.base + 0x0D3) < 240},
				{state = "precountdown", val = 0, max = 120, condition = rb(p.base + 0x12D) > 0},
				{state = "grace", val = rb(p.base + 0x145), max = 240, condition = rb(p.base + 0x0E1) == 0x01},
				{state = "normal", val = 0, max = 120},
			})
			end,
		},
		show_OSD = function()
			return bit.band(rb(0x10A7EA), 0x80) == 0 and rb(0x10A7EC) > 0 and bit.band(rb(0x10A788), 0x02) == 0
		end,
	},
	{	games = {"kof2001"},
		player = 0x108100, space = 0x200, 
		text = {
			life  = {offset = 0x138, max = 102, pos_X = 0x14, pos_Y = 0x00, color = c.green},
			guard = {offset = 0x146, max = 102, pos_X = 0x3C, pos_Y = 0x00, color = c.gray},
			super = {offset = 0x0E8, max = 078, pos_X = 0x28, pos_Y = 0xD8, color = c.yellow, read = rb},
		},
		show_OSD = function()
			return bit.band(rb(0x10A7D6), 0x80) == 0 and rb(0x10A7D8) > 0 and bit.band(rb(0x10A788), 0x02) == 0
		end,
	},
	{	games = {"kof2002"},
		player = 0x108100, space = 0x200, 
		text = {
			life  = {offset = 0x138, max = 102, pos_X = 0x10, pos_Y = 0x00, color = c.green},
			guard = {offset = 0x146, max = 102, pos_X = 0x38, pos_Y = 0x00, color = c.gray},
			super = {offset = 0x0E8, max = 066, pos_X = 0x6C, pos_Y = 0xD2, color = c.yellow, 
				read = rb, align = "align outer"},
			super_timeout = {offset = 0x0EA, max = 47, pos_X = 0x6C, pos_Y = 0xCA, color = c.pink,
				condition = function(p) return rw(p.base + 0x0EA) > 0 end, read = rb, align = "align outer"},
		},
		show_OSD = function()
			return bit.band(rb(0x10A7D6), 0x80) == 0 and rb(0x10A7D8) > 0 and bit.band(rb(0x10A788), 0x02) == 0
		end,
	},
	{	games = {"fatfury1"},
		player = 0x100300, space = 0x100, nplayers = 3, 
		text = {
			life  = {offset = 0xB9, max = 96, pos_X = 0x02, pos_Y = 0x18, color = c.green, 
				read = rb, align = "align outer"},
		},
		player_active = function(p)
			if p.base < 0x100500 then
				return rd(p.base) ~= 0x1448
			end
			return rd(p.base) ~= 0x3A54
		end,
		X_offset = {0, 0, 0},
		Y_offset = {0, 0, 0x10},
		swap_sides = function(p)
			if p[3].active then --swap sides and offsets for p 2-3 in vs. comp match
				p[2].side, p[2].Y_offset = -1, game.Y_offset[3]
				p[3].side, p[3].Y_offset =  1, game.Y_offset[2]
			end
		end,
		show_OSD = function()
			return rb(0x100002) == 0x22
		end,
	},
	{	games = {"fatfury2"},
		player = 0x100300, space = 0x100, 
		text = {
			life  = {offset = 0xCA, max = 96, pos_X = 0x8A, pos_Y = 0x10, color = c.green},
		},
		stun_bar = {
			pos_X = 0x50, pos_Y = 0x24, length = 0x40, height = 0x04, align = "align outer", 
			level = function(p) return rw(p.base + 0xD0), rw(p.base + 0xD2) end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rw(p.base + 0xB0), max = 180, 
					condition = rd(p.base) == 0x02C1C0 or rd(p.base) == 0x02C20A},
				{state = "precountdown", val = rw(p.base + 0xCE), max = 180, 
					condition = rw(p.base + 0xD0) >= rw(p.base + 0xD2)},
				{state = "normal", val = rw(p.base + 0xCE), max = 180},
			})
			end,
		},
		show_OSD = function()
			return rb(0x100920) > 0
		end,
	},
	{	games = {"fatfursp"},
		player = 0x100400, space = 0x100, 
		text = {
			life  = {offset = 0x9A, max = 96, pos_X = 0x8A, pos_Y = 0x10, color = c.green, read = rb},
		},
		stun_bar = {
			pos_X = 0x50, pos_Y = 0x24, length = 0x40, height = 0x04, align = "align outer", 
			level = function(p) return rb(p.base + 0xA4), rb(p.base + 0xA5) end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rw(p.base + 0xA6), max = 180, condition = rb(p.base + 0xA4) == 0xFF},
				{state = "normal", val = rw(p.base + 0xA6) == 0xFFFF and 0 or rw(p.base + 0xA6), max = 180},
			})
			end,
		},
		show_OSD = function()
			return rb(0x100920) > 0
		end,
	},
	{	games = {"fatfury3"},
		player = 0x100400, space = 0x100, 
		text = {
			life  = {offset = 0x89, max = 120, pos_X = 0x08, pos_Y = 0x20, color = c.green, 
				read = rb, align = "align outer"},
		},
		stun_bar = {
			pos_X = 0x50, pos_Y = 0x2A, length = 0x40, height = 0x04, align = "align outer", 
			level = function(p) return rb(p.base + 0x90), rb(p.base + 0x91) end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rw(p.base + 0x92), max = 400, 
					condition = bit.band(rb(p.base + 0xCB), 0x07) > 0 and bit.band(rb(p.base + 0xCE), 0x40) > 0},
				{state = "normal", val = rw(p.base + 0xF6), max = 100},
			})
			end,
		},
		show_OSD = function()
			return rw(0x100916) == 0xFFFF and rb(0x100921) == 0
		end,
	},
	{	games = {"rbff1"},
		player = 0x100400, space = 0x100, 
		text = {
			life  = {offset = 0x89, max = 192, pos_X = 0x14, pos_Y = 0x28, color = c.green, 
				read = rb, align = "align outer"},
			super = {offset = 0xBA, max =  60, pos_X = 0x8A, pos_Y = 0xD0, color = c.yellow, read = rb},
		},
		stun_bar = {
			pos_X = 0x50, pos_Y = 0x2A, length = 0x40, height = 0x04, align = "align outer", 
			level = function(p) return rb(p.base + 0x90), rb(p.base + 0x91) end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rw(p.base + 0x92), max = 400, 
					condition = bit.band(rb(p.base + 0xCB), 0x87) > 0 and bit.band(rb(p.base + 0xCE), 0x40) > 0},
				{state = "normal", val = rw(p.base + 0xF6), max = 100},
			})
			end,
		},
		show_OSD = function()
			return any_true({
				rw(0x106AA2) == 0x3800, rw(0x106AA2) == 0x4400, rw(0x106AA2) == 0x7738, 
			})
		end,
	},
	{	games = {"rbffspec"},
		player = 0x100400, space = 0x100, 
		text = {
			life  = {offset = 0x8B, max = 192, pos_X = 0x14, pos_Y = 0x28, color = c.green, 
				read = rb, align = "align outer"},
			super = {offset = 0xBC, max =  60, pos_X = 0x8A, pos_Y = 0xD0, color = c.yellow, read = rb},
		},
		show_OSD = function()
			return any_true({
				rw(0x106AAE) == 0x3800, rw(0x106AAE) == 0x4400, rw(0x106AAE) == 0x7738, 
			})
		end,
	},
	{	games = {"rbff2"},
		player = 0x100400, space = 0x100, 
		text = {
			life  = {offset = 0x8B, max = 192, pos_X = 0x14, pos_Y = 0x28, color = c.green, 
				read = rb, align = "align outer"},
			super = {offset = 0xBC, max =  60, pos_X = 0x8A, pos_Y = 0xD0, color = c.yellow, read = rb},
		},
		show_OSD = function()
			return any_true({
				rw(0x107C22) == 0x3800, rw(0x107C22) == 0x4400, rw(0x107C22) == 0x7738, 
			})
		end,
	},
	{	games = {"garou"},
		player = 0x100400, space = 0x100, 
		text = {
			life  = {offset = 0x8E, max = 120, pos_X = 0x14, pos_Y = 0x08, color = c.green, read = rb},
			super = {offset = 0xBE, max = 128, pos_X = 0x5C, pos_Y = 0xD0, color = c.yellow, 
				read = rb, align = "align outer"},
			guard = {pos_X = 0x44, pos_Y = 0x08, color = c.gray, 
				val = function(p) return rb(p.base + game.guard_offset) end,
				max = function(p) return game.guard_max[bit.band(rw(p.base + 0x10), 0xF)] end},
		},
		initial = function()
			local bank_address = 
				{["garou"] = 0x2FFFC0, ["garouo"] = 0x2FFFC0, ["garoup"] = 0x2FFFF0, ["garoubl"] = 0x2FFFF0}
			local bank_setting = 
				{["garou"] = 0x8313, ["garouo"] = 0x91A2, ["garoup"] = 0x2, ["garoubl"] = 0x2}
			local guard_max_base = 
				{["garou"] = 0x21E402, ["garouo"] = 0x21E402, ["garoup"] = 0x2EE402, ["garoubl"] = 0x2EE402}
			game.guard_max = {}
			memory.writeword(bank_address[emu.romname()], bank_setting[emu.romname()])
			for n = 0, 0xF do
				game.guard_max[n] = rb(guard_max_base[emu.romname()] + n)
			end
			game.guard_offset = 
				{["garou"] = 0xA8E4, ["garouo"] = 0xA8E4, ["garoup"] = 0xA89A, ["garoubl"] = 0xA89A}
			game.guard_offset = game.guard_offset[emu.romname()]
		end,
		show_OSD = function()
			return any_true({
				rw(0x10748A) == 0x3800, rw(0x10748A) == 0x4400, rw(0x10748A) == 0x7738, 
			})
		end,
	},
}

--------------------------------------------------------------------------------
-- post-process the modules

local sf2_limit = {
	["sf2"]   = function(p) return 0x1E end,
	["sf2ce"] = function(p) return 0x1F end,
	["sf2hf"] = function(p) return 0x1F end,
	["ssf2"]  = function(p) return 0x1F end,
	["ssf2t"] = function(p)
		return rw(game.stun_limit_base[emu.romname()] + rb(p.base + 0x2B1))
	end,
}

sf2_limit["hsf2"] = function(p)
	p.opponent = rb(0xFF0000 + rw(p.base + 0x344) + 0x32A)
	local mode = {
		[0] = sf2_limit["ssf2t"], --SuperT
		[2] = sf2_limit["ssf2t"], --Super
		[4] = sf2_limit["sf2"], --Normal
		[6] = sf2_limit["sf2ce"], --Champ
		[8] = sf2_limit["sf2hf"], --Turbo
	}
	return mode[p.opponent](p)
end


local functionize = function(param)
	if type(param) == "number" then
		return (function() return param end)
	end
	return param
end

for _, g in ipairs(profile) do
	if string.find(g.games[1], "sf2") then
		g.text = {
			life  = {offset = 0x2A, max = 144, pos_X = 0x10, pos_Y = 0x0E, color = c.green,
				condition = function(p) return g.show_life() end},
			super = {offset = 0x2B4, max = 48, pos_X = 0x48, pos_Y = 0xCE, color = c.yellow, 
				condition = function(p) return g.show_super(p) end, read = rb, align = "align outer"},
		}
		g.stun_bar = {
			pos_X = 0x16, pos_Y = 0x20, length = 0x40, height = 0x04, 
			level = function(p) return rw(p.base + 0x05E), sf2_limit[game.parent](p) end,
			timeout = function(p) return get_state({
				{state = "countdown", val = rw(p.base + 0x060), max = 180, condition = rb(p.base + 0x124) > 0},
				{state = "precountdown", val = 0, max = 180, condition = rb(p.base + 0x123) > 0},
				{state = "grace", val = rw(p.base + game.offset.grace), max = 60, 
					condition = rw(p.base + g.offset.grace) > 0 and game.parent ~= "sf2" and p.opponent ~= 4},
				{state = "normal", val = rw(p.base + 0x05C), max = 180},
			}) end
		}
		g.initial = function(p)
			game.parent = emu.parentname()
			game.parent = game.parent == "1" and emu.romname() or game.parent
		end
		g.special = function(p)
			if rb(p.base + game.offset.char_id) == 0xB then
				p.text.claw = {X = 0, Y = 0xD8, color = c.pink, val = "-", align = "align outer"}
				if rb(p.base + 0x14C) > 0 then
					p.text.claw.val = 8 - rb(p.base + 0x162)
				end
				p.text.claw.val = "claw: " .. p.text.claw.val .. "/8"
			end
		end
	elseif string.find(g.games[1], "sfa") then
		g.X_offset = {0, 0, 0x58, 0x58}
		g.Y_offset = {0, 0, 0, 0}
		g.player_active = function(p) return rb(p.base) > 0 end
		g.swap_sides = function(p)
			if p[3].active then --swap sides and offsets for p 2-3 in SFA Dramatic Battle
				p[2].side, p[2].X_offset = -1, g.X_offset[3]
				p[3].side, p[3].X_offset =  1, g.X_offset[2]
			end
		end
	elseif string.find(g.games[1], "sfiii") then
		g.special = function(p)
			local pos_X, pos_Y, max = 0x04, 0x30, 0x2A
			local length, height, space = max, 0x03, 0x08
			p.char = rw(p.base + g.char_offset)
			for _, slot in ipairs(g.charge_chars[p.char] or {}) do
				local charge_base = g.charge_base + rb(p.base + 0x002) * g.charge_space + 0x1C * slot
				local charge_level = {X = pos_X + length + 0x4, Y = pos_Y, align = "align outer", 
					val = max - rws(charge_base + 0x4), max = max + 1, color = c.pink}
				local top_bar = {X = emu.screenwidth()/2 - length - pos_X, Y = pos_Y, 
					length = length, height = height, data = charge_level, color = c.stun_level}
				if charge_level.val >= max then
					charge_level.color = c.green
					top_bar.color = c.stun_grace
				end
				table.insert(p.text, charge_level)
				table.insert(p.bar, top_bar)
				local charge_timeout = {X = pos_X + length + 0xE, Y = pos_Y, align = "align outer", 
					val = rws(charge_base + 0x2) + 1, max = max, color = c.yellow}
				local bottom_bar = {X = emu.screenwidth()/2 - length - pos_X, Y = pos_Y + height, 
					length = length, height = height, data = charge_timeout, color = c.stun_timeout}
				if rw(charge_base) == 0x1 then
					charge_timeout.color = c.cyan
					bottom_bar.color = c.stun_duration
				end
				table.insert(p.text, charge_timeout)
				table.insert(p.bar, bottom_bar)
				pos_Y = pos_Y + space
			end
		end
		g.show_OSD = function()
			local match = rd(g.match_status)
			return match > 0x00010003 and match < 0x00090000
		end
	end
	g.space     = g.space    or 0x400
	g.nplayers  = g.nplayers or 2
	g.X_offset  = g.X_offset or {0, 0}
	g.Y_offset  = g.Y_offset or {0, 0}
	g.base_type = g.player_ptr and "pointer" or "direct"
	g.player_active = g.player_active or function() return true end
	g.swap_sides    = g.swap_sides    or function() end
	for _, text in pairs(g.text or {}) do
		if text.offset then
			text.val = function(p) return (text.read or rw)(p.base + text.offset) end
		end
		text.max = functionize(text.max)
		text.pos_X = functionize(text.pos_X)
		text.pos_Y = functionize(text.pos_Y)
		text.condition = text.condition or function() return true end
	end
	if g.stun_bar then
		g.stun_bar.align = g.stun_bar.align or "align inner"
	end
	g.initial = g.initial or function() end
	g.special = g.special or function() end
end

--------------------------------------------------------------------------------
-- hotkey functions

input.registerhotkey(1, function()
	show_numbers = not show_numbers
	print((show_numbers and "showing" or "hiding") .. " numbers")
end)

input.registerhotkey(2, function()
	show_bars = not show_bars
	print((show_bars and "showing" or "hiding") .. " bars")
end)

--------------------------------------------------------------------------------
-- data update functions

local set_bar_text_X = {
	["align inner"] = function(text) --default
		return game.stun_bar.pos_X + game.stun_bar.length + 0x4
	end,

	["align outer"] = function(text)
		return game.stun_bar.pos_X - string.len(text) * 4 - 0x4
	end,
}


local set_text_X = {
	["align inner"] = function(p, text) --default
		return emu.screenwidth()/2 + p.side * (text.X + p.X_offset) - (p.side < 1 and 1 or 0) * text.width
	end,

	["align outer"] = function(p, text)
		return (p.side < 1 and 0 or 1) * (emu.screenwidth() - text.width) - p.side * text.X
	end,
}


local set_bar_base = {
	["align inner"] = function(p) --default
		return emu.screenwidth()/2, p.side
	end,

	["align outer"] = function(p)
		return (p.side < 1 and 0 or 1) * emu.screenwidth(), -p.side
	end,
}


local function set_bar_params(p, bar)
	bar.X = bar.X + p.X_offset
	bar.top = bar.Y + p.Y_offset
	bar.bottom = bar.top + bar.height
	bar.bg_inner = bar.base + bar.side * bar.X
	bar.bg_outer = bar.base + bar.side * (bar.X + bar.length)
	if bar.data.val == 0 then
		return
	end
	bar.normal_inner = bar.bg_inner
	bar.normal_outer = bar.data.val/bar.data.max >= 1 and bar.bg_outer or 
		bar.base + bar.side * (bar.X + bar.data.val/bar.data.max%1 * bar.length)
	if bar.data.val/bar.data.max < 1 then
		return
	end
	bar.over_inner = bar.bg_inner
	bar.over_outer = bar.base + bar.side * (bar.X + bar.data.val/bar.data.max%1 * bar.length)
end


local get_player_base = {
	["direct"] = function(p)
		return game.player + (p-1)*game.space
	end,

	["pointer"] = function(p)
		return rd(game.player_ptr + (p-1)*game.space)
	end,
}


local get_char_data = function(p)
	for _, text in pairs(game.text or {}) do
		if text.condition(p) then
			local data = {X = text.pos_X(p), Y = text.pos_Y(p), color = text.color, 
				align = text.align, val = text.val(p), max = text.max and text.max(p)}
			if text.max then
				data.max = text.max(p)
				data.val = (data.val > data.max and "-" or data.val) .. "/" .. data.max
			end
			table.insert(p.text, data)
		end
	end

	game.special(p)

	if not game.stun_bar then
		return
	end

	p.text.stun_level = {Y = game.stun_bar.pos_Y - 2, align = game.stun_bar.align}
	p.text.stun_level.val, p.text.stun_level.max = game.stun_bar.level(p)
	p.bar.stun_level = {X = game.stun_bar.pos_X, Y = game.stun_bar.pos_Y, 
		length = game.stun_bar.length, height = game.stun_bar.height, 
		data = p.text.stun_level, align = game.stun_bar.align, color = c.stun_level}

	p.text.stun_timeout = {Y = game.stun_bar.pos_Y + 6, align = game.stun_bar.align}
	p.bar.stun_timeout = {X = game.stun_bar.pos_X, Y = game.stun_bar.pos_Y + game.stun_bar.height, 
		length = game.stun_bar.length, height = game.stun_bar.height, 
		data = p.text.stun_timeout, align = game.stun_bar.align}

	p.state, p.text.stun_timeout.val, p.text.stun_timeout.max = game.stun_bar.timeout(p)
	if p.state == "countdown" then
		p.bar.stun_timeout.color = c.stun_duration
	elseif p.state == "grace" then
		p.bar.stun_timeout.color = c.stun_grace
	else
		p.bar.stun_timeout.color = c.stun_timeout
	end

	p.text.stun_level.display = p.text.stun_level.val
	if p.state == "precountdown" or p.state == "countdown" then
		p.text.stun_level.val = p.text.stun_level.max
		p.text.stun_level.display = "-"
	end
	p.text.stun_level.display = p.text.stun_level.display .. "/" .. p.text.stun_level.max
	p.text.stun_level.X   = set_bar_text_X[game.stun_bar.align](p.text.stun_level.display)
	p.text.stun_timeout.X = set_bar_text_X[game.stun_bar.align](p.text.stun_timeout.val)
end


local update_OSD = function()
	if not game then
		return
	end
	show_OSD = game.show_OSD(game.player)
	for p = 1, game.nplayers do
		player[p].base = get_player_base[game.base_type](p)
		player[p].active = game.player_active(player[p])
		player[p].side = bit.band(p, 1) > 0 and -1 or 1
		player[p].X_offset = game.X_offset[p]
		player[p].Y_offset = game.Y_offset[p]
	end
	game.swap_sides(player)
	for p = 1, game.nplayers do
		local p = player[p]
		p.bar, p.text = {}, {}
		if p.active then
			get_char_data(p)
		end
		for _, text in pairs(p.text) do
			text.display = text.display or text.val
			text.width = 4 * string.len(text.display)
			text.X = set_text_X[text.align or "align inner"](p, text)
			text.Y = text.Y + p.Y_offset
		end
		for _, bar in pairs(p.bar) do
			bar.base, bar.side = set_bar_base[bar.align or "align inner"](p)
			set_bar_params(p, bar)
		end
		local bar = p.bar.stun_level
		if bar then
			p.stun_X = bar.base + bar.side * (bar.X + bar.length/2) - 13
			p.stun_Y = bar.Y - 1
		end
	end
	--emu.message(string.format("P1: %s, P2: %s", player[1].state, player[2].state)) --debug
end


emu.registerafter(function()
	update_OSD()
end)

--------------------------------------------------------------------------------
-- drawing functions

local function pixel(x1, y1, color, dx, dy)
	gui.pixel(x1 + dx, y1 + dy, color)
end

local function line(x1, y1, x2, y2, color, dx, dy)
	gui.line(x1 + dx, y1 + dy, x2 + dx, y2 + dy, color)
end

local function box(x1, y1, x2, y2, color, dx, dy)
	gui.box(x1 + dx, y1 + dy, x2 + dx, y2 + dy, color)
end

local draw_stun = function(p)
	local f, s, o = 0xF8B000FF, 0xB06000FF, 0x500000FF --fill, shade, outline colors
	local x, y = p.stun_X, p.stun_Y
	box(0,1,6,6, o, x, y)
	line(7,3,7,5, o, x, y)
	box(1,0,28,2, o, x, y)
	box(9,3,12,6, o, x, y)
	box(14,3,28,6, o, x, y)
	box(1,1,6,5, f, x, y)
	line(3,2,6,2, o, x, y)
	line(1,4,4,4, o, x, y)
	pixel(1,1, s, x, y)
	pixel(1,3, s, x, y)
	pixel(6,3, s, x, y)
	pixel(6,5, s, x, y)
	line(8,1,13,1, f, x, y)
	box(10,2,11,5, f, x, y)
	box(15,1,20,5, f, x, y)
	box(17,1,18,4, o, x, y)
	pixel(15,5, s, x, y)
	pixel(20,5, s, x, y)
	box(22,1,23,5, f, x, y)
	box(26,1,27,5, f, x, y)
	line(24,2,25,3, f, x, y)
	line(24,3,25,4, f, x, y)
end


local draw_player_objects = function(p)
	if show_bars then
		for _, bar in pairs(p.bar) do
			gui.box(bar.bg_inner, bar.top, bar.bg_outer, bar.bottom, c.bg.fill, c.bg.outline)
			if bar.normal_outer then
				gui.box(bar.normal_inner, bar.top, bar.normal_outer, bar.bottom, bar.color.normal, 0)
			end
			if bar.over_outer then
				gui.box(bar.over_inner, bar.top, bar.over_outer, bar.bottom, bar.color.overflow, 0)
			end
		end
		if (p.state == "precountdown" or p.state == "countdown") and bit.band(emu.framecount(), 2) > 0 then
			draw_stun(p)
		end
	end
	if show_numbers then
		for _, text in pairs(p.text) do
			gui.text(text.X, text.Y, text.display, text.color or 0xFFFFFFFF)
		end
	end
end


local draw_OSD = function()
	if not game or not show_OSD then
		return
	end
	for p = 1, game.nplayers do
		if player[p].active then
			draw_player_objects(player[p])
		end
	end
end


gui.register(function()
	gui.clearuncommitted()
	draw_OSD()
end)

--------------------------------------------------------------------------------
-- initialize on game startup

print()
local function whatgame()
	game = nil
	player = {}
	for _, module in ipairs(profile) do
		for _, shortname in ipairs(module.games) do
			if emu.romname() == shortname or emu.parentname() == shortname then
				print("showing OSD for: " .. emu.gamename())
				game = module
				for p = 1, game.nplayers do
					player[p] = {}
				end
				game.initial()
				update_OSD()
				return
			end
		end
	end
	print("not prepared to show OSD for: " .. emu.gamename())
end


emu.registerstart(function()
	whatgame()
end)
