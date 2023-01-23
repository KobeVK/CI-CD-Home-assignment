import os, sys

buld_number = sys.argv[1]
envioronment = sys.argv[2]

os.environ['BUILD_NUMBER'] = buld_number
os.environ['ENVIRONMENT'] = envioronment


