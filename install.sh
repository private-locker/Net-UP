#!/bin/bash
getdir(){
	SOURCE="${BASH_SOURCE[0]}"
	while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  		DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
		SOURCE="$(readlink "$SOURCE")"
		[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
	done
	DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
}
root_check_init(){
    echo "Checking for Root.."
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be ran with sudo or root privileges, or this isn't going to work."
            exit 1
    else
        echo "Root Access Granted!"
    fi
}
clonemain(){
        echo "Cloning from GitHub..";
        git clone https://github.com/private-locker/NET-UP.git $HOMEDIR
}
clonemods(){
        echo "Cloning Modules from Repo.";
        git clone https://github.com/private-locker/modules.git $HOMEDIR/modules
}
changeperm(){
        echo -e "Changing Permissions of Files..";
        chmod +x $HOMEDIR/netup
        chmod +x $HOMEDIR/modules/enablemod
        chmod +x $HOMEDIR/modules/disablemod
}
cleanup(){
	echo -e "Cleaning up Install Script File.."
	rm -rf "$HOMEDIR/install.sh"
	rm -rf "$0";
}
run(){
	echo -e "Running Net-UP..";
	bash $HOMEDIR/netup
}
getdir;
root_check_init;
HOMEDIR=/root/netup
if [[ -d "$HOMEDIR" ]] ; then
    echo "Directory already exists..";
    echo "Removing old copy..";
    rm -rf $HOMEDIR
else
    echo "$HOMEDIR does not exists.."
fi
if [ "$DIR" != "$HOMEDIR" ]; then
        if [ -f "$DIR/netup" ]; then
		mkdir "$HOMEDIR"
                cp -Rf $DIR/* "$HOMEDIR/"
		rm -rf "$DIR"
		cd "$HOMEDIR"
		clonemods;
	else
		cd /root/
		clonemain;
		clonemods;
		cd "$HOMEDIR"
	fi
else
	cd /root/
	clonemain;
	clonemods;
	cd "$HOMEDIR"
fi
changeperm;
cleanup;
run;
echo -e "Exiting.. You can now use netup anywhere in the system."
exit
