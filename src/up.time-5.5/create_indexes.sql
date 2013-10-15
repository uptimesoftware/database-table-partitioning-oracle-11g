set serveroutput on;
set pagesize 1000;
set linesize 1000;

-- performance_sample --
CREATE INDEX UPTPAR_S_UPTIMEHOST_ID 
ON PERFORMANCE_SAMPLE ("UPTIMEHOST_ID")
/
CREATE INDEX UPTPAR_S_ERDC_ID
ON PERFORMANCE_SAMPLE ("ERDC_ID")
/
CREATE INDEX UPTPAR_S_LATEST_SAMPLE
ON PERFORMANCE_SAMPLE ("ERDC_ID", "SAMPLE_TIME")
/
CREATE INDEX UPTPAR_S_SAMPLE_BY_HOST
ON PERFORMANCE_SAMPLE ("UPTIMEHOST_ID", "SAMPLE_TIME")
/

-- performance_aggregate --
-- no indexes necessary

-- performance_cpu --
CREATE INDEX UPTPAR_C_SAMPLE_ID 
ON PERFORMANCE_CPU ("SAMPLE_ID")
/

-- performance_disk --
CREATE INDEX UPTPAR_D_SAMPLE_ID 
ON PERFORMANCE_DISK ("SAMPLE_ID")
/

-- performance_disk_total --
-- no indexes necessary

-- performance_esx3_workload --
CREATE INDEX UPTPAR_E_SAMPLE_ID 
ON PERFORMANCE_ESX3_WORKLOAD ("SAMPLE_ID")
/

-- performance_fscap --
CREATE INDEX UPTPAR_F_SAMPLE_ID 
ON PERFORMANCE_FSCAP ("SAMPLE_ID")
/

-- performance_lpar_worload --
CREATE INDEX UPTPAR_L_SAMPLE_ID 
ON PERFORMANCE_LPAR_WORKLOAD ("SAMPLE_ID")
/

-- performance_network --
CREATE INDEX UPTPAR_NET_SAMPLE_ID 
ON PERFORMANCE_NETWORK ("SAMPLE_ID")
/

-- performance_nrm --
--default index

-- performance_psinfo --
CREATE INDEX UPTPAR_P_SAMPLE_ID 
ON PERFORMANCE_PSINFO ("SAMPLE_ID")
/

-- performance_vxvol --
CREATE INDEX UPTPAR_V_SAMPLE_ID 
ON PERFORMANCE_VXVOL ("SAMPLE_ID")
/

-- performance_who --
CREATE INDEX UPTPAR_W_SAMPLE_ID 
ON PERFORMANCE_WHO ("SAMPLE_ID")
/

-- erdc_int_data --
CREATE INDEX UPTPAR_ERDC_INT
ON ERDC_INT_DATA ("ERDC_PARAMETER_ID", "ERDC_INSTANCE_ID", "SAMPLETIME")
/

-- erdc_decimal_data --
CREATE INDEX UPTPAR_ERDC_DECIMAL
ON ERDC_DECIMAL_DATA ("ERDC_PARAMETER_ID", "ERDC_INSTANCE_ID", "SAMPLETIME")
/

-- erdc_string_data --
CREATE INDEX UPTPAR_ERDC_STRING
ON ERDC_STRING_DATA ("ERDC_PARAMETER_ID", "ERDC_INSTANCE_ID", "SAMPLETIME")
/

-- ranged_object_value --
CREATE INDEX UPTPAR_RANGED_OBJECT_ID
ON RANGED_OBJECT_VALUE ("RANGED_OBJECT_ID")
/
CREATE INDEX UPTPAR_RANGED_OBJECT_NAME
ON RANGED_OBJECT_VALUE ("NAME")
/


CREATE OR REPLACE PROCEDURE rebuild_uptime_indexes IS
	CURSOR cur_index IS
		SELECT index_name
		FROM user_indexes
		WHERE (table_name like 'PERFORMANCE_%'
		OR table_name like 'ERDC_%_DATA'
		OR table_name like 'RANGED_OBJECT_VALUE')
		AND status = 'UNUSABLE';
BEGIN
	FOR line IN cur_index
	LOOP
		DBMS_OUTPUT.put_line('Rebuilding index ' || line.index_name);
		EXECUTE IMMEDIATE 'ALTER INDEX ' || line.index_name || ' REBUILD UNRECOVERABLE';
	END LOOP;
END rebuild_uptime_indexes;
/
