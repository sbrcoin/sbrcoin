#!/bin/bash
echo -e "\033[0;32mHow many CPU cores do you want to be used in compiling process? (Default is 1. Press enter for default.)\033[0m"
read -e CPU_CORES
if [ -z "$CPU_CORES" ]
then
	CPU_CORES=1
fi

# Clone SBRC code from SBRC official Github repository
	git clone https://github.com/sbrccoin-com/SBRC

# Entering SBRC directory
	cd SBRC

# Compile dependencies
	cd depends
	make -j$(echo $CPU_CORES) HOST=x86_64-apple-darwin17 
	cd ..

# Compile SBRC
	./autogen.sh
	./configure --prefix=$(pwd)/depends/x86_64-apple-darwin17 --enable-cxx --enable-static --disable-shared --disable-debug --disable-tests --disable-bench
	make -j$(echo $CPU_CORES) HOST=x86_64-apple-darwin17
	make deploy
	cd ..

# Create zip file of binaries
	cp SBRC/src/sbrcd SBRC/src/sbrc-cli SBRC/src/sbrc-tx SBRC/src/qt/sbrc-qt SBRC/SBRC.dmg .
	zip SBRC-MacOS.zip sbrcd sbrc-cli sbrc-tx sbrc-qt SBRC.dmg
	rm -f sbrcd sbrc-cli sbrc-tx sbrc-qt SBRC.dmg
