/*****************************************************************************
** Macro: Data Mining and Machine Learning Batch Retrain
**
** Description: Invoke Data Mining and Machine Learning to retrain an existing
** project outside of the user interface.
** 
** This project was not created with a data plan.
******************************************************************************/

%macro DMBatchRetrain(hostname, port, token, projectId, datasourceUri);

filename resp TEMP;
filename headers TEMP;

%let batchRetrainUrl=&hostname:&port/dataMining/projects/&projectId/retrainJobs?dataUri=&datasourceUri&&action=batch;

proc http
  method="POST"
  url="&batchRetrainUrl"
  headerout=headers
  out=resp;
  headers
  "Accept"="application/vnd.sas.job.execution.job+json"
  "Authorization"=&token;
run;

data _null_;
 infile resp;
 input;
 put _infile_;
run;

%mend;

/******************************************************************************
** Macro: Data Mining and Machine Learning Batch Retrain Current Job
**
** Description: Issue a request to get the current batch retrain job
**
******************************************************************************/

%macro DMBatchRetrainCurrentJob(hostname, port, token, projectId);


filename resp TEMP;
filename headers TEMP;

%let retrainingJobUri=&hostname:&port/dataMining/projects/&projectId/retrainJobs/@currentJob;

proc http
  method="GET"
  url="&retrainingJobUri"
  headerout=headers
  out=resp;
  headers
  "Accept"="application/vnd.sas.job.execution.job+json"
  "Authorization"=&token;
run;

data _null_;
 infile resp;
 input;
 put _infile_;
run;

%mend;

/******************************************************************************
** Macro: Data Mining and Machine Learning Batch Retrain Get Champion Model
**
** Description: Issue a request to get the champion model
**
******************************************************************************/

%macro DMBatchRetrainChampion(hostname, port, token, projectId);

filename resp TEMP;
filename headers TEMP;

%let retrainingChampionUri=&hostname:&port/dataMining/projects/&projectId/retrainJobs/@lastJob/champion;

proc http
  method="GET"
  url="&retrainingChampionUri"
  headerout=headers
  out=resp;
  headers
  "Accept"="application/vnd.sas.analytics.data.mining.model+json"
  "Authorization"=&token;
run;

data _null_;
 infile resp;
 input;
 put _infile_;
run;

%mend;

/**********************************************************************************************
 * Edit the following options to customize the batch retrain operation
 * hostname:        REQUIRED: The Viya host name
 *                            If you don't specify the protocol, the default of http will apply
 *                            For TLS enabled systems, make sure to specify https
 * port:            REQUIRED: The Viya port
 *                            The default port for non-TLS systems is 80
 *                            For TLS enabled systems, the default port is 443
 * token:           REQUIRED: The OAuth2 token used to authenticate the request
 * projectId:       REQUIRED: The ID of the project being used for retraining
 * datasourceUri:   REQUIRED. The uri of the datasource being used for retraining
**********************************************************************************************/

%let hostname = HOST;
%let port = PORT;
%let token = TOKEN;
%let projectId = ce8b683b-58f8-43c6-a26c-b98cc3f6c89d;
%let datasourceUri = /dataTables/dataSources/cas~fs~cas-shared-default~fs~rm_mdl/tables/PRIVAT_OKONOMI;

/* The DMBatchRetrain macro is used for retraining a project with a new data table.
 * It takes auth token, datasourceUri. datasourceUri is
 * used to specify  the data table to use for retraining.*/
%DMBatchRetrain(&hostname, &port, &token, &projectId, &datasourceUri);

/* The DMBatchRetrainCurrentJob macro can be optionally run to get the status of
 * the current batch retrain job. This macro might need to be called several times
 * before the job completes and the final status is known. */
*%DMBatchRetrainCurrentJob(&hostname, &port, &token, &projectId);

/* The DMBatchRetrainChampion macro can be optionally run to get the champion
 * after batch retrain job has completed. */
*%DMBatchRetrainChampion(&hostname, &port, &token, &projectId);
