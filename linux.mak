
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
	@echo Done

#[Folder]
$(SQM_FOLDER_DEP):
	@echo Creating $@
	@mkdir $@

 $(SQM_FOLDER_OBJ):
	@echo Creating $@
	@mkdir $@

C_TEMP = test

#[General Rules]
$(SQM_FOLDER_DEP)/%.d: $(SQM_FOLDER_DEP)
	@g++ -MM $(subst _C,:,$(subst _S,/,$(subst _U,_,$(patsubst %.d,%.cpp,$(notdir $@))))) | sed -E 's,^[a-zA-Z0-9_]+.o,$(patsubst $(SQM_FOLDER_DEP)/%.d,$(SQM_FOLDER_OBJ)/%.o,$@),g' > $@

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
	@rm -rf $(SQM_FOLDER_DEP)
	@echo Clean $(SQM_FOLDER_OBJ)
	@rm -rf $(SQM_FOLDER_OBJ)
	@echo Clean $(SQM_FILE_TARGET)
	@rm -rf $(SQM_FILE_TARGET)
	@echo Done
#	Run
run: $(SQM_FILE_TARGET)
	@powershell Write-Host -ForegroundColor Yellow [$$(Get-Date -Format \"yyyy/MM/dd HH:mm:ss\")]: $(SQM_CMD_RUN)
	@$(SQM_CMD_RUN)

#[Includes]
-include $(SQM_FILE_DEP)
