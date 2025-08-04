import os
from time import sleep

from function.ms_word import MSword
from function.db_work import DBwork
from function.output import Output
from function.parser import Parser
from module.common import Common


class Main(Common):
    def __init__(self):
        self.logger = self.get_logger()
        self.config = self.get_config()

    def execute(self):
        self.logger.info('################## Start to Main process')

        ################### 1. DB or 테이블 생성
        self.logger.info('################## Create database and table')
        db_work = DBwork()
        db_work.create_statement()

        ################### 2. 로그 경로 들어가서 로그 파일 가져오기
        self.logger.info('################## Read log files')
        parser = Parser()
        log_files = parser.get_files()

        for log in log_files:
            self.logger.info('로그 파일명: {}'.format(log))

        ################### 3. 식별자 확인
        self.logger.info('#########################################################################')
        self.logger.info('######################### 고객사 정보 확인 ################################')
        self.logger.info('*** DB에 식별자로 들어갈 정보입니다. 다음을 확인해 주세요!!')
        self.logger.info('*** 식별자는 `고객사명_로그파일명` 으로 만들어집니다!')

        client_name = self.config['client']['client_name']

        while True:
            self.logger.info('고객사 명: {}'.format(client_name))
            for i, log in enumerate(log_files):
                self.logger.info(f'식별자 {i}: {client_name}_{str(os.path.basename(log)).split(".")[0]}')

            sleep(0.5)

            check_info = input('위의 정보를 확인하였으며, 위의 정보를 토대로 실행해도 되겠습니까? (Y/N)').strip().lower()
            self.logger.info(f'사용자 입력: {check_info}')

            if check_info == 'y':
                self.logger.info("작업을 진행합니다.")
                break
            elif check_info == 'n':
                self.logger.warning("작업을 중지합니다.")
                exit()
            else:
                self.logger.warning("잘못된 입력입니다. Y 또는 N을 입력해 주세요.")

        ################### 4. 로그 파싱
        self.logger.info('################## get an information from log files')

        log_data = dict()
        for log in log_files:
            log_data[client_name + '_' + os.path.basename(log).split(".")[0]] = parser.get_information(log)

        ################### 5. 데이터 insert
        db_work.insert_information(log_data)

        ################### 6. 그래프 생성
        sleep(0.5)
        self.logger.info('################## Making Graph image')
        output = Output()

        for service in list(log_data.keys()):
            graph_data = list()
            for row in db_work.get_datasize(service):
                service, time, size_bytes = row
                graph_data.append((service, time, size_bytes))

            output.make_graph(graph_data)

        ################### 7. 점검보고서 작성
        sleep(0.5)
        self.logger.info('################## Making healthcheck report')
        for service in list(log_data.keys()):
            data = db_work.get_information_values(service)

            # 데이터 가공
            data["data_size"] = self.format_bytes(data["data_size"])
            data["innodb_buffer_pool_size"] = self.format_bytes(data["innodb_buffer_pool_size"])
            data["key_buffer_size"] = self.format_bytes(data["key_buffer_size"])
            data["innodb_buffer_pool_hit_rate"] = data["innodb_buffer_pool_hit_rate"] if not data["innodb_buffer_pool_hit_rate"] is None else "-"
            data["key_buffer_hit_rate"] = data["key_buffer_hit_rate"] if not data["key_buffer_hit_rate"] is None else "-"
            data["query_cache_hit_rate"] = data["query_cache_hit_rate"] if not data["query_cache_hit_rate"] is None else "-"
            data["diff_slow_queries"] = data["diff_slow_queries"] if not data["diff_slow_queries"] is None else "-"
            data["diff_select_full_join"] = data["diff_select_full_join"] if not data["diff_select_full_join"] is None else "-"
            data["diff_select_scan"] = data["diff_select_scan"] if not data["diff_select_scan"] is None else "-"
            data["diff_sort_merge_passes"] = data["diff_sort_merge_passes"] if not data["diff_sort_merge_passes"] is None else "-"

            # 워드 문서 생성
            MSword().make_report(data)
            break
        db_work.db_close()

    @staticmethod
    def format_bytes(size_in_bytes):
        """
        바이트 수를 입력받아 가장 적절한 단위(B, KB, MB, GB, TB)로 변환해 문자열로 반환
        """
        units = ['B', 'KB', 'MB', 'GB', 'TB']
        size = float(size_in_bytes)
        for unit in units:
            if size < 1024 or unit == 'TB':
                return f"{size:.2f} {unit}"
            size /= 1024


if __name__ == "__main__":
    Main().execute()


