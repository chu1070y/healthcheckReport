from module.common import Common
from module.connection import Connection
from sql.query import *


class DBwork(Common):
    def __init__(self):
        self.logger = self.get_logger()

        self.config = self.get_config()['db']

        self.db = Connection()
        self.db_name = self.config['db_name']

    def create_statement(self):
        self.db.mysql_execute(create_database.format(db_name=self.db_name))
        self.db.mysql_execute(create_information_table.format(db_name=self.db_name))
        self.db.mysql_commit()

    def insert_information(self, data: dict):
        ### 쿼리 생성
        columns = self.get_information_column()

        column_list = ','.join(columns)
        column_value = ', '.join([f"%({col})s" for col in columns])

        query = insert_information.format(db_name=self.db_name, column_list=column_list, column_value=column_value)

        ### 데이터 생성
        data_list = list()
        for k, v in data.items():
            v["service_name"] = k
            data_list.append(v)

        ### 쿼리 실행
        self.db.mysql_executemany(query, data_list)
        self.db.mysql_commit()

    def get_information_column(self):
        self.db.mysql_execute(get_info_column_name.format(db_name=self.db_name))
        return [item[0] for item in self.db.mysql_fetchall()]

    def get_information_values(self, service_name):
        return self.db.mysql_fetchone_dict(get_information.format(db_name=self.db_name, service_name=service_name))

    def get_datasize(self, service_name):
        self.db.mysql_execute(get_datasize.format(db_name=self.db_name, service_name=service_name))
        return self.db.mysql_fetchall()

    def db_close(self):
        self.db.mysql_close()


if __name__ == "__main__":
    db = DBwork()
    db.db_close()
