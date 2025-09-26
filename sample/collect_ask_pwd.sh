#!/bin/bash
###################################### 접속 정보 정의
db_user=root
socket=/tmp/mysql_8.0.sock

mysql_engine=/mysql/mysql_8.0

###################################### 비밀번호 입력받기
read -s -p "Enter password for $db_user(database user): " db_password
echo ""

###################################### 로그 파일 정의
LOGFILE="./$(hostname).log"
exec > "$LOGFILE" 2>&1

###################################### 함수
mysql_query() {
    $mysql_engine/bin/mysql -u"$db_user" -p"$db_password" -S "$socket" -N -B -e "$1" 2>/dev/null
}

###################################### 스크립트 시작!
echo ""
echo "!========== information ==========!"
echo ""

execute_time=$(date '+%Y-%m-%d %H:%M:%S')
echo "execute_time=$execute_time"

# Get OS Version
if [ -f /etc/os-release ]; then
    os_version=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
else
    os_version="Unknown"
fi

# Get Total Memory
os_memory=$(free -h | awk '/^Mem:/ { print $2 }')

# Get IP Address (exclude loopback and docker bridge)
ip_address=$(hostname -I | awk '{ for(i=1;i<=NF;i++) if ($i != "127.0.0.1") { print $i; break } }')

# Get CPU MHz average
cpu_mhz=$(awk -F: '/cpu MHz/ {sum+=$2; count++} END {if(count>0) printf "%.2f", sum/count; else print "Unknown"}' /proc/cpuinfo)

echo "hostname=$(hostname)"
echo "os_version=$os_version"
echo "os_memory=$os_memory"
echo "ip_address=$ip_address"
echo "cpu_cores=$(nproc)"
echo "cpu_mhz=$cpu_mhz"

echo ""
echo ""
db_proc=$(ps -ef | grep -E '[m]ysqld' || ps -ef | grep -E '[m]ariadbd')

if [ -n "$db_proc" ]; then
    echo "engine_home=$mysql_engine"

    # 옵션 파싱
    datadir=$(echo "$db_proc" | grep -oP '(--datadir=)[^ ]*' | head -n 1 | cut -d= -f2)
    config_file=$(echo "$db_proc" | grep -oP '(--defaults-file=)[^ ]*' | head -n 1 | cut -d= -f2)
    db_port=$(echo "$db_proc" | grep -oP '(--port=)[^ ]*' | head -n 1 | cut -d= -f2)

    # fallback: config에서 추출
    if [ -z "$config_file" ]; then
        for path in /etc/my.cnf /etc/mysql/my.cnf /usr/local/etc/my.cnf /etc/my.cnf_*; do
            if [ -f "$path" ]; then
                config_file="$path"
                break
            fi
        done
    fi

    if [ -z "$datadir" ] && [ -n "$config_file" ]; then
        datadir=$(grep -i '^datadir' "$config_file" | awk -F= '{print $2}' | xargs)
    fi

    if [ -z "$db_port" ] && [ -n "$config_file" ]; then
        db_port=$(grep -i '^port' "$config_file" | head -n1 | awk -F= '{print $2}' | xargs)
    fi

    # 기본값 fallback
    if [ -z "$db_port" ]; then db_port=3306; fi

    # Data 디렉토리 디스크 사용률
    data_disk_usage=""
    if [ -n "$datadir" ]; then
        data_disk_usage=$(df -h "$datadir" 2>/dev/null | awk 'NR==2 {print $5}' | tr -d '%')
    fi

    echo "data_home=$datadir"
    echo "config_file=$config_file"
    echo "db_port=$db_port"
    echo "data_disk_usage=$data_disk_usage"
else
    echo "############################# ERROR!!! Can't find MySQL/MariaDB !!!"
    echo "engine_home=NOT_RUNNING"
    echo "data_home="
    echo "config_file="
    echo "db_port="
    echo "data_disk_usage="
    exit 1
fi


# 1. ibdata usage from datadir
ibdata_usage=$(du -sch "$datadir"/ibdata* 2>/dev/null | tail -n 1 | awk '{print $1}')

# 2. binary log usage from log_bin_basename
binary_log_base=$(mysql_query "SHOW VARIABLES LIKE 'log_bin_basename';" | awk '{print $2}')
binary_log=$(du -sch "$binary_log_base"* 2>/dev/null | tail -n 1 | awk '{print $1}')

# 3. relay log usage from relay_log_basename
relay_log_base=$(mysql_query "SHOW VARIABLES LIKE 'relay_log_basename';" | awk '{print $2}')
relay_log=$(du -sch "$relay_log_base"* 2>/dev/null | tail -n 1 | awk '{print $1}')

# 출력
echo "ibdata_usage=$ibdata_usage"
echo "binary_log=$binary_log"
echo "relay_log=$relay_log"

# 메모리 사용률 (%MEM) 확인
memory_usage=$(ps -C mysqld -o pmem= 2>/dev/null | awk '{sum+=$1} END {if (sum) printf "%.2f", sum}')

if [ -z "$memory_usage" ]; then
    memory_usage=$(ps -C mariadbd -o pmem= 2>/dev/null | awk '{sum+=$1} END {if (sum) printf "%.2f", sum}')
fi

[ -z "$memory_usage" ] && memory_usage="0.00"
echo "memory_usage=${memory_usage}"


echo ""
echo ""

# 1. 설정값 (SHOW VARIABLES)
innodb_buffer_pool_size=$(mysql_query "SHOW VARIABLES LIKE 'innodb_buffer_pool_size';" | awk '{print $2}')
key_buffer_size=$(mysql_query "SHOW VARIABLES LIKE 'key_buffer_size';" | awk '{print $2}')

log_slow_path=$(mysql_query "SHOW VARIABLES LIKE 'slow_query_log_file';" | awk '{print $2}')
log_bin_path=$(mysql_query "SHOW VARIABLES LIKE 'log_bin_basename';" | awk '{print $2}')
tmpdir=$(mysql_query "SHOW VARIABLES LIKE 'tmpdir';" | awk '{print $2}')
max_connection=$(mysql_query "SHOW VARIABLES LIKE 'max_connections';" | awk '{print $2}')
error_log=$(mysql_query "SHOW VARIABLES LIKE 'log_error';" | awk '{print $2}')

echo "innodb_buffer_pool_size=$innodb_buffer_pool_size"
echo "key_buffer_size=$key_buffer_size"

# 2. 데이터 크기 (MB 또는 GB로 변환)
data_size=$(mysql_query "SELECT SUM(data_length + index_length) FROM information_schema.tables;")

# 3. 상태값 (SHOW GLOBAL STATUS)
declare -A status_vars=(
    [innodb_buffer_pool_read_requests]="Innodb_buffer_pool_read_requests"
    [innodb_buffer_pool_reads]="Innodb_buffer_pool_reads"
    [key_read_requests]="Key_read_requests"
    [key_reads]="Key_reads"
    [qcache_hits]="Qcache_hits"
    [qcache_inserts]="Qcache_inserts"
    [threads_created]="Threads_created"
    [connections]="Connections"
    [max_used_connections]="Max_used_connections"
    [aborted_connects]="Aborted_connects"
    [created_tmp_disk_tables]="Created_tmp_disk_tables"
    [created_tmp_tables]="Created_tmp_tables"
    [uptime]="Uptime"
    [questions]="Questions"
    [com_commit]="Com_commit"
    [com_rollback]="Com_rollback"
    [slow_queries]="Slow_queries"
    [select_full_join]="Select_full_join"
    [select_scan]="Select_scan"
    [sort_merge_passes]="Sort_merge_passes"
)

for key in "${!status_vars[@]}"; do
    value=$(mysql_query "SHOW GLOBAL STATUS LIKE '${status_vars[$key]}';" | awk '{print $2}')

    if [ -z "$value" ]; then
        value=0
    fi

    eval "$key=$value"
done

# 4. history length 상태
innodb_undo_history_length=$(mysql_query "
    SELECT count FROM information_schema.INNODB_METRICS
    WHERE name='trx_rseg_history_len';
")

# 출력
echo "log_slow_path=$log_slow_path"
echo "log_bin_path=$log_bin_path"
echo "tmpdir=$tmpdir"
echo "error_log=$error_log"
echo "data_size=$data_size"
echo "innodb_buffer_pool_read_requests=$innodb_buffer_pool_read_requests"
echo "innodb_buffer_pool_reads=$innodb_buffer_pool_reads"
echo "key_read_requests=$key_read_requests"
echo "key_reads=$key_reads"
echo "qcache_hits=$qcache_hits"
echo "qcache_inserts=$qcache_inserts"
echo "threads_created=$threads_created"
echo "connections=$connections"
echo "max_used_connections=$max_used_connections"
echo "max_connection=$max_connection"
echo "aborted_connects=$aborted_connects"
echo "created_tmp_disk_tables=$created_tmp_disk_tables"
echo "created_tmp_tables=$created_tmp_tables"
echo "uptime=$uptime"
echo "innodb_undo_history_length=$innodb_undo_history_length"
echo "questions=$questions"
echo "com_commit=$com_commit"
echo "com_rollback=$com_rollback"
echo "slow_queries=$slow_queries"
echo "select_full_join=$select_full_join"
echo "select_scan=$select_scan"
echo "sort_merge_passes=$sort_merge_passes"

human_uptime=$($mysql_engine/bin/mysql -u"$db_user" -p"$db_password" -S "$socket" -e "\s" 2>/dev/null | grep -i "Uptime" | awk -F'Uptime:' '{print $2}' | xargs)
uptime_human=$(echo "$human_uptime" | awk '{print $1, $2, $3, $4}')
echo "uptime_text=$uptime_human"

db_version=$($mysql_engine/bin/mysql -u"$db_user" -p"$db_password" -S "$socket" -e "\s" 2>/dev/null | grep -i "Server version" | awk -F'Server version:' '{print $2}' | xargs)
echo "db_version=$db_version"

echo ""
echo "!========== InnoDB Engine Status ==========!"
echo ""
$mysql_engine/bin/mysql -u"$db_user" -p"$db_password" -S "$socket" -e "SHOW ENGINE INNODB STATUS\G" 2>/dev/null

echo ""
echo "!========== Replication Status ==========!"
echo ""
$mysql_engine/bin/mysql -u"$db_user" -p"$db_password" -S "$socket" -e "SHOW SLAVE STATUS\G" 2>/dev/null

echo ""
echo "!========== Error Log ==========!"
echo ""

tail -100 $error_log

#echo ""
#echo "!========== Slow Query Log ==========!"
#echo ""
#slow_query_log_file=$(mysql_query "SHOW VARIABLES LIKE 'slow_query_log_file';" | awk '{print $2}')
#ls -lh "$slow_query_log_file"*

###################################### Made by 추추
