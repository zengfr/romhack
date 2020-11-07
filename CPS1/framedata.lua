print("Frame data collector script")
print("July 5, 2011")
print("http://code.google.com/p/mame-rr/")
print()
print("> 'startup' is the period before the 1st active frame")
print("> hitfreeze '*' means the attacker did not get frozen")
print("Lua hotkey 1: insert blank line")

local print_header = function()
	print("startup\tatkrecov.\thitstun\tfr.adv.\thitfreeze")
end

local print_results = function(c)
	print(string.format("%d\t%d\t%d\t%+d\t%d%s\t%s", 
		c.startup, c.atkrecov, c.hitstun, c.advantage, c.hitfreeze, c.non_projectile, c.freeze_details))
end

local profile = {
	{
		games = {"sf2"}, class = "sf2",
		address = {0xFF83C6, 0xFF86C6, projectile_slowdown = 0xFF82E2},
	},
	{
		games = {"sf2ce", "sf2hf"}, class = "sf2",
		address = {0xFF83BE, 0xFF86BE, projectile_slowdown = 0xFF82E2},
		no_frameskip = function() memory.writebyte(0xFF02BE, 0x00) end,
	},
	{
		games = {"ssf2t"}, class = "sf2",
		address = {0xFF844E, 0xFF884E, projectile_slowdown = 0xFF82F2},
		no_frameskip = function() memory.writebyte(0xFF8CD3, 0xFF) end,
		superfreeze = function(addr) return memory.readbyte(addr + 0x1FA) == 0x01 end,
	},
	{
		games = {"ssf2"}, class = "sf2",
		address = {0xFF83CE, 0xFF87CE, projectile_slowdown = 0xFF82F2},
	},
	{
		games = {"hsf2"}, class = "sf2",
		address = {0xFF833C, 0xFF873C, projectile_slowdown = 0xFF8C29},
		superfreeze = function(addr) return memory.readbyte(addr + 0x1FA) == 0x01 end,
	},
	{
		games = {"sfa"}, class = "sfa",
		hitfreeze = function(addr) return memory.readbyte(addr + 0x04F) ~= 0x00 end,
		superfreeze = function(addr) return memory.readbyte(0xFFAE84) ~= 0x00 end,
		delay = {startup = 0, atk_recover = 1, hit_recover = 0, prefreeze = 0, superfreeze = 10, postfreeze = {["*"] = 4, [""] = -4}},
	},
	{
		games = {"sfa2", "sfz2al"}, class = "sfa",
		hitfreeze = function(addr) return memory.readbyte(addr + 0x05F) ~= 0x00 end,
		superfreeze = function(addr) return memory.readbyte(0xFF8125) ~= 0x00 end,
		delay = {startup = -1, atk_recover = 1, hit_recover = 0, prefreeze = 0, superfreeze = 10, postfreeze = {["*"] = 4, [""] = -4}},
	},
	{
		games = {"sfa3"},
		address = {0xFF8400, 0xFF8800},
		attacking = function(addr)
			return (
				memory.readbyte(addr + 0x0A9) == 0x01 or --normal attack
				memory.readbyte(addr + 0x0CE) == 0x01 or --special
				memory.readbyte(addr + 0x005) == 0x04 --normal throw
			)
		end,
		supering  = function(addr) return memory.readbyte(addr + 0x216) == 0x01 end,
		hurt      = function(addr) return memory.readbyte(addr + 0x005) == 0x02 end,
		thrown    = function(addr) return memory.readbyte(addr + 0x005) == 0x06 end,
		hitfreeze = function(addr) return memory.readbyte(addr + 0x05F) ~= 0x00 end,
		superfreeze = function(addr) return memory.readbyte(0xFF8125) ~= 0x00 end,
		delay = {startup = -1, atk_recover = 1, hit_recover = 0, prefreeze = 0, superfreeze = 0, postfreeze = {["*"] = -4, [""] = -4}},
	},
	{
		games = {"dstlk"}, class = "dstlk",
		address = {0xFF8388, 0xFF8788},
	},
	{
		games = {"nwarr"}, class = "dstlk",
		address = {0xFF8388, 0xFF8888},
	},
	{
		games = {"vsav","vhunt2","vsav2"},
		address = {0xFF8400, 0xFF8800},
		attacking = function(addr) return memory.readbyte(addr + 0x105) == 0x01 end,
		supering  = function(addr) return memory.readbyte(addr + 0x006) == 0x12 end,
		hurt      = function(addr) return memory.readbyte(addr + 0x005) == 0x02 end,
		thrown    = function(addr) return memory.readbyte(addr + 0x005) == 0x06 end,
		hitfreeze = function(addr) return memory.readbyte(addr + 0x05C) ~= 0x00 end,
		delay = {startup = -1, atk_recover = 1, hit_recover = 1},
	},
	{
		games = {"sfiii"}, class = "sf3",
		address = {0x0200D18C, 0x0200D564},
		super_frozen  = 0x390,
		super_shadows = 0x398,
	},
	{
		games = {"sfiii2"}, class = "sf3",
		address = {0x0200E504, 0x0200E910},
		super_frozen  = 0x3B4,
		super_shadows = 0x3BC,
	},
	{
		games = {"sfiii3"}, class = "sf3",
		address = {0x02068C6C, 0x02069104},
		super_frozen  = 0x41C,
		super_shadows = 0x424,
	},
}

local fill_out = {
	["sf2"] = function(game)
		game.attacking = function(addr) return memory.readbyte(addr + 0x18B) == 0x01 end
		game.hurt      = function(addr) return memory.readbyte(addr + 0x003) >= 0x0E end
		game.thrown    = function(addr) return memory.readbyte(addr + 0x063) == 0xFF end
		game.hitfreeze = function(addr) return memory.readbyte(addr + 0x047) ~= 0x00 end
		game.delay = {startup = -1, atk_recover = 0, hit_recover = 0, 
			prefreeze = 0, superfreeze = -1, postfreeze = {["*"] = 0, [""] = 0}}
	end,

	["sfa"] = function(game)
		game.address = {0xFF8400, 0xFF8800}
		game.attacking = function(addr)
			return (
				memory.readbyte(addr + 0x132) == 0x01 or --normal attack
				memory.readbyte(addr + 0x006) == 0x0E or --special
				memory.readbyte(addr + 0x005) == 0x04 --normal throw
			)
		end
		game.supering  = function(addr) return memory.readbyte(addr + 0x006) == 0x10 end
		game.hurt      = function(addr) return memory.readbyte(addr + 0x005) == 0x02 end
		game.thrown    = function(addr) return memory.readbyte(addr + 0x005) == 0x06 end
	end,

	["dstlk"] = function(game)
		game.attacking = function(addr)
			return (
				memory.readbyte(addr + 0x005) == 0x02 or --normal attack
				memory.readbyte(addr + 0x004) == 0x10 or --special
				memory.readbyte(addr + 0x004) == 0x0E or --throw
				memory.readbyte(addr + 0x088) == 0x01 --special recovery
			)
		end
		game.supering = function(addr)
			return (
				memory.readbyte(addr + 0x004) == 0x10 or --special
				memory.readbyte(addr + 0x004) == 0x0E or --throw
				memory.readbyte(addr + 0x088) == 0x01 --special recovery
			)
		end
		game.hurt      = function(addr) return memory.readbyte(addr + 0x004) == 0x0C end
		game.thrown    = function(addr) return memory.readbyte(addr + 0x004) == 0x12 end
		game.hitfreeze = function(addr) return memory.readbyte(addr + 0x04B) ~= 0x00 end
		game.delay = {startup = 0, atk_recover = 1, hit_recover = 1}
		game.update = {func = emu.registerbefore, cycle = 4}
	end,

	["sf3"] = function(game)
		game.attacking = function(addr)
			return memory.readword(addr + 0x026) == 0x0002 or memory.readword(addr + 0x026) == 0x0004
		end
		game.supering  = function(addr) return memory.readword(addr + game.super_shadows) == 0x0001 end
		game.hurt      = function(addr) return memory.readword(addr + 0x026) == 0x0001 end
		game.thrown    = function(addr) return memory.readword(addr + 0x026) == 0x0003 end
		game.hitfreeze = function(addr, opp_addr)
			return memory.readword(addr + 0x044) ~= 0x0000 and 
				(memory.readbyte(addr + game.super_frozen) == 0x00 and memory.readbyte(opp_addr + game.super_frozen) == 0x00)
		end
		game.superfreeze = function(addr, opp_addr)
			return memory.readword(addr + 0x044) ~= 0x0000 and 
				(memory.readbyte(addr + game.super_frozen) == 0x01 or memory.readbyte(opp_addr + game.super_frozen) == 0x01)
		end
		game.delay = {startup = 0, atk_recover = 0, hit_recover = 0, 
			prefreeze = 0, superfreeze = 1, postfreeze = {["*"] = -4, [""] = -3}}
	end,
}

for _, game in ipairs(profile) do
	game.update = game.update or {func = emu.registerafter, cycle = 1}
	if game.class then
		fill_out[game.class](game)
	end
end

--------------------------------------------------------------------------------

local game, player_old, count, register_count, last_frame
local super_mode = false

input.registerhotkey(1, function()
	print()
end)

input.registerhotkey(2, function()
	if not game.supering then
		return
	end
	super_mode = not super_mode
	print() print("now tracking: " .. (super_mode and "super moves only" or "all moves"))
	print_header()
end)


local function initialize_count()
	count = {active = true, total = 0, total_superfreeze = 0, hitfreeze = 0, non_projectile = "*", freeze_details = ""}
end

local function initialize()
	player_old = {{}, {}}
	register_count, last_frame = 0, 0
	initialize_count()
end


local get_attack_state = {
	[false] = function(addr) --non-super mode
		return game.attacking(addr)
	end,

	[true] = function(addr) --super mode
		return game.supering(addr)
	end,
}

local function update_frame_data()
	if game.address.projectile_slowdown and
		memory.readbyte(game.address[1] + 0x02) ~= 0x04 and memory.readbyte(game.address[2] + 0x02) ~= 0x04 then
		memory.writebyte(game.address.projectile_slowdown, 0) --disable projectile slowdown
	end
	if game.no_frameskip then
		game.no_frameskip() --disable frameskip
	end

	local player = {{}, {}}
	for p = 1, 2 do --get the current status of the players from RAM
		local addr = game.address[p]
		local opp_addr = (p == 1 and game.address[2]) or game.address[1]
		player[p].attacking   = get_attack_state[super_mode](addr)
		player[p].hurt        = game.hurt(addr)
		player[p].thrown      = game.thrown(addr)
		player[p].hitfreeze   = game.hitfreeze(addr, opp_addr)
		player[p].superfreeze = game.superfreeze and game.superfreeze(addr, opp_addr)
	end

	if not count.active and player[1].attacking and not player_old[1].attacking then --check for start of the attack
		initialize_count()
	end

	if count.active and not count.startup then --check for hit
		if player[1].superfreeze and not player_old[1].superfreeze and not count.prefreeze then --superfreeze just started
			count.prefreeze = count.total + game.delay.prefreeze
		elseif player_old[1].superfreeze and not player[1].superfreeze then --superfreeze just ended
			count.superfreeze = count.total - count.prefreeze
		end

		if player[2].hurt and not player_old[2].hurt then --attack hit
			count.startup = count.total + game.delay.startup
		elseif player[2].thrown and not player_old[2].thrown then --throw grabbed
			count.startup = count.total
		elseif not player[1].attacking then --attack whiffed; stop counting
			count.active = false
		end
	end

	if count.startup and not count.atkrecov then
		if player_old[1].hurt and not player[1].hurt then --check if the attacker got hit/traded
			count.atkrecov = count.total - count.hitfreeze - count.startup + game.delay.hit_recover
		elseif player_old[1].attacking and not (player[1].attacking or player[1].hurt) then --check for attacker recovery
			count.atkrecov = count.total - count.hitfreeze - count.startup + game.delay.atk_recover
		end
	end

	if count.startup and --check for dummy recovery
		(player_old[2].hurt or player_old[2].thrown) and not (player[2].hurt or player[2].thrown) then
		count.hitstun  = count.total - count.hitfreeze - count.startup + game.delay.hit_recover
	end

	if count.active and count.atkrecov and count.hitstun then --print results and stop counting
		count.advantage = count.hitstun - count.atkrecov
		if not count.non_projectile then --if it was a projectile...
			count.atkrecov = count.atkrecov + count.hitfreeze --...then p1 didn't have any hitfreeze so add it back
		end
		if count.prefreeze then
			count.superfreeze = count.superfreeze + game.delay.superfreeze
			count.postfreeze = count.startup - count.superfreeze + game.delay.postfreeze[count.non_projectile]
			count.startup = count.prefreeze + count.postfreeze
			count.freeze_details = count.prefreeze .. " (" .. count.superfreeze .. ") " .. count.postfreeze
		end
		print_results(count)
		count.active = false
	end

	player_old = player

	if (player[1].superfreeze or player[2].superfreeze) then --check for superfreeze
		count.total_superfreeze = count.total_superfreeze + 1
	end
	if player[1].hitfreeze or player[2].hitfreeze then --check for hitfreeze
		count.hitfreeze = count.hitfreeze + 1
	end
	if player[1].hitfreeze then
		count.non_projectile = "" --only a non-projectile would freeze p1 (remove the "*")
	end
	count.total = count.total + 1

	if count.active then --display count if counting
		emu.message(count.total .. " (" .. count.total_superfreeze .. ")" .. " [" .. count.hitfreeze .. "]")
	end
end


savestate.registerload(function() --prevent strange behavior after loading
	initialize()
end)


emu.registerstart( function()
	game = nil
	emu.registerbefore(function() end)
	emu.registerafter(function() end)
	super_mode = false
	initialize()
	print()
	for n, module in ipairs(profile) do
		for m, shortname in ipairs(module.games) do
			if emu.romname() == shortname or emu.parentname() == shortname then
				game = module
				print("tracking " .. shortname .. " frame data")
				if fba and (emu.sourcename() == "CPS1" or emu.sourcename() == "CPS2") then
					print("Warning: FBA gives inaccurate results for CPS1/CPS2.")
				end
				if game.supering then
					print("Lua hotkey 2: toggle normal/super-only mode")
				end
				if game.no_frameskip then
					print("* disabling frameskip")
				end
				if game.address.projectile_slowdown then
					print("* disabling projectile slowdown")
				end
				print()
				print_header()
				game.update.func(function()
					register_count = register_count + 1
					if register_count == game.update.cycle then
						update_frame_data()
					end
					if last_frame < emu.framecount() then
						register_count = 0
					end
					last_frame = emu.framecount()
				end)
				return
			end
		end
	end
	print("not prepared for " .. emu.romname() .. " frame data")
end)
