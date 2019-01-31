import os, sys, subprocess, shutil

python_lib_path = './lib/python/'
shutil.copytree(python_lib_path, './python_lib/')
from python_lib.make_utils import * 

root = os.getcwd()

# UNIT TESTS 
os.chdir('./test/code/')
run_python(program = 'make_test.py')
os.chdir(root)

# EXAMPLE 
os.chdir('./example/code/')
run_python(program = 'make_example.py')
os.chdir(root)

shutil.rmtree('python_lib')
raw_input('\n Press <Enter> to exit')