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

#include <ctype.h>
#include <iostream>
#include <stdio.h>
#include <string>
#include <termios.h>

#include "GetPassword.h"

using namespace std;

string GetPassword(const string &prompt) {
	const char BACKSPACE = 127;
	const char ESCAPE = 27;
	const char RETURN = 10;

	//save terminal mode
	struct termios prev_termios;
	tcgetattr(0, &prev_termios);

	//disable buffered i/o and echo mode
	struct termios new_termios = prev_termios;
	new_termios.c_lflag &= ~(ICANON | ECHO);
	tcsetattr(0, TCSANOW, &new_termios);

	string password;
	cout << prompt;
	while (true) {
		char c = getchar();
		if (c == RETURN) {
			break;
		} else if (c == BACKSPACE) {
			if (!password.empty()) {
				cout << "\b \b";
				password.resize(password.length() - 1);
			}
		} else if (c == ESCAPE) {
			c = getchar();
			if (c == '[') {
				//this is an escape sequence, discard the rest
				c = getchar();
				if (c == '[') {
					getchar();
				} else if (isdigit(c)) {
					while (c != '~') {
						c = getchar();
					}
				}
			} else {
				ungetc(c, stdin);
			}
		} else {
			password += c;
			cout << "*";
		}
	}

	//restore terminal mode
	tcsetattr(0, TCSANOW, &prev_termios);
	return password;
}
