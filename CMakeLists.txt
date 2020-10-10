cmake_minimum_required(VERSION 3.16)
project(sedutil-linuxpba LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 11)
add_executable(linuxpba
	linux/DtaDevLinuxNvme.cpp
	linux/DtaDevLinuxSata.cpp
	linux/DtaDevOS.cpp
	LinuxPBA/UnlockSEDs.cpp
	LinuxPBA/GetPassword.cpp
	LinuxPBA/LinuxPBA.cpp
	Common/DtaAnnotatedDump.cpp
      	Common/DtaDevOpal.cpp
     	Common/DtaHexDump.cpp
	Common/DtaCommand.cpp
	Common/DtaDevOpal1.cpp
      	Common/DtaResponse.cpp
	Common/DtaDev.cpp
	Common/DtaDevOpal2.cpp
      	Common/DtaSession.cpp
	Common/DtaDevEnterprise.cpp
      	Common/DtaDiskType.cpp
	Common/DtaDevGeneric.cpp
	Common/DtaHashPwd.cpp
	Common/pbkdf2/blockwise.c  Common/pbkdf2/hmac.c    Common/pbkdf2/sha1.c
	Common/pbkdf2/chash.c      Common/pbkdf2/pbkdf2.c
	)
target_include_directories(linuxpba PRIVATE linux LinuxPBA Common Common/pbkdf2)
