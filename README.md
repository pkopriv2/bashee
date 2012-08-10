# Bashee 

Bashee is a simple command line utility to parse embedded bash files (.esh). An .esh file is to 
bash what an .erb file is to ruby albeit with somewhat limited functionality.   An .esh file has 
a very simple structure.  Bash blocks are surrounded with double hyphens (--) and all variables 
within the file are parsed as variables.  Here is a quick example of a .esh file:

	--
	greeting="World"
	--
	hello, $greeting!

# Installation

* Install the current version.
	
	curl https://raw.github.com/pkopriv2/bashee/master/install.sh | bash -s 

* Install a specific version.

	curl https://raw.github.com/pkopriv2/bashee/master/install.sh | bash -s "1.0.1"

# Usage

## Basic Case

hello.esh:

	--
	greeting="World"
	--
	hello, $greeting!

command:

	bashee hello.esh > hello.txt

## Variables from stdin.

hello.esh:

	hello, $greeting!

command:

	bashee hello.esh > hello.txt <<-EOF
		greeting="world" 
	EOF 

## Variables from the current environment

hello.esh:

	hello, $greeting!

command:

	export greeting="world"
	env bashee hello.esh > hello.txt
