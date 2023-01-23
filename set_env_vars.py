import os, sys

buld_number = sys.argv[1]
envioronment = sys.argv[2]

BUILD_NUMBER = os.getenv('BUILD_NUMBER', buld_number)
ENVIRONMENT = os.getenv('ENVIRONMENT', envioronment)