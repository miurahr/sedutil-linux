cmake_minimum_required(VERSION 3.16)
project(sedutil LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 11)
add_compile_options(-m64 -Wall -O2)
add_link_options(-static -static-libgcc -static-libstdc++)
include_directories(linux prebootauth cli common common/pbkdf2)

add_library(common OBJECT
            common/DtaAnnotatedDump.cpp
            common/DtaCommand.cpp
            common/DtaDev.cpp
            common/DtaDevEnterprise.cpp
            common/DtaDevGeneric.cpp
            common/DtaDevOpal.cpp
            common/DtaDevOpal1.cpp
            common/DtaDevOpal2.cpp
            common/DtaDiskType.cpp
            common/DtaHashPwd.cpp
            common/DtaHexDump.cpp
            common/DtaResponse.cpp
            common/DtaSession.cpp
            common/pbkdf2/blockwise.c
            common/pbkdf2/chash.c
            common/pbkdf2/pbkdf2.c
            common/pbkdf2/sha1.c
            common/pbkdf2/hmac.c
            )
add_library(linuxdevice OBJECT
            linux/DtaDevLinuxNvme.cpp
            linux/DtaDevLinuxSata.cpp
            linux/DtaDevOS.cpp
            )
link_libraries(common linuxdevice)
add_executable(linuxpba
               prebootauth/UnlockSEDs.cpp
               prebootauth/GetPassword.cpp
               prebootauth/LinuxPBA.cpp
               )
add_executable(sedutil-cli cli/DtaOptions.cpp cli/sedutil.cpp)
