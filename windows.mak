# [SQM] = SWT Qucik Make Template
# ----------------------------------------------------------------------------
# [Arguments] Please define the variables below in the main makefile
#  SQM_FILE_TARGET = The final target file name 
#  SQM_FILE_SRC = The source files
#  SQM_FOLDER_DEP = Folder for the dependency rule files.
#  SQM_FOLDER_OBJ = Folder for the object files
#  SQM_CMD_RUN = Running test command
# [Remark]
# 1. include this makefile in the main makefile.
# 2. Use back slash, '/', as the folder seprator

#[Phony Targets]
.PHONY: show run clean

#[Pre-defined Variables]
SQM_FILE_DEP = $(patsubst %.cpp,.Dep/%.d,$(subst :,_C,$(subst /,_S,$(subst _,_U,$(SQM_FILE_SRC)))))
SQM_FILE_OBJ = $(patsubst %.cpp,.Obj/%.o,$(subst :,_C,$(subst /,_S,$(subst _,_U,$(SQM_FILE_SRC)))))
SQM_GPP_LINK_ARG ?=

#[Final]
$(SQM_FILE_TARGET): $(SQM_FOLDER_DEP) $(SQM_FOLDER_OBJ) $(SQM_FILE_OBJ)
	@echo Linking...
	@g++ $(SQM_GPP_LINK_ARG) $(SQM_FILE_OBJ) -o $@
	@powershell Write-Host -ForegroundColor Green Done

#[Folder]
$(SQM_FOLDER_DEP):
	@echo Creating $@
	@powershell $$null = New-Item -Path ./ -Name $@ -ItemType Directory

 $(SQM_FOLDER_OBJ):
	@echo Creating $@
	@powershell $$null = New-Item -Path ./ -Name $@ -ItemType Directory

#[General Rules]
$(SQM_FOLDER_DEP)/%.d: $(SQM_FOLDER_DEP)
	@g++ -MM $(subst _C,:,$(subst _S,/,$(subst _U,_,$(patsubst %.d,%.cpp,$(notdir $@))))) -MF $@
	@powershell -command "(Get-Content $@) -replace '^([a-zA-Z0-9_]+).o:', '$(patsubst $(SQM_FOLDER_DEP)/%.d,$(SQM_FOLDER_OBJ)/%.o,$@):' | Out-File $@ -Encoding ASCII"

$(SQM_FOLDER_OBJ)/%.o:
	@echo Creating $@
	@g++ -c $(subst _C,:,$(subst _S,/,$(subst _U,_,$(patsubst %.o,%.cpp,$(notdir $@))))) -o $@

#[Function Target]
#	Show Dependencies and Objects
show:
	@echo Source = $(SQM_FILE_SRC)
	@echo Dependency = $(SQM_FILE_DEP)
	@echo Object = $(SQM_FILE_OBJ)
#	Clean
clean:
	@echo Clean $(SQM_FOLDER_DEP)
	@powershell (Remove-Item -Path $(SQM_FOLDER_DEP) -Force -Recurse -ErrorAction SilentlyContinue)
	@echo Clean $(SQM_FOLDER_OBJ)
	@powershell (Remove-Item -Path $(SQM_FOLDER_OBJ) -Force -Recurse -ErrorAction SilentlyContinue)
	@echo Clean $(SQM_FILE_TARGET)
	@powershell (Remove-Item -Path $(SQM_FILE_TARGET) -Force -Recurse -ErrorAction SilentlyContinue)
	@powershell Write-Host -ForegroundColor Green Done
#	Run
run: $(SQM_FILE_TARGET)
	@powershell Write-Host -ForegroundColor Yellow [$$(Get-Date -Format \"yyyy/MM/dd HH:mm:ss\")]: $(SQM_CMD_RUN)
	@$(SQM_CMD_RUN)

#[Includes]
include $(SQM_FILE_DEP)
