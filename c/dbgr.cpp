/*
 * @Author: https://github.com/zengfr 
 * @Date: 2020-10-27 10:35:05 
 * @Last Modified by:   https://github.com/zengfr 
 * @Last Modified time: 2020-10-27 10:35:05 
 */

#include <stdio.h>
#include <stdint.h>
 
extern "C" __declspec(dllexport) __cdecl char* getAuthor()
{ 
    char  author[] = "Author:https://github.com/zengfr";
    char *pstr = author;
    return pstr;
}
extern "C" __declspec(dllexport) __cdecl  void * getRegisters()
{
   static  uint64_t  rs[16]={
   0l,0,0,0l,
   0,0,0,0,
   0,0,0,0,
   0,0,0,0l};
 
    __asm__ __volatile__(
        " mov %%eax,%0 ;\n\t"
        " mov %%ebx,%1 ;\n\t"
        " mov %%ecx,%2 ;\n\t"
        " mov %%edx,%3 ;\n\t"

        " mov %%ebp,%4 ;\n\t"
        " mov %%esp,%5 ;\n\t"
        " mov %%esi,%6 ;\n\t"
        " mov %%edi,%7 ;\n\t"
       
        " mov %%r8,%8 ;\n\t"
        " mov %%r9,%9 ;\n\t"

         " mov %%cs,%10 ;\n\t"
         " mov %%ds,%11 ;\n\t"
         " mov %%es,%12 ;\n\t"
         " mov %%ss,%13 ;\n\t"
            :"=m"(rs[0]),"=m"(rs[1]),"=m"(rs[2]) ,"=m"(rs[3]) 
            ,"=m"(rs[4]),"=m"(rs[5]),"=m"(rs[6]) ,"=m"(rs[7]) 
            ,"=m"(rs[8]),"=m"(rs[9]),"=m"(rs[10]),"=m"(rs[11]) 
            ,"=m"(rs[12]),"=m"(rs[13]) 
             //: /* no  registers */
            //: /* no registers */
    );
    return rs;
}

extern "C" __declspec(dllexport) __cdecl  void * getBaseRegisters()
{
   static  uint64_t  rs[8]={0l,0,0,0l,0,0l,0,0l};
 
    __asm__ __volatile__(
       
         " mov %%eax,%0 ;\n\t"
        " mov %%ebx,%1 ;\n\t"
        " mov %%ecx,%2 ;\n\t"
        " mov %%edx,%3 ;\n\t"

        " mov %%ebp,%4 ;\n\t"
        " mov %%esp,%5 ;\n\t"
        " mov %%esi,%6 ;\n\t"
        " mov %%edi,%7 ;\n\t"
            :"=m"(rs[0]),"=m"(rs[1]),"=m"(rs[2]) ,"=m"(rs[3]) 
            ,"=m"(rs[4]),"=m"(rs[5]),"=m"(rs[6]) ,"=m"(rs[7]) 
             //: /* no registers */
            //: /* no registers */
    );
    return rs;
}
extern "C" __declspec(dllexport) __cdecl  void * getSegmentRegisters()
{
   static  uint64_t  rs[8]={0l,0,0,0l,0,0l,0,0l};
 
    __asm__ __volatile__(
       
         " mov %%cs,%0 ;\n\t"
         " mov %%ds,%1 ;\n\t"
         " mov %%es,%2 ;\n\t"
         " mov %%fs,%3 ;\n\t"
         " mov %%gs,%4 ;\n\t"
         " mov %%ss,%5 ;\n\t"
            :"=m"(rs[0]),"=m"(rs[1]),"=m"(rs[2]) ,"=m"(rs[3]) 
            ,"=m"(rs[4]),"=m"(rs[5]) 
             //: /* no registers */
            //: /* no registers */
    );
    return rs;
}
extern "C" __declspec(dllexport) __cdecl  void * getCpRegisters()
{
   static  uint64_t  rs[8]={
       0l,0l,0l,0l,
       0l,0l,0l,0l
   };
    
    __asm__ __volatile__(
       
         " mov %%r8,%0 ;\n\t"
         " mov %%r9,%1 ;\n\t"
         " mov %%r10,%2 ;\n\t"
         " mov %%r11,%3 ;\n\t"

         " mov %%r12,%4 ;\n\t"
         " mov %%r13,%5 ;\n\t"
         " mov %%r14,%6 ;\n\t"
         " mov %%r15,%7 ;\n\t"
            :"=m"(rs[0]),"=m"(rs[1]),"=m"(rs[2]) ,"=m"(rs[3]) 
            ,"=m"(rs[4]),"=m"(rs[5]),"=m"(rs[6]) ,"=m"(rs[7]) 
             //: /* no registers */
            //: /* no registers */
    );
    return rs;
}
extern "C" __declspec(dllexport) __cdecl  inline uint64_t readMem64(uint64_t *reg)
{
	uint64_t value;

	__asm__ __volatile__(
		"mov %[reg], %[val]\n"
		: [val] "=rm" (value)
		: [reg] "rm" (*reg)
		);

	return value;
}
extern "C" __declspec(dllexport) __cdecl  inline uint32_t readMem32(uint32_t *reg)
{
	uint32_t value;

	__asm__ __volatile__(
		"mov %[reg], %[val]\n"
		: [val] "=rm" (value)
		: [reg] "rm" (*reg)
		);

	return value;
}