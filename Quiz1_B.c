#include "stdio.h"
#include "stdint.h"

typedef union
{
    uint16_t bits;
}bf16_t;

float test[3] = {3.14159, 1.618, -123.456};
bf16_t test_bf16_output[3] = {0x0};
float test_output[3] = {0};

static inline float bf16_to_fp32(bf16_t h)
{
    union {
        float f;
        uint32_t i;
    } u = {.i = (uint32_t)h.bits << 16};
    return u.f;
}

static inline bf16_t fp32_to_bf16(float s)
{
    bf16_t h;
    union {
        float f;
        uint32_t i;
    } u = {.f = s};
    if ((u.i & 0x7fffffff) > 0x7f800000) { /* NaN */
        h.bits = (u.i >> 16) | 64;         /* force to quiet */
        return h;                                                                                                                                             
    }
    h.bits = (u.i + (0x7fff + ((u.i >> 0x10) & 1))) >> 0x10;
    return h;
}

int main(){  
    

    for (int i = 0; i < 3; i++)
    {
        test_bf16_output[i] = fp32_to_bf16(test[i]);
        test_output[i] = bf16_to_fp32(test_bf16_output[i]);
        printf("%f, 0x%.8X, %f \n", test[i], test_bf16_output[i].bits, test_output[i]);
    }
      
    return 0;
}