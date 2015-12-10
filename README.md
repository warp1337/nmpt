# nmpt

This is a clone of the Nick's Machine Perception Toolbox (http://mplab.ucsd.edu/~nick/NMPT/) which 
was only available via *.zip file and good old "GNU Make"
I borrowed the CMAKE file from: https://github.com/ChristianFrisson (Thanks!) and slightly changed 
the CMAKE CXXFlags to -fpermissive

## Dependencies Ubuntu

	 sudo apt-get install libhighgui2.4 libcv2.4 libopencv-gpu2.4 libcvaux-dev libcv-dev libhighgui-dev libopencv-gpu-dev 

## Installation

	git clone https://github.com/warp1337/nmpt.git
	cd nmpt
	mkdir build
	cd build
	cmake ..
	make
	(make install)

## Usage

	http://mplab.ucsd.edu/~nick/NMPT/
