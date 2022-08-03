# psptoolchain-allegrex

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/pspdev/psptoolchain-allegrex/CI?label=CI&logo=github&style=for-the-badge)](https://github.com/pspdev/psptoolchain-allegrex/actions?query=workflow%3ACI)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/pspdev/psptoolchain-allegrex/CI-Docker?label=CI-Docker&logo=github&style=for-the-badge)](https://github.com/pspdev/psptoolchain-allegrex/actions?query=workflow%3ACI-Docker)

This program will automatically build and install a compiler and other tools used in the creation of homebrew software for the Sony Playstation Portable handheld videogame system (PSP).


## **ATENTION!**

If you're trying to install in your machine the **WHOLE PSP Development Environment** this is **NOT** the repo to use, you should use instead the [pspdev](https://github.com/pspdev/pspdev "pspdev") repo.

## What these scripts do

These scripts download (`git clone`) and install:

-   [binutils](https://github.com/pspdev/binutils-gdb "binutils")
-   [gdb](https://github.com/pspdev/binutils-gdb "gdb")
-   [gcc](https://github.com/pspdev/gcc "gcc")
-   [newlib](https://github.com/pspdev/newlib "newlib")
-   [pthread-embedded](https://github.com/pspdev/pthread-embedded "pthread-embedded")

## Requirements

1.  Install gcc/clang, make, cmake, patch, git, texinfo, flex, bison, gettext, wget, gsl, gmp, mpfr, mpc, readline, libarchive, gpgme, bash, openssl and libtool if you don't have those.
We offer a script to help you for installing dependencies:

### Ubuntu/Debian
```bash
sudo ./prepare-debian-ubuntu.sh
```

### Fedora
```bash
sudo ./prepare-fedora.sh
```

### OSX
```bash
sudo ./prepare-mac-os.sh
```
[MacPorts]: http://www.macports.org/
[HomeBrew]: http://brew.sh/

2.  Ensure that you have enough permissions for managing PSPDEV location (default to `/usr/local/pspdev`, but you can use a different path). PSPDEV location MUST NOT have spaces or special characters in its path! PSPDEV should be an absolute path. On Unix systems, if the command `mkdir -p $PSPDEV` fails for you, you can set access for the current user by running commands:
```bash
export PSPDEV=/usr/local/pspdev
sudo mkdir -p $PSPDEV
sudo chown -R $USER: $PSPDEV
```

3.  Add this to your login script (example: `~/.bash_profile`)
    **Note:** Ensure that you have full access to the PSPDEV path. You can change the PSPDEV path with the following requirements: only use absolute paths, don't use spaces, only use Latin characters.
```bash
export PSPDEV=/usr/local/pspdev
export PATH=$PATH:$PSPDEV/bin
```

4.  Run toolchain.sh
```bash
./toolchain.sh
```

## Thanks
