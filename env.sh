if [[ -z $bashee_home ]]
then
	export bashee_home=$HOME/.bashee
fi

PATH=$PATH:$bashee_home/bin
