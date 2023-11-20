#!/bin/bash
if [[ x$1 -eq x ]]; then
   sblbin=../bin/sbl
else
   sblbin=$1
fi

${sblbin} math_atan.sbl
${sblbin} math_chop.sbl
${sblbin} math_cos.sbl
${sblbin} math_diff.sbl
${sblbin} math_div.sbl
${sblbin} math_exp.sbl
${sblbin} math_limits1.sbl
${sblbin} math_limits2.sbl
${sblbin} math_limits3.sbl
${sblbin} math_limits4.sbl
${sblbin} math_ln.sbl
${sblbin} math_plus.sbl
${sblbin} math_minus.sbl
${sblbin} math_pow.sbl
${sblbin} math_prod.sbl
${sblbin} math_read.sbl
${sblbin} math_remdr.sbl
${sblbin} math_sin.sbl
${sblbin} math_sqrt.sbl
${sblbin} math_sum.sbl
${sblbin} math_tan.sbl
