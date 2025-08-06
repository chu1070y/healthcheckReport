from module.common import Common
import matplotlib.pyplot as plt


class Output(Common):
    def __init__(self):
        self.logger = self.get_logger()

    def make_graph(self, data):
        max_value = max(row[2] for row in data)

        units = [
            ('TB', 1024 ** 4),
            ('GB', 1024 ** 3),
            ('MB', 1024 ** 2),
            ('KB', 1024),
        ]

        for name, factor in units:
            if max_value >= factor:
                unit = name
                convert_value = lambda b, f=factor: b / f
                break

        # 데이터 변환
        sizes = [round(convert_value(row[2]), 2) for row in data]
        labels = [row[1].split()[0] for row in data]

        # 그래프 그리기
        plt.set_loglevel('WARNING')
        plt.figure(figsize=(10, 5))

        bars = plt.bar(labels, sizes, color='#0b5a74', width=0.6)

        # 막대 위에 값 표시
        for bar, size in zip(bars, sizes):
            height = bar.get_height()
            plt.text(
                bar.get_x() + bar.get_width() / 2,
                height + 0.02,
                f'{size:.2f}',
                ha='center',
                va='bottom',
                fontsize=10
            )

        # 스타일 설정
        plt.title(f'Data Size ({unit})', fontsize=14)
        plt.ylabel('')
        plt.grid(axis='y', linestyle='-', alpha=0.7)

        ax = plt.gca()
        ax.spines['left'].set_visible(False)  # Y축 선
        ax.spines['bottom'].set_visible(True)  # X축 선
        ax.spines['top'].set_visible(False)
        ax.spines['right'].set_visible(False)
        ax.set_axisbelow(True)

        plt.xticks(fontsize=11)
        plt.tight_layout()

        # 그래프 출력
        # plt.show()

        # 그래프 저장
        save_path = f"./result/{data[0][0]}.png"
        plt.savefig(save_path, dpi=300)
        plt.close()
