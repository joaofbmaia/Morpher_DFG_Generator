rm *_looptrace.log
rm *_loopinfo.log
rm *_munittrace.log
rm memtraces/*
clang -D CGRA_COMPILER -target i386-unknown-linux-gnu -c -emit-llvm -O2 -fno-tree-vectorize  -fno-slp-vectorize -mllvm -inline-threshold=100 -fno-unroll-loops fir.c -S -o fir.ll
opt -gvn -mem2reg -memdep -memcpyopt -lcssa -loop-simplify -licm -loop-deletion -indvars -simplifycfg -mergereturn -indvars fir.ll -o fir_gvn.ll
#opt -load ~/manycore/cgra_dfg/buildeclipse/skeleton/libSkeletonPass.so -fn $1 -ln $2 -ii $3 -skeleton fir_gvn.ll -S -o fir_gvn_instrument.ll

opt -load ../../build/skeleton/libSkeletonPass.so -fn $1 -skeleton fir_gvn.ll -S -o fir_gvn_instrument.ll

#clang -target i386-unknown-linux-gnu -c -emit-llvm -S ../../skeleton/instrumentation/instrumentation.cpp -o instrumentation.ll

#llvm-link fir_gvn_instrument.ll instrumentation.ll -o final.ll

#llc -filetype=obj final.ll -o final.o
#clang++ -m32 final.o -o final
