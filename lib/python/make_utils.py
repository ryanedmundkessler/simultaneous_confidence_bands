import os, sys, subprocess, shutil

LOG_DIR_DEFAULT = '../output/'

def run_python(program, log_dir = LOG_DIR_DEFAULT):

    log_file   = program.replace('.py', '.log') 
    cmd        = 'python {0}'.format(program)

    print('\nExecuting: {0}'.format(cmd))

    with open(log_dir + log_file, 'w') as log:
        subprocess.call(cmd, shell = True, stdout = log) 
        log.close()

def run_stata(program, log_dir = LOG_DIR_DEFAULT):
    
    log_file = program.replace('.do', '.log') 
    cmd      = 'stata-se -b {0}'.format(program)

    print('\n Executing: {0}'.format(cmd))

    subprocess.call(cmd, shell = True) 
    os.rename(log_file, log_dir + log_file) 

def clear_dirs(dir_list):

    for dir in dir_list:
        if os.path.exists(dir):
            shutil.rmtree(dir)
        os.mkdir(dir)

