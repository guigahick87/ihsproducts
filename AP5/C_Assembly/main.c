#include <stdio.h>
#include <math.h>
 
#include "AsmMath.h"
 
int main(){
    double radians = 1;
    double x = 9, y = 0.22;
     
    printf("sin(%lf)            = %lf   = %lf\n", radians, asm_sin(radians), sin(radians));
    
	
	printf("cos(%lf)            = %lf   = %lf\n", radians, asm_cos(radians), cos(radians));
    
	printf("tan(%lf)            = %lf   = %lf\n", radians, asm_tan(radians), tan(radians));
    
	printf("%lf^%lf     		= %lf   = %lf\n", x, y, asm_pow(x, y), pow(x, y));
	
	printf("e^%lf           = %lf   = %lf\n", x, asm_exp(x), exp(x));
    
	printf("ln(%lf)             = %lf   = %lf\n", x, asm_log(x), log(x));
    
	printf("log10(%lf)          = %lf   = %lf\n", x, asm_log10(x), log10(x));
    
	printf("sqrt(%lf)           = %lf   = %lf\n", x, asm_sqrt(x), sqrt(x));
    
	 
    return 0;
}