#!/usr/bin/env bash
export PATH="/home/arvin/.local/lib/python3.8/site-packages/siliconcompiler/tools/surelog/bin:/home/arvin/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
cd /home/arvin/Desktop/build/Register_File/job0/import/0
surelog -nocache -parse -nouhdm /home/arvin/Desktop/Register_File.v -top Register_File +libext+.sv+.v
