#!/bin/bash 

# Ask questions with boolean answers 
# extract expected answers from a config.ini file
# optionally ask for confirmation per question, globally, or on error

verbose=1
prompt=1
cfile="conf.ini"

# returns 0 if string found in list; 1 if not
function strToBool {

    str="${1}"; shift
    strs="${@}"

    for s in ${strs[@]}
    do
      if [[ "${str}" == "${s}" ]]
      then
        return 0
      fi

    done

    return 1

}

# return if user specified in the affirmative
function isAffirm() {
  strToBool "${1^^}" "Y YES T TRUE C CONFIRM K KEEP"
  return $?
}

function isNegate(){
  strToBool "${1^^}" "N NO M MODIFY"
  return $?
}

# exit on abort 
function assertAbort {

  local astr="${1^^}"; 
  shift

  strToBool "${astr}" "A ABORT ~~ABORT~~"
  if [[ $? -eq 0 ]]
  then
    echo -ne "++ABORT++ ${@}\n"
    exit 9
  fi

}

# prompt with a provided question, and default return value
function iprompt {

  # iprompt cannot use echo to return values
  # as exit calls within subshells are not functional here

  local -n ret="${1}"
  query="${2}"
  defans="${3:-ABORT}"
  local answer=

  read -p "${query}" answer

  if [[ "x${answer}" == "x" ]]
  then
    answer="${defans}"
  fi

  assertAbort "${answer}" 

  ret="${answer^^}"
}

function echoVerbose(){
  if [[ ${verbose} -eq 0 ]]
  then
    echo -ne "${@}" >&2
  fi
}

function uprompt {

  local cfile="${cfile}" 
  section="default"
  key=""
  cans="K"
  copts="[(K)eep/(m)odify/(a)bort]"
  local prompt=${prompt}
  local ans="" 
  
  OPTIND=
  while getopts 'C:k:pq:s:v' flag
  do
   case "${flag}" in
      C) cfile="${OPTARG}";;
    k|q) key="${OPTARG}";;
      p) prompt=0;; 
      s) section="${OPTARG}";;
      v) verbose=0;;
   esac
   shift $(( ${OPTIND} - 1 ))
   OPTIND=
  done
 
  if [[ ! -r ${cfile} ]]
  then
    echo -ne "++ERROR++ Cannot read conf file: ${cfile}\n"
    assertAbort 'A'
  fi

  if [[ -z "${key}" ]]
  then
    echo -ne "++ERROR++ [${section}] Provided Key is Empty!\n"
    assertAbort "A" 
  fi

  echoVerbose "++TRYING++ [${section}] ${key}\n"

  # match against section_key; if found print extracted value and return 0; else just return 1
  # nice one to potong@stackexchange for the use of sed-hold-space as a way of changing the return value
  # this is GNU only ;)
  ans=$( sed -nre "/^\W*${section}_${key}\W*=\W*(.*?)/{s//\1/ ;h}; \${x;/./{p;q0};q1}" "${cfile}" 2>/dev/null )
  if [[ $? -ne 0 ]]
  then
    echo -ne "++ERROR++ Cannot find [${section}] ${key}\n"
    prompt=0
  else

    echoVerbose "++EXTRACTED++ [${section}] ${key} == \"${ans}\"\n"

    isAffirm "${ans}"
    y=$?
 
    isNegate "${ans}"
    n=$?

    if [[ ${y} -ne 0 && ${n} -ne 0 ]]
    then
      # invalid answer -- prompt for new one ;)
      prompt=0 
      ans=""
    fi

  fi

  if [[ ${prompt} -eq 0 ]]
  then

    # if not ans
    if [[ -z "${ans}" ]]
    then

      echo -ne "++CONFIRM++ [${section}] ${key}\n"
      iprompt ans "++INPUT++ Please specify the required value [y/n/A] " "A"

    else
     
      echo -ne "++CONFIRM++ [${section}] ${key} == \"${ans}\"\n" 
      iprompt modify "++CONFIRM++ Please choose [(K)eep/(m)odify/(a)bort] " "K"
      isAffirm "${modify}"
      if [[ $? -ne 0 ]]
      then
        iprompt ans "++INPUT++ Specify [${section}] ${key} = [y/n/A]? " "A" 
      fi

    fi

  fi

  isAffirm "${ans}"
  return $?
  

}

