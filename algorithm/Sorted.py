import csv
from collections import Counter, defaultdict
from itertools import combinations

input_file = "transactions.csv"
output_file = "transactions_sorted.csv"
output_csv_file = 'association_rules.csv'

str_user = 'MAKH'
str_items = 'MASP'

min_support = 0
min_conf = 0


try:
    data = []
    with open(input_file, 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:

            items = row[str_items].split(',') if row[str_items] else []
            data.append({str_user: row[str_user], str_items: items})


    item_counts = Counter()
    for trans in data:
        for item in trans[str_items]:
            item_counts[item.strip()] += 1  # Loại bỏ khoảng trắng thừa (nếu có)


    for item, count in item_counts.items():
        print(f"{item}: {count}")

    # Tạo thứ tự ưu tiên cho các sản phẩm dựa trên tần suất
    item_priority = {item: index for index, (item, _) in enumerate(item_counts.most_common())}

    # Hàm sắp xếp các sản phẩm theo thứ tự ưu tiên
    def sort_items(items):
        return sorted(items, key=lambda x: item_priority.get(x, len(item_counts)))

    # Lọc các giao dịch có nhiều hơn 1 sản phẩm
    filtered_data = [trans for trans in data if len(trans[str_items]) > 1]


    for trans in data:
        trans[str_items] = sort_items(trans[str_items])

    with open(output_file, 'w', encoding='utf-8', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=[str_user, str_items])
        writer.writeheader()
        for trans in data:

            writer.writerow({
                str_user: trans[str_user],
                str_items: ','.join(trans[str_items])
            })

except FileNotFoundError:
    print(f"File {input_file} not found.")
except Exception as e:
    print(f"Error: {e}")