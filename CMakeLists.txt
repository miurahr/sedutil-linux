cmake_minimum_required(VERSION 3.16)
project(sedutil-linuxpba LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 11)
add_compile_options(-m64 -Wall -O2)
include_directories(linux LinuxPBA Common Common/pbkdf2)

add_library(common OBJECT
            Common/DtaAnnotatedDump.cpp
            Common/DtaCommand.cpp
            Common/DtaDev.cpp
            Common/DtaDevEnterprise.cpp
            Common/DtaDevGeneric.cpp
            Common/DtaDevOpal.cpp
            Common/DtaDevOpal1.cpp
            Common/DtaDevOpal2.cpp
            Common/DtaDiskType.cpp
            Common/DtaHashPwd.cpp
            Common/DtaHexDump.cpp
            Common/DtaResponse.cpp
            Common/DtaSession.cpp
            Common/pbkdf2/blockwise.c
            Common/pbkdf2/chash.c
            Common/pbkdf2/pbkdf2.c
            Common/pbkdf2/sha1.c
            Common/pbkdf2/hmac.c
            )
add_library(linuxdevice OBJECT
            linux/DtaDevLinuxNvme.cpp
            linux/DtaDevLinuxSata.cpp
            linux/DtaDevOS.cpp
            )
link_libraries(common linuxdevice)
add_executable(linuxpba
               LinuxPBA/UnlockSEDs.cpp
               LinuxPBA/GetPassword.cpp
               LinuxPBA/LinuxPBA.cpp
               )
add_executable(sedutil-cli Common/DtaOptions.cpp Common/sedutil.cpp)
