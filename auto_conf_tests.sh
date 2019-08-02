#!/bin/bash

source ./auto_conf.sh

sec='deploy'
QUD001='Deploy Of Infrastructure'
QUD002='These Exact Words In Release Document'

uprompt -v -s "${sec}" -q "${QUD001}"
if [[ $? -eq 0 ]]
then
    echo -ne "START!! ~~~ ${QUD001} ~~~\n"
else
    echo -ne "BOO\n" 
fi

uprompt -v -p -s "${sec}" -q "${QUD002}"
if [[ $? -eq 0 ]]
then
    echo -ne "Truthness\n"
else
    echo -ne "Falsehood\n"
fi


# non-verbose; force user prompt
uprompt -v -s "ansible_deploy" -k "Ansible Prep"
if [[ $? -eq 0 ]]
then
  echo -ne "Prepping Ansible Environment!\n"
  echo -ne "ansible-playbook -i ....\n" 
else
  echo -ne "Skipping Ansible Prep!\n"
fi

# non-verbose; force user prompt
uprompt -s "deploy" -k "Deploy Of Infrastructure" -p
if [[ $? -eq 0 ]]
then
  echo -ne "\nThe Answer Given Was In The Affirmative\n"
  echo -ne "DEPLOYING INFRA!!!\n\n"
  
else
  echo -ne "\nThe Answer Given Was In The Negative\n"
  echo -ne "NOT DEPLOYING INFRA!!!\n\n"
fi

# non-verbose; no-prompt
echo -ne "\nShall we deploy optionals?\n"
uprompt -s "deploy" -k "These Exact Words In Release Document" 
if [[ $? -eq 0 ]]
then 
  echo -ne "\nThe Answer Given Was In The Affirmative\n"
  echo -ne "Enabling Optional Features!!!\n\n"
else
  echo -ne "\nThe Answer Given Was In The Negative\n"
  echo -ne "Must have been optional this release, etc...\n\n"
fi

# verbose; no-prompt
uprompt -v -s "test_suite" -k "Run Metric Tests" 
if [[ $? -eq 0 ]]
then 
  echo -ne "\nWizz...Foom!\n\n"
else
  echo -ne "\nMetrics? Where we're going...\n\n"
fi

