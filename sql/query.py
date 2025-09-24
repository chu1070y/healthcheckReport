create_database = 'create database if not exists {db_name}'

create_information_table = '''
create table if not exists {db_name}.hc_information (
    service_name varchar(30),
    execute_time datetime,
    hostname varchar(30),
    os_version varchar(100),
    db_version varchar(100),
    ip_address varchar(20),
    cpu_cores varchar(10),
    cpu_mhz varchar(10),
    os_memory varchar(10),
    data_home varchar(100),
    engine_home varchar(100),
    config_file varchar(100),
    error_log varchar(100),
    log_slow_path varchar(100),
    log_bin_path varchar(100),
    db_port int,
    data_disk_usage smallint,
    data_size bigint,
    ibdata_usage text,
    memory_usage float,
    innodb_buffer_pool_size bigint,
    key_buffer_size int,
    innodb_buffer_pool_read_requests bigint,
    innodb_buffer_pool_reads int,
    key_read_requests int,
    key_reads int,
    qcache_hits int default 0,
    qcache_inserts int default 0,
    threads_created bigint,
    connections bigint,
    max_used_connections smallint,
    max_connection smallint,
    aborted_connects int,
    created_tmp_disk_tables bigint,
    created_tmp_tables bigint,
    tmpdir varchar(50),
    uptime_text varchar(100),
    uptime bigint,
    innodb_undo_history_length int,
    questions bigint,
    com_commit bigint,
    com_rollback bigint,
    innodb_engine_status mediumtext,
    replication_status text,
    error_log_content text,
    slow_queries int,
    binary_log varchar(10),
    relay_log varchar(10),
    select_full_join bigint,
    select_scan bigint,
    sort_merge_passes bigint,
    
    
    -- calculated columns
    innodb_buffer_pool_hit_rate numeric(5,2) generated always as (100 - innodb_buffer_pool_reads/NULLIF(innodb_buffer_pool_read_requests, 0) * 100),
    key_buffer_hit_rate numeric(5,2) generated always as (100 - key_reads/NULLIF(key_read_requests, 0) * 100),
    query_cache_hit_rate numeric(5,2) generated always as (qcache_hits/NULLIF((qcache_hits+qcache_inserts), 0) * 100),
    thread_cache_miss_rate numeric(5,2) generated always as (threads_created/NULLIF(connections, 0) * 100),
    max_used_connect numeric(5,2) generated always as (max_used_connections/NULLIF(max_connection, 0) * 100),
    connection_miss_rate numeric(5,2) generated always as (aborted_connects/NULLIF(connections, 0) * 100),
    created_tmp_rate numeric(5,2) generated always as (created_tmp_disk_tables/NULLIF((created_tmp_disk_tables + created_tmp_tables), 0) * 100),
    qps double generated always as (round((`questions` / nullif(`uptime`,0)),2)),
    tps double generated always as (round(((`com_commit` + `com_rollback`) / nullif(`uptime`,0)),2)),
    
    PRIMARY KEY (service_name, execute_time)

)
'''

get_info_column_name = "select column_name from information_schema.columns where table_schema='health_check' and table_name='hc_information' and EXTRA != 'VIRTUAL GENERATED' order by ORDINAL_POSITION"

insert_information = 'replace into {db_name}.hc_information ({column_list}) values ({column_value})'

get_datasize = "SELECT * FROM (SELECT service_name, DATE_FORMAT(execute_time,'%Y-%m-%d %H:%i:%s') AS execute_time,data_size FROM {db_name}.hc_information WHERE service_name='{service_name}' ORDER BY execute_time DESC LIMIT 6) AS recent ORDER BY execute_time ASC"

get_information = """
SELECT *
FROM (
  SELECT
    *,
    slow_queries - LAG(slow_queries) OVER (PARTITION BY service_name ORDER BY execute_time)           AS diff_slow_queries,
    select_full_join - LAG(select_full_join) OVER (PARTITION BY service_name ORDER BY execute_time)   AS diff_select_full_join,
    select_scan - LAG(select_scan) OVER (PARTITION BY service_name ORDER BY execute_time)             AS diff_select_scan,
    sort_merge_passes - LAG(sort_merge_passes) OVER (PARTITION BY service_name ORDER BY execute_time) AS diff_sort_merge_passes
  FROM {db_name}.hc_information
  WHERE service_name = '{service_name}'
) t
WHERE t.execute_time = '{execute_time}';
"""

