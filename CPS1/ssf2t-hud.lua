----------------------------------------------------------------------------------------------------
-- Global Variables
----------------------------------------------------------------------------------------------------

p2=0x000400
stage_timer=false
draw_hud=2
draw_hitboxes = true
p1_projectile = false
p2_projectile = false
frameskip = true
----------------------------------------------------------------------------------------------------
--Miscellaneous functions
----------------------------------------------------------------------------------------------------

-- Calculate positional difference between the two dummies
local function calc_range()
	local range = 0
	if memory.readword(0xFF8454) >= memory.readword(0xFF8454+p2) then
		if memory.readword(0xFF8458) >= memory.readword(0xFF8458+p2) then
			range = (memory.readword(0xFF8454) - memory.readword(0xFF8454+p2)) .. "/" .. (memory.readword(0xFF8458) - memory.readword(0xFF8458+p2))
		else
			range = (memory.readword(0xFF8454) - memory.readword(0xFF8454+p2)) .. "/" .. (memory.readword(0xFF8458+p2) - memory.readword(0xFF8458))
		end
	else
		if memory.readword(0xFF8458+p2) >= memory.readword(0xFF8458) then
			range = (memory.readword(0xFF8454+p2) - memory.readword(0xFF8454)) .. "/" .. (memory.readword(0xFF8458+p2) - memory.readword(0xFF8458))
		else
			range = (memory.readword(0xFF8454+p2) - memory.readword(0xFF8454)) .. "/" .. (memory.readword(0xFF8458) - memory.readword(0xFF8458+p2))
		end
	end
	return range
end

--Determines if a projectile is still in game and if one can be exectued
local function projectile_onscreen(player)
	local text
	if player == 0 then
		if memory.readbyte(0xFF8622) > 0 then
			text = "Not Ready"
		else
			text = "Ready"
		end
	else
		if memory.readbyte(0xFF8A22) > 0 then
			text = "Not Ready"
		else
			text = "Ready"
		end
	end
	return text
end

--Determines if a special cancel can be performed after a normal move has been executed
local function check_cancel(player) 
	local text
	if player == 1 then
		if memory.readbyte(0xFF85E3) > 0 then
			text = "Ready"
		else
			text = "Not Ready"
		end
	else
		if memory.readbyte(0xFF85E3+p2) > 0 then
			text = "Ready"
		else
			text = "Not Ready"
		end
	end
	return text
end

--Determine the character being used and draw approriate readings
local function determine_char(player)
	local text
	if player == 1 then
		if memory.readbyte(0xFF87DF) == 0x0A then
			--Balrog
			gui.text(2,65,"Ground Straight: ".. memory.readbyte(0xFF84CE))
			gui.text(2,73,"Ground Upper: " ..memory.readbyte(0xFF84D6))
			gui.text(2,81,"Straight: " .. memory.readbyte(0xFF852B))
			gui.text(80,65,"Upper Dash: " .. memory.readbyte(0xFF8524))
			gui.text(80,73,"Buffalo Headbutt: " .. memory.readbyte(0xFF850E))
			gui.text(80,81,"Crazy Buffalo: " .. memory.readbyte(0xFF8522))
			p1_projectile = false
			return
		elseif memory.readbyte(0xFF87DF) == 0x02 then
			--Blanka
			gui.text(2,65,"Normal Roll: " .. memory.readbyte(0xFF8507))
			gui.text(2,73,"Vertical Roll: " .. memory.readbyte(0xFF84FE))
			gui.text(2,81,"Ground Shave Roll: " .. memory.readbyte(0xFF850F))
			p1_projectile = false
			return
		elseif memory.readbyte(0xFF87DF) == 0x0C then
			--Cammy
			gui.text(2,65,"Spin Knuckle: " .. memory.readbyte(0xFF84F0))
			gui.text(2,73,"Cannon Spike: " .. memory.readbyte(0xFF84E0))
			gui.text(2,81,"Spiral Arrow: ".. memory.readbyte(0xFF84E4))
			gui.text(80,65,"Hooligan Combination: " .. memory.readbyte(0xFF84F7))
			gui.text(80,73,"Spin Drive Smasher: " .. memory.readbyte(0xFF84F4))
			p1_projectile = false
			return
		elseif memory.readbyte(0xFF87DF) == 0x05 then
			--Chun Li
			gui.text(2,65,"Kikouken: ".. memory.readbyte(0xFF84CE))
			gui.text(2,73,"Up Kicks: " .. memory.readbyte(0xFF8508))
			gui.text(2,81,"Spinning Bird Kick: " .. memory.readbyte(0xFF84FE))
			gui.text(80,65,"Senretsu Kyaku: " .. memory.readbyte(0xFF850D))
			p1_projectile = true
			return
		elseif memory.readbyte(0xFF87DF) == 0x0F then
			--Dee Jay
			gui.text(2,65,"Air Slasher: " .. memory.readbyte(0xFF84E0))
			gui.text(2,73,"Sovat Kick: " .. memory.readbyte(0xFF84F4))
			gui.text(2,81,"Jack Knife: ".. memory.readbyte(0xFF84E4))
			gui.text(80,65,"Machine Gun Upper: " .. memory.readbyte(0xFF84F9))
			gui.text(80,73,"Sovat Carnival: " .. memory.readbyte(0xFF84FD))
			p1_projectile = true
			return
		elseif memory.readbyte(0xFF87DF) == 0x07 then  
			--Dhalsim
			gui.text(2,65,"Yoga Blast: " .. memory.readbyte(0xFF84D2))
			gui.text(2,73,"Yoga Flame: " .. memory.readbyte(0xFF84E8))
			gui.text(2,81,"Yoga Fire: " .. memory.readbyte(0xFF84CE))
			gui.text(80,65,"Yoga Teleport: ".. memory.readbyte(0xFF84D6))
			gui.text(80,73,"Yoga Inferno: " .. memory.readbyte(0xFF84E4))	
			p1_projectile = true
			return
		elseif memory.readbyte(0xFF87DF) == 0x01 then
			--Honda
			gui.text(2,65,"Flying Headbutt: " .. memory.readbyte(0xFF84D6))
			gui.text(2,73,"Butt Drop: " .. memory.readbyte(0xFF84DE))
			gui.text(2,81,"Oichio Throw: " .. memory.readbyte(0xFF84E4))
			gui.text(80,65, "Double Headbutt" .. memory.readbyte(0xFF84E2))
			p1_projectile = false
			return
		elseif memory.readbyte(0xFF87DF) == 0x0E then
			--Fei Long
			gui.text(2,65,"Rekka: " .. memory.readbyte(0xFF84DE))
			gui.text(2,73,"Rekka 2: " .. memory.readbyte(0xFF84EE))
			gui.text(2,81,"Flame Kick: " .. memory.readbyte(0xFF84E2))
			gui.text(80,65,"Chicken Wing: " .. memory.readbyte(0xFF8502))
			gui.text(80,73,"Rekka Sinken: " .. memory.readbyte(0xFF84FE))
			p1_projectile = false
			return
		elseif memory.readbyte(0xFF87DF) == 0x03 then 
			--Guile
			gui.text(2,65,"Sonic Boom: " .. memory.readbyte(0xFF84CE))
			gui.text(2,73,"Flash Kick: " .. memory.readbyte(0xFF84D4))
			gui.text(2,81,"Double Somersault: " .. memory.readbyte(0xFF84E2))
			p1_projectile = true
			return
		elseif memory.readbyte(0xFF87DF) == 0x04 then 
			--Ken
			gui.text(2,65, "Hadouken: ".. memory.readbyte(0xFF84E2))
			gui.text(2,73, "Shoryuken: " .. memory.readbyte(0xFF84E6))
			gui.text(2,81, "Hurricane Kick: " .. memory.readbyte(0xFF84DE))
			gui.text(42,89, "Shoryureppa: " .. memory.readbyte(0xFF84EE))
			gui.text(80,65, "Crazy Kick 1: " .. memory.readbyte(0xFF8534))
			gui.text(80,73, "Crazy Kick 2: " .. memory.readbyte(0xFF8536))
			gui.text(80,81, "Crazy Kick 3: " .. memory.readbyte(0xFF8538))
			p1_projectile = true
			return
		elseif memory.readbyte(0xFF87DF) == 0x08 then 
			--Dictator
			gui.text(2,65,"Scissor Kick: " .. memory.readbyte(0xFF84D6))
			gui.text(2,73,"Head Stomp: ".. memory.readbyte(0xFF84DF))
			gui.text(2,81,"Devil's Reverse: " .. memory.readbyte(0xFF84FA))
			gui.text(80,65,"Psycho Crusher: " .. memory.readbyte(0xFF84CE))
			gui.text(80,73,"Knee Press Knightmare: " .. memory.readbyte(0xFF8513))
			p1_projectile = false
			return
		elseif memory.readbyte(0xFF87DF) == 0x00 then 
			--Ryu
			gui.text(2,65,"Hadouken: " .. memory.readbyte(0xFF84E2))
			gui.text(2,73,"Shoryuken: " .. memory.readbyte(0xFF84E6))
			gui.text(2,81, "Hurricane Kick: " .. memory.readbyte(0xFF84DE))
			gui.text(80,65, "Red Hadouken: " .. memory.readbyte(0xFF852E))
			gui.text(80,73, "Shinku Hadouken: " .. memory.readbyte(0xFF84EE))
			p1_projectile = true
		elseif memory.readbyte(0xFF87DF) == 0x09 then 
			--Sagat
			gui.text(2,65,"Tiger Shot: " .. memory.readbyte(0xFF84DA))
			gui.text(2,73,"Tiger Knee: " .. memory.readbyte(0xFF84D2))
			gui.text(2,81,"Tiger Uppercut: " .. memory.readbyte(0xFF84CE))
			gui.text(80,65, "Tiger Genocide: " .. memory.readbyte(0xFF84EC))
			p1_projectile = true
			return
		elseif memory.readbyte(0xFF87DF) == 0x0D then  
			--T.Hawk
			gui.text(2,65,"Mexican Typhoon: " .. memory.readbyte(0xFF84E0) .. ", " .. memory.readbyte(0xFF84E1))
			gui.text(2,73,"Tomahawk: " .. memory.readbyte(0xFF84DB))
			gui.text(2,81,"Double Typhoon: " .. memory.readbyte(0xFF84E0) .. ", " .. memory.readbyte(0xFF84ED))
			p1_projectile = false
			return
		elseif memory.readbyte(0xFF87DF) == 0x0B then 
			--Claw
			gui.text(2,65,"Wall Dive (Kick): " .. memory.readbyte(0xFF84DA))
			gui.text(2,73,"Wall Dive (Punch): " .. memory.readbyte(0xFF84DE))
			gui.text(2,81,"Crystal Flash: " .. memory.readbyte(0xFF84D6))
			gui.text(90,65,"Flip Kick: " .. memory.readbyte(0xFF84EB))
			gui.text(90,73,"Rolling Izuna Drop: " .. memory.readbyte(0xFF84E7))
			p1_projectile = false
			return
		elseif memory.readbyte(0xFF87DF) == 0x06 then 
			--Zangief
			gui.text(2,65, "Bear Grab: " .. memory.readbyte(0xFF84E9) ..  ", " .. memory.readbyte(0xFF84EA))
			gui.text(2,73, "Spinning Pile Driver: " .. memory.readbyte(0xFF84CE) .. ", " .. memory.readbyte(0xFF84CF))
			gui.text(2,81, "Banishing Flat: " .. memory.readbyte(0xFF8501))
			gui.text(2,89, "Final Atomic Buster: " .. memory.readbyte(0xFF84FA) .. ", " .. memory.readbyte(0xFF84FB))
			p1_projectile = false
			return
		end
	else
		if memory.readbyte(0xFF8BDF) == 0x0A then
			--Balrog
			gui.text(230,65,"Ground Straight: " .. memory.readbyte(0xFF84CE+p2))
			gui.text(230,73,"Ground Upper: " ..memory.readbyte(0xFF84D6+p2))
			gui.text(230,81,"Straight: " .. memory.readbyte(0xFF852B+p2))
			gui.text(307,65,"Upper Dash: " .. memory.readbyte(0xFF8524+p2))
			gui.text(307,73,"Buffalo Headbutt: " .. memory.readbyte(0xFF850E+p2))
			gui.text(307,81,"Crazy Buffalo: " .. memory.readbyte(0xFF8522+p2))
			p2_projectile = false
			return
		elseif memory.readbyte(0xFF8BDF) == 0x02 then
			--Blanka
			gui.text(302,65,"Normal Roll: " .. memory.readbyte(0xFF8507+p2))
			gui.text(302,73,"Vertical Roll: " .. memory.readbyte(0xFF84FE+p2))
			gui.text(302,81,"Ground Shave Roll: " .. memory.readbyte(0xFF850F+p2))
			p2_projectile = false
			return
		elseif memory.readbyte(0xFF8BDF) == 0x0C then
			--Cammy
			gui.text(218,65,"Spin Knuckle: " .. memory.readbyte(0xFF84F0+p2))
			gui.text(218,73,"Cannon Spike: " .. memory.readbyte(0xFF84E0+p2))
			gui.text(218,81,"Spiral Arrow: " .. memory.readbyte(0xFF84E4+p2))
			gui.text(290,65,"Hooligan Combination: " .. memory.readbyte(0xFF84F7+p2))
			gui.text(290,73,"Spin Drive Smasher: " .. memory.readbyte(0xFF84F4+p2))
			p2_projectile = false
			return
		elseif memory.readbyte(0xFF8BDF) == 0x05 then
			--Chun Li
			gui.text(233,65,"Kikouken: " .. memory.readbyte(0xFF84CE+p2))
			gui.text(233,73,"Up Kicks: " .. memory.readbyte(0xFF8508+p2))
			gui.text(233,81,"Spinning Bird Kick: " .. memory.readbyte(0xFF84FE+p2))
			gui.text(313,65,"Senretsu Kyaku: " .. memory.readbyte(0xFF850D+p2))
			p2_projectile = true
			return
		elseif memory.readbyte(0xFF8BDF) == 0x0F then
			--Dee Jay
			gui.text(223,65,"Air Slasher: " .. memory.readbyte(0xFF84E0+p2))
			gui.text(223,73,"Sovat Kick: " .. memory.readbyte(0xFF84F4+p2))
			gui.text(223,81,"Jack Knife: " .. memory.readbyte(0xFF84E4+p2))
			gui.text(303,65,"Machine Gun Upper: " .. memory.readbyte(0xFF84F9+p2))
			gui.text(303,73,"Sovat Carnival: " .. memory.readbyte(0xFF84FD+p2))
			p2_projectile = true
			return
		elseif memory.readbyte(0xFF8BDF) == 0x07 then  
			--Dhalsim
			gui.text(223,65,"Yoga Blast: " .. memory.readbyte(0xFF84D2+p2))
			gui.text(223,73,"Yoga Flame: " .. memory.readbyte(0xFF84E8+p2))
			gui.text(223,81,"Yoga Fire: " .. memory.readbyte(0xFF84CE+p2))
			gui.text(303,65,"Yoga Teleport: ".. memory.readbyte(0xFF84D6+p2))
			gui.text(303,73,"Yoga Inferno: " .. memory.readbyte(0xFF84E4+p2))
			p2_projectile = true
			return
		elseif memory.readbyte(0xFF8BDF) == 0x01 then
			--Honda
			gui.text(223,65,"Flying Headbutt: " .. memory.readbyte(0xFF84D6+p2))
			gui.text(223,73,"Butt Drop: " .. memory.readbyte(0xFF84DE+p2))
			gui.text(223,81,"Oichio Throw: " .. memory.readbyte(0xFF84E4+p2))
			gui.text(303,65, "Double Headbutt: " .. memory.readbyte(0xFF84E2+p2))
			p2_projectile = false
			return
		elseif memory.readbyte(0xFF8BDF) == 0x0E then
			--Fei Long
			gui.text(242,65,"Rekka: " .. memory.readbyte(0xFF84DE+p2))
			gui.text(242,73,"Rekka 2: "	.. memory.readbyte(0xFF84EE+p2))
			gui.text(242,81,"Flame Kick: " .. memory.readbyte(0xFF84E2+p2))
			gui.text(322,65, "Chicken Wing: " .. memory.readbyte(0xFF8502+p2))
			gui.text(322,73, "Rekka Sinken: " .. memory.readbyte(0xFF84FE+p2))
			p2_projectile = false
			return
		elseif memory.readbyte(0xFF8BDF) == 0x03 then 
			--Guile
			gui.text(302,65,"Sonic Boom: " .. memory.readbyte(0xFF84CE+p2))
			gui.text(302,73,"Flash Kick: " .. memory.readbyte(0xFF84D4+p2))
			gui.text(302,81,"Double Somersault: " .. memory.readbyte(0xFF84E2+p2))
			p2_projectile = true
			return
		elseif memory.readbyte(0xFF8BDF) == 0x04 then 
			--Ken
			gui.text(223,65, "Hadouken: " .. memory.readbyte(0xFF84E2+p2))
			gui.text(223,73, "Shoryuken: " .. memory.readbyte(0xFF84E6+p2))
			gui.text(223,81, "Hurricane Kick: " .. memory.readbyte(0xFF84DE+p2))
			gui.text(322,65, "Crazy Kick 1: " .. memory.readbyte(0xFF8534+p2))
			gui.text(322,73, "Crazy Kick 2: " .. memory.readbyte(0xFF8536+p2))
			gui.text(322,81, "Crazy Kick 3: " .. memory.readbyte(0xFF8538+p2))
			gui.text(272,89, "Shoryureppa: " .. memory.readbyte(0xFF84EE+p2))
			p2_projectile = true
			return
		elseif memory.readbyte(0xFF8BDF) == 0x08 then 
			--Dictator
			gui.text(217,65,"Scissor Kick: " .. memory.readbyte(0xFF84D6+p2))
			gui.text(217,73,"Headstomp: " .. memory.readbyte(0xFF84DF+p2))
			gui.text(217,81,"Devil's Reverse: " .. memory.readbyte(0xFF84FA+p2))
			gui.text(290,65,"Psycho Crusher: " .. memory.readbyte(0xFF84CE+p2))
			gui.text(290,73,"Knee Press Nightmare: " .. memory.readbyte(0xFF8513+p2))
			p2_projectile = false
			return
		elseif memory.readbyte(0xFF8BDF) == 0x00 then 
			--Ryu
			gui.text(210,65,"Hadouken: " .. memory.readbyte(0xFF84E2+p2))
			gui.text(210,73,"Shoryuken: " .. memory.readbyte(0xFF84E6+p2))
			gui.text(210,81, "Hurricane Kick: " .. memory.readbyte(0xFF84DE+p2))
			gui.text(310,65, "Red Hadouken: " .. memory.readbyte(0xFF852E+p2))
			gui.text(310,73, "Shinku Hadouken: " .. memory.readbyte(0xFF84EE+p2))
			p2_projectile = true
			return
		elseif memory.readbyte(0xFF8BDF) == 0x09 then 
			--Sagat
			gui.text(214,65,"Tiger Shot: " .. memory.readbyte(0xFF84DA+p2))
			gui.text(214,73,"Tiger Knee: " .. memory.readbyte(0xFF84D2+p2))
			gui.text(214,81,"Tiger Uppercut: " .. memory.readbyte(0xFF84CE+p2))
			gui.text(314,65, "Tiger Genocide: " .. memory.readbyte(0xFF84EC+p2))
			p2_projectile = true
			return
		elseif memory.readbyte(0xFF8BDF) == 0x0D then 
			--T.Hawk
			gui.text(294,65,"Mexican Typhoon: " .. memory.readbyte(0xFF84E0+p2) .. ", " .. memory.readbyte(0xFF84E1+p2))
			gui.text(294,73,"Tomahawk: " .. memory.readbyte(0xFF84DB+p2))
			gui.text(294,81,"Double Typhoon: " .. memory.readbyte(0xFF84E0+p2) .. ", " .. memory.readbyte(0xFF84ED+p2))
			p2_projectile = false
			return
		elseif memory.readbyte(0xFF8BDF) == 0x0B then 
			--Claw
			gui.text(210,65,"Wall Dive (Kick): " .. memory.readbyte(0xFF84DA+p2))
			gui.text(210,73,"Wall Dive (Punch): " .. memory.readbyte(0xFF84DE+p2))
			gui.text(210,81,"Crystal Flash: " .. memory.readbyte(0xFF84D6+p2))
			gui.text(298,65,"Flip Kick: " .. memory.readbyte(0xFF84EB+p2))
			gui.text(298,73,"Rolling Izuna Drop: " .. memory.readbyte(0xFF84E7+p2))
			p2_projectile = false
			return
		elseif memory.readbyte(0xFF8BDF) == 0x06 then 
			--Zangief
			gui.text(275,65, "Bear Grab: " .. memory.readbyte(0xFF84E9+p2) ..  ", " .. memory.readbyte(0xFF84EA+p2))
			gui.text(275,73, "Spinning Pile Driver: " .. memory.readbyte(0xFF84CE+p2) .. ", " .. memory.readbyte(0xFF84CF+p2))
			gui.text(275,81, "Banishing Flat: " .. memory.readbyte(0xFF8501+p2))
			gui.text(275,89, "Final Atomic Buster: " .. memory.readbyte(0xFF84FA+p2) .. ", " .. memory.readbyte(0xFF84FB+p2))
			p2_projectile = false
			return
		end
	end
end

----------------------------------------------------------------------------------------------------
-- Hitboxes
-- Original Authors for this Script: Dammit, MZ, Felineki
-- Homepage: http://code.google.com/p/mame-rr/
----------------------------------------------------------------------------------------------------

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

local AXIS_COLOR           = 0xFFFFFFFF
local BLANK_COLOR          = 0xFFFFFFFF
local AXIS_SIZE            = 12
local MINI_AXIS_SIZE       = 2
local BLANK_SCREEN         = false
local DRAW_AXIS            = true
local DRAW_MINI_AXIS       = false
local DRAW_PUSHBOXES       = true
local DRAW_THROWABLE_BOXES = true
local DRAW_DELAY           = 1
local NUMBER_OF_PLAYERS    = 2
local MAX_GAME_PROJECTILES = 8
local MAX_BONUS_OBJECTS    = 16

local profile = {
	{
		games = {"ssf2t"},
		status_type = "normal",
		address = {
			player           = 0xFF844E,
			projectile       = 0xFF97A2,
			left_screen_edge = 0xFF8ED4,
			stage            = 0xFFE18B,
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
		throw_box_list = {
			{param_offset = 0x6C, type = "throwable"},
			{param_offset = 0x64, type = "throw"},
		}
	},
}

for _,game in ipairs(profile) do
	game.box_number = #game.box_list + #game.throw_box_list
end

for _,box in pairs(boxes) do
	box.fill    = box.color * 0x100 + box.fill
	box.outline = box.color * 0x100 + box.outline
end

local game, effective_delay

local globals = {
	game_phase       = 0,
	left_screen_edge = 0,
	top_screen_edge  = 0,
}
local player       = {}
local projectiles  = {}
local frame_buffer = {}
if fba then
	DRAW_DELAY = DRAW_DELAY + 1
end


--------------------------------------------------------------------------------
-- prepare the hitboxes

local function adjust_delay(address)
	if not address or not mame then
		return DRAW_DELAY
	end
	local stage = memory.readbyte(address)
	for _, val in ipairs({
		0xA, --Boxer
		0xC, --Cammy
		0xD, --T.Hawk
		0xF, --Dee Jay
	}) do
		if stage == val then
			return DRAW_DELAY + 1 --these stages have an extra frame of lag
		end
	end
	return DRAW_DELAY
end


local get_status = {
	["normal"] = function()
		if bit.band(memory.readword(0xFF8008), 0x08) > 0 then
			return true
		end
	end,

	["hsf2"] = function()
		if memory.readword(0xFF8004) == 0x08 then
			return true
		end
	end,
}

local function update_globals()
	globals.left_screen_edge = memory.readword(game.address.left_screen_edge)
	globals.top_screen_edge  = memory.readword(game.address.left_screen_edge + 0x4)
	globals.game_playing     = get_status[game.status_type]()
end


local function get_x(x)
	return x - globals.left_screen_edge
end


local function get_y(y)
	return emu.screenheight() - (y - 15) + globals.top_screen_edge
end


local get_box_parameters = {
	[1] = function(box)
		box.hval   = memory.readbytesigned(box.address + 0)
		box.hval2  = memory.readbyte(box.address + 5)
		if box.hval2 >= 0x80 and box.type == "attack" then
			box.hval = -box.hval2
		end
		box.vval   = memory.readbytesigned(box.address + 1)
		box.hrad   = memory.readbyte(box.address + 2)
		box.vrad   = memory.readbyte(box.address + 3)
	end,

	[2] = function(box)
		box.hval   = memory.readwordsigned(box.address + 0)
		box.vval   = memory.readwordsigned(box.address + 2)
		box.hrad   = memory.readword(box.address + 4)
		box.vrad   = memory.readword(box.address + 6)
	end,
}


local process_box_type = {
	["vulnerability"] = function(obj, box)
	end,

	["attack"] = function(obj, box)
		if obj.projectile then
			box.type = "proj. attack"
		elseif memory.readbyte(obj.base + 0x03) == 0 then
			return false
		end
	end,

	["push"] = function(obj, box)
		if obj.projectile then
			box.type = "proj. vulnerability"
		elseif not DRAW_PUSHBOXES then
			return false
		end
	end,

	["weak"] = function(obj, box)
		if (game.char_mode and memory.readbyte(obj.base + game.char_mode) ~= 0x4)
			or memory.readbyte(obj.animation_ptr + 0x15) ~= 2 then
			return false
		end
	end,

	["throw"] = function(obj, box)
		get_box_parameters[2](box)
		if box.hval == 0 and box.vval == 0 and box.hrad == 0 and box.vrad == 0 then
			return false
		end

		for offset = 0,6,2 do
			memory.writeword(box.address + offset, 0) --bad
		end

		box.hval   = obj.pos_x + box.hval * (obj.facing_dir == 1 and -1 or 1)
		box.vval   = obj.pos_y - box.vval
		box.left   = box.hval - box.hrad
		box.right  = box.hval + box.hrad
		box.top    = box.vval - box.vrad
		box.bottom = box.vval + box.vrad
	end,

	["throwable"] = function(obj, box)
		if not DRAW_THROWABLE_BOXES or
			(memory.readbyte(obj.animation_ptr + 0x8) == 0 and
			memory.readbyte(obj.animation_ptr + 0x9) == 0 and
			memory.readbyte(obj.animation_ptr + 0xA) == 0) or
			memory.readbyte(obj.base + 0x3) == 0x0E or
			memory.readbyte(obj.base + 0x3) == 0x14 or
			memory.readbyte(obj.base + 0x143) > 0 or
			memory.readbyte(obj.base + 0x1BF) > 0 or
			memory.readbyte(obj.base + 0x1A1) > 0 then
			return false
		elseif memory.readbyte(obj.base + 0x181) > 0 then
			box.type = "air throwable"
		end

		box.hrad = memory.readword(box.address + 0)
		box.vrad = memory.readword(box.address + 2)
		box.hval = obj.pos_x
		box.vval = obj.pos_y - box.vrad/2
		box.left   = box.hval - box.hrad
		box.right  = box.hval + box.hrad
		box.top    = obj.pos_y - box.vrad
		box.bottom = obj.pos_y
	end,
}


local function define_box(obj, entry)
	local box = {
		type = game.box_list[entry].type,
		id = memory.readbyte(obj.animation_ptr + game.box_list[entry].id_ptr),
	}

	if box.id == 0 or process_box_type[box.type](obj, box) == false then
		return nil
	end

	local addr_table = obj.hitbox_ptr + memory.readwordsigned(obj.hitbox_ptr + game.box_list[entry].addr_table)
	box.address = addr_table + box.id * game.box_list[entry].id_space
	get_box_parameters[game.box_parameter_size](box)

	box.hval   = obj.pos_x + box.hval * (obj.facing_dir == 1 and -1 or 1)
	box.vval   = obj.pos_y - box.vval
	box.left   = box.hval - box.hrad
	box.right  = box.hval + box.hrad
	box.top    = box.vval - box.vrad
	box.bottom = box.vval + box.vrad

	return box
end


local function define_throw_box(obj, entry)
	local box = {
		type = game.throw_box_list[entry].type,
		address = obj.base + game.throw_box_list[entry].param_offset,
	}

	if process_box_type[box.type](obj, box) == false then
		return nil
	end

	return box
end


local function update_game_object(obj)
	obj.facing_dir    = memory.readbyte(obj.base + 0x12)
	obj.pos_x         = get_x(memory.readwordsigned(obj.base + 0x06))
	obj.pos_y         = get_y(memory.readwordsigned(obj.base + 0x0A))
	obj.animation_ptr = memory.readdword(obj.base + 0x1A)
	obj.hitbox_ptr    = memory.readdword(obj.base + 0x34)

	for entry in ipairs(game.box_list) do
		table.insert(obj, define_box(obj, entry))
	end
end


local function read_projectiles()
	local current_projectiles = {}

	for i = 1, MAX_GAME_PROJECTILES do
		local obj = {base = game.address.projectile + (i-1) * 0xC0}
		if memory.readword(obj.base) == 0x0101 then
			obj.projectile = true
			update_game_object(obj)
			table.insert(current_projectiles, obj)
		end
	end

	for i = 1, MAX_BONUS_OBJECTS do
		local obj = {base = game.address.projectile + (MAX_GAME_PROJECTILES + i-1) * 0xC0}
		if bit.band(0xff00, memory.readword(obj.base)) == 0x0100 then
			update_game_object(obj)
			table.insert(current_projectiles, obj)
		end
	end

	return current_projectiles
end


local function update_sf2_hitboxes()
	if not game then
		return
	end
	effective_delay = adjust_delay(game.address.stage)
	update_globals()

	for f = 1, effective_delay do
		frame_buffer[f].status = frame_buffer[f+1].status
		for p = 1, NUMBER_OF_PLAYERS do
			frame_buffer[f][player][p] = copytable(frame_buffer[f+1][player][p])
		end
		frame_buffer[f][projectiles] = copytable(frame_buffer[f+1][projectiles])
	end

	frame_buffer[effective_delay+1].status = globals.game_playing
	for p = 1, NUMBER_OF_PLAYERS do
		player[p] = {base = game.address.player + (p-1) * game.player_space}
		if memory.readword(player[p].base) > 0x0100 then
			update_game_object(player[p])
		end
		frame_buffer[effective_delay+1][player][p] = player[p]

		local prev_frame = frame_buffer[effective_delay][player][p]
		if prev_frame and prev_frame.pos_x then
			for entry in ipairs(game.throw_box_list) do
				table.insert(prev_frame, define_throw_box(prev_frame, entry))
			end
		end

	end
	frame_buffer[effective_delay+1][projectiles] = read_projectiles()
end


--------------------------------------------------------------------------------
-- draw the hitboxes

local function draw_hitbox(obj, entry)
	local hb = obj[entry]

	if DRAW_MINI_AXIS then
		gui.drawline(hb.hval, hb.vval-MINI_AXIS_SIZE, hb.hval, hb.vval+MINI_AXIS_SIZE, boxes[hb.type].outline)
		gui.drawline(hb.hval-MINI_AXIS_SIZE, hb.vval, hb.hval+MINI_AXIS_SIZE, hb.vval, boxes[hb.type].outline)
	end

	gui.box(hb.left, hb.top, hb.right, hb.bottom, boxes[hb.type].fill, boxes[hb.type].outline)
end


local function draw_axis(obj)
	if not obj or not obj.pos_x then
		return
	end
	
	gui.drawline(obj.pos_x, obj.pos_y-AXIS_SIZE, obj.pos_x, obj.pos_y+AXIS_SIZE, AXIS_COLOR)
	gui.drawline(obj.pos_x-AXIS_SIZE, obj.pos_y, obj.pos_x+AXIS_SIZE, obj.pos_y, AXIS_COLOR)
end


local function render_sf2_hitboxes()
	gui.clearuncommitted()
	if not game or not frame_buffer[1].status or not draw_hitboxes then
		return
	end

	if BLANK_SCREEN then
		gui.box(0, 0, emu.screenwidth(), emu.screenheight(), BLANK_COLOR)
	end

	for entry = 1, game.box_number do
		for i in ipairs(frame_buffer[1][projectiles]) do
			local obj = frame_buffer[1][projectiles][i]
			if obj[entry] then
				draw_hitbox(obj, entry)
			end
		end

		for p = 1, NUMBER_OF_PLAYERS do
			local obj = frame_buffer[1][player][p]
			if obj and obj[entry] then
				draw_hitbox(obj, entry)
			end
		end
	end

	if DRAW_AXIS then
		for p = 1, NUMBER_OF_PLAYERS do
			draw_axis(frame_buffer[1][player][p])
		end
		for i in ipairs(frame_buffer[1][projectiles]) do
			draw_axis(frame_buffer[1][projectiles][i])
		end
	end
end

--------------------------------------------------------------------------------
-- initialize on game startup

local function whatgame()
	game = nil
	for n, module in ipairs(profile) do
		for m, shortname in ipairs(module.games) do
			if emu.romname() == shortname or emu.parentname() == shortname then
				print("drawing " .. shortname .. " hitboxes")
				game = module
				for p = 1, NUMBER_OF_PLAYERS do
					player[p] = {}
				end
				for f = 1, DRAW_DELAY + 2 do
					frame_buffer[f] = {}
					frame_buffer[f][player] = {}
					frame_buffer[f][projectiles] = {}
				end
				return
			end
		end
	end
	print("not prepared for " .. emu.romname() .. " hitboxes")
end


emu.registerstart( function()
	whatgame()
end)

----------------------------------------------------------------------------------------------------
--End Hit box script by: Dammit, MZ, Felineki
--Homepage: http://code.google.com/p/mame-rr/
----------------------------------------------------------------------------------------------------


local function fskip()
	if frameskip == true	then
		memory.writebyte(0xFF8CD3,0x70)
	else
		memory.writebyte(0xFF8CD3,0xFF)
	end
end

----------------------------------------------------------------------------------------------------
--Dizzy meters
----------------------------------------------------------------------------------------------------

--Determine the color of the bar based on the value (higher = darker)
local function diz_col(val,type)
	local color = 0x00000000
	
	if type == 0 then
		if val <= 5.66 then
			color = 0x00FF5DA0
			return color
		elseif val > 5.66 and val <= 11.22 then
			color = 0x54FF00A0
			return color
		elseif val > 11.22 and val <= 16.88 then
			color = 0xAEFF00A0
			return color
		elseif val > 16.88 and val <= 22.44 then
			color = 0xFAFF00A0
			return color
		elseif val > 22.4 and val <= 28.04 then
			color = 0xFF5400A0
			return color
		elseif val > 28.04 then
			color = 0xFF0026A0
			return color
		end
	else
		if val <= 10922.5 then
			color = 0x00FF5DA0
			return color
		elseif val > 10922.5 and val <= 21845 then
			color = 0x54FF00A0
			return color
		elseif val > 21845 and val <= 32767.5 then
			color = 0xAEFF00A0
			return color
		elseif val > 32767.5 and val <= 43690 then
			color = 0xFAFF00A0
			return color
		elseif val > 43690 and val <= 54612.5 then
			color = 0xFF5400A0
			return color
		elseif val > 54612.5 then
			color = 0xFF0026A0
			return color
		end
	end
end

local function draw_dizzy()

	local p1_s = memory.readbyte(0xFF84AD)
	local p1_c = memory.readword(0xFF84AB)
	local p1_d = memory.readword(0xFF84AE)
	local p1_f = memory.readword(0xFF863E)
	
	local p2_s = memory.readbyte(0xFF88AD)
	local p2_c = memory.readword(0xFF88AB)
	local p2_d = memory.readword(0xFF88AE)
	local p2_f = memory.readbyte(0xFF8A3E)
	
	-- P1 Stun meter
	if p1_s > 0 then
		if p1_s <= 10 then
			gui.box(35,45,(35+(3.38 * p1_s)),49,diz_col(p1_s,0),0x000000FF)
		elseif p1_s > 10 and p1_s <= 20 then
			gui.box(35,45,(35+(3.38 * p1_s)),49,diz_col(p1_s,0),0x000000FF)
		elseif p1_s > 20 then
			gui.box(35,45,(35+(3.38 * p1_s)),49,diz_col(p1_s,0),0x000000FF)
		end
	end
	
	-- P1 Stun counter
	if p1_c > 0 then
		if p1_c <= 70 then
			gui.box(35,49,(35+(0.001754 * p1_c)),53,diz_col(p1_c,1),0x000000FF)
		elseif p1_c > 70 and p1_c <= 150 then
			gui.box(35,49,(35+(0.001754* p1_c)),53,diz_col(p1_c,1),0x000000FF)
		elseif p1_c > 150 then
			gui.box(35,49,(35+(0.001754 * p1_c)),53,diz_col(p1_c,1),0x000000FF)
		end
	end
	
	-- P2 Stun meter
	if p2_s > 0 then
		if p2_s <= 10 then
			gui.box(233,45,(233+(3.38 * p2_s)),49,diz_col(p2_s,0),0x000000FF)
		elseif p2_s > 10 and p2_s <= 20 then
			gui.box(233,45,(233+(3.38 * p2_s)),49,diz_col(p2_s,0),0x000000FF)
		elseif p2_s > 20 then
			gui.box(233,45,(233+(3.38 * p2_s)),49,diz_col(p2_s,0),0x000000FF)
		end
	end
	
	-- P2 Stun counter
	if p2_c > 0 then
		if p2_c <= 70 then
			gui.box(233,49,(233+(0.001754 * p2_c)),53,diz_col(p2_c,1),0x000000FF)
		elseif p2_c > 70 and p2_c <= 150 then
			gui.box(233,49,(233+(0.001754 * p2_c)),53,diz_col(p2_c,1),0x000000FF)
		elseif p2_c > 150 then
			gui.box(233,49,(233+(0.001754 * p2_c)),53,diz_col(p2_c,1),0x000000FF)
		end
	end
	
	if p1_f > 0 then
		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(3,190,11,(190 - (0.428 * p1_d)),0xFF0000B0,0x00000000)
		gui.text(3,192,p1_d)
	end
	

	if p2_f > 0 then
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(370,190,378,(190 - (0.428 * p2_d)),0xFF0000B0,0x00000000)
		gui.text(365,192,p2_d)
	end
	
end

----------------------------------------------------------------------------------------------------
--Grab meters
----------------------------------------------------------------------------------------------------

local function draw_grab(player,p1_char,p2_char,p_gc)

local p_a = 0
local p1_hg = memory.readbyte(0xFF84CD)
local p2_hg = memory.readbyte(0xFF88CD)

	if player == 0 then
	
		-- Draw the grab speed meter
		
		if p1_hg == 0x15 then
			gui.box(16,190,22,180,0xFF0C00C0,0x000000FF)
			gui.text(18,182,"1")
		elseif p1_hg == 0x12 then
			gui.box(16,190,22,170,0xFF0C00C0,0x000000FF)
			gui.text(18,172,"2")
		elseif p1_hg == 0x0F then
			gui.box(16,190,22,160,0xFF0C00C0,0x000000FF)
			gui.text(18,162,"3")
		elseif p1_hg == 0x0C then
			gui.box(16,190,22,150,0xFF0C00C0,0x000000FF)
			gui.text(18,152,"4")
		elseif p1_hg == 0x09 then
			gui.box(16,190,22,140,0xFF0C00C0,0x000000FF)
			gui.text(18,142,"5")
		elseif p1_hg == 0x06 then
			gui.box(16,190,22,130,0xFF0C00C0,0x000000FF)
			gui.text(18,132,"6")
		elseif p1_hg == 0x03 then
			gui.box(16,190,22,120,0xFF0C00FF,0x000000FF)
			gui.text(18,122,"7")
		end
		
		
		gui.box(16,120,22,190,0x00000040,0x000000FF)
		gui.line(16,130,22,130,0x000000FF,0x000000FF)
		gui.line(16,140,22,140,0x000000FF,0x000000FF)
		gui.line(16,150,22,150,0x000000FF,0x000000FF)
		gui.line(16,160,22,160,0x000000FF,0x000000FF)
		gui.line(16,170,22,170,0x000000FF,0x000000FF)
		gui.line(16,180,22,180,0x000000FF,0x000000FF)


		if p1_char == 0x04 or p1_char == 0x0D then
		--Ken thawk
		p_a = (90 / 120)
		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(3,190,11,190 - (p_a * memory.readbyte(p_gc)),0xFFFF00B0,0x00000000)
		gui.box(370,190,378,190 - ((90 / 63) * memory.readbyte(0xFF88CB)),0xFF0000B0,0x00000000)
		gui.text(363,192,memory.readbyte(0xFF88CB) .. "/" .. "63")
		gui.text(1,192,memory.readbyte(p_gc) .. "/" .. "120")
		elseif p1_char == 0x02 or p1_char == 0x01 then
		--Blanka E.Honda
		p_a = (90 / 130)
		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(3,190,11,190 - (p_a * memory.readbyte(p_gc)),0xFFFF00B0,0x00000000)
		gui.box(370,190,378,190 - ((90 / 63) * memory.readbyte(0xFF88CB)),0xFF0000B0,0x00000000)
		gui.text(363,192,memory.readbyte(0xFF88CB) .. "/" .. "63")
		gui.text(1,192,memory.readbyte(p_gc) .. "/" .. "130")
		elseif p1_char == 0x06 or p1_char == 0x07 then
		--Dhalsim Zangief
		p_a = (90 / 180)
		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(3,190,11,190 - (p_a * memory.readbyte(p_gc)),0xFFFF00B0,0x00000000)
		gui.box(370,190,378,190 - ((90 / 63) * memory.readbyte(0xFF88CB)),0xFF0000B0,0x00000000)
		gui.text(363,192,memory.readbyte(0xFF88CB) .. "/" .. "63")
		gui.text(1,192,memory.readbyte(p_gc) .. "/" .. "180")
		elseif p1_char == 0x0A then
		--Boxer
		p_a = (90 / 210)
		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(3,190,11,190 - (p_a * memory.readbyte(p_gc)),0xFFFF00B0,0x00000000)
		gui.box(370,190,378,190 - ((90 / 63) * memory.readbyte(0xFF88CB)),0xFF0000B0,0x00000000)
		gui.text(363,192,memory.readbyte(0xFF88CB) .. "/" .. "63")
		gui.text(1,192,memory.readbyte(p_gc) .. "/" .. "210")
		end
		
	else
	
		-- Draw grab speed
		
		if p2_hg == 0x15 then
			gui.box(357,190,363,180,0xFF0C00C0,0x000000FF)
			gui.text(359,182,"1")
		elseif p2_hg == 0x12 then
			gui.box(357,190,363,170,0xFF0C00C0,0x000000FF)
			gui.text(359,172,"2")
		elseif p2_hg == 0x0F then
			gui.box(357,190,363,160,0xFF0C00C0,0x000000FF)
			gui.text(359,162,"3")
		elseif p2_hg == 0x0C then
			gui.box(357,190,363,150,0xFF0C00C0,0x000000FF)
			gui.text(359,152,"4")
		elseif p2_hg == 0x09 then
			gui.box(357,190,363,140,0xFF0C00C0,0x000000FF)
			gui.text(359,142,"5")
		elseif p2_hg == 0x06 then
			gui.box(357,190,363,130,0xFF0C00C0,0x000000FF)
			gui.text(359,132,"6")
		elseif p2_hg == 0x03 then
			gui.box(357,190,363,120,0xFF0C00C0,0x000000FF)
			gui.text(359,122,"7")
		end
		
		
		gui.box(357,190,363,120,0x00000040,0x000000FF)
		gui.line(357,130,363,130,0x000000FF,0x000000FF)
		gui.line(357,140,363,140,0x000000FF,0x000000FF)
		gui.line(357,150,363,150,0x000000FF,0x000000FF)
		gui.line(357,160,363,160,0x000000FF,0x000000FF)
		gui.line(357,170,363,170,0x000000FF,0x000000FF)
		gui.line(357,180,363,180,0x000000FF,0x000000FF)
		if p2_char == 0x04 or p2_char == 0x0D then
		--Ken thawk
		p_a = (90 / 120)
		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(370,190,378,190 - (p_a * memory.readbyte(p_gc)),0xFFFF00B0,0x00000000)
		gui.box(3,190,11,190 - ((90 / 63) * memory.readbyte(0xFF84CB)),0xFF0000B0,0x00000000)
		gui.text(1,192,memory.readbyte(0xFF84CB) .. "/" .. "63")
		gui.text(355,192,memory.readbyte(p_gc) .. "/" .. "120")
		elseif p2_char == 0x02 or p2_char == 0x01 then
		--Blanka E.Honda
		p_a = (90 / 130)
		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(370,190,378,190 - (p_a * memory.readbyte(p_gc)),0xFFFF00B0,0x00000000)
		gui.box(3,190,11,190 - ((90 / 63) * memory.readbyte(0xFF84CB)),0xFF0000B0,0x00000000)
		gui.text(1,192,memory.readbyte(0xFF84CB) .. "/" .. "63")
		gui.text(355,192,memory.readbyte(p_gc) .. "/" .. "130")
		elseif p2_char == 0x06 or p2_char == 0x07 then
		--Dhalsim Zangief
		p_a = (90 / 180)
		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(370,190,378,190 - (p_a * memory.readbyte(p_gc)),0xFFFF00B0,0x00000000)
		gui.box(3,190,11,190 - ((90 / 63) * memory.readbyte(0xFF84CB)),0xFF0000B0,0x00000000)
		gui.text(1,192,memory.readbyte(0xFF84CB) .. "/" .. "63")
		gui.text(355,192,memory.readbyte(p_gc) .. "/" .. "180")
		elseif p2_char == 0x0A then
		--Boxer
		p_a = (90 / 210)
		gui.box(3,100,11,190,0x00000040,0x000000FF)
		gui.box(370,100,378,190,0x00000040,0x000000FF)
		gui.box(370,190,378,190 - (p_a * memory.readbyte(p_gc)),0xFFFF00A0,0x00000000)
		gui.box(3,190,11,190 - ((90 / 63) * memory.readbyte(0xFF84CB)),0xFF0000B0,0x00000000)
		gui.text(1,192,memory.readbyte(0xFF84CB) .. "/" .. "63")
		gui.text(355,192,memory.readbyte(p_gc) .. "/" .. "210")
		end
	end

end

local function check_grab()

local p1_c = memory.readbyte(0xFF87DF) -- P1 Character
local p1_gc = 0 -- P1 Grab counter
local p1_gb = memory.readbyte(0xFF84CB) -- P1 Grab Break
local p1_gf = memory.readbyte(0xFF85CE) -- P1 Grab flag
local p1_tf = memory.readbyte(0xFF84B1) -- P1 Throw Flag
 
local p2_c = memory.readbyte(0xFF8BDF) -- P2 Character
local p2_gc = 0 -- P1 Grab counter
local p2_gb = memory.readbyte(0xFF88CB) -- P2 Grab Break
local p2_gf = memory.readbyte(0xFF89CE) -- P2 Throw flag
local p2_tf = memory.readbyte(0xFF88B1) -- P2 Throw Flag

	if p1_c == 0x01 or p1_c == 0x02 or p1_c == 0x04 or p1_c == 0x06 or p1_c == 0x07 or p1_c == 0x0A or p1_c == 0x0D then
		if p1_c == 0x01  or p1_c == 0x02 or p1_c == 0x04 or p1_c == 0x07 or p1_c == 0x0D then -- Blanka, Dhalsim, E.Honda, Ken, T.Hawk
			if p1_c == 0x07 then
				p1_gv = 0x06
			end
			p1_gc = 0xFF846C
		elseif p1_c == 0x06 then -- Gief
			p1_gc = 0xFF84D7
		elseif p1_c == 0x0A then -- Boxer
			p1_gc = 0xFF84E3
		end
		
		if p2_tf == 0xFF then
			if p1_c == 0x04 or p1_c == 0x02 then -- Check ken and Blanka
				if p1_gf == 0x07 then
					draw_grab(0,p1_c,p2_c,p1_gc)
				end
			elseif p1_c == 0x01 then -- Check Honda
				if p1_gf == 0x07 or p1_gf == 0x04 then
					draw_grab(0,p1_c,p2_c,p1_gc)
				end
			elseif p1_c == 0x07 then  -- Check Dhalsim
				if p1_gf == 0x06 then
					draw_grab(0,p1_c,p2_c,p1_gc)
				end
			elseif p1_c == 0x0A then -- Check Balrog
				if p1_gf == 0x06 or p1_gf == 0x05 then
					draw_grab(0,p1_c,p2_c,p1_gc)
				end
			elseif p1_c == 0x0D then -- Check Hawk
				if p1_gf == 0x06 or p1_gf == 0x07 then
					draw_grab(0,p1_c,p2_c,p1_gc)
				end
			elseif p1_c == 0x06 then -- Check Zangief
				if p1_gf == 0x05 or p1_gf == 0x06 or p1_gf == 0x03 then
					draw_grab(0,p1_c,p2_c,p1_gc)
				end
			end
		end
		
	--	if p1_gf == p1_gv and p2_tf == 0xFF then
			
	--		draw_grab(0,p1_c,p2_c,p1_gc)
	--	end
	end
	
	if p2_c == 0x01 or p2_c == 0x02 or p2_c == 0x04 or p2_c == 0x06 or p2_c == 0x07 or p2_c == 0x0A or p2_c == 0x0D then
		if p2_c == 0x01  or p2_c == 0x02 or p2_c == 0x04 or p2_c == 0x07 or p2_c == 0x0D then  -- Blanka, Dhalsim, E.Honda, Ken, T.Hawk
			p2_gc = 0xFF886C
		elseif p2_c == 0x06 then -- Gief
			p2_gc = 0xFF88D7
		elseif p2_c == 0x0A then -- Boxer
			p2_gc = 0xFF88E3
		end
		
		if p1_tf == 0xFF then
			if p2_c == 0x04 or p2_c == 0x02 then -- Check ken and Blanka
				if p2_gf == 0x07 then
					draw_grab(1,p1_c,p2_c,p2_gc)
				end
			elseif p2_c == 0x01 then -- Check Honda
				if p2_gf == 0x07 or p2_gf == 0x04 then
					draw_grab(1,p1_c,p2_c,p2_gc)
				end
			elseif p2_c == 0x07 then  -- Check Dhalsim
				if p2_gf == 0x06 then
					draw_grab(1,p1_c,p2_c,p2_gc)
				end
			elseif p2_c == 0x0A then -- Check Balrog
				if p2_gf == 0x06 or p2_gf == 0x05 then
					draw_grab(1,p1_c,p2_c,p2_gc)
				end
			elseif p2_c == 0x0D then -- Check Hawk
				if p2_gf == 0x06 or p2_gf == 0x07 then
					draw_grab(1,p1_c,p2_c,p2_gc) 
				end
			elseif p2_c == 0x06 then -- Check Zangief
				if p2_gf == 0x05 or p2_gf == 0x06 or p2_gf == 0x03 then
					draw_grab(1,p1_c,p2_c,p2_gc)
				end
			end
		end
			
				
	--	if p2_gf == p2_gv and p1_tf == 0xFF  then
		--	draw_grab(1,p1_c,p2_c,p2_gc)
		--end
	end
end

----------------------------------------------------------------------------------------------------
--Draw HUD
----------------------------------------------------------------------------------------------------

local function render_st_hud()

	in_match = memory.readword(0xFF847F)
	
	if in_match == 0 then
		return
	end
	
		if draw_hud > 0 then
			--Universal
			gui.text(153,12,"Distance X/Y: " .. calc_range()) 
			--P1
			gui.text(6,16,"X/Y: ") 
			gui.text(2,24,memory.readword(0xFF8454) .. "," .. memory.readword(0xFF8458))
			gui.text(35,22,"Life: " .. memory.readbyte(0xFF8479))
			gui.text(154,41,memory.readbyte(0xFF84AD) .. "/34")
			gui.text(154,50,memory.readword(0xFF84AB))
			gui.box(35,45,150,49,0x00000040,0x000000FF)
			gui.box(35,49,150,53,0x00000040,0x000000FF)
			gui.line(136,45,136,49,0x000000FF)
			gui.text(22,206,"Super: " .. memory.readbyte(0xFF8702))
			gui.text(6,216,"Special/Super Cancel: " .. check_cancel(1))
			--P2
			gui.text(363,16,"X/Y: ")
			gui.text(356,24,memory.readword(0xFF8854) .. "," .. memory.readword(0xFF8858))
			gui.text(314,22,"Life: " .. memory.readbyte(0xFF8879))
			gui.text(212,41,memory.readbyte(0xFF88AD) .. "/34")
			gui.text(212,50,memory.readword(0xFF88AB))
			gui.box(233,45,348,49,0x00000040,0x000000FF)
			gui.box(233,49,348,53,0x00000040,0x000000FF)
			gui.line(334,45,334,49,0x000000FF)
			gui.text(327,206,"Super: " .. memory.readbyte(0xFF8B02))
			gui.text(255,216,"Special/Super Cancel: " .. check_cancel(2))
			
			-- Character specific HUD
			if draw_hud == 2 then
				determine_char(1)
				determine_char(2)
			end 
			if p1_projectile == true then
				gui.text(34,56,"Projectile: " .. projectile_onscreen(0))
			end
			if p2_projectile == true then
				gui.text(266,56,"Projectile: " .. projectile_onscreen(1))
			end
			draw_dizzy()
			check_grab()
			fskip()
		end
end

----------------------------------------------------------------------------------------------------
--Hot Keys
----------------------------------------------------------------------------------------------------

input.registerhotkey(1, function()
	-- Toggle ST HUD
	if draw_hud == 0 then
		draw_hud = 1
		print("---------------------------------------------------------------------------------")
		print("Hiding special move displays")
		print("---------------------------------------------------------------------------------")
	elseif draw_hud == 1 then
		draw_hud = 2
		print("---------------------------------------------------------------------------------")
		print("Showing full HUD")
		print("---------------------------------------------------------------------------------")
	elseif draw_hud == 2 then
		draw_hud = 0
		print("---------------------------------------------------------------------------------")
		print("Hiding HUD")
		print("---------------------------------------------------------------------------------")
	end
end)

input.registerhotkey(2, function()
	DRAW_THROWABLE_BOXES = not DRAW_THROWABLE_BOXES
	print("---------------------------------------------------------------------------------")
	print((DRAW_THROWABLE_BOXES and "Showing" or "Hiding") .. " Throw Hitboxes")
	print("---------------------------------------------------------------------------------")
end)

input.registerhotkey(3, function()
	frameskip = not frameskip
	print("---------------------------------------------------------------------------------")
	print((frameskip and "Disabling" or "Enabling") .. " Frameskip")
	print("---------------------------------------------------------------------------------")
end)

input.registerhotkey(4, function()
	draw_hitboxes = not draw_hitboxes
	print("---------------------------------------------------------------------------------")
	print((draw_hitboxes and "Showing" or "Hiding") .. " Hitboxes")
	print("---------------------------------------------------------------------------------")
end)

input.registerhotkey(5, function()
	DRAW_PUSHBOXES = not DRAW_PUSHBOXES
	print("---------------------------------------------------------------------------------")
	print((DRAW_PUSHBOXES and "Showing" or "Hiding") .. " Pushboxes")
	print("---------------------------------------------------------------------------------")
end)

print("SSF2T HUD v1.6")
print("---------------------------------------------------------------------------------")
print("Lua Hotkey 1: Toggle HUD Display")
print("Lua Hotkey 2: Display/Hide Throable Boxes")
print("Lua Hotkey 3: Display/Hide Character Axis")
print("Lua Hotkey 4: Disable/Enable Frameskip")
print("Lua Hotkey 5: Display/Hide Push boxes")
print("---------------------------------------------------------------------------------")


----------------------------------------------------------------------------------------------------
--Main loop
----------------------------------------------------------------------------------------------------
	-- Draw these functions on the same frame data is read
	emu.registerbefore(function()
		--Hitbox rendering
		update_sf2_hitboxes()
		render_sf2_hitboxes()
		--Render ST HUD
		render_st_hud()
	end)