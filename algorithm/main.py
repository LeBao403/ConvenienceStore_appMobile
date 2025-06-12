import csv
import os
import shutil
from CrawlAPI import crawl_transactions
from FP_Tree import build_fp_tree, fp_growth, generate_association_rules
from utils import sort_transactions, save_rules, clean_csv_output

def main():
    # Cấu hình
    API_URL = 'https://localhost:7199/api/DonHang/transactions'
    TRANSACTIONS_FILE = 'transactions.csv'
    TRANSACTIONS_SORTED_FILE = 'transactions_sorted.csv'
    OUTPUT_CSV_FILE = 'association_rules.csv'
    MIN_SUPPORT = 0.01  
    MIN_CONF = 0.01    
    

    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__))) 
    assets_dir = os.path.join(project_root, 'cua_hang_tien_loi', 'assets')  
    output_in_assets = os.path.join(assets_dir, 'association_rules.csv') 


    if not os.path.exists(assets_dir):
        os.makedirs(assets_dir)
        print(f"Đã tạo thư mục assets tại: {assets_dir}")

    # Bước 1: Crawl dữ liệu từ API
    if not crawl_transactions(API_URL):
        return

    # Bước 2: Sắp xếp dữ liệu và lưu vào transactions_sorted.csv
    sort_transactions(TRANSACTIONS_FILE, TRANSACTIONS_SORTED_FILE)

    # Bước 3: Đọc dữ liệu từ file transactions_sorted.csv
    transactions = []
    try:
        with open(TRANSACTIONS_SORTED_FILE, 'r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            for row in reader:
                masp_list = [x.strip() for x in row['MASP'].split(',') if x.strip()]  # Loại bỏ khoảng trắng thừa
                transactions.append({'MAKH': row['MAKH'], 'MASP': masp_list})
    except FileNotFoundError:
        print(f"File {TRANSACTIONS_SORTED_FILE} không tìm thấy.")
        return
    except Exception as e:
        print(f"Lỗi khi đọc file {TRANSACTIONS_SORTED_FILE}: {e}")
        return

    # Bước 4: Xây dựng FP-Tree và tìm tập luật kết hợp
    min_sup = max(1, int(len(transactions) * MIN_SUPPORT))  # Đảm bảo min_sup không nhỏ hơn 1
    print(f"Ngưỡng hỗ trợ tối thiểu (min_sup): {min_sup}")
    fp_tree, header_table = build_fp_tree(transactions, min_sup, str_items='MASP')

    if fp_tree is None:
        print("Không tìm thấy tập luật kết hợp nào.")
        return

    frequent_itemsets = fp_growth(header_table, min_sup, transactions)  
    if not frequent_itemsets:
        print("Không có tập phổ biến nào được tìm thấy.")
        return

    print("\nCác tập phổ biến:")
    for itemset, count in sorted(frequent_itemsets, key=lambda x: (-x[1], x[0])):
        print(f"{itemset}: {count}")

    # Bước 5: Tạo và lưu quy tắc kết hợp
    rules = generate_association_rules(frequent_itemsets, MIN_CONF)
    if not rules:
        print("Không có quy tắc kết hợp nào đạt ngưỡng độ tin cậy.")
        return

    print("\nCác quy tắc kết hợp:")
    for antecedent, consequent, support, confidence in sorted(rules, key=lambda x: (-x[3], x[2])):
        print(f"{antecedent} → {consequent}: support = {support}, confidence = {confidence:.3f}")

    # Lưu file vào thư mục algorithm trước
    save_rules(rules, OUTPUT_CSV_FILE)
    clean_csv_output(OUTPUT_CSV_FILE, OUTPUT_CSV_FILE)

    # Bước 6: Sao chép file vào thư mục assets của ứng dụng Flutter
    try:
        shutil.copy2(OUTPUT_CSV_FILE, output_in_assets)
        print(f"Đã sao chép file {OUTPUT_CSV_FILE} vào {output_in_assets}")
    except Exception as e:
        print(f"Lỗi khi sao chép file vào thư mục assets: {e}")
        return

if __name__ == "__main__":
    main()