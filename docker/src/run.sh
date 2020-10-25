#!/bin/bash

export OMP_THREAD_LIMIT=${PATH_FINDER_NUM_THREADS:-4}
export OMP_NUM_THREADS=${PATH_FINDER_NUM_THREADS:-4}
EXECUTABLE_SANITIZED=${SRC_DIR}/PathFinderCli/build/file_creator
EXECUTABLE_ULTRA=${SRC_DIR}/PathFinderCli/build_ultra/file_creator

if [ "$1" = "gdb" ]; then
    echo "Executing cgdb"
    /usr/bin/cgdb --args ${EXECUTABLE_SANITIZED} -f /graph.txt -l 10 -o /home/builder/out
elif [ "$1" = "valgrind" ]; then
    echo "Executing valgrind"
    valgrind ${EXECUTABLE_ULTRA} -f /graph.txt -l 10 -o /home/builder/out
else
    echo "Executing with asan"
    ${EXECUTABLE_SANITIZED} -f /graph.txt -l 10 -o /home/builder/out
fi

exit 0
