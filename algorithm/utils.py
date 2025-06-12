import csv
from collections import Counter

def sort_transactions(input_file, output_file, str_user='MAKH', str_items='MASP'):
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
                item_counts[item.strip()] += 1
        item_priority = {item: index for index, (item, _) in enumerate(item_counts.most_common())}
        def sort_items(items):
            return sorted(items, key=lambda x: item_priority.get(x, len(item_counts)))
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
        print(f"Đã lưu dữ liệu đã sắp xếp vào file: {output_file}")
    except FileNotFoundError:
        print(f"File {input_file} không tìm thấy.")
    except Exception as e:
        print(f"Lỗi: {e}")

def save_rules(rules, output_file):
    headers = ['antecedent', 'consequent', 'support', 'confidence']
    try:
        with open(output_file, 'w', encoding='utf-8', newline='') as file:
            writer = csv.DictWriter(file, fieldnames=headers)
            writer.writeheader()
            for antecedent, consequent, support, confidence in rules:
                writer.writerow({
                    'antecedent': str(antecedent),
                    'consequent': str(consequent),
                    'support': support,
                    'confidence': round(confidence, 3)
                })
        print(f"Đã lưu quy tắc vào file: {output_file}")
    except Exception as e:
        print(f"Lỗi khi ghi file: {e}")

def clean_csv_output(input_file, output_file):
    try:
        with open(input_file, 'r', encoding='utf-8') as file:
            lines = file.readlines()
        lines = lines[1:]
        with open(output_file, 'w', encoding='utf-8') as file:
            for line in lines:
                cols = line.strip().split(',')
                if len(cols) == 4:
                    antecedent = cols[0].replace("'", '"')
                    consequent = cols[1].replace("'", '"')
                    support = cols[2].strip()
                    confidence = cols[3].strip()
                    file.write(f"{antecedent},{consequent},{support},{confidence}\n")
        print(f"Đã làm sạch và lưu file: {output_file}")
    except Exception as e:
        print(f"Lỗi khi xử lý file: {e}")