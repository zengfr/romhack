/*
  UTF-to-VLQ
  Public domain
*/

#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
#include <fcntl.h>
#endif

typedef unsigned char byte;
typedef unsigned long long ULL;

typedef ULL(*in_func_t)(void);
typedef void(*out_func_t)(ULL);

static char in_mode;
static char out_mode;
static int options[128];
static ULL translation[256];
static ULL mem;

#define conv_lf options['L']
#define conv_cr options['c']
#define bom_in options['b']
#define bom_out options['B']
#define trans_le options['t']

static byte getb(void) {
  int x=fgetc(stdin);
  if(x==EOF) exit(0);
  return x;
}

static inline ULL sign_extend(ULL x,int y) {
  return x|((x&(1LL<<y))?-1LL<<y:0);
}

static ULL read_8bit_raw(void) {
  return getb();
}

static ULL read_16bit_le_raw(void) {
  ULL x=getb();
  return x|(getb()<<8);
}

static ULL read_16bit_be_raw(void) {
  ULL x=getb()<<8;
  return x|getb();
}

static ULL read_32bit_le_raw(void) {
  ULL x=getb();
  x|=getb()<<8;
  x|=getb()<<16;
  return x|(getb()<<24);
}

static ULL read_32bit_be_raw(void) {
  ULL x=getb()<<24;
  x|=getb()<<16;
  x|=getb()<<8;
  return x|getb();
}

static ULL read_64bit_le_raw(void) {
  ULL x=getb();
  x|=getb()<<8;
  x|=getb()<<16;
  x|=((ULL)getb())<<24;
  x|=((ULL)getb())<<32;
  x|=((ULL)getb())<<40;
  x|=((ULL)getb())<<48;
  x|=((ULL)getb())<<56;
  return x;
}

static ULL read_64bit_be_raw(void) {
  ULL x=((ULL)getb())<<56;
  x|=((ULL)getb())<<48;
  x|=((ULL)getb())<<40;
  x|=((ULL)getb())<<32;
  x|=((ULL)getb())<<24;
  x|=getb()<<16;
  x|=getb()<<8;
  return x;
}

static ULL read_utf8(void) {
  ULL x=getb();
  if((x&0xE0)==0xC0) {
    x=((x&0x1F)<<6)|(getb()&0x3F);
  } else if((x&0xF0)==0xE0) {
    x=((x&0x0F)<<6)|(getb()&0x3F);
    x=(x<<6)|(getb()&0x3F);
  } else if((x&0xF8)==0xF0) {
    x=((x&0x07)<<6)|(getb()&0x3F);
    x=(x<<6)|(getb()&0x3F);
    x=(x<<6)|(getb()&0x3F);
  } else if((x&0xFC)==0xF8) {
    x=((x&0x03)<<6)|(getb()&0x3F);
    x=(x<<6)|(getb()&0x3F);
    x=(x<<6)|(getb()&0x3F);
    x=(x<<6)|(getb()&0x3F);
  } else if((x&0xFE)==0xFC) {
    x=((x&0x01)<<6)|(getb()&0x3F);
    x=(x<<6)|(getb()&0x3F);
    x=(x<<6)|(getb()&0x3F);
    x=(x<<6)|(getb()&0x3F);
    x=(x<<6)|(getb()&0x3F);
  } else if(x==0xFE || x==0xFF) {
    x=((x&0x01)<<6)|(getb()&0x3F);
    x=(x<<6)|(getb()&0x3F);
    x=(x<<6)|(getb()&0x3F);
    x=(x<<6)|(getb()&0x3F);
    x=(x<<6)|(getb()&0x3F);
    x=(x<<6)|(getb()&0x3F);
  }
  return x;
}

static ULL read_vlq8(void) {
  byte x=getb();
  ULL r=0;
  while(x&0x80) {
    r=(r<<7)|(x&0x7F);
    x=getb();
  }
  return r|x;
}

static ULL read_leb128(void) {
  byte x=getb();
  int i=0;
  ULL r=0;
  while(x&0x80) {
    r|=(x&0x7F)<<(7*(i++));
    x=getb();
  }
  return r|(x<<(7*i));
}

static ULL read_utf16_le(void) {
  ULL r;
  if(mem) {
    r=mem;
    mem=0;
    return r;
  }
  r=getb();
  r|=getb()<<8;
  if(r>=0xD800 && r<0xDC00) {
    int x=fgetc(stdin);
    if(x==EOF) return r;
    x|=getb()<<8;
    if(x>=0xDC00 && x<0xE000) return (((r&0x3FF)<<10)|(x&0x3FF))+0x10000ULL;
    mem=x;
  }
  return r;
}

static ULL read_utf16_be(void) {
  ULL r;
  if(mem) {
    r=mem;
    mem=0;
    return r;
  }
  r=getb()<<8;
  r|=getb();
  if(r>=0xD800 && r<0xDC00) {
    int x=fgetc(stdin);
    if(x==EOF) return r;
    x=(x<<8)|getb();
    if(x>=0xDC00 && x<0xE000) return (((r&0x3FF)<<10)|(x&0x3FF))+0x10000ULL;
    mem=x;
  }
  return r;
}

static ULL read_translate(void) {
  return translation[getb()];
}

static ULL read_hex(void) {
  char a,b;
  do a=getb(); while(a<=' ');
  do b=getb(); while(b<=' ');
  return (((a&15)+(a>='A'?9:0))<<4)|((b&15)+(b>='A'?9:0));
}

static void write_8bit_raw(ULL x) {
  putchar(x);
}

static void write_16bit_le_raw(ULL x) {
  putchar(x&255);
  putchar(x>>8);
}

static void write_16bit_be_raw(ULL x) {
  putchar(x>>8);
  putchar(x&255);
}

static void write_32bit_le_raw(ULL x) {
  putchar(x&255);
  putchar(x>>8);
  putchar(x>>16);
  putchar(x>>24);
}

static void write_32bit_be_raw(ULL x) {
  putchar(x>>24);
  putchar(x>>16);
  putchar(x>>8);
  putchar(x&255);
}

static void write_64bit_le_raw(ULL x) {
  putchar(x&255);
  putchar(x>>8);
  putchar(x>>16);
  putchar(x>>24);
  putchar(x>>32);
  putchar(x>>40);
  putchar(x>>48);
  putchar(x>>56);
}

static void write_64bit_be_raw(ULL x) {
  putchar(x>>56);
  putchar(x>>48);
  putchar(x>>40);
  putchar(x>>32);
  putchar(x>>24);
  putchar(x>>16);
  putchar(x>>8);
  putchar(x&255);
}

static void write_utf8(ULL x) {
  if(out_mode=='0' && !x) {
    putchar(0xC0);
    putchar(0x80);
  } else if(x<0x80ULL) {
    putchar(x);
  } else if(x<0x800ULL) {
    putchar(0xC0|(x>>6));
    putchar(0x80|(x)&0xBF);
  } else if(x<0x10000ULL) {
    putchar(0xE0|(x>>12));
    putchar(0x80|(x>>6)&0xBF);
    putchar(0x80|(x)&0xBF);
  } else if(x<0x200000ULL) {
    putchar(0xF0|(x>>18));
    putchar(0x80|(x>>12)&0xBF);
    putchar(0x80|(x>>6)&0xBF);
    putchar(0x80|(x)&0xBF);
  } else if(x<0x4000000ULL) {
    putchar(0xF8|(x>>24));
    putchar(0x80|(x>>18)&0xBF);
    putchar(0x80|(x>>12)&0xBF);
    putchar(0x80|(x>>6)&0xBF);
    putchar(0x80|(x)&0xBF);
  } else if(x<0x80000000ULL) {
    putchar(0xFC|(x>>30));
    putchar(0x80|(x>>24)&0xBF);
    putchar(0x80|(x>>18)&0xBF);
    putchar(0x80|(x>>12)&0xBF);
    putchar(0x80|(x>>6)&0xBF);
    putchar(0x80|(x)&0xBF);
  } else if(x<0x1000000000ULL) {
    putchar(0xFE|(x>>36));
    putchar(0x80|(x>>30)&0xBF);
    putchar(0x80|(x>>24)&0xBF);
    putchar(0x80|(x>>18)&0xBF);
    putchar(0x80|(x>>12)&0xBF);
    putchar(0x80|(x>>6)&0xBF);
    putchar(0x80|(x)&0xBF);
  } else {
    exit(1);
  }
}

static void write_vlq8(ULL x) {
  int i;
  for(i=63;i;i-=7) if(x&-(1LL<<i)) putchar(0x80|(x>>i)&0xFF);
  putchar(x&0x7F);
}

static void write_leb128(ULL x) {
  while(x&~0x7FULL) {
    putchar(0x80|x&0xFF);
    x>>=7;
  }
  putchar(x);
}

static void write_utf16_le(ULL x) {
  if(x>0x10FFFFULL) exit(1);
  if(x&0x1F0000ULL) {
    x-=0x10000ULL;
    write_16bit_le_raw((x>>10)|0xD800);
    write_16bit_le_raw((x&0x3FF)|0xDC00);
  } else {
    write_16bit_le_raw(x);
  }
}

static void write_utf16_be(ULL x) {
  if(x>0x10FFFFULL) exit(1);
  if(x&0x1F0000ULL) {
    x-=0x10000ULL;
    write_16bit_be_raw((x>>10)|0xD800);
    write_16bit_be_raw((x&0x3FF)|0xDC00);
  } else {
    write_16bit_be_raw(x);
  }
}

static void write_translate(ULL x) {
  int i;
  for(i=0;i<256;i++) if(translation[i]==x) { putchar(i); return; }
  exit(1);
}

static void write_hex(ULL x) {
  printf("%02X",(int)x);
}

static void write_unpack_ascii(ULL x) {
  while(x) {
    if(x&127) putchar(x&127);
    x>>=7;
  }
}

static const in_func_t in_func[128]={
  ['8']=read_8bit_raw,
  ['w']=read_16bit_le_raw,
  ['W']=read_16bit_be_raw,
  ['d']=read_32bit_le_raw,
  ['D']=read_32bit_be_raw,
  ['q']=read_64bit_le_raw,
  ['Q']=read_64bit_be_raw,
  ['1']=read_utf8,
  ['0']=read_utf8,
  ['V']=read_vlq8,
  ['v']=read_leb128,
  ['u']=read_utf16_le,
  ['U']=read_utf16_be,
  ['T']=read_translate,
  ['4']=read_hex,
  [0]=0
};

static const out_func_t out_func[128]={
  ['8']=write_8bit_raw,
  ['w']=write_16bit_le_raw,
  ['W']=write_16bit_be_raw,
  ['d']=write_32bit_le_raw,
  ['D']=write_32bit_be_raw,
  ['q']=write_64bit_le_raw,
  ['Q']=write_64bit_be_raw,
  ['1']=write_utf8,
  ['0']=write_utf8,
  ['V']=write_vlq8,
  ['v']=write_leb128,
  ['u']=write_utf16_le,
  ['U']=write_utf16_be,
  ['T']=write_translate,
  ['4']=write_hex,
  ['a']=write_unpack_ascii,
  [0]=0
};

int main(int argc,char**argv) {
  int b;
  int is_lf=0;
  ULL x;
#ifdef _WIN32
  _setmode(_fileno(stdin),_O_BINARY);
  _setmode(_fileno(stdout),_O_BINARY);
#endif
  if(argc<2 || !argv[1][0] || !in_func[argv[1][0]] || !out_func[argv[1][1]]) return 1;
  in_mode=argv[1][0];
  out_mode=argv[1][1];
  for(b=2;argv[1][b];b++) options[argv[1][b]&127]=1;
  if(argc>2) {
    FILE*fp=fopen(argv[2],"rb");
    int i;
    if(!fp) return 1;
    fseek(fp,0,SEEK_END);
    b=ftell(fp)>>8;
    rewind(fp);
    for(i=0;i<255;i++) {
      translation[i]=fgetc(fp);
      if(b>1) translation[i]=trans_le?(translation[i]|((ULL)fgetc(fp)<<8)):((translation[i]<<8)|fgetc(fp));
      if(b>2) translation[i]=trans_le?(translation[i]|((ULL)fgetc(fp)<<16)):((translation[i]<<8)|fgetc(fp));
      if(b>3) translation[i]=trans_le?(translation[i]|((ULL)fgetc(fp)<<24)):((translation[i]<<8)|fgetc(fp));
      if(b>4) translation[i]=trans_le?(translation[i]|((ULL)fgetc(fp)<<32)):((translation[i]<<8)|fgetc(fp));
      if(b>5) translation[i]=trans_le?(translation[i]|((ULL)fgetc(fp)<<40)):((translation[i]<<8)|fgetc(fp));
      if(b>6) translation[i]=trans_le?(translation[i]|((ULL)fgetc(fp)<<48)):((translation[i]<<8)|fgetc(fp));
      if(b>7) translation[i]=trans_le?(translation[i]|((ULL)fgetc(fp)<<56)):((translation[i]<<8)|fgetc(fp));
    }
    fclose(fp);
  }
  if(bom_out) out_func[out_mode&127](0xFEFF);
  while(!feof(stdin)) {
    x=in_func[in_mode&127]();
    if(bom_in && x!=0xFEFF) return 1;
    if(is_lf && x==10) {
      is_lf=0;
      continue;
    }
    if(is_lf=(conv_lf && x==13)) x=10;
    if(conv_cr && x==10) out_func[out_mode&127](13);
    if(!bom_in) out_func[out_mode&127](x);
    bom_in=0;
  }
  return 0;
}
