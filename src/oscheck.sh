os_check(){
	if [ "$(grep -Ei 'debian|ubuntu|mint|raspbian|*buntu' /etc/*release)" ]; then
		check_good "OS Verification Passed!";
	else
		print_error "OS Verification Failed!";
	fi
}
