https://github.com/zengfr/romhack
https://gitee.com/zengfr/romhack
"use strict"

var paletteAddress = 0xB7A52;		// per level * scen = 8 * 4
var paletteAddressIndex1 = 0x8E8E;	// for sprite, per level * scene = 8 * 10?
var paletteAddressIndex2 = 0xBBA52;	// for scroll layer 1, seems fixed for HUD
var paletteAddressIndex3 = 0x8AE0;	// for scroll layer 2
var paletteAddressIndex4 = 0x8C52;

// load pal from rom and oveewrite old
function loadRomPal() {
	var bf = new bytebuffer(romFrameData);
	var bf2 = new bytebuffer(romFrameData);
	
	
	var paletteIndex = bf.getInt(paletteAddressIndex1 + (palset * 4 + palset2) * 4);	// palset = level
	var paletteIndex2 = paletteAddressIndex2;
	var paletteIndex3 = bf.getInt(paletteAddressIndex3 + (palset * 4 + palset2) * 4);	
	var paletteIndex4 = bf.getInt(paletteAddressIndex4 + (palset * 4 + palset2) * 4);	
	labelInfo2.innerText = 'palset:' + palset +   ' palset2:' + palset2 + ' addr:' + paletteIndex.toString(16).toUpperCase();
	
	// load sprite palette
	bf.position(paletteIndex);
	for(let i = 0;i < 32;i++) {
		let p = bf.getShort();
		bf2.position(paletteAddress + p * 32);
		loadRomPalCps1(bf2, i << 4)
	}

	// load layer 2 & 3 palette
	bf.position(paletteIndex2);
	for(let i = 0;i < 32;i++) {
		loadRomPalCps1(bf, (i << 4) + 16 * 32)
	}
	
	// load layer 2 & 3 palette
	bf.position(paletteIndex3);
	for(let i = 0;i < 32;i++) {
		loadRomPalCps1(bf, (i << 4) + 2 * 16 * 32)
	}
	
	bf.position(paletteIndex4);
	for(let i = 0;i < 32;i++) {
		loadRomPalCps1(bf, (i << 4) + 3 * 16 * 32)
	}
	

	if(showPal)
		drawPal();
}
var showPal;

function movetoTile(tile) {
	curStartTile = tile;
	refresh()
}


var playerCB = [	// collision boxes groups for 4 players
	0x100000,0x100C00,0x101800,0x102400
];

var animAddressIndex = 0x0B7472;
var animAddress = [0x34892, 0x34B90, 0x34E7C, 0x56C38, 0x5708C, 0x57C20, 0x57D84, 0x577D2, 0x3906A, 0x3DAF8,
		0x3DD50, 0x4200E, 0x42386, 0x42516, 0x45706, 0x47244, 0x47A52, 0x718EE, 0x4837C, 0x49574, 0x4C90E,
		0x4DBA0, 0x4F4E4, 0x4FC22, 0x50DFA, 0x5727A, 0x6F8A6, 0x57682,
		0x9E41C, 0x9EDFE, 0x9F094, 0x9F252, 0x9EACC];

// show object animation from rom address
function drawAnimation() {
//	let addr = animAddress[curAnim];
	var bf = new bytebuffer(romFrameData);
	let addr = bf.getInt(animAddressIndex + curAnim * 8);

	if(animTimer) {
		clearTimeout(animTimer)
		animTimer = null;
	}
//	let addr = animAddress[curAnim];
	var bf = new bytebuffer(romFrameData);
	
	let offset = bf.getShort(addr + curAnimAct * 2);
	if(offset == 0) {
		labelInfo.innerText = "EOF";
		return;
	}
	let startAddress = addr + offset;
	
	if(addr < 0x90000)	// obj
		loopDrawAnimation(startAddress, 0xA);
	else	// player
		loopDrawAnimation(startAddress, 0xC);

	labelInfo.innerText = 'addr:' + addr.toString(16).toUpperCase() + "/" + startAddress.toString(16).toUpperCase() + " off:"
			+ offset.toString(16).toUpperCase() + ' act:' + curAnimAct
			+ ' ' + curAnim + '/' + curAnimAct + "/" + (bf.getShort(addr)/2-1);
}
function loopDrawAnimation(addr, offset) {
	animTimer = null;

	var bf = new bytebuffer(romFrameData, addr);
	let fr = bf.getShort();

	if(fr < 0) {
		if(fr == -offset)
			return;	// stop loop & timer
		addr += fr;	// end with go back offset = fr, so loop
	} else {
		ctx.clearRect(0, 0, canvas.width, canvas.height);
		drawAnimationFrame(addr);
		addr += offset;
	}
	
	animTimer = setTimeout("loopDrawAnimation("+ addr +"," + offset+")", 200);
}

function drawAnimationFrame(addr, c = ctx, offx = 128, offy = 160, cbbase = 0x103000) {
	var bf = new bytebuffer(romFrameData, addr);
	let fr = bf.getShort();
	let fr2 = bf.getShort();
	let index = bf.getInt();	// ??
	let cb1 = bf.get();	// collision box attack
	let cb2 = bf.get();	// collision box defense
	if(fr < 0) {
		return fr;
	}
	
	let frame = romFrames[fr / 4];
	if(!frame) debugger
	drawRomFrameBase(frame, c, offx, offy);
	if(fr2 >= 0) {
		let frame2 = romFrames[fr2 / 4];
		if(!frame2) debugger
		drawRomFrameBase(frame2, c, offx, offy);
	}
	
	c.lineWidth = 1;
	// draw cross
	c.strokeStyle = 'purple';
	c.moveTo(offx - 30, offy);
	c.lineTo(offx + 30, offy);
	c.moveTo(offx, offy - 30);
	c.lineTo(offx, offy + 30);
	c.stroke();
	// draw collision box
	bf.position(cbbase + 0xc * cb1);
	c.strokeStyle = 'green';
	drawCB(bf, c, offx, offy)
	bf.position(cbbase + 0xc * cb2);
	c.strokeStyle = 'red';
	drawCB(bf, c, offx, offy)
}

function drawCB(bf, c = ctx, offx = 128, offy = 160) {
	let z = bf.getShort();
	let z2 = bf.getShort();
	let x = bf.getShort();
	let x2 = bf.getShort();
	let y = bf.getShort();
	let y2 = bf.getShort();
	c.strokeRect(x + offx, -y + offy, x2, -y2);
//	labelInfo.title = 'x=' + x + ',' + x2 + ' y=' + y + ',' + y2 + ' z=' + z + ',' + z2;
}

var mapData = [
	0x215AC, 0x215CA, 0x215E8, 0x215F2, 0x21610, 0x21624, 0x21642, 0x2166A
];
var bgAddress = [	// real map
	0x138FC8,0x139AC8,0x13BAC8,0x13BDC8,0x13DDC8,0x13FDC8,0x141DC8,0x143DC8
]
var mapTileAddress = [	// map tiles set for real map to index, by 2x2 unit
	0x162068,
	0x164198,
	0x166758,
	0x166C98,
	0x1683E8,
	0x16B3D8,
	0x16E188,
	0x172158,
//	0x108000,0x123A28,0x147DC8	???
];
var bg2Address = 0x177288;	// layer 2 background


let bgWidth = 32;
let bgHeight;	// default 8
let bgGrid = 2;		// each map tile contains 4 raw tiles?

// draw a background with tilemap
function drawbg() {
	var bf = new bytebuffer(romFrameData);
	var bf2 = new bytebuffer(romFrameData);
	var bf3 = new bytebuffer(romFrameData);
	// ctxBack.clearRect(0, 0, canvasBack.width, canvasBack.height);
	let addr = bgAddress[curbg];
	
//	labelInfo.innerText = 'address:' + bf.position().toString(16).toUpperCase()
//			+ ' 2x2tile address:' + mapTileAddress[curbg].toString(16).toUpperCase();
	var imageData = ctxBack.createImageData(gridWidth, gridHeight);
	
	bf3.position(mapData[curbg] + bgScene * 10);
	let width = bf3.get();
	let height = bf3.get();
	if(width > 20)
		width = 20;
	if(height > 10)
		height = 10;
	let v3 = bf3.getInt();
	bf3.position(v3);
	
	let startscr=0;
	for(let scr=0;scr<width * height;scr++) {
		let scrTile = bf3.getShort();
		if(scr<bgAddressSkip * height)
			continue;

		let scrx = Math.floor(startscr / height) * 256;
		let scry = (height - startscr % height - 1) * 256;
		
		bf.position(addr + scrTile * 64 * 2);

		for(let i=0;i<8;i++) {
			for(let j=0;j<8;j++) {
				let maptile=bf.getShort();
				bf2.position(maptile*4*4 + mapTileAddress[curbg]);
				for(let gi=0;gi<bgGrid;gi++)
					for(let gj=0;gj<bgGrid;gj++) {
						let tile = bf2.getShort();
						let flag = bf2.get();
						let pal = bf2.get();
						if(hideBackground) {	// hide background based on flag and color, 0x10 maybe the switch
							let hide = flag & 0xF;
							if((pal & 0x80) == 0)
								hide = 16;
							drawTilesBase(imageData, tile, 1, 1, (pal & 0x1F) + 0x40, 16, false, (pal & 0x40), (pal & 0x20), hide);
						} else 
							drawTilesBase(imageData, tile, 1, 1, (pal & 0x1F) + 0x40, 16, false, (pal & 0x40), (pal & 0x20));
						ctxBack.putImageData(imageData, scrx + (i*bgGrid+gi) * gridWidth, scry + (j*bgGrid+gj) * gridHeight);
					}
			}
		}
		startscr++;
	}
	

}


var map2Data = [
	0x2313E,	0x2315C,	0x2317A,	0x23184,	0x231A2,	0x231B6,	0x231D4,	0x231FC
];
let bg2Width = 16;
let bg2Height = 8;
function drawbg2() {
	var bf = new bytebuffer(romFrameData);
	var bf3 = new bytebuffer(romFrameData);

	bf3.position(map2Data[curbg] + bgScene * 10);
	let width = bf3.get();
	let height = bf3.get();
	if(width > 20)
		width = 20;
	if(height > 10)
		height = 10;
	let v3 = bf3.getInt();
	bf3.position(v3);
	
	// ctxBack.clearRect(0, 0, canvasBack.width, canvasBack.height);
	
	labelInfo.innerText = 'width:' + width + ' height:' + height;
	var imageData = ctxBack.createImageData(gridWidth*2, gridHeight*2);
	
	let startscr=0;
	for(let scr=0;scr<width * height;scr++) {
		let scrTile = bf3.getShort();
		if(scr<bgAddressSkip * height)
			continue;

		let scrx = Math.floor(startscr / height) * 256;
		let scry = (height - startscr % height - 1) * 256;
		
		bf.position(bg2Address + scrTile *128 * 2);
		
		for(let i=0;i<8;i++) {
			for(let j=0;j<8;j++) {

				let tile = bf.getShort();
				let flag = bf.get();
				let pal = bf.get();
				drawTilesBase(imageData, tile, 1, 1, (pal & 0x1F) + 0x60, 32, false, (pal & 0x40), (pal & 0x20));
				//drawTilesBase2(imageData, tile, (pal & 0x1F)+0x60, 32);
				ctxBack.putImageData(imageData, scrx + (i) * gridWidth*2, scry + (j) * gridHeight*2);

			}
		}
		startscr++
	}

}

function setMapTileStart(bgstart) {
	bgScene = bgstart;
	refresh();
}

var playerSpriteAddress = [0x163E, 0x164E, 0x165E, 0x166E, 0x168E];

var animPlayerAddr = [];
//draw anim by player 0-3
function drawRomFramePlayer() {
	var bf = new bytebuffer(romFrameData);
	for(let player = 0;player < 4;player++) {
		let type = bf.getInt(player * 4 + playerSpriteAddress[curPlayerType]);
		animPlayerAddr[player] = bf.getShort(type + curPlayerFrame * 2) + type;
		if(animPlayerAddr[player] == 0) {
			labelInfo.innerText = "EOF";
			return;
		}
	}

	loopDrawAnimationPlayer();
//
//	labelInfo.innerText = 'addr:' + addr.toString(16).toUpperCase() + "/" + startAddress.toString(16).toUpperCase() + " off:"
//			+ offset.toString(16).toUpperCase() + ' act:' + curAnimAct
//			+ ' ' + curAnim + '/' + curAnimAct + "/" + (bf.getShort(addr)/2-1);
}

function loopDrawAnimationPlayer() {
	animTimer = null;
	
	var bf = new bytebuffer(romFrameData);
	ctxBack.clearRect(0, 0, canvasBack.width, canvasBack.height);
	
	for(let player = 0;player < 4;player++) {
		let type = bf.getInt(player * 4 + playerSpriteAddress[curPlayerType]);
		let offset = bf.getShort(type + curPlayerFrame * 2);
//		let s = bf.getShort(type + offset);
//		
//		let frame = romFrames[s/4];
//		
//		drawRomFrameBase(frame, ctxBack, player * 100 + 100)

//		drawAnimationFrame(type + offset, ctxBack, player * 100 + 100, undefined, playerCB[player])

//		nFrame.value=curRomFrame
//		hexFrame.value=curRomFrame.toString(16).toUpperCase();
		
		bf.position(animPlayerAddr[player]);
		let fr = bf.getShort();

		if(fr < 0) {
			if(fr == -offset)
				return;	// stop loop & timer
//			animPlayerAddr[player] += fr;	// end with go back offset = fr, so loop
			let type = bf.getInt(player * 4 + playerSpriteAddress[curPlayerType]);	// get begin address to loop
			animPlayerAddr[player] = bf.getShort(type + curPlayerFrame * 2) + type;
		} else {
			drawAnimationFrame(animPlayerAddr[player], ctxBack, player * 100 + 100, undefined, playerCB[player]);
			animPlayerAddr[player] += 0xC;
		}
	}

	
	animTimer = setTimeout("loopDrawAnimationPlayer()", 200);
}

//get frame from addr. return a frame obj
function getRomFrame(addr){
	var bf = new bytebuffer(romFrameData);
	var bf2 = new bytebuffer(romFrameData);
	let positionIndexStart = bf.getInt(0xFFFFA)
	
	let frame = {
			sprites : []
	};
	
	let si = bf.getInt(addr);
	
	bf.position(si);
	let tileNumber = bf.getShort();
	let spriteNumber = bf.getShort();
	let flag = bf.get();
	let palette = bf.get();
	let pidx = bf.getShort();
	
	let pos = bf.getInt(positionIndexStart + pidx * 4);
	bf2.position(pos);
	frame.info = 'sprite:' + si.toString(16).toUpperCase() + ' position:' + pos.toString(16).toUpperCase();
	
	for(let j = 0;j < spriteNumber;j++) {
		let x = bf2.getShort();
		let y = bf2.getShort();
		let tile = bf.getShort();

		let sprite = {
			x : x,
			y : y,
			tile : tile,
			nx : 1,
			ny : 1,
			vflip : palette & 0x40,	// this tile need flip
			hflip : palette & 0x20,	// this tile need flip
			pal : palette & 0x1F,
		};
		if(flag & 0x80) {
			let size = bf.get();
			let pal = bf.get();
			
			sprite.nx = (size % 16) + 1,
			sprite.ny = (size >> 4) + 1,
			
			sprite.vflip = pal & 0x40;	// this tile need flip
			sprite.hflip = pal & 0x20;	// this tile need flip
			sprite.pal = pal & 0x1F;	// pal only 5 bits
		}
		frame.sprites.push(sprite);
//		console.log("tile: ", JSON.stringify(sprite));
	}
	return frame;
}

var romFrames = [];		// frames that extracted from romFrameData
//load frames data from rom
function loadRomFrame() {
	var bf = new bytebuffer(romFrameData);
	let spriteIndexStart = bf.getInt(0xFFFF4);
	let spritecount = bf.getShort(0xFFFF8)
	
	frameAddress = [];	// clear
	romFrames = [];
	for(let i = 0;i < spritecount;i++) {
		frameAddress.push(i * 4 + spriteIndexStart);
		romFrames.push(getRomFrame(i * 4 + spriteIndexStart))
	}
}
