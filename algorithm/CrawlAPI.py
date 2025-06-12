import requests
import csv
from collections import defaultdict
import urllib3

# Tắt cảnh báo InsecureRequestWarning
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

def crawl_transactions(api_url):
    response = requests.get(api_url, verify=False)
    if response.status_code == 200:
        transactions = response.json()
        grouped_transactions = defaultdict(lambda: {'MAKH': None, 'MASP': []})
        for transaction in transactions:
            madh = transaction['madh']
            if grouped_transactions[madh]['MAKH'] is None:
                grouped_transactions[madh]['MAKH'] = transaction['makh']
            grouped_transactions[madh]['MASP'].append(str(transaction['masp']))
        csv_data = []
        for madh, data in grouped_transactions.items():
            makh = data['MAKH']
            masp_string = ','.join(data['MASP'])
            csv_data.append({'MAKH': makh, 'MASP': masp_string})
        with open('transactions.csv', 'w', newline='', encoding='utf-8') as file:
            writer = csv.DictWriter(file, fieldnames=['MAKH', 'MASP'])
            writer.writeheader()
            writer.writerows(csv_data)
        print("Đã lưu dữ liệu giao dịch vào file transactions.csv thành công!")
        return True
    else:
        print(f"Lỗi khi gọi API: {response.status_code} - {response.text}")
        return False