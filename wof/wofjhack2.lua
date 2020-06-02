print("Wofj HackScript")

local globals = {
}

di = "DebugStart"
-- game-specific modules

wb, ww, wd = memory.writebyte, memory.writeword, memory.writedword
rb, rw, rd = memory.readbyte, memory.readword, memory.readdword
rbs, rws, rds = memory.readbytesigned, memory.readwordsigned, memory.readdwordsigned
local fc = emu.framecount
local game, buffer

A5					= 0xFF8000
Input_Start			= 0xFF637E	--开始键内存地址
Player_Base			= 0xFFBE1C	--玩家对象内存基址

DIR0_UP				= 0
DIR1_RU				= 1
DIR2_RIGHT			= 2
DIR3_RD				= 3
DIR4_DOWN			= 4
DIR5_LD				= 5
DIR6_LEFT			= 6
DIR7_LU				= 7
DIR8_NONE			= 8
DIRF_NONE			= 0xFF

STK1_RIGHT			= 1			--方向右的方位值
STK2_LEFT			= 2			--方向左的方位值
STK4_DOWN			= 4			--方向下的方位值
STK5_RD				= 5
STK6_LD				= 6
STK8_UP				= 8			--方向上的方位值
STK9_RU				= 9
STKA_LU				= 0x0A

T_STK2DIR = {DIRF_NONE, DIR2_RIGHT, DIR6_LEFT, DIRF_NONE, DIR4_DOWN, DIR3_RD, DIR5_LD, DIRF_NONE,
		DIR0_UP, DIR1_RU, DIR7_LU, DIRF_NONE, DIRF_NONE, DIRF_NONE, DIRF_NONE, DIRF_NONE}

IPT0_RIGHT			= 0			--方向右的数据位
IPT1_LEFT			= 1			--方向左的数据位
IPT2_DOWN			= 2			--方向下的数据位
IPT3_UP				= 3			--方向上的数据位
IPT4_BtnA			= 4			--按键A的数据位
IPT5_BtnB			= 5			--按键B的数据位

OBJE0_Len			= 0xE0		--每对象内存长度
OBJ01_Show			= 0x01		--是否显示
OBJ02_BeHit			= 0x02		--是否被碰撞?
OBJ04_X				= 0x04		--X坐标
OBJ08_Z				= 0x08		--Z坐标 纵深
OBJ0C_Y				= 0x0C		--Y坐标 高度
OBJ10_YBase			= 0x10		--地形高度
OBJ12_Spr			= 0x12		--当前图片
OBJ16_Flip			= 0x16		--面向
OBJ17_Pal			= 0x17
OBJ18_ShakeX		= 0x18
OBJ1A_MountOffs		= 0x1A
OBJ1E_1E			= 0x1E
OBJ1F_FlyLeft		= 0x1F
OBJ20_CharId		= 0x20		--对象内 角色ID 偏移
OBJ24_Dir			= 0x24
OBJ28_ActStatA		= 0x28		--4级动作状态
OBJ29_ActStatB		= 0x29
OBJ2A_ActStatC		= 0x2A
OBJ2B_ActStatD		= 0x2B
OBJ2C_AniNext		= 0x2C		--下个动画
OBJ30_Ani1			= 0x30
OBJ31_Ani2			= 0x31
OBJ32_Ani3			= 0x32
OBJ33_Ani4			= 0x33
OBJ34_AniLeft		= 0x34		--剩余帧数
OBJ36_SpdList		= 0x36
OBJ3A_MountObj		= 0x3A		--马匹对象
OBJ40_XSpd			= 0x40		--X移动速度
OBJ42_XAcc			= 0x42		--X移动加速度
OBJ44_XSpd2			= 0x44		--X移动速度2
OBJ48_YSpd			= 0x48		--Y移动速度
OBJ4A_YAcc			= 0x4A		--Y移动加速度
OBJ50_MSpr			= 0x50
OBJ54_MAniNext		= 0x54
OBJ58_MAni1			= 0x58
OBJ59_MAni2			= 0x59
OBJ5A_MAni3			= 0x5A
OBJ5B_MAni4			= 0x5B
OBJ5C_MAniLeft		= 0x5C
OBJ5E_NameId		= 0x5E		--头像名字ID
OBJ60_StunLeft		= 0x60
OBJ61_StunVal		= 0x61
OBJ62_ShakeLeft		= 0x62
OBJ63_Mount			= 0x63		--对象内 骑乘状态 偏移
OBJ64_ActFunc		= 0x64
OBJ68_HitObj1		= 0x68		--抓取和打击对象
OBJ6A_HitMeObj		= 0x6A
OBJ6C_BeThrowBox	= 0x6C
OBJ6E_VulBox		= 0x6E
OBJ70_AtkBox		= 0x70
OBJ72_BeHitType		= 0x72
OBJ74_74			= 0x74
OBJ76_FanTan		= 0x76
OBJ78_WuDi			= 0x78
OBJ7A_AtkType		= 0x7A
OBJ7C_HitBar		= 0x7C
OBJ7E_7E			= 0x7E		--UnknowDown
OBJ80_80			= 0x80
OBJ82_Life			= 0x82
OBJ84_LifeDisp		= 0x84
OBJ86_HitObj2		= 0x86		--打击对象
OBJ8B_ZhengZha		= 0x8B
OBJ8C_Weapon		= 0x8C
OBJ8E_Dismount		= 0x8E		--对象内 下马动画ID 偏移
OBJ90_Def			= 0x90
OBJ93_CrossItem		= 0x93
OBJ94_FlagForAi		= 0x94
OBJ96_FlipEnemy		= 0x96		--敌人面向
OBJ97_JumpStat		= 0x97
OBJ98_AiDef			= 0x98
OBJ99_DownType		= 0x99
OBJ9A_SndDelay		= 0x9A
OBJ9C_X2			= 0x9C
OBJ9E_Z2			= 0x9E
OBJA0_Input			= 0xA0		--对象内 摇杆按键内存 偏移
OBJA1_InputPre		= 0xA1
OBJA2_InputNew		= 0xA2
OBJA4_NewBtnA		= 0xA4
OBJA7_DownUpA		= 0xA7
OBJA8_A8			= 0xA8
OBJA9_AtkCount		= 0xA9
OBJAD_ComboLeft		= 0xAD
OBJAE_ComboLev		= 0xAE
OBJB0_RKey1			= 0xB0		--步行下上和骑马后前搓招内存
OBJB1_RKey1Left		= 0xB1
OBJB4_QuickA		= 0xB4
OBJB5_UpDown		= 0xB5
OBJB7_BackLeft		= 0xB7
OBJB8_ThrowHit		= 0xB8
OBJB9_Flash			= 0xB9
OBJBC_BC			= 0xBC
OBJBD_StkPre		= 0xBD + 0x2A0
OBJC1_Xuan			= 0xC1		--旋风坐按键历史
OBJC2_Xuan2			= 0xC2		--旋风坐按键历史2
OBJXX_ActStat5		= 0xDC + 0x2A0
OBJXX_RunLeft		= 0xBC + 0x2A0
OBJXX_DirPre		= 0xAB + 0x2A0
OBJXX_DirRun		= 0xAC + 0x2A0

local profile =
{
	{
		game = "wofj",
		breakpoints =
		{

			{	base = 0x1AA58,													--断点地址,处理3个玩家都会依次来到此处
				func = function()
					local cp = gra("a0")											--获取当前玩家基址
					changechar(cp)

					call(0x1AAF0)
					local input = rb(cp + OBJA0_Input)
					local inputpre = rb(cp + OBJA1_InputPre)
					local inputnew = bit.band(bit.bnot(inputpre), input)
					wb(cp + OBJA2_InputNew, inputnew)
					srb("d5", inputnew)

					if bit.btst(inputnew,IPT4_BtnA) ~= 0 then					--1AA6E
						wb(cp + OBJA4_NewBtnA, -1)
					end

					local stunleft = rb(cp + OBJ60_StunLeft)
					if stunleft ~= 0 then										--1AA78
						wb(cp + OBJ60_StunLeft, stunleft - 1)

						stunleft = stunleft - 1
						if stunleft == 0 then									--1AA7E
							wb(cp + OBJ61_StunVal, 0)
						end
					end

					local wudi = rb(cp + OBJ78_WuDi)
					if wudi ~= 0 then											--1AA88
						wb(cp + OBJ78_WuDi, wudi - 1)
					end

					local obj_a8 = rb(cp + OBJA8_A8)
					if obj_a8 ~= 0 then										--1AA88
						wb(cp + OBJA8_A8, obj_a8 - 1)
					end

					local snddelay = rb(cp + OBJ9A_SndDelay)
					if snddelay ~= 0 then										--1AA9C
						wb(cp + OBJ9A_SndDelay, snddelay - 1)
					end

					local objhead = rb(cp)
					if objhead ~= 0 then										--1AAA4
						local a5_1ac = rb(A5 + 0x1AC) wb(A5 + 0x1AC, a5_1ac + 1)
						local x = rw(cp + OBJ04_X) ww(cp + OBJ9C_X2, x)
						local z = rw(cp + OBJ08_Z) ww(cp + OBJ9E_Z2, z)

						local charid = rw(cp + OBJ20_CharId)
						local mount = rb(cp + OBJ63_Mount)
						if mount > 0 then										--1AABA
							local def = rw(cp + OBJ90_Def) ww(cp + OBJ90_Def, def + 1)

							if charid == 0 then
								if JMP_1EC1A(cp) ~= 0 then return 1 end
							else
								sr("pc", 0x1AAC0) return 1
							end

						else
							if charid == 0 then
								SyncSP(0x1AADC)

								if JSR_1AB58(cp) ~= 0 then return 1 end

								local ybase = rws(cp + OBJ10_YBase)
								if ybase ~= 0 then								--1AAE0
									local y = rws(cp + OBJ0C_Y)
									ww(cp + OBJ0C_Y, y + ybase)
									ww(cp + OBJ10_YBase, 0)
									wb(cp + OBJ93_CrossItem, 0)
								end
							else
								sr("pc", 0x1AACE) return 1
							end
						end
					end
					RTS()
					return 0
				end
			},

		},
		clones = {},
	},
}

JSR_1AB58 = function(cp)
	sr("d0", 0)
	local actstata = rb(cp + OBJ28_ActStatA)
	if actstata == 2 then	--00出场 02在场 04退场 06胜利失败
		if JMP_1ADB0(cp) ~= 0 then return 1 end
		return 0
	else
		sr("pc", 0x1AB58) return 1
	end
end

--02------------------------------------------------------------------------------

JMP_1ADB0 = function(cp)
	SUB_1766(cp)
--	SUB_1F7C(cp)
--	RoteKey(cp, OBJB0_RKey1, OBJB1_RKey1Left, STK4_DOWN, STK8_UP)
	RoteKey(cp, OBJB0_RKey1, OBJB1_RKey1Left, STK4_DOWN, STK1_RIGHT, false, true)

	local runleft = rb(cp + OBJXX_RunLeft)
	if runleft ~= 0 then
		wb(cp + OBJXX_RunLeft, runleft - 1)
	end

	local actstat5 = rb(cp + OBJXX_ActStat5)
	if actstat5 == 4 then
--		local actstata2 = rw(cp + OBJ28_ActStatA)
		local actstatc = rb(cp + OBJ2A_ActStatC)
		if actstatc ~= 0 then
			print("停跑")
			wb(cp + OBJXX_ActStat5, 0)
		end
	end

	sr("d0", 0)
	local actstatb = rb(cp + OBJ29_ActStatB)
	if actstatb == 0 then	--00待机1ADE4 02被打11720 04抓人1B552 06被抓78CE 08放下7CAE 0C武器被挥
		SyncSP(0x1ADCA)
		if JSR_1ADE4(cp) ~= 0 then return 1 end
		call(0x15C0)
		RTS()
		return 0
	else
		sr("pc", 0x1ADBC) return 1
	end
end

--0200------------------------------------------------------------------------------

JSR_1ADE4 = function(cp)
	local shakeleft = rb(cp + OBJ62_ShakeLeft)
	if shakeleft ~= 0 then
		wb(cp + OBJ62_ShakeLeft, shakeleft - 1 )
		RTS()
		return 0
	end

	local comboleft = rb(cp + OBJAD_ComboLeft)
	if comboleft ~= 0 then														--1ADF0
		wb(cp + OBJAD_ComboLeft, comboleft - 1 )
	end

	local hitobj2 = rw(cp + OBJ86_HitObj2)
	if hitobj2 ~= 0 then														--1ADFA
		hitobj2 = extw2a(hitobj2)
		local e_fantan = rw(hitobj2 + OBJ76_FanTan)
		local x = rw(cp + OBJ04_X)
		ww(cp + OBJ04_X, x - e_fantan)

		local actstata2 = rw(cp + OBJ28_ActStatA)
		if actstata2 ~= 0x0202
			then ww(cp + OBJ86_HitObj2, 0)
		end
	end

	sr("d0", 0)
	local actstatc = rb(cp + OBJ2A_ActStatC )									--1AE16
	if actstatc == 0 or actstatc == 2 or actstatc == 8 or actstatc == 0x0A or actstatc == 0x0C or actstatc == 0x0E then
		SyncSP(0x1AE24)

		if actstatc == 0 then	--00待机1AE40 02保险1B064 04捡取1B00A 06武器1AF3E 08出拳1B400 0A冲刺1B31C 0C浮空1B20A 0E下上拳1B0A2
			if JSR_1AE40(cp) ~= 0 then return 1 end
		end

		if actstatc == 2 then
			if JSR_1B064(cp) ~= 0 then return 1 end
		end

		if actstatc == 8 then
			if JSR_1B400(cp) ~= 0 then return 1 end
		end

		if actstatc == 0x0A then
			if JSR_1B31C(cp) ~= 0 then return 1 end
		end

		if actstatc == 0x0C then
			if JSR_1B20A(cp) ~= 0 then return 1 end
		end

		if actstatc == 0x0E then
			if JSR_1B0A2(cp) ~= 0 then return 1 end
		end

		call(0x269E)
		SUB_1E62(cp)
		RTS()
		return 0
	else
		sr("pc", 0x1AE16) return 1
	end
end

--020000------------------------------------------------------------------------------

JSR_1AE40 = function(cp)
	ww(cp, 0x0101)
	ww(cp + OBJ94_FlagForAi, 0)

	local y = rws(cp + OBJ0C_Y)
	if y > 0 then
		wd(cp + OBJ28_ActStatA, 0x02080001)										--1AE4E
		RTS()
		return 0
	end
	wd(cp + OBJ0C_Y, 0)															--1AE58

	if JMP_1AE60(cp) ~= 0 then return 1 end
	return 0
end

JMP_1AE60 = function(cp)
	local input = rb(cp + OBJA0_Input)											--1AE60
	srb("d6", input)

	if SUB_1B02(cp) == 2 then return 0 end

	local flip = rb(cp + OBJ16_Flip)
	if SUB_1BBEA(cp) ~= 0 then
		wb(cp + OBJ16_Flip, bit.bnot(flip))
	end

	local actstat5 = rb(cp + OBJXX_ActStat5)
	local inputnew = rb(cp + OBJA2_InputNew)
	local rkey1 = rbs(cp + OBJB0_RKey1)
	if bit.btst(inputnew,IPT4_BtnA) ~= 0 then									--1AE70
		if rkey1 < 0 then														--1AE76
			print("地面下上拳")
			wb(cp + OBJ78_WuDi, 3) ww(cp + OBJ94_FlagForAi, 8)	--1AE7C
			wd(cp + OBJ28_ActStatA, 0x02000E00)
			sr("a4", 0x70ACC) SUB_247C(cp)
			RTS()
			return 0
		end

		if actstat5 == 4 then
			print("跑拳")
			SUB_1702(cp)
			ww(cp + OBJ94_FlagForAi, 0x6) ww(cp + OBJ7A_AtkType, 0x0170)
			wb(cp + OBJ2A_ActStatC, 0x0A)
			sr("a4", 0x70AB4) SUB_247C(cp)
			RTS()
			return 0
		end

		call(0x1E9D8)															--1AE9C
		if gra("pc") == 0x1EAB8 then
			call(0x1EAB8)
			return 0
		end

		local weapobj = rw(cp + OBJ8C_Weapon)									--1AEA0
		if weapobj ~= 0 then
			print("使用武器")
			weapobj = extw2a(weapobj)
			ww(cp + OBJ2A_ActStatC, 0x0600)
			wd(weapobj + OBJ28_ActStatA, 0x020C0000)
			wb(cp + OBJ31_Ani2, 0) ww(cp + OBJ94_FlagForAi, 0x0E)
			SUB_1702(cp)
			RTS()
			return 0
		end

		wb(cp + OBJ2A_ActStatC, 0x8)											--1AEC6

		if JSR_1B400(cp) ~= 0 then return 1 end
		return 0
	end

	if bit.btst(inputnew,IPT5_BtnB) ~= 0 then									--1AED0
--[[			if bit.btst(input,IPT2_DOWN) ~= 0 then							--1AED6
			print("地面下跳")
			SUB_1702(cp)
			ww(cp + OBJ94_FlagForAi, 6) ww(cp + OBJ7A_AtkType, 0x0170)
			wb(cp + OBJ2A_ActStatC, 0x0A)
			sr("a4", 0x70AA0) SUB_247C(cp)
			RTS()
			return 0
		end]]

		if actstat5 == 4 then
			print("跑跳")
			wb(cp + OBJXX_ActStat5, 6)
		else
			print("走跳")
		end

		wb(cp + OBJA4_NewBtnA, 0) wb(cp + OBJ2A_ActStatC, 0x0C)	--1AF00
		sr("a4", 0x70984) SUB_247C(cp)
		RTS()
		return 0
	end

	local stk = bit.band(input, 0x0F)											--CALL 1BBCC
	local dir = T_STK2DIR[stk + 1]

	if actstat5 == 2 then
		if stk ~= 0 and dir ~= DIRF_NONE then
			wb(cp + OBJXX_DirPre, dir)
		else
			print("停走")
			actstat5 = 0
			wb(cp + OBJXX_ActStat5, actstat5)
		end
	end

	if actstat5 == 4 then
		if stk ~= 0 then
			local dirrun = rb(cp + OBJXX_DirPre)
			wb(cp + OBJXX_DirRun, dirrun)

			wb(cp + OBJXX_DirPre, dir)

			local dirdiff = dir - dirrun
			dirdiff = bit.band(dirdiff + 1, 7)
			if dirdiff > 3  or dir == DIRF_NONE then
				print("停跑")
				actstat5 = 0
				wb(cp + OBJXX_ActStat5, actstat5)
				sr("a4", 0x707FE) SUB_247C(cp)
			end
		else
			dir = rb(cp + OBJXX_DirPre)
		end
	end

	if actstat5 ~= 2 and actstat5 ~= 4 then
		if stk ~= 0 and dir ~= DIRF_NONE then
			wb(cp + OBJXX_DirPre, dir)

			local runleft = rb(cp + OBJXX_RunLeft)
			if runleft > 3 then
				local dirrun = rb(cp + OBJXX_DirRun)
				local dirdiff = dir - dirrun
				dirdiff = bit.band(dirdiff + 1, 7)
				if dirdiff <= 3 then
					print("开跑")
					actstat5 = 4
					wb(cp + OBJXX_ActStat5, actstat5)
					sr("a4", 0x70AB4) SUB_247C(cp)
					ww(cp + OBJ70_AtkBox, 0)
				end
			else
				print("开走")
				wb(cp + OBJXX_RunLeft, 0x0F)
				wb(cp + OBJBD_StkPre, stk)

				actstat5 = 2
				wb(cp + OBJXX_ActStat5, actstat5)

				dirrun = rb(cp + OBJXX_DirPre)
				wb(cp + OBJXX_DirRun, dirrun)
			end
		else
			sr("a4", 0x707FE) SUB_247C(cp)
			RTS()
			return 0
		end
	end

--	print(dir)
	sr("d0", dir)
	SUB_112E(cp)

	if actstat5 ~= 4 then
		SUB_2470(cp)
--	else
--		local spr = rd(cp + OBJ12_Spr)
--		if spr ~= 0x7144A then
--			SUB_2470(cp)
--		end
	end

	SUB_1E3C(cp)
	RTS()
	return 0
end

--020002------------------------------------------------------------------------------

JSR_1B064 = function(cp)
	local mount = rb(cp + OBJ63_Mount)
	local ani34 = rws(cp + OBJ32_Ani3)
	if ani34 < 0 then
		ww(cp + OBJ2A_ActStatC, 0)
		local objhead = rb(cp)
		wb(cp, bit.bclr(objhead, 7))

		if mount ~= 0 then
			call(0x1F086)
		end
		RTS()
		return 0
	end

	local actstatd = rb(cp + OBJ2B_ActStatD )
	if actstatd == 0 then
		local hitobj1 = rw(cp + OBJ68_HitObj1)
		if hitobj1 ~=0 then
			print("保险打中扣血")
			wb(cp + OBJ2B_ActStatD, -1)

			if mount == 0 then
				local a5__5a = rw(A5 - 0x5A)
				ww(A5 - 0x5A, a5__5a - 0x20)
			end

			local life = rws(cp + OBJ82_Life)
			ww(cp + OBJ84_LifeDisp, life)
			life = life - 6
			if life < 0 then
				life = 0
			end
			ww(cp + OBJ82_Life, life)
		end
	end

	if mount == 0 then
		SUB_2470(cp)
	else
		SUB_24BE(cp) SUB_257E(cp)
	end
	RTS()
	return 0
end

--02000E------------------------------------------------------------------------------

JSR_1B0A2 = function(cp)
	sr("d0", 0)
	local actstatd = rb(cp + OBJ2B_ActStatD )
	if actstatd == 0 then
		JMP_1B0B6(cp)
	end

	if actstatd == 2 then
		JMP_1B11C(cp)
	end

	if actstatd == 4 then
		JMP_1B16E(cp)
	end

	if actstatd == 6 then
		JMP_1B1D2(cp)
	end
	return 0
end

JMP_1B0B6 = function(cp)
	SUB_2470(cp)
	local ani34 = rws(cp + OBJ32_Ani3)
	if ani34 == 0 then
		ww(cp + OBJ48_YSpd, 0x0500)
		ww(cp + OBJ4A_YAcc, 0x0010)
		wb(cp + OBJ2B_ActStatD, 2)
		ww(cp + OBJ68_HitObj1, 0)
		ww(cp + OBJ7A_AtkType, 0x60)
		SUB_1702(cp)

		local xspd = 3
		local xspd2 = 2
		local flip = rb(cp + OBJ16_Flip)
		if flip ~= 0 then
			xspd = -xspd
			xspd2 = -xspd2
		end

		ww(cp + OBJ40_XSpd, xspd)
		ww(cp + OBJ44_XSpd2, xspd2)
		ww(cp + OBJ97_JumpStat, 4)

		srw("d0",0x33)
		srw("d1",0xD0)
		srw("d3",0x00)
		srw("d4",0x03)
		srw("d5",0x10)
		call(0x5B80)
	end
	RTS()
	return 0
end

JMP_1B11C = function(cp)
	local atktype = rw(cp + OBJ7A_AtkType)
	if atktype < 0x80 then
		local hitobj1 = rw(cp + OBJ68_HitObj1)
		if hitobj1 ~=0 then
			ww(cp + OBJ68_HitObj1, 0)
			ww(cp + OBJ7A_AtkType, atktype + 0x10)
			SUB_1702(cp)
		end
	end

	local xspd = rw(cp + OBJ40_XSpd)
	local x =  rw(cp + OBJ04_X)
	ww(cp + OBJ04_X, x + xspd)
	SUB_10BC(cp)
	SUB_2470(cp)

	local ani3 = rws(cp + OBJ32_Ani3)
	if ani3 ~= 0 then
		wb(cp + OBJ1F_FlyLeft, 8)
		wb(cp + OBJ2B_ActStatD, 4)
		ww(cp + OBJ48_YSpd, 0)
		ww(cp + OBJ4A_YAcc, 0xFF70)
	end
	RTS()
	return 0
end

JMP_1B16E = function(cp)
	SUB_2470(cp)
	local atktype = rw(cp + OBJ7A_AtkType)
	if atktype < 0x80 then
		local hitobj1 = rw(cp + OBJ68_HitObj1)
		if hitobj1 ~=0 then
			ww(cp + OBJ68_HitObj1, 0)
			ww(cp + OBJ7A_AtkType, atktype + 0x10)
			SUB_1702(cp)
		end
	end

	local xspd2 = rw(cp + OBJ44_XSpd2)
	local x =  rw(cp + OBJ04_X)
	ww(cp + OBJ04_X, x + xspd2)

	local flyleft = rb(cp + OBJ1F_FlyLeft)
	if flyleft ~= 0 then
		wb(cp + OBJ1F_FlyLeft, flyleft - 1)
		RTS()
		return 0
	end

	SUB_10BC(cp)
	local y = rws(cp + OBJ0C_Y)
	if y <= 0 then
		wd(cp + OBJ0C_Y, 0)
		wb(cp + OBJ1F_FlyLeft, 0)
		ww(cp + OBJ94_FlagForAi, 0)
		wb(cp + OBJ2B_ActStatD, 6)
		ww(A5 - 0x62, 0x16)
		call(0x6082)
	end
	RTS()
	return 0
end

JMP_1B1D2 = function(cp)
	local flyleft = rb(cp + OBJ1F_FlyLeft)
	wb(cp + OBJ1F_FlyLeft, flyleft + 0x20)
	flyleft = rb(cp + OBJ1F_FlyLeft)
	if flyleft == 0 then
		ww(cp + OBJ48_YSpd, 0x038E)
		ww(cp + OBJ4A_YAcc, 0xFFC8)

		local xspd = 1
		local flip = rb(cp + OBJ16_Flip)
		if flip == 0 then
			xspd = -xspd
		end
		ww(cp + OBJ40_XSpd, xspd)

		wd(cp + OBJ28_ActStatA, 0x02000C06)
		print("反弹后跳")
		sr("a4", 0x708E0) SUB_247C(cp)
	end
	RTS()
	return 0
end

--02000C------------------------------------------------------------------------------

JSR_1B20A = function(cp)
	sr("d0", 0)
	local actstatd = rb(cp + OBJ2B_ActStatD )
	if actstatd == 0 then	--00起跳1B21E 02跳中1B26E 04降落1B2E8 06跳踢1B2AA
		JMP_1B21E(cp)
	end

	if actstatd == 2 then
		JMP_1B26E(cp)
	end

	if actstatd == 4 then
		JMP_1B2E8(cp)
	end

	if actstatd == 6 then
		JMP_1B2AA(cp)
	end
	return 0
end

JMP_1B21E = function(cp)
	SUB_2470(cp)
	local ani34 = rws(cp + OBJ32_Ani3)
	if ani34 ~= 0 then															--1B228
		local xspd = 0															--1ED84
		local flagforai = 2
		local input = rb(cp + OBJA0_Input)
		if input ~= 0 then
			if bit.btst(input,IPT0_RIGHT) ~= 0 then							--1B246
				xspd = 2
				flagforai = 4
			end
			if bit.btst(input,IPT1_LEFT) ~= 0 then								--1B252
				xspd = -2
				flagforai = 4
			end
		end
		local yspd = 0x05D1

			local actstat5 = rb(cp + OBJXX_ActStat5)
		if actstat5 == 6 then
			xspd = xspd * 1.5
			yspd = yspd * 1.1
		end

		wb(cp + OBJ2B_ActStatD, 2)
		ww(cp + OBJ40_XSpd, xspd)
		ww(cp + OBJ48_YSpd, yspd)
		ww(cp + OBJ4A_YAcc, 0xFFBD)
		ww(cp + OBJ94_FlagForAi, flagforai)
		wb(cp + OBJ97_JumpStat, 4)

		call(0x5EB0)
	end
	RTS()
	return 0
end

JMP_1B26E = function(cp)
	local newbtna = rb(cp + OBJA4_NewBtnA)
	if newbtna ~= 0 then

		ww(cp + OBJ7A_AtkType, 0x30)
		SUB_1702(cp)

		local xspd = rw(cp + OBJ40_XSpd)
		if xspd ~= 0 then														--1B284
			ww(cp + OBJ7A_AtkType, 0x40)
		end

		wb(cp + OBJA4_NewBtnA, 0)

		local actstat5 = rb(cp + OBJXX_ActStat5)
		if actstat5 == 6 then
			print("跑跳拳")
			ww(cp + OBJ7A_AtkType, 0x260)
			sr("a4", 0x70AFE)
		else
			print("走跳拳")
			sr("a4", 0x709BE)
		end

		SUB_247C(cp)
		wb(cp + OBJ2B_ActStatD, 6)

		sr("d0", 7)
		call(0x1EBFA)
	end
	if JMP_1B2AA(cp) ~= 0 then return 1 end
	return 0
end

JMP_1B2AA = function(cp)
	local xspd = rw(cp + OBJ40_XSpd)
	local x = rw(cp + OBJ04_X)													--1B2AA
	ww(cp + OBJ04_X, x + xspd)
	SUB_10BC(cp) SUB_2470(cp)

	local actstat5 = rb(cp + OBJXX_ActStat5)
	if actstat5 == 6 then
		local spr = rd(cp + OBJ12_Spr)
		if spr == 0x715AA or spr == 0x715F8 then
			wd(cp + OBJ12_Spr, 0x716A8)
		end
	end

	local y = rws(cp + OBJ0C_Y)
	if y <= 0 then																--1B2C2
		wd(cp + OBJ0C_Y, 0)
		ww(cp + OBJ94_FlagForAi, 0)
		wb(cp + OBJ2B_ActStatD, 4)
		wb(cp + OBJXX_ActStat5, 0)

		sr("a4", 0x709B0) SUB_247C(cp)
		call(0x5EBE)

		if JMP_1B2E8(cp) ~= 0 then return 1 end
		return 0
	end
	RTS()
	return 0
end

JMP_1B2E8 = function(cp)
	local input = rb(cp + OBJA0_Input)											--1B2E8
	if bit.band(input, 0x3F) ~= 0 then											--1B2F0
		ww(cp + OBJ2A_ActStatC, 0)
		sr("a4", 0x707FE) SUB_247C(cp)

		local inputnew = rb(cp + OBJA2_InputNew)
		srb("d5", inputnew)
		if JMP_1AE60(cp) ~= 0 then return 1 end
		return 0
	else
		SUB_2470(cp)
		local ani34 = rws(cp + OBJ32_Ani3)
		if ani34 ~= 0 then														--1B314
			ww(cp + OBJ2A_ActStatC, 0)
		end
	end
	RTS()
	return 0
end

--02000A------------------------------------------------------------------------------

JSR_1B31C = function(cp)
	local y = rws(cp + OBJ0C_Y)
	if y > 0 then																--1B320
		wd(cp + OBJ28_ActStatA, 0x02080002)
		RTS()
		return 0
	end

	local actstatd = rbs(cp + OBJ2B_ActStatD)
	if actstatd >= 0 then														--1B330
		if actstatd == 0 then													--1B334
			SUB_2470(cp)
			local ani34 = rws(cp + OBJ32_Ani3)
			if ani34 ~= 0 then													--1B340
				SUB_1702(cp)
				ww(cp + OBJ7A_AtkType, 0x50)
				wb(cp + OBJ2B_ActStatD, 2)
				wb(cp + OBJ1F_FlyLeft, 0x10)
				call(0x5E68)

				local xspd = 4
				local flip = rb(cp + OBJ16_Flip)
				if flip ~= 0 then												--1B36A
					xspd = -xspd
				end
				ww(cp + OBJ40_XSpd, xspd)
			end
		else
			local xspd = rws(cp + OBJ40_XSpd)
			local x = rws(cp + OBJ04_X)
			ww(cp + OBJ04_X, x + xspd)

			local flyleft = rb(cp + OBJ1F_FlyLeft)
			flyleft = flyleft - 1
			wb(cp + OBJ1F_FlyLeft, flyleft)
			if flyleft == 0 then												--1B37E
				wb(cp + OBJ2B_ActStatD, -1)
				wb(cp + OBJA4_NewBtnA, 0)
				call(0x616C)
				wb(cp + OBJ1F_FlyLeft, 0x10)

				local xspd = 0x300
				local xacc = 0xFFD0
				local flip = rb(cp + OBJ16_Flip)
				if flip ~= 0 then												--1B3A4
					xspd = -xspd
					xacc = -xacc
				end
				ww(cp + OBJ40_XSpd, xspd)
				ww(cp + OBJ42_XAcc, xacc)
			end
		end
	else
		local newbtna = rb(cp + OBJA4_NewBtnA)
		if newbtna ~= 0 then													--1B3B4
			local rkey1 = rbs(cp + OBJB0_RKey1)
			if rkey1 < 0 then													--1B3BA
				print("下跳接下上拳")
				ww(cp + OBJ94_FlagForAi, 8)
				wd(cp + OBJ28_ActStatA, 0x02000E00)
				sr("a4",0x70AD6) SUB_247C(cp)
			end
		end

		SUB_10D2(cp)
		local y = rws(cp + OBJ0C_Y)
		if y > 0 then															--1B3E0
			SUB_10BC(cp)
		else
			ww(cp + OBJ48_YSpd, 0)
		end

		local flyleft = rb(cp + OBJ1F_FlyLeft)
		flyleft = flyleft - 1
		wb(cp + OBJ1F_FlyLeft, flyleft)
		if flyleft == 0 then													--1B3F2
			ww(cp + OBJ2A_ActStatC, 0)
			ww(cp + OBJ94_FlagForAi, 0)
		end
	end
	RTS()
	return 0
end

--020008------------------------------------------------------------------------------

JSR_1B400 = function(cp)
	sr("d0", 0)
	local actstatd = rb(cp + OBJ2B_ActStatD )
	if actstatd == 0 then	--00出拳3段1B412 02出拳后1B45E 04收尾1B540
		JMP_1B412(cp)
	end

	if actstatd == 2 then
		JMP_1B45E(cp)
	end

	if actstatd == 4 then
		JMP_1B540(cp)
	end
	return 0
end

JMP_1B412 = function(cp)
	local comboleft = rb(cp + OBJAD_ComboLeft)
	if comboleft == 0 then														--1B416
		wb(cp + OBJAE_ComboLev, 0)
	end

	if JMP_1B418(cp) ~= 0 then return 1 end
	return 0
end

JMP_1B418 = function(cp)
	local combolev = rb(cp + OBJAE_ComboLev)									--1B418
	if combolev > 2 then
		combolev = 0
		wb(cp + OBJAE_ComboLev, combolev)
	end

	print("连拳" .. combolev + 1)
	wb(cp + OBJ2B_ActStatD, 2)
	ww(cp + OBJ94_FlagForAi, 0x0A)
	SUB_1702(cp)
	ww(cp + OBJ7A_AtkType, combolev * 0x10)
	sr("d0", combolev * 2)
	sr("a4", 0x70A2A) SUB_2466(cp)
	sr("d0", 5 + combolev * 2)
	call(0x1EBB6)
	RTS()
	return 0
end

JMP_1B45E = function(cp)
	SUB_2470(cp)
	local ani34 = rws(cp + OBJ32_Ani3)
	if ani34 ~= 0 then															--1B468
		if ani34 < 0 then														--1B46C
			ww(cp, 0x0101)
			local comboleft = rb(cp + OBJAD_ComboLeft)
			if comboleft ~= 0 then												--1B478
				local newbtna = rb(cp + OBJA4_NewBtnA)
				if newbtna ~= 0 then											--1B482
					local combolev = rb(cp + OBJAE_ComboLev)
					if combolev == 1 then										--1B48A
						local hitobj1 = rw(cp + OBJ68_HitObj1)
						hitobj1 = extw2a(hitobj1)
						local e_hitmeobj = rw(hitobj1 + OBJ6A_HitMeObj)
						e_hitmeobj = extw2a(e_hitmeobj)
						if e_hitmeobj == cp then						--1B494
							local e_behit = rw(hitobj1 + OBJ02_BeHit)
							if e_behit == 0 or e_behit == 8 then				--1B49E 1B4A6
								local e_life = rw(hitobj1 + OBJ82_Life)
								if e_life >= 0 then							--1B4AC
									local e_ani2 = rb(hitobj1 + OBJ31_Ani2)
									if e_ani2 ~= 0x10 then						--1B4B4
										local e_mount = rb(hitobj1 + OBJ63_Mount)
										if e_mount == 0 then					--1B4BC
											local e_actstata2 = rw(hitobj1 + OBJ28_ActStatA)
											if e_actstata2 ~= 0x0204 then		--1B4C4
												local mode = rw(A5 - 0x1CDE)
												if mode ~= 0x0C then			--1B4CC
													local input = rb(cp + OBJA0_Input)
													input = bit.band(input, 0x0F)
													if input == STK8_UP or input == STK4_DOWN then	--1B4DA 1B4E0
														print("连拳投")
														ww(cp + OBJ86_HitObj2, 0)
														ww(hitobj1 + OBJ68_HitObj1, hitobj1)
														wd(cp + OBJ28_ActStatA, 0x02040200)
														wd(hitobj1 + OBJ28_ActStatA, 0x02060000)

														sr("d4", 0x0E) sr("d5", 0x20) sr("d6", 0x40) call(0x1BCA)
														sr("a1",hitobj1) call(0x1684)

														ww(hitobj1 + OBJ74_74, 0x0200)
														local e_objhead = rb(hitobj1)
														wb(hitobj1, bit.bset(e_objhead, 7))
														call(0x1B552)
														RTS()
														return 0
													end
												end
											end
										end
									end
								end
							end
						end
					end
					wb(cp + OBJAE_ComboLev, combolev + 1)
					if JMP_1B418(cp) ~= 0 then return 1 end
					return 0
				end
			end
			ww(cp + OBJ2A_ActStatC, 0)
			RTS()
			return 0
		end
		local x = rw(cp + OBJ04_X)
		local flip = rb(cp + OBJ16_Flip)
		if flip ~= 0 then
			ww(cp + OBJ04_X, x - 0x20)
		else
			ww(cp + OBJ04_X, x + 0x20)
		end
	end
	RTS()
	return 0
end

JMP_1B540 = function(cp)
	SUB_2470(cp)
	local ani34 = rws(cp + OBJ32_Ani3)
	if ani34 < 0 then
		ww(cp + OBJ2A_ActStatC, 0)
	end
	RTS()
	return 0
end

--------------------------------------------------------------------------------

JMP_1EC1A = function(cp)
	local x = rw(cp + OBJ04_X) ww(cp + OBJ9C_X2, x)
--	SUB_1EC8(cp)
--	RoteKey(cp, OBJB0_RKey1, OBJB1_RKey1Left, STK2_LEFT, STK1_RIGHT, true, true, 0x02000000, 6)
	RoteKey(cp, OBJB0_RKey1, OBJB1_RKey1Left, STK4_DOWN, STK1_RIGHT, false, true, 0x02000000, 4)

	sr("d0", 0)
	local actstata = rb(cp + OBJ28_ActStatA)
	if actstata == 2 then
		if JMP_1ED1E(cp) ~= 0 then return 1 end
		return 0
	else
		sr("pc", 0x1EC24) return 1
	end
end

--M2------------------------------------------------------------------------------

JMP_1ED1E = function(cp)
	SUB_1766(cp)
	call(0x2008)

	sr("d0", 0)
	local actstatb = rb(cp + OBJ29_ActStatB)
	if actstatb == 0 then
		SyncSP(0x1ED34)
		if JSR_1ED48(cp) ~= 0 then return 1 end
		call(0x15C0)
		RTS()
		return 0
	else
		sr("pc", 0x1ED26) return 1
	end
end

--M200------------------------------------------------------------------------------

JSR_1ED48 = function(cp)
	local shakeleft = rb(cp + OBJ62_ShakeLeft)
	if shakeleft ~= 0 then
		wb(cp + OBJ62_ShakeLeft, shakeleft - 1 )
		RTS()
		return 0
	end

	local comboleft = rb(cp + OBJAD_ComboLeft)
	if comboleft ~= 0 then														--1ED58
		wb(cp + OBJAD_ComboLeft, comboleft - 1 )
	end

	local hitobj2 = rw(cp + OBJ86_HitObj2)
	if hitobj2 ~= 0 then														--1ED62
		hitobj2 = extw2a(hitobj2)
		local e_fantan = rw(hitobj2 + OBJ76_FanTan)
		local x = rw(cp + OBJ04_X)
		ww(cp + OBJ04_X, x - e_fantan)

		local actstata2 = rw(cp + OBJ28_ActStatA)
		if actstata2 ~= 0x0202
			then ww(cp + OBJ86_HitObj2, 0)
		end
	end

	sr("d0", 0)
	local actstatc = rb(cp + OBJ2A_ActStatC )
	if actstatc == 0 or actstatc == 2 or actstatc == 4 or actstatc == 6 or actstatc == 0x10 then	--1ED7A
		SyncSP(0x1ED86)

		if actstatc == 0 then	--00待机1EDA0 02保险1F282 04马拳1F418 06冲刺1F0CA 08马反拳1F2DE 0A转身1EF72 0C马快拳1F2B8 0E跳转身1F09A 10马跳包括下马1F2F8
			if JSR_1EDA0(cp) ~= 0 then return 1 end
		end

		if actstatc == 2 then
			if JSR_1B064(cp) ~= 0 then return 1 end							--1F282已并入1B064
		end

		if actstatc == 4 then
			if JSR_1F418(cp) ~= 0 then return 1 end
		end

		if actstatc == 6 then
			if JSR_1F0CA(cp) ~= 0 then return 1 end
		end

		if actstatc == 0x10 then
			wb(cp + OBJXX_ActStat5, 0)
			call(0x1F2F8)
			RTS()
		end

		call(0x269E)
		SUB_1E62(cp)
		RTS()
		return 0
	else
		sr("pc", 0x1ED7A) return 1
	end
end

--M20000------------------------------------------------------------------------------

JSR_1EDA0 = function(cp)
	ww(cp + OBJ94_FlagForAi, 0)
	ww(cp, 0x0101)

	call(0x1EB04)																--1EDA8
	if gra("pc") == 0x1EB78 then
		call(0x1EB78)
		return 0
	end

	local input = rb(cp + OBJA0_Input)
	srb("d6", input)
	local inputnew = rb(cp + OBJA2_InputNew)

	if SUB_1B02(cp) == 2 then return 0 end

	local back = IPT0_RIGHT														--1ED84
	local forward = IPT1_LEFT
	local flip = rb(cp + OBJ16_Flip)
	if flip == 0 then
		back = IPT1_LEFT
		forward = IPT0_RIGHT
	end
	sr("d2", back)
	sr("d3", forward)


	if bit.btst(inputnew,IPT5_BtnB) ~= 0 then									--1EDC0
		if bit.btst(input,forward) ~= 0 then									--1EDC6
			print("骑马前B")
			ww(cp + OBJ2A_ActStatC, 0x0600)
			RTS()
			return 0
		end

		if bit.btst(input,back) ~= 0 then										--1EDD2
			print("骑马后B")
			sr("a4", 0x70E02) SUB_247C(cp)
			sr("a3", 0x6FD5E) SUB_258A(cp)
			SUB_1702(cp)
			ww(cp + OBJ7A_AtkType, 0xF0)
			ww(cp + OBJ2A_ActStatC, 0x0E00)
			call(0x1EBE8)
			RTS()
			return 0
		end

		ww(cp + OBJ2A_ActStatC, 0x1000)											--1EDFE
		wd(cp + OBJ64_ActFunc, 0x1F40C)

		local rkey1 = rbs(cp + OBJB0_RKey1)
		if rkey1 < 0 then														--1EE0C
			print("骑马后前B")
			wd(cp + OBJ64_ActFunc, 0x1804)
			ww(cp + OBJ94_FlagForAi, 8)
		end
		RTS()
		return 0
	end

	sr("d0", 0)
	local actstatd = rb(cp + OBJ2B_ActStatD )									--1EE22
	if actstatd == 0 then	--00待机1EE32 02后退1EEE6
		JMP_1EE32(cp)
		return 0
	else
		sr("pc", 0x1EE22) return 1
	end
end

JMP_1EE32 = function(cp)
	local back = gr("d2")
	local forward = gr("d3")
	local input = gr("d6")
	if bit.btst(input,back) ~= 0 then
--		print("骑马后退")
		wb(cp + OBJB7_BackLeft, 0x3C)
		wb(cp + OBJ2B_ActStatD, 2)
		sr("a4", 0x70EE6) SUB_247C(cp)
		sr("a3", 0x6FB66) SUB_258A(cp)
		call(0x1EF2C)
		RTS()
		return 0
	end

	local inputnew = rb(cp + OBJA2_InputNew)
	if bit.btst(inputnew,IPT4_BtnA) ~= 0 then									--1EE5E
		sr("a3", 0x6FD8A) SUB_258A(cp)
		local rkey1 = rbs(cp + OBJB0_RKey1)
		if rkey1 < 0 then														--1EE70
			print("骑马后前A")
			wb(cp + OBJ1F_FlyLeft, 0)
			wd(cp + OBJ64_ActFunc, 0x1812)
			ww(cp + OBJ94_FlagForAi, 8)
			ww(cp + OBJ2A_ActStatC, 0x1000)
			RTS()
			return 0
		end

		local quicka = rb(cp + OBJB4_QuickA)									--1EE8C
		quicka = bit.bnot(quicka)
		quicka = bit.band(quicka, 0x1F)
		if quicka == 0 then													--1EE96
			print("骑马快拳0")
			call(0x60A8) SUB_1702(cp)
			ww(cp + OBJ7A_AtkType, 0x0130)
			ww(cp + OBJ2A_ActStatC, 0x0C00)
			ww(cp + OBJ94_FlagForAi, 0x0C)
			sr("a4", 0x70E24) SUB_247C(cp)
			RTS()
			return 0
		end

		ww(cp + OBJ2A_ActStatC, 0x0400)											--1EEBC
		JSR_1F418(cp)
		return 0
	end

	local stk = bit.band(input, 0x0F)											--CALL 1BBCC 1F5FA
	local dir = T_STK2DIR[stk + 1]
	if dir == DIRF_NONE then													--1EECE
		sr("a3", 0x6F9F0) SUB_258A(cp)
		RTS()
		return 0
	end

	sr("d0", dir)
	SUB_112E(cp)
	SUB_257E(cp) SUB_1E3C(cp)													--1EEDA
	RTS()
	return 0
end

--M20006------------------------------------------------------------------------------

JSR_1F0CA = function(cp)
	sr("d0", 0)
	local actstatd = rb(cp + OBJ2B_ActStatD )
	if actstatd == 0 then
		JMP_1F0E2(cp)
	end

	if actstatd == 2 then
		JMP_1F116(cp)
	end

	if actstatd == 4 then
		JMP_1F18A(cp)
	end

	if actstatd == 6 then
		JMP_1F1FA(cp)
	end

	if actstatd == 8 then
		JMP_1F218(cp)
	end

	if actstatd == 0x0A then
		JMP_1F22C(cp)
	end
	return 0
end

JMP_1F0E2 = function(cp)
	wb(cp + OBJA4_NewBtnA, 0)
	wb(cp + OBJ2B_ActStatD, 2)
	wb(cp + OBJ1F_FlyLeft, 0x0A)
	ww(cp + OBJ94_FlagForAi, 6)
	ww(cp + OBJ7A_AtkType, 0x100)
	SUB_1702(cp)
	sr("a4", 0x70F94) SUB_247C(cp)
	sr("a3", 0x6F9F0) SUB_258A(cp)
	RTS()
	return 0
end

JMP_1F116 = function(cp)
	local xspd = 0
	local yacc = 0
	local inputnew = rb(cp + OBJA2_InputNew)
	if bit.btst(inputnew,IPT5_BtnB) ~= 0 then									--1F11A
		print("骑马旋刀")
		wb(cp + OBJ2B_ActStatD, 0x0A)
		wd(cp + OBJ64_ActFunc, 0x1F25A)
		wb(cp + OBJBC_BC, -1)
		sr("a4", 0x70EF4) SUB_247C(cp)
		local ani34 = rws(cp + OBJ32_Ani3)
		ww(cp + OBJ7A_AtkType, ani34)
		SUB_1702(cp)
		sr("a3", 0x6FC80)
		xspd = 0x300
		yacc = -0x20
	else
		local flyleft = rb(cp + OBJ1F_FlyLeft)
		flyleft = flyleft - 1
		wb(cp + OBJ1F_FlyLeft, flyleft)
		if flyleft == 0 then 													--1F154
			wb(cp + OBJ2B_ActStatD, 4)
			sr("a3", 0x6FBA6)
			xspd = 0x480
			yacc = -0x30
		else
			RTS()
			return 0
		end
	end

	local flip = rb(cp + OBJ16_Flip)
	if flip ~= 0 then															--1F16C
		xspd = -xspd
		yacc = -yacc
	end

	ww(cp + OBJ40_XSpd, xspd)
	ww(cp + OBJ42_XAcc, 0)
	ww(cp + OBJ4A_YAcc, yacc)
	wb(cp + OBJ31_Ani2, 4)
	SUB_258A(cp)
	RTS()
	return 0
end

JMP_1F18A = function(cp)
	local snddelay = rb(cp + OBJ9A_SndDelay)
	if snddelay == 0 then														--1F18E
		wb(cp + OBJ9A_SndDelay, 0x19) call(0x5F5A)
	end

	local newbtna = rb(cp + OBJA4_NewBtnA)
	if newbtna ~= 0 then														--1F19A
		print("骑马刺刀")
		local yacc = rws(cp + OBJ4A_YAcc)
		yacc = yacc * 0.5
		ww(cp + OBJ42_XAcc, yacc)
		wb(cp + OBJ2B_ActStatD, 8)
		ww(cp + OBJ7A_AtkType, 0x110)
		wd(cp + OBJ64_ActFunc, 0x616C)
		SUB_1702(cp)
		sr("a4", 0x70DBE) SUB_247C(cp) call(0x5E9E)
		sr("a3", 0x6FD1A) SUB_258A(cp)
	else
		SUB_10D2(cp) SUB_257E(cp)
		local mani34 = rws(cp + OBJ5A_MAni3)
		if mani34 ~= 0 then													--1F1E6
			JMP_1F1E8(cp)
			return 0
		end
	end
	RTS()
	return 0
end

JMP_1F1E8 = function(cp)
	local yacc = rws(cp + OBJ4A_YAcc)
	ww(cp + OBJ42_XAcc, yacc)
	wb(cp + OBJ2B_ActStatD, 6)
	call(0x616C)
	RTS()
	return 0
end

JMP_1F1FA = function(cp)
	SUB_10D2(cp) SUB_257E(cp)

	local mani34 = rws(cp + OBJ5A_MAni3)
	if mani34 < 0 then															--1F206
		JMP_1F208(cp)
		return 0
	end
	RTS()
	return 0
end

JMP_1F208 = function(cp)
	ww(cp + OBJ2A_ActStatC, 0)
	sr("a4", 0x70ED8) SUB_247C(cp)
	RTS()
	return 0
end

JMP_1F218 = function(cp)
	SUB_10D2(cp) SUB_24BE(cp) SUB_257E(cp)
	local mani34 = rws(cp + OBJ5A_MAni3)
	if mani34 < 0 then															--1F228
		JMP_1F208(cp)
		return 0
	end
	RTS()
	return 0
end

JMP_1F22C = function(cp)
	local snddelay = rb(cp + OBJ9A_SndDelay)
	if snddelay == 0 then														--1F230
		wb(cp + OBJ9A_SndDelay, 0x19) call(0x5F5A)
	end
	SUB_10D2(cp) SUB_257E(cp) SUB_24BE(cp) SUB_1702(cp)

	local ani34 = rws(cp + OBJ32_Ani3)
	ww(cp + OBJ7A_AtkType, ani34)
	local mani34 = rws(cp + OBJ5A_MAni3)
	if mani34 > 0 then															--1F256
		JMP_1F1E8(cp)
		return 0
	end
	RTS()
	return 0
end

--M20004------------------------------------------------------------------------------

JSR_1F418 = function(cp)
	sr("d0", 0)
	local actstatd = rb(cp + OBJ2B_ActStatD )
	if actstatd == 0 then	--00出拳3段1F428 02出拳后1F474
		JMP_1F428(cp)
	end

	if actstatd == 2 then
		JMP_1F474(cp)
	end
end

JMP_1F428 = function(cp)
	local input = rb(cp + OBJA0_Input)
	input = bit.band(input, 0x0C)
	wb(cp + OBJB5_UpDown, input)

	local comboleft = rb(cp + OBJAD_ComboLeft)
	if comboleft == 0 then														--1F438
		wb(cp + OBJAE_ComboLev, 0)
	end

	JMP_1F43E(cp)
	return 0
end

JMP_1F43E = function(cp)
	wb(cp + OBJ2B_ActStatD, 2)
	wb(cp + OBJ94_FlagForAi, 0x0A)
	SUB_1702(cp)
	local combolev = rb(cp + OBJAE_ComboLev)
	ww(cp + OBJ7A_AtkType, 0xA0 + combolev * 0x10)
	sr("a4", 0x70C66) SUB_2466(cp)
	sr("d0", combolev) call(0x1EB7E)
	RTS()
	return 0
end

JMP_1F474 = function(cp)
	SUB_2470(cp) SUB_257E(cp)
	local ani34 = rws(cp + OBJ32_Ani3)
	if ani34 ~= 0 then															--1F480
		if ani34 >= 0 then														--1F482
			local forward = IPT0_RIGHT
			local flip = rb(cp + OBJ16_Flip)
			if flip ~= 0 then													--1F48A
				forward = IPT1_LEFT
			end

			local input = rb(cp + OBJA0_Input)
			if bit.btst(input,forward) == 0 then								--1F492
				RTS()
				return 0
			end

			local stk = bit.band(input, 0x0F)
			local dir = T_STK2DIR[stk + 1]
			if dir ~= DIRF_NONE then											--1F49C
				sr("d0", dir)
				SUB_112E(cp)
				SUB_1E3C(cp)
				RTS()
				return 0
			end
		end
		local quicka = rb(cp + OBJB4_QuickA)
		quicka = bit.bnot(quicka)
		quicka = bit.band(quicka, 0x1F)
		if quicka ~= 0 then													--1F4B0
			local comboleft = rb(cp + OBJAD_ComboLeft)
			if comboleft ~= 0 then												--1F4B8
				wb(cp + OBJAD_ComboLeft, 0)
				local newbtna = rb(cp + OBJA4_NewBtnA)
				if newbtna ~= 0 then 											--1F4C2
					local combolev = rb(cp + OBJAE_ComboLev)
					wb(cp + OBJAE_ComboLev, combolev + 1)
					JMP_1F43E(cp)
					return 0
				end
			end
			sr("a3", 0x6F9F0) SUB_258A(cp)
			ww(cp + OBJ2A_ActStatC, 0)
		else
			print("骑马快拳2")
			call(0x1EE98)
		end
	end
	RTS()
	return 0
end
--------------------------------------------------------------------------------
for game in ipairs(profile) do
	local g = profile[game]
	g.number_players = g.number_players or 2
end


emu.update_func = emu.registerafter or emu.registerbefore
emu.registerfuncs = memory.registerexec
if not emu.registerfuncs then
	print("Warning: This requires FBA-rr 0.0.7+ or MameLua.")
end

--------------------------------------------------------------------------------
pd = function()
	print(di)
end

call = function(GameAddr)
	memory.call("pc", GameAddr)
end

RTS = function()
	local sp = gra("a7")
	local RtsAddr = rd(sp)
	sr("pc", RtsAddr)
	sr("a7", sp + 4)
end

SyncSP = function(RtsAddr)
	local newsp = gra("a7") -4
	sr("a7", newsp)
	wd(newsp, RtsAddr)
end

--[[Luacall = function(LuaFunc, RtsAddr)
	SyncSP(RtsAddr)
	local rt = LuaFunc()
	RTS()
	return rt
end--]]

changechar = function(cp)
	local sta_cur = rbs(Input_Start)											--读取当前开始键状态
	if sta_cur == 0 then return end											--如果没人按就结束处理
	local sta_pre = rbs(Input_Start + 1)										--读取前次开始键状态
	local player_id = getplayer_id(cp)

	if (bit.btst(sta_cur,player_id) == 1 and bit.btst(sta_pre,player_id) == 0 and rws(cp + OBJ2A_ActStatC) == 0) then	--当前玩家在按开始，并且前次没按，并且状态是待机
		emu.message("Player" .. player_id + 1 .. " hit start and idle")
		local charid = rws(cp + OBJ20_CharId) + 1								--读取玩家的角色ID
		if charid > 4 then charid =0 end

		ww(cp + OBJ20_CharId, charid)											--写入新的角色ID
		ww(cp + OBJ8E_Dismount, charid * 4)										--写入新的下马动画ID

		if (rbs(cp + OBJ63_Mount)) == 0 then									--如果步行
			ww(cp + OBJA0_Input, 0x0C00)										--用于步行中触发 更新动画
		else
			ww(cp + OBJA0_Input, 0x1000)										--用于骑乘中触发 攻击
		end
	end
end

getplayer_id = function(cp)
	for i =0,2 do																--循环匹配当前玩家ID
		if cp == Player_Base + (OBJE0_Len * i) then return(i) end
	end
end

SUB_10BC = function(cp)
	local yspd = rws(cp + OBJ48_YSpd)
	local yacc = rws(cp + OBJ4A_YAcc)
	ww(cp + OBJ48_YSpd, yspd + yacc)

	local y = rds(cp + OBJ0C_Y)
	wd(cp + OBJ0C_Y, y + yspd * 0x100)
end

SUB_10D2 = function(cp)
	local xspd = rws(cp + OBJ40_XSpd)
	local xacc = rws(cp + OBJ42_XAcc)
	ww(cp + OBJ40_XSpd, xspd + xacc)

	local x = rds(cp + OBJ04_X)
	wd(cp + OBJ04_X, x + xspd * 0x100)
end

SUB_112E = function(cp)														--处理位移
	local dircur = bit.band(gr("d0"), 0x7)
	local spdlist = rd(cp + OBJ36_SpdList)
	local xspd = rws(spdlist + dircur * 4)
	local zspd = rws(spdlist + dircur * 4 + 2)

	local mount = rb(cp + OBJ63_Mount)
	if mount == 0 then
		local actstat5 = rb(cp + OBJXX_ActStat5)
		if actstat5 == 4 then
			xspd = xspd * 2
			zspd = zspd * 2
		end
	end

	local x = rds(cp + OBJ04_X)
	local z = rds(cp + OBJ08_Z)
	wd(cp + OBJ04_X, x + xspd * 0x100)
	wd(cp + OBJ08_Z, z + zspd * 0x100)
end

SUB_1702 = function(cp)
	local atkcount = rb(A5 +0x1F9)
	atkcount = atkcount + 1
	wb(A5 +0x1F9, atkcount)
	wb(cp + OBJA9_AtkCount, atkcount)
end

SUB_1766 = function(cp)
	local a5__1c6d = rb(A5 - 0x1C6D)
	if bit.btst(a5__1c6d, 0) == 0 then											--176C
		local flash = rb(cp + OBJB9_Flash)
		if flash ~= 0 then														--1772
			flash = flash - 1
			wb(cp + OBJB9_Flash, flash)
			if flash == 0 then													--1778
				ww(cp, 0x0101)
				wb(cp + OBJ17_Pal, 0)
			else
				local a5__1ccc = rws(A5 - 0x1CCC)
				a5__1ccc = bit.band(a5__1ccc, 3)
				if a5__1ccc ~= 0 then											--178C
					a5__1ccc = a5__1ccc - 2
					if a5__1ccc >= 0 then										--1790
						if a5__1ccc ~= 0 then									--1792
							wb(cp + OBJ17_Pal, 0)
						else
							wb(cp + OBJ17_Pal, 0x8B)
						end
					else
						wb(cp + OBJ01_Show, 1)
					end
				else
					wb(cp + OBJ01_Show, 0)
				end
			end
		end
	end
end

SUB_1B02 = function(cp)														--处理保险按键
	local life = rws(cp + OBJ82_Life)
	if life > 0 then
		local inputnew = rb(cp + OBJA2_InputNew)
		if bit.btst(inputnew,IPT5_BtnB) ~= 0 then
			local input = rb(cp + OBJA0_Input)
			if bit.btst(input,IPT4_BtnA) ~= 0 then
				call(0x1BB0)
				local objhead = rb(cp)
				wb(cp, bit.bset(objhead, 7))
				wb(cp + OBJBC_BC, 0)
				wd(cp + OBJ64_ActFunc, 0x1F25A)
				SUB_1702(cp)

				local charid = rw(cp + OBJ20_CharId)
				sr("d0", charid + 0x0F)
				sr("d1", 0x90) sr("d3", 0) sr("d4", 7) sr("d5", 8)
				call(0x5BE0)

				local d4
				local mount = rb(cp + OBJ63_Mount)
				if mount ~= 0 then
					print("骑马保险")
					d4 = charid + 5
					sr("a3", 0x6FD8A) SUB_258A(cp)
				else
					print("步行保险")
					d4 = charid
				end
				local a4 = rd(0x1B88 + d4 * 4)
				sr("a4", a4) SUB_247C(cp)

				ww(cp + OBJ68_HitObj1, 0)
				ww(cp + OBJ76_FanTan, 0)
				ww(cp + OBJ7A_AtkType, 0x90)
				wd(cp + OBJ28_ActStatA, 0x02000200)
				RTS()
				return 2
			end
		end
	end
	return 0
end

SUB_1E3C = function(cp)
	local a5__60 = rb(A5 - 0x60)
	if a5__60 == 0 then														--1E40
		local zcam = rws(A5 - 0x570)
		local zmin = zcam + 0x14
		local zmax = zcam + 0xA0
		local z = rws(cp + OBJ08_Z)
		if zmin > z then														--1E4E
			ww(cp + OBJ08_Z, zmin)
		else
			if zmax < z then													--1E5E
				ww(cp + OBJ08_Z, zmax)
			end
		end
	end
end

SUB_1E62 = function(cp)
	local a5__60 = rb(A5 - 0x60)
	if a5__60 == 0 then														--1E66
		local x = rws(cp + OBJ04_X)
		local xcam = rws(A5 - 0x574)
		local xoffs = x - xcam
		if xoffs < 0x20 then													--1E76
			ww(cp + OBJ04_X, xcam + 0x20)
			sr("d1", 1)
		else
			if xoffs > 0x160 then												--1E88
				ww(cp + OBJ04_X, xcam + 0x160)
				sr("d1", 1)
			end
		end
	else
		sr("d1", 0)
	end
end

SUB_1EC8 = function(cp)														--检测马上后前A
	local rkey1 = rbs(cp + OBJB0_RKey1)
	local rkey1left = rb(cp + OBJB1_RKey1Left)
	if rkey1 >= 0 then
		local input = rb(cp + OBJA0_Input)
		if rkey1 == 0 then
			local back = IPT1_LEFT
			local flip = rb(cp + OBJ16_Flip)
			if flip ~= 0 then
				back = IPT0_RIGHT
			end
			if bit.btst(input,back) == 0 then
				if rkey1left ~= 6 then
					wb(cp + OBJB1_RKey1Left, 0)
				else
					local actstata234 = rd(cp + OBJ28_ActStatA)
					if actstata234 == 0x02000000 then
						wb(cp + OBJB0_RKey1, 2)
						call(0x0F98)
						local rnd = gr("d0")
						rnd = bit.band(rnd,0x1F)
						rkey1left = rb(0x1F5C + rnd)
						wb(cp + OBJB1_RKey1Left, rkey1left)
					end
				end
			else
				if rkey1left ~= 6 then
					wb(cp + OBJB1_RKey1Left, rkey1left + 1)
				end
			end
		else
			input = bit.band(input, 0x0F)
			local forward = STK2_LEFT
			local flip = rb(cp + OBJ16_Flip)
			if flip == 0 then
				forward = STK1_RIGHT
			end
			if input ~= forward then
				rkey1left = rkey1left - 1
				wb(cp + OBJB1_RKey1Left, rkey1left)
				if rkey1left == 0 then
					wb(cp + OBJB0_RKey1, 0)
				end
			else
				wb(cp + OBJB1_RKey1Left, 0x0C)
				wb(cp + OBJB0_RKey1, -1)
				print("后前搓招完成")
			end
		end
	else
		rkey1left = rkey1left - 1
		wb(cp + OBJB1_RKey1Left, rkey1left)
		if rkey1left == 0 then
			wb(cp + OBJB0_RKey1, 0)
		end
	end
end

SUB_1F7C = function(cp)														--检测步行下上拳
	local rkey1 = rbs(cp + OBJB0_RKey1)
	local rkey1left = rb(cp + OBJB1_RKey1Left)
	if rkey1 >= 0 then															--1F80 > 1FEA
		local input = rb(cp + OBJA0_Input)
		if rkey1 == 0 then														--1F84 > 1FC4
			if bit.btst(input,IPT2_DOWN) == 0 then								--1F90 > 1FA0
				if rkey1left ~= 4 then											--1F98 > 1FAE
					wb(cp + OBJB1_RKey1Left, 0)
				else
					wb(cp + OBJB0_RKey1, 2)
					call(0x0F98)
					local rnd = gr("d0")
					rnd = bit.band(rnd,0x1F)
					rkey1left = rb(0x1F5C + rnd)
					wb(cp + OBJB1_RKey1Left, rkey1left)
				end
			else
				if rkey1left ~= 4 then											--1FA6 > 1FAC
					wb(cp + OBJB1_RKey1Left, rkey1left + 1)
				end
			end
		else
			input = bit.band(input, 0x0F)
			if input ~= STK8_UP then											--1FD0 > 1FDE
				rkey1left = rkey1left - 1
				wb(cp + OBJB1_RKey1Left, rkey1left)
				if rkey1left == 0 then											--1FD6 > 1FDC
					wb(cp + OBJB0_RKey1, 0)
				end
			else
				wb(cp + OBJB1_RKey1Left, 0x0C)
				wb(cp + OBJB0_RKey1, -1)
				print("下上搓招完成")
			end
		end
	else
		rkey1left = rkey1left - 1
		wb(cp + OBJB1_RKey1Left, rkey1left)
		if rkey1left == 0 then													--1FEE > 1FF6
			wb(cp + OBJB0_RKey1, 0)
		else
			local inputnew = rb(cp + OBJA2_InputNew)
			if bit.btst(inputnew,IPT4_BtnA) ~= 0 then							--2000 > 2006
				wb(cp + OBJA7_DownUpA, -1)
			end
		end
	end
end

RoteKey = function(cp, OBJ_ROTESTAT, OBJ_ROTELEFT, KEY1, KEY2, FLIP1, FLIP2, ACTSTAT, TIME1, TIME2)
	local rotestat = rbs(cp + OBJ_ROTESTAT)
	local roteleft = rb(cp + OBJ_ROTELEFT)
	if rotestat < 0 then
		roteleft = roteleft - 1
		wb(cp + OBJ_ROTELEFT, roteleft)
		if roteleft == 0 then
			wb(cp + OBJ_ROTESTAT, 0)
		end
	else
		local input = rb(cp + OBJA0_Input)
		input = bit.band(input, 0x0F)
		if rotestat == 0 then
--			if FLIP1 == nil then FLIP1 = false end
			if FLIP1 then
				local flip = rb(cp + OBJ16_Flip)
				if flip ~= 0 then
					KEY1 = bit.band(KEY1, 0x0C) + (3 - bit.band(KEY1, 3))
				end
			end
			if TIME1 == nil then TIME1 = 4 end
			if input ~= KEY1 then
				if roteleft ~= TIME1 then
					wb(cp + OBJ_ROTELEFT, 0)
				else
--					if ACTSTAT == nil then ACTSTAT = 0 end
					if ACTSTAT == nil or ACTSTAT == 0 or rd(cp + OBJ28_ActStatA) == ACTSTAT then
						wb(cp + OBJ_ROTESTAT, 2)
						call(0x0F98)
						local rnd = gr("d0")
						rnd = bit.band(rnd,0x1F)
						roteleft = rb(0x1F5C + rnd)
						wb(cp + OBJ_ROTELEFT, roteleft)
					end
				end
			else
				if roteleft ~= TIME1 then
					wb(cp + OBJ_ROTELEFT, roteleft + 1)
				end
			end
		else
			local KEY2Org = KEY2
--			if FLIP2 == nil then FLIP2 = false end
			if FLIP2 then
				local flip = rb(cp + OBJ16_Flip)
				if flip ~= 0 then
					KEY2 = bit.band(KEY2, 0x0C) + (3 - bit.band(KEY2, 3))
				end
			end
			if input ~= KEY2 then
				roteleft = roteleft - 1
				wb(cp + OBJ_ROTELEFT, roteleft)
				if roteleft == 0 then
					wb(cp + OBJ_ROTESTAT, 0)
				end
			else
				if TIME2 == nil then TIME2 = 0x0C end
				wb(cp + OBJ_ROTELEFT, TIME2)
				wb(cp + OBJ_ROTESTAT, -1)
				print(KEY1 .. "到" .. KEY2Org .. "搓招完成")
			end
		end
	end
end

SUB_2466 = function(cp)
	local combolev = gr("d0")
	local ani = gra("a4")
	local offs = rws(ani + combolev)
	sr("a4", ani + offs)
	SUB_247C(cp)
end

SUB_2470 = function(cp)
	local anileft = rws(cp + OBJ34_AniLeft)
	anileft = anileft - 1
	ww(cp + OBJ34_AniLeft, anileft)

	if anileft <= 0 then														--2474
		local aninext = rd(cp + OBJ2C_AniNext)
		sr("a4", aninext)
		SUB_247C(cp)
	end
end

SUB_247C = function(cp)
	local ani = gra("a4")
	local spr = rd(ani)
	wd(cp + OBJ12_Spr, spr)

	local ani1234 = rd(ani + 4)
	wd(cp + OBJ30_Ani1, ani1234)

	local anileft = rws(ani + 8)
	local aninext
	if anileft >= 0 then														--2484
		aninext = ani + 0xA
	else
		anileft = bit.band(anileft, 0x7FFF)
		aninext = rd(ani + 0xA)
	end

	ww(cp + OBJ34_AniLeft, anileft)
	wd(cp + OBJ2C_AniNext, aninext)
	local bbox = rw(spr - 2)
	local vbox = rw(spr - 6)
	local abox = rw(spr - 4)
	ww(cp + OBJ6C_BeThrowBox, bbox)
	ww(cp + OBJ6E_VulBox, vbox)
	ww(cp + OBJ70_AtkBox, abox)
end

SUB_24BE = function(cp)
	local anileft = rws(cp + OBJ34_AniLeft)
	anileft = anileft - 1
	ww(cp + OBJ34_AniLeft, anileft)

	if anileft <= 0 then														--24C2
		local aninext = rd(cp + OBJ2C_AniNext)
		sr("a4", aninext)
		SUB_247C(cp)

		local ani1 = rbs(cp + OBJ30_Ani1)
		if ani1 < 0 then														--24FE 2510
			local actfunc = rd(cp + OBJ64_ActFunc)
			if actfunc ~= 0 then												--2516
				sr("a4", actfunc)
				call(actfunc)
				sr("d0", 0)
			end
		end
	end
end

SUB_257E = function(cp)
	local manileft = rws(cp + OBJ5C_MAniLeft)
	manileft = manileft - 1
	ww(cp + OBJ5C_MAniLeft, manileft)

	if manileft <= 0 then														--2474
		local maninext = rd(cp + OBJ54_MAniNext)
		sr("a3", maninext)
		SUB_258A(cp)
	end
end

SUB_258A = function(cp)
	local mani = gra("a3")
	local mspr = rd(mani)
	wd(cp + OBJ50_MSpr, mspr)

	local mountoffs = rw(mani + 4)
	ww(cp + OBJ1A_MountOffs, mountoffs)
	local mani34 = rw(mani + 6)
	ww(cp + OBJ5A_MAni3, mani34)

	local manileft = rws(mani + 8)
	local maninext
	if manileft >= 0 then														--2598
		maninext = mani + 0xA
	else
		manileft = bit.band(manileft, 0x7FFF)
		maninext = rd(mani + 0xA)
	end

	ww(cp + OBJ5C_MAniLeft, manileft)
	wd(cp + OBJ54_MAniNext, maninext)
end

SUB_269E = function(cp)
	wb(A5 - 0x7FAC, 0)
	local a5__60 = rb(A5 - 0x60)
	if a5__60 == 0 then														--26A6
		local zmax = rws(A5 - 0x4E2) + 0x100
		local zmin = rws(A5 - 0x4E0)
		local z = rws(cp + OBJ08_Z)
		if zmax >= z and zmin <= z then										--26B6 26C2
			local x = rws(cp + OBJ04_X)
			local xmin = rws(A5 - 0x55A)
			local xmax = rws(A5 - 0x55C)
			if x < xmin and x > xmax then										--26CE 26EC
				local xcam = rws(A5 - 0x574)
				local xcammax = xcam + 0x1FF
				if x < xcammax then											--26F8
					ww(A5 - 0x7FAE, xmax)
					sr("d6", 0)
					sr("d0", xmax)
					sr("d1", z)
					call(0x2784)
					local d1 = grws("d1")
					ww(cp + OBJ08_Z, z + d1)

					local d6 = grws("d6")
					if d6 < 0 then												--2714
					end
				end
			end
		end
	end

end

SUB_1BBCC = function(cp)														--取玩家方向 同1F5FA
	local input = rb(cp + OBJA0_Input)
	local stk = bit.band(input, 0x0F)
	local dir = T_STK2DIR[stk + 1]
	return dir
end

SUB_1BBEA = function(cp)														--检测转身
	local flip = rb(cp + OBJ16_Flip)
	local input = rb(cp + OBJA0_Input)
	if flip ~= 0 then return bit.btst(input,IPT0_RIGHT) end
	return bit.btst(input,IPT1_LEFT)
end

-- functions referenced in the modules

gra = function(register)
	return bit.band(memory.getregister("m68000." .. register), 0xFFFFFF)	--裁剪到24位地址
end

gr = function(register)
	return memory.getregister("m68000." .. register)
end

grb = function(register)
	return bit.band(memory.getregister("m68000." .. register), 0xFF)
end

grw = function(register)
	return bit.band(memory.getregister("m68000." .. register), 0xFFFF)
end

grs = function(register)
	local data = memory.getregister("m68000." .. register)
	if data >= 0x80000000 then
		data = data - 0x100000000
	end
	return data
end

grbs = function(register)
	local data = bit.band(memory.getregister("m68000." .. register), 0xFF)
	if data >= 0x80 then
		data = data - 0x100
	end
	return data
end

grws = function(register)
	local data = bit.band(memory.getregister("m68000." .. register), 0xFFFF)
	if data >= 0x8000 then
		data = data - 0x10000
	end
	return data
end



sr = function(register, data)
	return memory.setregister("m68000." .. register, data)
end

srb = function(register, data)
	local reg = memory.getregister("m68000." .. register)
	data = bit.band(reg, 0xFFFFFF00) + bit.band(data, 0xFF)
	return memory.setregister("m68000." .. register, data)
end

srw = function(register, data)
	local reg = memory.getregister("m68000." .. register)
	data = bit.band(reg, 0xFFFF0000) + bit.band(data, 0xFFFF)
	return memory.setregister("m68000." .. register, data)
end



extb2w = function(data)
	tmp=bit.band(data, 0xFF)
	if tmp >= 0x80 then return tmp + 0xFF00 end
	return tmp
end

extb2d = function(data)
	tmp=bit.band(data, 0xFF)
	if tmp >= 0x80 then return tmp + 0xFFFFFF00 end
	return tmp
end

extw2d = function(data)
	tmp=bit.band(data, 0xFFFF)
	if tmp >= 0x8000 then return tmp + 0xFFFF0000 end
	return tmp
end

extw2a = function(data)
	tmp = bit.band(data, 0xFFFF)
	if tmp >= 0x8000 then return tmp + 0xFF0000 end
	return tmp
end



moveb = function(Dst, Low8)
	return bit.band(Dst, 0xFFFFFF00) + bit.band(Low8, 0xFF)
end

movew = function(Dst, Low16)
	return bit.band(Dst, 0xFFFF0000) + bit.band(Low16, 0xFFFF)
end

any_true = function(condition)
	for n = 1, #condition do
		if condition[n] == true then return true end
	end
end



bit.btst = function(value, bit_number)
	return bit.band(bit.rshift(value, bit_number), 1)
end

bit.bset = function(value, bit_number)
	return bit.bor(value, bit.lshift(1, bit_number))
end

bit.bclr = function(value, bit_number)
	return bit.band(value, bit.bnot(bit.lshift(1, bit_number)))
end

--------------------------------------------------------------------------------


emu.update_func( function()
	globals.register_count = (globals.register_count or 0) + 1
	globals.last_frame = globals.last_frame or fc()
--	if globals.register_count == 1 then
--	end
	if globals.last_frame < fc() then
		globals.register_count = 0
	end
	globals.last_frame = fc()
end)


--------------------------------------------------------------------------------
-- hotkey functions

input.registerhotkey(1, function()
	emu.message(("activated" or "deactivated") .. " blank screen mode")
end)


input.registerhotkey(2, function()
	emu.message(("showing" or "hiding") .. " object axis")
end)


input.registerhotkey(3, function()
	emu.message(("showing" or "hiding") .. " hitbox axis")
end)


input.registerhotkey(4, function()
	emu.message(("showing" or "hiding") .. " pushboxes")
end)


--------------------------------------------------------------------------------
-- initialize on game startup

local initialize_bps = function()
	for _, pc in ipairs(globals.breakpoints or {}) do
		memory.registerexec(pc, nil)
	end
	for _, addr in ipairs(globals.watchpoints or {}) do
		memory.registerwrite(addr, nil)
	end
	globals.breakpoints, globals.watchpoints = {}, {}
end


local initialize_buffers = function()
	buffer = {}
end


local whatgame = function()
	print()
	game = nil
	initialize_bps()
	initialize_buffers()
	for _, module in ipairs(profile) do
		if emu.romname() == module.game or emu.parentname() == module.game then
			print("Hacking " .. emu.gamename())
			game = module
			if not emu.registerfuncs then
				return
			end
			for _, bp in ipairs(game.breakpoints or {}) do
				if bp.no_background and not globals.no_background then
					break
				end
				local pc = bp.base + (bp[emu.romname()] or game.clones[emu.romname()] or 0)
				memory.registerexec(pc, bp.func)
				table.insert(globals.breakpoints, pc)
			end
			return
		end
	end
	print("unsupported game: " .. emu.gamename())
end


savestate.registerload(function()
	initialize_buffers()
end)


emu.registerstart(function()
	whatgame()
end)
