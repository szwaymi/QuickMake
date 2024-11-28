[SQM] = SWT Qucik Make Template
----------------------------------------------------------------------------
[Arguments] 
    
    Please define the variables below in the main makefile

    SQM_FILE_TARGET = The final target file name 
    SQM_FILE_SRC = The source files
    SQM_FOLDER_DEP = Folder for the dependency rule files.
    SQM_FOLDER_OBJ = Folder for the object files
    SQM_CMD_RUN = Running test command

[Remark]
    
    1. include this makefile in the main makefile.
    2. Use back slash, '/', as the folder seprator

[OS and Makefile]

    Makefile

    windows.mak    For windows, it would use powershell as shell.
    linux.mak      For linux, however, the shell is not confirmed.

    Including

    Use the codes below to include suitable makefile.

    ifeq ($(OS), Windows_NT)
    include windows.mak
    else
    include linux.mak
    endif
