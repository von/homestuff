#
# Utility functions

######################################################################
#
# Testing functions

# Is the given variable non-null?
function defined()
{
    test "X${1}" != "X"
}

# Is the given variable undefined?
function undefined()
{
    test "X${1}" = "X"
}

# Is the given value a valid file?
function is_file()
{
    $(defined ${1}) && test -f ${1} -a -r ${1}
}

# Is the given value a valid directory?
function is_dir()
{
    $(defined ${1}) && test -d ${1} -a -r ${1}
}

# Given a list of potential directories, filter those that don't exist
function filter_dirs()
{
    local exist
    for dir; do
	if $(is_dir ${dir}) ; then
	    if $(defined ${exist}) ; then
		exist+=" "${dir}
	    else
		exist=${dir}
	    fi
	fi
    done
    echo $exist
}

######################################################################
#
# Print warning

warn()
{
    echo $* 1>&2
}

######################################################################
#
# Are we root?
#

function am_root()
{
    # Kudos: http://superuser.com/a/688629/128341
    if [[ $UID == 0 || $EUID == 0 ]]; then 
      return 0
    fi
    return 1
}

function am_not_root()
{
    if am_root ; then
      return 1
    fi
    return 0
}

######################################################################
#
# Are we on a remote machine?
#

function am_remote()
{
    # Kudos: http://unix.stackexchange.com/a/9607/29832
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
      return 0
    fi
    return 1
}


######################################################################
#
# Are we interactive?
#

function am_interactive()
{
    # Checking for -i file in invocation arguments
    if [[ "$-" == *i* ]] ; then
	return 0
    else
	return 1
    fi
}
