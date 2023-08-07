%macro deploy_to_test(DECISION_PATH, FLOW_NAME, DESTINATION);
  /* Get module code from TEST */
  %get_module_code(&DECISION_PATH., &FLOW_NAME., &DESTINATION., &VIYA_TEST., sas_services);

  /* Publish to TEST */
  %publish_module(&FLOW_NAME., &DESTINATION., &VIYA_TEST., sas_services);
%mend;



