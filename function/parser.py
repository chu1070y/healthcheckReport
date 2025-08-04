import glob
import os
import re

from module.common import Common


class Parser(Common):
    def __init__(self):
        self.logger = self.get_logger()
        self.conf = self.get_config()

    def get_files(self):
        try:
            path = self.conf['path'].get('log_path', None)

            if not path:
                self.logger.error("log_path is not defined in config.ini")
                exit(1)

            # 하위 모든 파일 검색
            file_pattern = os.path.join(path, "**")
            self.logger.info(f"Searching for files with pattern: {file_pattern}")

            # 모든 파일 리스트 반환
            return [f for f in glob.glob(file_pattern, recursive=True) if os.path.isfile(f)]

        except Exception as e:
            self.logger.error(f"Error while getting files: {e}")
            exit(1)

    def get_information(self, file_path):
        info_data = dict()

        with open(file_path, 'r', encoding='utf-8') as file:
            text = file.read()

        pattern = r"!========== (.*?) ==========!"
        parts = re.split(pattern, text)

        for i in range(1, len(parts), 2):
            session = parts[i].strip()
            content = parts[i + 1].strip()

            if session.lower() == 'information':
                info_data = self.parse_information(content)

            elif session == 'InnoDB Engine Status':
                info_data['innodb_engine_status'] = content

            elif session == 'Replication Status':
                info_data['replication_status'] = content

            elif session == 'Error Log':
                info_data['error_log_content'] = content

            else:
                self.logger.warning("The session code ({}) is not registered".format(session))

        return info_data

    @staticmethod
    def parse_information(section_text):
        info_dict = dict()
        for line in section_text.splitlines():
            if "=" in line:
                key, value = line.split("=", 1)
                info_dict[key.strip()] = value.strip()
        return info_dict


if __name__ == "__main__":
    parser = Parser()
    result = parser.get_files()

    print(result)


