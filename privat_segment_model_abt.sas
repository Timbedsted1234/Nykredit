/*****************************************************************
	NAME:	privat_segment_model_abt.sas
	DESC:	skaber/genskaber alle tre model abtere som anvendes
			til privat segmentet
******************************************************************/
%csbinit;
%let m_abt_stk_flg=N;
%let m_mdl_abt_lst_prc_by_usr=&sysuserid;
%let m_abt_stk_size=;
%let m_abt_bld_dt=31MAR2022;

%dabt_build_mdl_abt_wrapper(m_project_sk=14, m_abt_sk=1000011,
		m_abt_bld_dt=%quote(&m_abt_bld_dt),m_abt_stk_flg=&m_abt_stk_flg, m_abt_stk_size=&m_abt_stk_size, m_mdl_abt_lst_prc_by_usr=&m_mdl_abt_lst_prc_by_usr);

%dabt_build_mdl_abt_wrapper(m_project_sk=48, m_abt_sk=1000039,
		m_abt_bld_dt=%quote(&m_abt_bld_dt),m_abt_stk_flg=&m_abt_stk_flg, m_abt_stk_size=&m_abt_stk_size, m_mdl_abt_lst_prc_by_usr=&m_mdl_abt_lst_prc_by_usr);

%dabt_build_mdl_abt_wrapper(m_project_sk=61, m_abt_sk=1000050,
		m_abt_bld_dt=%quote(&m_abt_bld_dt),m_abt_stk_flg=&m_abt_stk_flg, m_abt_stk_size=&m_abt_stk_size, m_mdl_abt_lst_prc_by_usr=&m_mdl_abt_lst_prc_by_usr);

