
SQM_FILE_TARGET = QuickMake.exe
SQM_FILE_SRC = main.cpp Test/test.cpp
SQM_FOLDER_DEP = .Dep
SQM_FOLDER_OBJ = .Obj
SQM_CMD_RUN = ./QuickMake

ifeq ($(OS), Windows_NT)
#include windows_template.mak
else
include linux.mak
endif
