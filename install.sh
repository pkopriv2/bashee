#!/usr/bin/env bash

info() {
	if ! tput setaf &> /dev/null
	then
		echo -e "$1"
	else
		echo -e "$(tput setaf 2)$1$(tput sgr0)"
	fi
}

error() {
	if ! tput setaf &> /dev/null
	then
		echo -e "$1" 1>&2
	else
		echo -e "$(tput setaf 1)$1$(tput sgr0)" 1>&2
	fi
}

if (( $# > 0 )) 
then
	info "Installing version: $1"
	version=$1
else
	info "Installing latest version of bashee."
	version="latest" 
fi

if (( $UID == 0 )) 
then
	error "Installing as root is not currently supported."
	exit 1
fi

bashee_file_tmp=${bashee_file_tmp:-/tmp/bashee.tar}
bashee_file_remote=${bashee_file_remote:-"https://github.com/downloads/pkopriv2/bashee/bashee-$version.tar"}

info "Attempting to download tar file: $bashee_file_remote"
if command -v curl &> /dev/null
then
	if ! curl -L $bashee_file_remote > $bashee_file_tmp
	then
		error "Error downloading: $bashee_file_remote.  Either cannot download or cannot write to file: $bashee_file_tmp"
		exit 1
	fi

elif command -v wget &> /dev/null
then
	if ! wget -q -O $bashee_file_tmp $bashee_file_remote
	then
		error "Error downloading: $bashee_file_remote.  Either cannot download or cannot write to file: $bashee_file_tmp"
		exit 1
	fi

else
	error "This installation requires either curl or wget."
	exit 1
fi


info "Installing bashee."
if ! tar -xf $bashee_file_tmp -C ~
then
	error "Error unpackaging tmp file [$bashee_tmp_file]"
	exit 1
fi 

env_files=( "~/.bashrc" "~/.zshrc" ) 
for file in "${env_files[@]}"
do
	eval "file=$file" # expand the path correctly

	if [[ ! -f $file ]]
	then
		continue
	fi

	if grep -q "source ~/.bashee/env.sh" $file
	then
		continue
	fi

	info "Adding env entries to: $file"
	cat - >> $file <<-EOF

		# Generated by: bashee
		source ~/.bashee/env.sh
	EOF

	if (( $? )) 
	then 
		error "Error updating file [$file]"
		exit 1
	fi
done

info "Successfully installed bashee!  Please source your environment for changes to take effect."
