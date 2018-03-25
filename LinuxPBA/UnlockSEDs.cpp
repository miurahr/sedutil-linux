/* C:B**************************************************************************
This software is Copyright 2014-2017 Bright Plaza Inc. <drivetrust@drivetrust.com>

This file is part of sedutil.

sedutil is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

sedutil is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with sedutil.  If not, see <http://www.gnu.org/licenses/>.

* C:E********************************************************************** */

#include <algorithm>
#include <dirent.h>
#include <iostream>
#include <memory>

#include "DtaDevGeneric.h"
#include "DtaDevOpal1.h"
#include "DtaDevOpal2.h"
#include "UnlockSEDs.h"

using namespace std;

void UnlockSEDs(char *password) {
	vector<string> devices;
	DIR *dir = opendir("/dev");
	if (dir != NULL) {
		while (true) {
			struct dirent *dirent = readdir(dir);
			if (dirent == NULL) {
				closedir(dir);
				break;
			}
			string dev_name = dirent->d_name;
			if (dev_name.compare(0, 2, "sd") == 0 || dev_name.compare(0, 4, "nvme") == 0) {
				devices.push_back("/dev/" + dev_name);
			}
		}
	}
	sort(devices.begin(), devices.end());

	cout << endl << endl << "[+] Unlocking devices..." << endl;
	for (const string &dev_path : devices) {
		unique_ptr<DtaDev> dev(new DtaDevGeneric(dev_path.c_str()));
		string dev_descr = "Device " + dev_path + " (" + dev->getModelNum() + ")";

		if (!dev->isPresent()) {
			continue;
		} else if (!dev->isOpal1() && !dev->isOpal2()) {
			cout << "[i] " << dev_descr << " does not support encryption" << endl;
			continue;
		} else if (dev->isOpal2()) {
			dev.reset(new DtaDevOpal2(dev_path.c_str()));
		} else {
			dev.reset(new DtaDevOpal1(dev_path.c_str()));
		}
		dev->no_hash_passwords = false;

		if (dev->Locked()) {
			bool failed = false;
			if (dev->MBREnabled() && dev->setMBRDone(1, password)) {
				failed = true;
			}
			if (dev->setLockingRange(0, OPAL_LOCKINGSTATE::READWRITE, password)) {
				failed = true;
			}

			if (failed) {
				cout << "\033[31m[!] " << dev_descr << " failed to decrypt\033[39m" << endl;
			} else {
				cout << "\033[32m[i] " << dev_descr << " was decrypted successfully\033[39m" << endl;
			}
		} else {
			cout << "[i] " << dev_descr << " is not encrypted" << endl;
		}
	}
}
