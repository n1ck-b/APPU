# gen_reg_tests.py
# Формат: clear load_shift output_control serial ABCD QA QB QC QD QD_cascade

tests = [
    # 1. Асинхронный сброс, OC=0
    # clr ld oc ser  A B C D    QA QB QC QD  cascade
    "0   1  0  0    0 0 0 0    0  0  0  0   0",
    # 2. Параллельная загрузка 1010, OC=0
    "1   1  0  0    1 0 1 0    1  0  1  0   0",
    # 3. Параллельная загрузка 1101, OC=1 (выходы Z, каскад D=1)
    "1   1  1  0    1 1 0 1    Z  Z  Z  Z   1",
    # 4. Сдвиг вправо: serial=1, OC=0 (было 1101 -> станет 1110)
    "1   0  0  1    0 0 0 0    1  1  1  0   0",
    # 5. Сдвиг вправо: serial=0, OC=0 (было 1110 -> станет 0111)
    "1   0  0  0    0 0 0 0    0  1  1  1   1",
    # 6. Сдвиг вправо: serial=1, OC=1 (было 0111 -> станет 1011, выходы Z, каскад 1)
    "1   0  1  1    0 0 0 0    Z  Z  Z  Z   1",
    # 7. Сдвиг вправо: serial=0, OC=1 (было 1011 -> станет 0101, выходы Z, каскад 1)
    "1   0  1  0    0 0 0 0    Z  Z  Z  Z   1",
    # 8. Параллельная загрузка 1111, OC=0
    "1   1  0  0    1 1 1 1    1  1  1  1   1",
    # 9. Сброс при OC=1 (выходы Z, каскад сбрасывается в 0)
    "0   1  1  0    0 0 0 0    Z  Z  Z  Z   0",
]

with open("test_file_register.txt", "w") as f:
    for line in tests:
        # убираем комментарии и лишние пробелы
        clean_line = " ".join(line.split())
        f.write(clean_line + "\n")

print("Файл test_file_register.txt успешно создан!")