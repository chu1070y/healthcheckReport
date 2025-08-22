-- PK 확인
select service_name, execute_time from hc_information;

-- 과거 데이터 사이즈 입력
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pCMSDB1', '2025-07-17 12:00:00', 10.42 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pCMSDB1', '2025-06-19 12:00:00', 10.27 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pCMSDB1', '2025-05-21 12:00:00', 10.18 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pCMSDB1', '2025-04-10 12:00:00', 10.31 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pCMSDB1', '2025-03-13 12:00:00', 10.63 * 1024 * 1024 * 1024);

INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pCMSDB1s1', '2025-07-17 12:00:00', 9.49 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pCMSDB1s1', '2025-06-19 12:00:00', 9.55 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pCMSDB1s1', '2025-05-21 12:00:00', 9.63 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pCMSDB1s1', '2025-04-10 12:00:00', 9.93 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pCMSDB1s1', '2025-03-13 12:00:00', 10.42 * 1024 * 1024 * 1024);

INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pConfDB1', '2025-07-17 12:00:00', 21.07 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pConfDB1', '2025-06-19 12:00:00', 20.71 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pConfDB1', '2025-05-21 12:00:00', 20.37 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pConfDB1', '2025-04-10 12:00:00', 18.5 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pConfDB1', '2025-03-13 12:00:00', 18.34 * 1024 * 1024 * 1024);

INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pConfDB2-rocky9', '2025-07-17 12:00:00', 16.68 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pConfDB2-rocky9', '2025-06-19 12:00:00', 16.59 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pConfDB2-rocky9', '2025-05-21 12:00:00', 16.57 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pConfDB2-rocky9', '2025-04-10 12:00:00', 16.75 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pConfDB2-rocky9', '2025-03-13 12:00:00', 16.67 * 1024 * 1024 * 1024);

INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pDPGDbm1', '2025-07-17 12:00:00', 853.66 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pDPGDbm1', '2025-06-19 12:00:00', 825.86 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pDPGDbm1', '2025-05-21 12:00:00', 750.78 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pDPGDbm1', '2025-04-10 12:00:00', 726.67 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pDPGDbm1', '2025-03-13 12:00:00', 675.64 * 1024 * 1024);

INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pDPGDbm1s1', '2025-07-17 12:00:00', 875.64 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pDPGDbm1s1', '2025-06-19 12:00:00', 815.61 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pDPGDbm1s1', '2025-05-21 12:00:00', 785.55 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pDPGDbm1s1', '2025-04-10 12:00:00', 727.66 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pDPGDbm1s1', '2025-03-13 12:00:00', 693.64 * 1024 * 1024);

INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pIPAMDB1', '2025-07-17 12:00:00', 11.25 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pIPAMDB1', '2025-06-19 12:00:00', 11.25 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pIPAMDB1', '2025-05-21 12:00:00', 11.25 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pIPAMDB1', '2025-04-10 12:00:00', 11.25 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pIPAMDB1', '2025-03-13 12:00:00', 11.25 * 1024 * 1024);

INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pJiraDB1', '2025-07-17 12:00:00', 4.64 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pJiraDB1', '2025-06-19 12:00:00', 4.57 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pJiraDB1', '2025-05-21 12:00:00', 4.54 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pJiraDB1', '2025-04-10 12:00:00', 4.5 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pJiraDB1', '2025-03-13 12:00:00', 4.47 * 1024 * 1024 * 1024);

INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pRpaDb1', '2025-07-17 12:00:00', 5.71 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pRpaDb1', '2025-06-19 12:00:00', 5.3 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pRpaDb1', '2025-05-21 12:00:00', 5.07 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pRpaDb1', '2025-04-10 12:00:00', 4.69 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pRpaDb1', '2025-03-13 12:00:00', 4.41 * 1024 * 1024 * 1024);

INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pRpaDbs1', '2025-07-17 12:00:00', 6.08 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pRpaDbs1', '2025-06-19 12:00:00', 5.72 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pRpaDbs1', '2025-05-21 12:00:00', 5.44 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pRpaDbs1', '2025-04-10 12:00:00', 5.04 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pRpaDbs1', '2025-03-13 12:00:00', 4.77 * 1024 * 1024 * 1024);

INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pSDBm1', '2025-07-17 12:00:00', 634.37 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pSDBm1', '2025-06-19 12:00:00', 637.07 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pSDBm1', '2025-05-21 12:00:00', 627.48 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pSDBm1', '2025-04-10 12:00:00', 600.25 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pSDBm1', '2025-03-13 12:00:00', 586.35 * 1024 * 1024 * 1024);

INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pSDBm1s1', '2025-07-17 12:00:00', 574.11 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pSDBm1s1', '2025-06-19 12:00:00', 577.92 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pSDBm1s1', '2025-05-21 12:00:00', 576.97 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pSDBm1s1', '2025-04-10 12:00:00', 575.31 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pSDBm1s1', '2025-03-13 12:00:00', 575.07 * 1024 * 1024 * 1024);

INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pSDBm1s2', '2025-07-17 12:00:00', 640.33 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pSDBm1s2', '2025-06-19 12:00:00', 643.68 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pSDBm1s2', '2025-05-21 12:00:00', 606.37 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pSDBm1s2', '2025-04-10 12:00:00', 581.37 * 1024 * 1024 * 1024);
INSERT INTO health_check.hc_information (service_name, execute_time, data_size) VALUES ('cjenm_pSDBm1s2', '2025-03-13 12:00:00', 577.73 * 1024 * 1024 * 1024);

