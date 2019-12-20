User avatarGnawtor
Posts: 13
Joined: Fri Feb 14, 2020 2:51 pm
Re: Hacking Willow rom with Gecko Grabber
Post by Gnawtor » Mon Feb 24, 2020 11:57 pm

Alright, here's a quick and dirty guide to hacking Willow using Gecko Grabber and Rom Mangler. Click here to get the new version. You will need Java runtimes installed for this to work.

Make a new folder called WillowHack and extract the contents of willow.zip to it. Extract RomMangler.jar here too.

IMPORTANT: Within your WillowHack folder, make another folder called out. Extract willow.zip to the out folder too.

Make 4 new text files in WillowHack and rename them to:

willow_split_gfx.cfg
willow_split_gfx_out.cfg
willow_split_prg.cfg
willow_split_prg_out.cfg

These files will tell RomMangler how to combine and split Willow for easier hacking.

Paste the following into the config files:

willow_split_gfx.cfg
CODE: SELECT ALL

ROMX_LOAD_WORD_SKIP_6,wlm-7.7a,000000,80000
ROMX_LOAD_WORD_SKIP_6,wlm-5.9a,000002,80000
ROMX_LOAD_WORD_SKIP_6,wlm-3.3a,000004,80000
ROMX_LOAD_WORD_SKIP_6,wlm-1.5a,000006,80000
ROM_LOAD64_BYTE,wl_24.7d,200000,20000
ROM_LOAD64_BYTE,wl_14.7c,200001,20000
ROM_LOAD64_BYTE,wl_26.9d,200002,20000
ROM_LOAD64_BYTE,wl_16.9c,200003,20000
ROM_LOAD64_BYTE,wl_20.3d,200004,20000
ROM_LOAD64_BYTE,wl_10.3c,200005,20000
ROM_LOAD64_BYTE,wl_22.5d,200006,20000
ROM_LOAD64_BYTE,wl_12.5c,200007,20000
willow_split_gfx_out.cfg
CODE: SELECT ALL

ROMX_LOAD_WORD_SKIP_6,out\wlm-7.7a,000000,80000
ROMX_LOAD_WORD_SKIP_6,out\wlm-5.9a,000002,80000
ROMX_LOAD_WORD_SKIP_6,out\wlm-3.3a,000004,80000
ROMX_LOAD_WORD_SKIP_6,out\wlm-1.5a,000006,80000
ROM_LOAD64_BYTE,out\wl_24.7d,200000,20000
ROM_LOAD64_BYTE,out\wl_14.7c,200001,20000
ROM_LOAD64_BYTE,out\wl_26.9d,200002,20000
ROM_LOAD64_BYTE,out\wl_16.9c,200003,20000
ROM_LOAD64_BYTE,out\wl_20.3d,200004,20000
ROM_LOAD64_BYTE,out\wl_10.3c,200005,20000
ROM_LOAD64_BYTE,out\wl_22.5d,200006,20000
ROM_LOAD64_BYTE,out\wl_12.5c,200007,20000
willow_split_prg.cfg
CODE: SELECT ALL

ROM_LOAD16_BYTE,wle_30.11f,00000,20000
ROM_LOAD16_BYTE,wle_35.11h,00001,20000
ROM_LOAD16_BYTE,wlu_31.12f,40000,20000
ROM_LOAD16_BYTE,wlu_36.12h,40001,20000
ROM_LOAD16_WORD_SWAP,wlm-32.8h,80000,80000
willow_split_prg_out.cfg
CODE: SELECT ALL

ROM_LOAD16_BYTE,out\wle_30.11f,00000,20000
ROM_LOAD16_BYTE,out\wle_35.11h,00001,20000
ROM_LOAD16_BYTE,out\wlu_31.12f,40000,20000
ROM_LOAD16_BYTE,out\wlu_36.12h,40001,20000
ROM_LOAD16_WORD_SWAP,out\wlm-32.8h,80000,80000
Now let's combine the program and graphics ROMs. Make a new batch file called combine.bat and paste the following into it:
CODE: SELECT ALL

java -jar RomMangler.jar combine willow_split_prg.cfg willow_prg.bin
java -jar RomMangler.jar combine willow_split_gfx.cfg willow_gfx.bin
Run combine.bat and it will create two new files:

willow_gfx.bin
willow_prg.bin

These are combined binaries of Willow's M68K and Graphics ROMs. They should look exactly like they do in MAME's memory viewer. These are your original master copies, so be careful not to edit them. Make copies of them and rename them to:

willow_gfx_hack.bin
willow_prg_hack.bin

Make all of your changes to the hacked copies and use the originals for reference.

After you've made your changes to the GFX and PRG files, you will need to split your hack into multiple files so that MAME can play it. Make another batch file called split.bat and paste the following into it:
CODE: SELECT ALL

java -jar RomMangler.jar split willow_split_gfx_out.cfg willow_gfx_hack.bin
java -jar RomMangler.jar split willow_split_prg_out.cfg willow_prg_hack.bin

java -jar RomMangler.jar zipdir out willow.zip
This will split your hacked GFX and PRG binaries to the out folder. Then a new zip file called willow.zip is created inside your WillowHack folder, and the contents of the out folder are added to it. The new willow.zip in the WillowHack folder can now be copied to your MAME ROMs folder.

Now, you can do whatever you want, but here's where I'd like to suggest that you keep a separate copy of MAME specifically for hacking. Unlike most home console emulators, MAME doesn't really like to run any ROMs that it doesn't already support, so you should avoid contaminating a good ROM set if you have one.

Another annoying thing about MAME is that it tries to stop you from playing any ROM with an incorrect checksum. You have to run your hacks from the command line instead of MAME's default interface. The rationale here is that if you are running a ROM with an incorrect checksum from the command line, MAME assumes you probably know what you are doing. In your MAME folder, create a new batch file called willow_debug.bat and paste the following into it:
CODE: SELECT ALL

mame64 willow -debug
This will load your hack in debug mode (press F5 in the debug console to begin emulation)


This is a very bare-bones lesson in how to use Rom Mangler. A better tutorial is in the works that will cover how to set up a M68K assembler for easier hacking, but for now this should get you started.

If you want to hack other CPS games, refer to MAME's CPS driver source code to create your own config files (read my first post in this thread). Rom Mangler may not support every ROM loading method, and a recent update to MAME's code changed the names of a bunch of them since Rom Mangler was first made, but the current plan is for the tool to go open source eventually so the community can continue updating it.

Let us know how it goes. I poked around at Willow's graphics and ROM and this game looks like a lot of fun to hack. There is a ton of empty space in the program ROM and the graphics are arranged very nicely for editing. Best of luck.

Here are some palette locations I found, hope this helps:
OBJ palettes: $E5080
SCROLL1 palettes: $E6EA0
SCROLL2 palettes: $E9920
Top
User avatarTailsnic Retroworks
Posts: 6
Joined: Wed Feb 19, 2020 5:44 pm
Contact: Contact Tailsnic Retroworks
Re: Hacking Willow rom with Gecko Grabber
Post by Tailsnic Retroworks » Wed Feb 26, 2020 2:08 am

Many thanks!!!!! I'll try it as soon as possible!!!!!
Top
User avatarGnawtor
Posts: 13
Joined: Fri Feb 14, 2020 2:51 pm
Re: Hacking Willow rom with Gecko Grabber
Post by Gnawtor » Wed Feb 26, 2020 11:24 pm

You're welcome!

Here are some more Rom Mangler configs. Come on everyone, fucking hack some CPS games with us!

Street Fighter II: Hyper Fighting

sf2hf_split_gfx.cfg
CODE: SELECT ALL

ROMX_LOAD_WORD_SKIP_6,s92-1m.3a,000000,80000
ROMX_LOAD_WORD_SKIP_6,s92-3m.5a,000002,80000
ROMX_LOAD_WORD_SKIP_6,s92-2m.4a,000004,80000
ROMX_LOAD_WORD_SKIP_6,s92-4m.6a,000006,80000
ROMX_LOAD_WORD_SKIP_6,s92-5m.7a,200000,80000
ROMX_LOAD_WORD_SKIP_6,s92-7m.9a,200002,80000
ROMX_LOAD_WORD_SKIP_6,s92-6m.8a,200004,80000
ROMX_LOAD_WORD_SKIP_6,s92-8m.10a,200006,80000
ROMX_LOAD_WORD_SKIP_6,s92-10m.3c,400000,80000
ROMX_LOAD_WORD_SKIP_6,s92-12m.5c,400002,80000
ROMX_LOAD_WORD_SKIP_6,s92-11m.4c,400004,80000
ROMX_LOAD_WORD_SKIP_6,s92-13m.6c,400006,80000
sf2hf_split_prg.cfg
CODE: SELECT ALL

ROM_LOAD16_WORD_SWAP,s2te_23.8f,000000,80000
ROM_LOAD16_WORD_SWAP,s2te_22.7f,080000,80000
ROM_LOAD16_WORD_SWAP,s2te_21.6f,100000,80000
Final Fight

ffight_split_gfx.cfg
CODE: SELECT ALL

ROMX_LOAD_WORD_SKIP_6,ff-5m.7a,000000,80000
ROMX_LOAD_WORD_SKIP_6,ff-7m.9a,000002,80000
ROMX_LOAD_WORD_SKIP_6,ff-1m.3a,000004,80000
ROMX_LOAD_WORD_SKIP_6,ff-3m.5a,000006,80000
ffight_split_prg.cfg
CODE: SELECT ALL

ROM_LOAD16_BYTE,ff_36.11f,00000,20000
ROM_LOAD16_BYTE,ff_42.11h,00001,20000
ROM_LOAD16_BYTE,ff_37.12f,40000,20000
ROM_LOAD16_BYTE,ffe_43.12h,40001,20000
ROM_LOAD16_WORD_SWAP,ff-32m.8h,80000,80000
Knights of the Round

knights_split_gfx.cfg
CODE: SELECT ALL

ROMX_LOAD_WORD_SKIP_6,kr-5m.3a,000000,80000
ROMX_LOAD_WORD_SKIP_6,kr-7m.5a,000002,80000
ROMX_LOAD_WORD_SKIP_6,kr-1m.4a,000004,80000
ROMX_LOAD_WORD_SKIP_6,kr-3m.6a,000006,80000
ROMX_LOAD_WORD_SKIP_6,kr-6m.7a,200000,80000
ROMX_LOAD_WORD_SKIP_6,kr-8m.9a,200002,80000
ROMX_LOAD_WORD_SKIP_6,kr-2m.8a,200004,80000
ROMX_LOAD_WORD_SKIP_6,kr-4m.10a,200006,80000
knights_split_prg.cfg
CODE: SELECT ALL

ROM_LOAD16_WORD_SWAP,kr_23e.8f,00000,80000
ROM_LOAD16_WORD_SWAP,kr_22.7f,80000,80000
Captain Commando

captcomm_split_gfx.cfg
CODE: SELECT ALL

ROMX_LOAD_WORD_SKIP_6,cc-5m.3a,000000,80000
ROMX_LOAD_WORD_SKIP_6,cc-7m.5a,000002,80000
ROMX_LOAD_WORD_SKIP_6,cc-1m.4a,000004,80000
ROMX_LOAD_WORD_SKIP_6,cc-3m.6a,000006,80000
ROMX_LOAD_WORD_SKIP_6,cc-6m.7a,200000,80000
ROMX_LOAD_WORD_SKIP_6,cc-8m.9a,200002,80000
ROMX_LOAD_WORD_SKIP_6,cc-2m.8a,200004,80000
ROMX_LOAD_WORD_SKIP_6,cc-4m.10a,200006,80000
captcomm_split_prg.cfg
CODE: SELECT ALL

ROM_LOAD16_WORD_SWAP,cce_23f.8f,000000,80000
ROM_LOAD16_WORD_SWAP,cc_22f.7f,080000,80000
ROM_LOAD16_BYTE,cc_24f.9e,100000,20000
ROM_LOAD16_BYTE,cc_28f.9f,100001,20000
Top
User avatarTailsnic Retroworks
Posts: 6
Joined: Wed Feb 19, 2020 5:44 pm
Contact: Contact Tailsnic Retroworks
Re: Hacking Willow rom with Gecko Grabber
Post by Tailsnic Retroworks » Mon Mar 02, 2020 4:21 pm

Hi again, and many thanks for the palette guides. I have made the first sprite (stop) using the exported .pcx in photoshop, and after that loading it in Paintshop Pro for exporting it in Version 2 format. I have one problem here.

Image

The program says that cannot accept pixel format for this operation. I have tried even exporting an original .pcx without using photoshop, directly exported with Gecko Grabber, and it says the same thing.

How can I really create a new .PCX version 2 pasting the changes? What version of Paintshop Pro must I use to save a good .PCX after editing?

I am very excited with this project, xD.
Top
supneo
Posts: 2
Joined: Tue Mar 03, 2020 8:08 pm
Re: Hacking Willow rom with Gecko Grabber
Post by supneo » Tue Mar 03, 2020 8:13 pm

Gnawtor wrote: ↑Wed Feb 26, 2020 11:24 pm
You're welcome!

Here are some more Rom Mangler configs. Come on everyone, fucking hack some CPS games with us!

Street Fighter II: Hyper Fighting

sf2hf_split_gfx.cfg
CODE: SELECT ALL

ROMX_LOAD_WORD_SKIP_6,s92-1m.3a,000000,80000
ROMX_LOAD_WORD_SKIP_6,s92-3m.5a,000002,80000
ROMX_LOAD_WORD_SKIP_6,s92-2m.4a,000004,80000
ROMX_LOAD_WORD_SKIP_6,s92-4m.6a,000006,80000
ROMX_LOAD_WORD_SKIP_6,s92-5m.7a,200000,80000
ROMX_LOAD_WORD_SKIP_6,s92-7m.9a,200002,80000
ROMX_LOAD_WORD_SKIP_6,s92-6m.8a,200004,80000
ROMX_LOAD_WORD_SKIP_6,s92-8m.10a,200006,80000
ROMX_LOAD_WORD_SKIP_6,s92-10m.3c,400000,80000
ROMX_LOAD_WORD_SKIP_6,s92-12m.5c,400002,80000
ROMX_LOAD_WORD_SKIP_6,s92-11m.4c,400004,80000
ROMX_LOAD_WORD_SKIP_6,s92-13m.6c,400006,80000
sf2hf_split_prg.cfg
CODE: SELECT ALL

ROM_LOAD16_WORD_SWAP,s2te_23.8f,000000,80000
ROM_LOAD16_WORD_SWAP,s2te_22.7f,080000,80000
ROM_LOAD16_WORD_SWAP,s2te_21.6f,100000,80000
Final Fight

ffight_split_gfx.cfg
CODE: SELECT ALL

ROMX_LOAD_WORD_SKIP_6,ff-5m.7a,000000,80000
ROMX_LOAD_WORD_SKIP_6,ff-7m.9a,000002,80000
ROMX_LOAD_WORD_SKIP_6,ff-1m.3a,000004,80000
ROMX_LOAD_WORD_SKIP_6,ff-3m.5a,000006,80000
ffight_split_prg.cfg
CODE: SELECT ALL

ROM_LOAD16_BYTE,ff_36.11f,00000,20000
ROM_LOAD16_BYTE,ff_42.11h,00001,20000
ROM_LOAD16_BYTE,ff_37.12f,40000,20000
ROM_LOAD16_BYTE,ffe_43.12h,40001,20000
ROM_LOAD16_WORD_SWAP,ff-32m.8h,80000,80000
Knights of the Round

knights_split_gfx.cfg
CODE: SELECT ALL

ROMX_LOAD_WORD_SKIP_6,kr-5m.3a,000000,80000
ROMX_LOAD_WORD_SKIP_6,kr-7m.5a,000002,80000
ROMX_LOAD_WORD_SKIP_6,kr-1m.4a,000004,80000
ROMX_LOAD_WORD_SKIP_6,kr-3m.6a,000006,80000
ROMX_LOAD_WORD_SKIP_6,kr-6m.7a,200000,80000
ROMX_LOAD_WORD_SKIP_6,kr-8m.9a,200002,80000
ROMX_LOAD_WORD_SKIP_6,kr-2m.8a,200004,80000
ROMX_LOAD_WORD_SKIP_6,kr-4m.10a,200006,80000
knights_split_prg.cfg
CODE: SELECT ALL

ROM_LOAD16_WORD_SWAP,kr_23e.8f,00000,80000
ROM_LOAD16_WORD_SWAP,kr_22.7f,80000,80000
Captain Commando

captcomm_split_gfx.cfg
CODE: SELECT ALL

ROMX_LOAD_WORD_SKIP_6,cc-5m.3a,000000,80000
ROMX_LOAD_WORD_SKIP_6,cc-7m.5a,000002,80000
ROMX_LOAD_WORD_SKIP_6,cc-1m.4a,000004,80000
ROMX_LOAD_WORD_SKIP_6,cc-3m.6a,000006,80000
ROMX_LOAD_WORD_SKIP_6,cc-6m.7a,200000,80000
ROMX_LOAD_WORD_SKIP_6,cc-8m.9a,200002,80000
ROMX_LOAD_WORD_SKIP_6,cc-2m.8a,200004,80000
ROMX_LOAD_WORD_SKIP_6,cc-4m.10a,200006,80000
captcomm_split_prg.cfg
CODE: SELECT ALL

ROM_LOAD16_WORD_SWAP,cce_23f.8f,000000,80000
ROM_LOAD16_WORD_SWAP,cc_22f.7f,080000,80000
ROM_LOAD16_BYTE,cc_24f.9e,100000,20000
ROM_LOAD16_BYTE,cc_28f.9f,100001,20000
Hi Gnawtor, do you have the settings to edit street fighter 2 ce? Thank you.