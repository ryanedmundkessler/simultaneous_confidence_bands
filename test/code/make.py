import os, sys, subprocess, shutil

python_lib_path = '../../lib/python/'
shutil.copytree(python_lib_path, './python_lib/')
from python_lib.make_utils import * 

clear_dirs(['../output/'])

run_stata(program = 'basic_functionality.do')
run_stata(program = 'monte_carlo.do')

shutil.rmtree('python_lib')
raw_input('\n Press <Enter> to exit')