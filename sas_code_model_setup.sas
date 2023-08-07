
%mm_get_repository_id(
    repositorynm=DMRepository,
    idvar=myRepID,
    fldridvar=myRepFldrID
);

%put &=myRepFldrID;
%put &=myRepID;

%mm_create_folder(
    foldernm       = demo_sascode_project,
    reposfolderID  = %str(&myRepFldrID));

%mm_get_folder_id(
    repositorynm=DMRepository,
    foldernm=demo_sascode_project,
    idvar=myFldrID);

%put &=myFldrID;

%mm_create_project(
    projectnm        = Log_reg_model,
    folderID         = %str(&myFldrID),
    function         = classification,
    projectID        = projID,
    projectversionID = projVerID
);

%mm_get_project_id(
    projectnm=Log_reg_model,
    projectloc=%nrstr(DMRepository/demo_sascode_project),
    idvar=myProjID);

%put &=myProjID;
