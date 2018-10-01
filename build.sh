KERNEL_DIR=$PWD
ANYKERNEL_DIR=$KERNEL_DIR/AnyKernel2
CCACHEDIR=../CCACHE/gemini
TOOLCHAINDIR=~/toolchain/ubertc_aarch64-4.9
DATE=$(date +"%Y%m%d")
KERNEL_NAME="Nightmare"
DEVICE="gemini"
VER="Oreo-v1.0"
FINAL_ZIP="$KERNEL_NAME"-"$DEVICE"-"$VER"-"$DATE".zip

export LOCALVERSION=-${KERNEL_NAME}-${VER}
export ARCH=arm64
export KBUILD_BUILD_USER="HASH"
export KBUILD_BUILD_HOST="lazy-machine"
export CROSS_COMPILE=$TOOLCHAINDIR/bin/aarch64-linux-android-
export LD_LIBRARY_PATH=$TOOLCHAINDIR/lib/
export USE_CCACHE=1
export CCACHE_DIR=$CCACHEDIR/.ccache

echo "  "
echo " Clean up some shit!! "
echo " -------------------- "
rm $ANYKERNEL_DIR/gemini/*.zip
rm $ANYKERNEL_DIR/gemini/Image.gz-dtb
rm $KERNEL_DIR/arch/arm64/boot/Image.gz $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb
make clean && make mrproper

echo "  "
echo " Build it "
echo " -------- "
make gemini_defconfig
make -j$( nproc --all )

echo "  "
echo " Wrap things up "
echo " -------------- "
cp $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb $ANYKERNEL_DIR/gemini
cd $ANYKERNEL_DIR/gemini
zip -r9 $FINAL_ZIP * -x *.zip $FINAL_ZIP
echo "  "
echo " Build Complete "
echo " -------------- "
