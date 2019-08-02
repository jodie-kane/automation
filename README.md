The conf.py is used with fabric (upto v1.14.1 AFAICT) \
I created it to help automate what was a completely manual deployment process.

It's Hideously Functional (tm). \
(but not as ugly as the recent bash re-write :P )

#### Python
The python version has examples at the end of the file
```bash
shell> virtualenv -p python2.7 ~/path/to/virtenvs/fabric
shell> source ~/path/to/virtenvs/fabric/bin/activate
shell> pip install fabric==1.14.1
shell> python ~/path/to/automation/conf.py 
```

This way we could use a spreadsheet / ini-file to hold pre-determined answers \
to the deployment questions which would be asked as part of the roll-out process.

Therefore the release scripts + the answers to the release questions and the application code \
could all be reviewed in advance, and maintained within version control and tied to a unique revision number.

The bash script is really just a port of the python version.  It doesn't handle ini files in the standard format yet. 

#### Bash 
The bash file has a separate file for examples:
```bash
shell> ./auto_conf_tests.sh
```

caveats: 
 - it can / should be improved ;)
 - it's output is uglier than the python script
 - and it hasn't been used in a production environment
 - should use an ini-parser library

It was really a practice exercise to 'keep my eye in'
