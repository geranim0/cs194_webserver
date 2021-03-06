#!/usr/bin/env xonsh

import argparse

parser = argparse.ArgumentParser(description='build either test or cs194_webserver')
parser.add_argument("--build_dir", type=str, choices=['cs194_webserver', 'test'], 
                        help='Which directory to build')

parser.add_argument("--build_all_conan", dest='build_all', action='store_true', 
                help='build all with conan')

parser.add_argument("--build_missing_conan", dest='build_all', action='store_false', 
                help='build missing with conan')

parser.set_defaults(build_all=False)

parser.add_argument("--build_type", type=str, choices=['Debug', 'Release'], 
                        help='Debug or Release?')

parser.add_argument("--conan_profile", type=str, help='Which conan profile to use?')

args = parser.parse_args()


cd @(args.build_dir)/build/@(args.build_type)

if not args.build_all:
    conan install ../.. --build=missing -pr=@(args.conan_profile)
else:
    conan install ../.. -b -pr=@(args.conan_profile)


cmake ../.. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=@(args.build_type)
state = !(cmake --build .)

#used for next script to know if compilation was success or failure
exit(state.returncode)