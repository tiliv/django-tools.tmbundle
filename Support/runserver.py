#!/usr/bin/env python

import os
import sys
from multiprocessing import Process

from django.core.management import execute_from_command_line

PID_FILENAME = os.environ['TMPDIR'] + 'runserver.pid'

# Bundle helpers
def get_existing_pid():
    try:
        return open(PID_FILENAME).read()
    except:
        pass

def set_pid(pid):
    with open(PID_FILENAME, 'w') as f:
        f.write(str(pid))

def remove_pid():
    with open(PID_FILENAME, 'w') as f:
        f.write('')
        
class Writer(object):
    def write(self, s=''):
        echo(s)
    def flush(self):
        # sys.stdout.flush()
        sys.__stdout__.flush()
        
# New process target
def runserver(bind_address):
    """
    Function that is the target of the subprocess.
    
    """
    
    set_pid(os.getpid())
    sys.stdout = Writer()
    execute_from_command_line(argv=['', 'runserver'])
    # echo("Server is running")
    
    remove_pid()

# Ongoing helpers
def echo(s=''):
    sys.__stdout__.write("""<pre>{}</pre>""".format(str(s).replace('<', '&lt;')))
    # sys.stdout.flush()

if __name__ == "__main__":
    pid = get_existing_pid()
    if pid:
        # Kill existing process first
        echo("ALREADY RUNNING; PID={}".format(pid))
    
    echo(__name__)
    
    bind_address = os.environ.get('DJANGO_BIND_ADDRESS', 'localhost:8000')
    os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'
    sys.path.insert(0, os.environ['TM_PROJECT_DIRECTORY'])
    
    process = Process(target=runserver, args=(bind_address,))
    
    # go go gadget subprocess
    process.start()
    process.join()
