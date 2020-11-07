"use strict"

var paletteAddress = 0xA8B48;		// per level * scen = 8 * 4
var paletteAddressIndex1 = 0x4D8C;	// for sprite, per level * scene = 8 * 10?
var paletteAddressIndex2 = 0x4D14;	// for scroll layer 1, seems fixed for HUD
var paletteAddressIndex3 = 0x4D3C;	// for scroll layer 2
var paletteAddressIndex4 = 0x4D64;

// load pal from rom and oveewrite old
function loadRomPal() {
	var bf = new bytebuffer(romFrameData);
	var bf2 = new bytebuffer(romFrameData);
	
	
	var paletteIndex = bf.getInt(paletteAddressIndex1 + palset * 4);	// palset = level
	var paletteIndex2 = bf.getInt(paletteAddressIndex2 + palset * 4);
	var paletteIndex3 = bf.getInt(paletteAddressIndex3 + palset * 4);
	var paletteIndex4 = bf.getInt(paletteAddressIndex4 + palset * 4);
	labelInfo2.innerText = 'palset:' + palset +   ' palset2:' + palset2 + ' addr:' + paletteIndex.toString(16).toUpperCase();
	
	// load sprite palette
	bf.position(paletteIndex);
	for(let i = 0;i < 32;i++) {
		loadRomPalCps1(bf, (i << 4))
	}

	// load layer 2 & 3 palette
	bf.position(paletteIndex2);
	for(let i = 0;i < 32;i++) {
		loadRomPalCps1(bf, (i << 4) + 1 * 16 * 32);
	}
	
	// load layer 2 & 3 palette
	bf.position(paletteIndex3);
	for(let i = 0;i < 32;i++) {
		loadRomPalCps1(bf, (i << 4) + 2 * 16 * 32);
	}
	
	bf.position(paletteIndex4);
	for(let i = 0;i < 32;i++) {
		loadRomPalCps1(bf, (i << 4) + 3 * 16 * 32);
	}
	

	if(showPal)
		drawPal();
}

function movetoTile(tile) {
	curStartTile = tile;
	refresh()
}


var playerCB = [	// collision boxes groups for 4 players
	0x100000,0x100C00,0x101800,0x102400
];

var animAddress = [
	
];
// show object animation from rom address
function drawAnimation(addr) {
//	let addr = animAddress[curAnim];
	var bf = new bytebuffer(romFrameData);
	if(!addr)
		addr = animAddress[curAnim];

	if(animTimer) {
		clearTimeout(animTimer)
		animTimer = null;
	}
	
	let testbyte = bf.get(addr);	// if 1 or 2 probably index of anim, if 3f probably index of frame
	if(testbyte <= 0x4) {
		let offset = bf.getShort(addr + curAnimAct * 2);
		if(offset == 0)
			return;
		addr = addr + offset;
	}

	
	
//	let addr = animAddress[curAnim];
//	var bf = new bytebuffer(romFrameData);
	
//	let offset = bf.getShort(addr + curAnimAct * 2);
//	if(offset == 0) {
//		labelInfo.innerText = "EOF";
//		return;
//	}
//	let startAddress = addr + offset;
	

	loopDrawAnimation(addr);

//	labelInfo.innerText = 'addr:' + addr.toString(16).toUpperCase() + "/" + startAddress.toString(16).toUpperCase() + " off:"
//			+ offset.toString(16).toUpperCase() + ' act:' + curAnimAct
//			+ ' ' + curAnim + '/' + curAnimAct + "/" + (bf.getShort(addr)/2-1);
}
function loopDrawAnimation(addr) {
	animTimer = null;
	var bf = new bytebuffer(romFrameData, addr);
	
	let offset = bf.getShort();
	if(offset < 0) {
		addr = addr + offset;
		bf.position(addr);
		offset = bf.getShort();
	}

	
	let fr = offset + addr;
	let flag2 = bf.get();
	let flag = bf.get();
//	let link = bf.getInt();
//	let flag = bf.getShort();


	ctx.clearRect(0, 0, canvas.width, canvas.height);
	
	let frame = getRomFrame(addr + bf.getShort(addr));
	if(!frame) {
		return;
	}
	
	labelInfo.innerText = 'anim:' + addr.toString(16).toUpperCase();
	
	drawRomFrameBase(frame);

	addr = addr + 4;
	animTimer = setTimeout("loopDrawAnimation("+ addr +")", 200);
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


var bgAddress = 0xA8F5E;

let bgWidth = 32;
let bgHeight;	// default 8
let bgGrid = 2;		// each map tile contains 4 raw tiles?

// draw a background with tilemap
function drawbg() {
	var bf = new bytebuffer(romFrameData);
	var bf2 = new bytebuffer(romFrameData);
	var bf3 = new bytebuffer(romFrameData);
	// ctxBack.clearRect(0, 0, canvasBack.width, canvasBack.height);
	
	let tileindex = bf.getInt(bgAddress + curbg * 8);
	let tileaddr = bf.getInt(bgAddress + curbg * 8 + 4);
	let bigindex = bf.getInt(0xA990C + curbg * 4);
	
//	labelInfo.innerText = 'address:' + bf.position().toString(16).toUpperCase()
//			+ ' 2x2tile address:' + mapTileAddress[curbg].toString(16).toUpperCase();
	var imageData = ctxBack.createImageData(gridWidth, gridHeight);

	var height = 2;
	bf3.position(bigindex);
	
	let startscr=0;
//	for(let scr=0;scr<6 + bgAddressSkip * 2;scr++) {
	let scenecount = bf3.getr(-2) / 2;
	let scenelength = bf3.getr(-1);
	labelInfo.innerHTML += ',size:' + scenecount+','+scenelength;
	bf3.skip(bgAddressSkip * 2 * scenecount + bgScene * 2);

	for(let scr=0;scr<4;scr++) {
		
		if(scr%2==0 && scr > 0)
			bf3.skip(2 * (scenecount-1))
		
		let scrTile = bf3.get();
//		if(scr<bgAddressSkip * 2)
//			continue;
//		

		let scry = 256 - (scr & 1) * 256;//Math.floor(startscr / height) * 256;
		let scrx = (scr >> 1) * 256;//(height - startscr % height - 1) * 256;

		bf.position(tileindex+scrTile * 64 * 2);
	
		for(let i=0;i<8;i++) {
			for(let j=0;j<8;j++) {
				let maptile=bf.getShort();
				bf2.position(maptile + tileaddr);
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
						ctxBack.putImageData(imageData, scrx + (j*bgGrid+gj)%32 * gridHeight, scry + (i*bgGrid+gi) * gridWidth);
					}
			}
		}
		startscr++;
	}

}

var bg2Address = 0xA9D4A;	// layer 2 background
function drawbg2() {
	var bf = new bytebuffer(romFrameData);
	var bf2 = new bytebuffer(romFrameData);
	var bf3 = new bytebuffer(romFrameData);
	// ctxBack.clearRect(0, 0, canvasBack.width, canvasBack.height);
	
	let tileindex = bf.getInt(bg2Address + curbg * 8);
	let tileaddr = bf.getInt(bg2Address + curbg * 8 + 4);
	let bigindex = bf.getInt(0xA9934 + curbg * 4);
	
//	labelInfo.innerText = 'address:' + bf.position().toString(16).toUpperCase()
//			+ ' 2x2tile address:' + mapTileAddress[curbg].toString(16).toUpperCase();
	var imageData = ctxBack.createImageData(gridWidth*2, gridHeight*2);

	var height = 2;
	bf3.position(bigindex);
	
	let startscr=0;
//	for(let scr=0;scr<6 + bgAddressSkip * 2;scr++) {
	let scenecount = bf3.getr(-2) / 2;
	let scenelength = bf3.getr(-1);
	labelInfo.innerHTML += ',size:' + scenecount+','+scenelength;
	bf3.skip(bgAddressSkip * 2 * scenecount + bgScene * 2);

	for(let scr=0;scr<4;scr++) {
		
		if(scr%2==0 && scr > 0)
			bf3.skip(2 * (scenecount-1))
		
		let scrTile = bf3.get();
//		if(scr<bgAddressSkip * 2)
//			continue;
//		

		let scry = 256 - (scr & 1) * 256;//Math.floor(startscr / height) * 256;
		let scrx = (scr >> 1) * 256;//(height - startscr % height - 1) * 256;

		bf.position(tileindex+scrTile * 16 * 2);
	
		for(let i=0;i<4;i++) {
			for(let j=0;j<4;j++) {
				let maptile=bf.getShort();
				bf2.position(maptile + tileaddr);
				for(let gi=0;gi<bgGrid;gi++)
					for(let gj=0;gj<bgGrid;gj++) {
						
						let tile = bf2.getShort();
						let flag = bf2.get();
						let pal = bf2.get();
						if(hideBackground) {	// hide background based on flag and color, 0x10 maybe the switch
							let hide = flag & 0xF;
							if((pal & 0x80) == 0)
								hide = 16;
							drawTilesBase(imageData, tile, 1, 1, (pal & 0x1F) + 0x60, 32, false, (pal & 0x40), (pal & 0x20), hide);
						} else 
							drawTilesBase(imageData, tile, 1, 1, (pal & 0x1F) + 0x60, 32, false, (pal & 0x40), (pal & 0x20));
						ctxBack.putImageData(imageData, scrx + (j*bgGrid+gj)%32 * gridHeight*2, scry + (i*bgGrid+gi) * gridWidth*2);
					}
			}
		}
		startscr++;
	}



}

function setMapTileStart(bgstart) {
	bgScene = bgstart;
	refresh();
}

function getCB(addr) {
	var bf = new bytebuffer(romFrameData, addr);
	return {
		z : bf.getShort(),
		z2 : bf.getShort(),
		x : bf.getShort(),
		x2 : bf.getShort(),
		y : bf.getShort(),
		y2 : bf.getShort(),
	}
}

frameAddress = [
	0x14DDE4, 0x108c30, 0x111384, //0x14ec90, 0x13a22e, 0x151c94, 0x152c22, 0x1397ca, 0x151454, 0x10a696, 0x10bf0e, 0x11b1a2, 0x13e6fe
];

// get frame from addr. return a frame obj
function getRomFrame(addr, f){
//	if(!curRomFrame2)
//		curRomFrame2 = 0;
	var bf = new bytebuffer(romFrameData);
	var bf2 = new bytebuffer(romFrameData);
	var bf3 = new bytebuffer(romFrameData);
	var bf4 = new bytebuffer(romFrameData);
//	let offset = bf.getShort(addr + curRomFrame2 * 2);

	let frame = {
			sprites : [],
	};
	
//	bf.position(addr + offset);
	if(f >= 0) {	// use frameAddress and has multiple frames
		let offset = bf.getShort(addr + f * 2);
		if(offset == 0)
			return;
		let addr2 = addr + offset;
		let addr3= addr2 + bf.getShort(addr2);

		addr = addr3;
	}
	
	bf.position(addr);
	
	let cb1addr = bf.getShort(addr - 8);
	if(cb1addr) {
		frame.cb1 = getCB(0x214A2 + cb1addr);
	}

	let cb2addr = bf.getShort(addr - 6);
	if(cb2addr) {
		frame.cb2 = getCB(0x214A2 + cb2addr);
	}


	let func = bf.get();
	frame.info = '0x'+addr.toString(16).toUpperCase() + ' function 0x' + func.toString(16).toUpperCase();

	if(func == 0x0) {	// single tile
		let cnt = bf.get();

		let nxy =  bf.get();
		let nx = nxy % 16;
		let ny = nxy >> 4;
		
		let palette = bf.get();

		let x = bf.getShort();
		let y = bf.getShort();
		

		
		let tile = bf.getShort();


		let sprite = {
				x : x,
				y : y,
				tile : tile,
				nx : nx + 1,
				ny : ny + 1,
				vflip : palette & 0x40,	// this tile need flip
				hflip : palette & 0x20,	// this tile need flip
				pal : palette & 0x1F,
			};
		
		frame.sprites.push(sprite);
	} else if(func == 0x8) {	// multiple tiles with same palette/size
			
		let cnt = bf.get();	// tile count
		bf.skip(2);

		let nxy = bf.get();
		let nx = nxy % 16;
		let ny = nxy >> 4;
		
		let palette = bf.get();
		

		let addr2 = bf.getShort() + 0x10678A;
		bf2.position(addr2)
		
		let x = bf.getShort();
		let y = -bf.getShort();
		
		let tile = bf.getShort();
		if(tile > 0) {
			let sprite = {
					x : x,
					y : y,
					tile : tile,
					nx : nx + 1,
					ny : ny + 1,
					vflip : palette & 0x40,	// this tile need flip
					hflip : palette & 0x20,	// this tile need flip
					pal : palette & 0x1F,
				};
			
			frame.sprites.push(sprite);
			cnt--;
		}
		
		for(let i = 0;i < cnt;i++) {

			x += bf2.getShort();
			y -= bf2.getShort();

			
			let tile = bf.getShort();
			if(tile < 0) {
				i--;
				continue;
			}

			let sprite = {
					x : x,
					y : y,
					tile : tile,
					nx : nx + 1,
					ny : ny + 1,
					vflip : palette & 0x40,	// this tile need flip
					hflip : palette & 0x20,	// this tile need flip
					pal : palette & 0x1F,
				};
			
			frame.sprites.push(sprite);

		}


	} else if(func == 0xC) {	// multiple tiles with different palette/size
		
		let cnt = bf.get();
		bf.skip(2);
		cnt = bf.getShort();


		for(let i = 0;i < cnt;i++) {
			let x = bf.getShort();
			let y = -bf.getShort();
			
			let nxy = bf.get();
			let nx = nxy % 16;
			let ny = nxy >> 4;
			
			let palette = bf.get();
			
			let tile = bf.getShort();


			let sprite = {
					x : x,
					y : y,
					tile : tile,
					nx : nx + 1,
					ny : ny + 1,
					vflip : palette & 0x40,	// this tile need flip
					hflip : palette & 0x20,	// this tile need flip
					pal : palette & 0x1F,
				};
			
			frame.sprites.push(sprite);

		}
	} else if(func == 0x1C) {	// single tile with fixed palette=1
		
		let cnt = bf.get();
		bf.skip(4);


		let x = bf.getShort();
		let y = bf.getShort();
		
		let nxy = 0;
		let nx = nxy % 16;
		let ny = nxy >> 4;
		
		let palette = 1;
		
		let tile = bf.getShort();


		let sprite = {
				x : x,
				y : y,
				tile : tile,
				nx : nx + 1,
				ny : ny + 1,
				vflip : palette & 0x40,	// this tile need flip
				hflip : palette & 0x20,	// this tile need flip
				pal : palette & 0x1F,
			};
		
		frame.sprites.push(sprite);


	} else if(func == 0x10) {	// multiple sets of tiles, all with different palette/size
		let cnt = bf.get();
		bf.skip(2)

		let nxy = bf.get();
		let nx = nxy % 16;
		let ny = nxy >> 4;
		
		let palette = bf.get();
		
		cnt = bf.getShort();
		
		for(let i = 0;i < cnt;i++) {
			let x = bf.getShort();
			let y = -bf.getShort();
			let addr2 = bf.getInt();
			bf2.position(addr2);
			

			let cnt2 = bf2.get() + 1;
			bf2.skip();

			let addr3 = bf2.getShort() + 0x10678A;
			bf3.position(addr3);
			
			let tile = bf2.getShort();
			if(tile > 0) {
				let sprite = {
						x : x,
						y : y,
						tile : tile,
						nx : nx + 1,
						ny : ny + 1,
						vflip : palette & 0x40,	// this tile need flip
						hflip : palette & 0x20,	// this tile need flip
						pal : palette & 0x1F,
					};
				
				frame.sprites.push(sprite);
				cnt2--;
			}

			for(let j = 0;j < cnt2;j++) {
				x += bf3.getShort();
				y -= bf3.getShort();
				
				let tile = bf2.getShort();
				if(tile <= 0) {
					j--;
					continue;
				}
					
				let sprite = {
						x : x,
						y : y,
						tile : tile,
						nx : nx + 1,
						ny : ny + 1,
						vflip : palette & 0x40,	// this tile need flip
						hflip : palette & 0x20,	// this tile need flip
						pal : palette & 0x1F,
					};
				
				frame.sprites.push(sprite);
			}

		}
		
	} else if(func == 0x14) {	// multiple sets of tiles, each set of tiles with same palette/size
		let cnt = bf.get();
		bf.skip(2)
		cnt = bf.getShort();

		
		for(let i = 0;i < cnt;i++) {
			let x = bf.getShort();
			let y = -bf.getShort();
			let addr2 = bf.getInt();
			bf2.position(addr2);
			
			let nxy = bf2.get() & 0x7f;
			let nx = nxy % 16;
			let ny = nxy >> 4;
			
			let palette = bf2.get();
			let cnt2 = bf2.get() + 1;
			bf2.skip();

			let addr3 = bf2.getShort() + 0x10678A;
			bf3.position(addr3);
			
			let tile = bf2.getShort();
			if(tile > 0) {
				let sprite = {
						x : x,
						y : y,
						tile : tile,
						nx : nx + 1,
						ny : ny + 1,
						vflip : palette & 0x40,	// this tile need flip
						hflip : palette & 0x20,	// this tile need flip
						pal : palette & 0x1F,
					};
				
				frame.sprites.push(sprite);
				cnt2--;
			}

			for(let j = 0;j < cnt2;j++) {
				x += bf3.getShort();
				y -= bf3.getShort();
				
				let tile = bf2.getShort();
				if(tile <= 0) {
					j--;
					continue;
				}
					
				let sprite = {
						x : x,
						y : y,
						tile : tile,
						nx : nx + 1,
						ny : ny + 1,
						vflip : palette & 0x40,	// this tile need flip
						hflip : palette & 0x20,	// this tile need flip
						pal : palette & 0x1F,
					};
				
				frame.sprites.push(sprite);
			}

		}
	} else if(func == 0x18) {		// 4 tiles with 4 directions, make a circle
		bf.skip();
		let nxy = bf.get();
		let nx = nxy % 16;
		let ny = nxy >> 4;
		
		let palette = bf.get();
		let x = bf.getShort();
		let y = bf.getShort();
		let tile = bf.getShort();
		
		let sprite = {
				x : x,
				y : y,
				tile : tile,
				nx : nx + 1,
				ny : ny + 1,
				vflip : palette & 0x40,	// this tile need flip
				hflip : palette & 0x20,	// this tile need flip
				pal : palette & 0x1F,
			};
		frame.sprites.push(sprite);
		palette += 0x20;
		sprite = {
				x : x + 0x10,
				y : y,
				tile : tile,
				nx : nx + 1,
				ny : ny + 1,
				vflip : palette & 0x40,	// this tile need flip
				hflip : palette & 0x20,	// this tile need flip
				pal : palette & 0x1F,
			};
		frame.sprites.push(sprite);
		palette += 0x20;
		sprite = {
				x : x,
				y : y + 0x10,
				tile : tile,
				nx : nx + 1,
				ny : ny + 1,
				vflip : palette & 0x40,	// this tile need flip
				hflip : palette & 0x20,	// this tile need flip
				pal : palette & 0x1F,
			};
		frame.sprites.push(sprite);
		palette += 0x20;
		sprite = {
				x : x + 0x10,
				y : y + 0x10,
				tile : tile,
				nx : nx + 1,
				ny : ny + 1,
				vflip : palette & 0x40,	// this tile need flip
				hflip : palette & 0x20,	// this tile need flip
				pal : palette & 0x1F,
			};
		frame.sprites.push(sprite);
		
	} else {
		labelInfo.innerHTML = 'unsupported 0x' + func.toString(16).toUpperCase();
		return;
	}
	
	return frame;
}

var animPlayerAddr = [];


function loadRomFrame() {
	var bf = new bytebuffer(romFrameData);
	
	for(let i = 0;i < 400;i++) {

		frameAddress.push(bf.getInt(0xA0AA0 + i * 4));	// read from animation and show first frame
		animAddress.push(bf.getInt(0xA0AA0 + i * 4));
	}
	
	

}
