def generate_decoder_tests(filename="test_file_decoder.txt"):
    with open(filename, "w") as f:
        # Перебираем все возможные комбинации входов
        for e1 in (0, 1):
            for e2 in (0, 1):
                for a in range(16):
                    # По умолчанию при отключенном дешифраторе все выходы '1'
                    y = [1] * 16

                    # Активный режим: оба разрешения равны '0'
                    if e1 == 0 and e2 == 0:
                        y[a] = 0  # активный низкий уровень на выбранном выходе

                    # Вектор адреса A (4 бита): A(3) слева, A(0) справа
                    a_str = f"{a:04b}"

                    # Вектор выхода Y (16 бит): Y(15) слева, Y(0) справа
                    y_str = "".join(str(y[i]) for i in range(15, -1, -1))

                    # Записываем строку через пробел
                    f.write(f"{e1} {e2} {a_str} {y_str}\n")

    print(f"Файл {filename} успешно создан (64 тестовых вектора).")


if __name__ == "__main__":
    generate_decoder_tests()