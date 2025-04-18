#!/bin/sh

show_help() {
	echo "Use '-b' or '--brew' to install packages with Homebrew, or use '-p' or '--port' to install with MacPorts."
	echo "If left unspecified, tries Homebrew first, then MacPorts."
	exit 1
}

if [ $# -gt 1 ]; then
	echo "Invalid number of command line options."
	show_help
fi

# default is autodetection
try_brew=1
try_port=1
if [ $# -eq 1 ]; then
	case "$1" in
	-b|--brew)
		try_port=0 ;;
	-p|--port)
		try_brew=0 ;;
	*)
		show_help ;;
	esac
fi

# Check if either Homebrew (brew) or MacPorts (port) are installed
if ! command -v brew &> /dev/null && ! command -v port &> /dev/null; then
	echo "Go install Homebrew from http://brew.sh/ or MacPorts from http://www.macports.org/ first, then we can talk!"
	exit 1
fi

# sanity checks
if [ $try_brew -eq 1 -a ! command -v brew &> /dev/null ]; then
	echo "Not trying Homebrew, because it is not installed."
	try_brew=0
fi
if [ $try_port -eq 1 -a ! -e command -v port &> /dev/null ]; then
	echo "Not trying MacPorts, because it is not installed."
	try_port=0
fi
if [ $try_brew -eq 0 -a $try_port -eq 0 ]; then
	echo "Invalid package manager specified. Maybe use autodetection."
	exit 1
fi

# actual installation
if [ $try_brew -eq 1 ]; then
	CURRENT_USER=$(stat -f '%Su' /dev/console)
	sudo -u $CURRENT_USER brew install gettext texinfo bison flex gnu-sed gsl gmp mpfr readline
	exit
fi
if [ $try_port -eq 1 ]; then
	sudo port install  gsed
	exit
fi
