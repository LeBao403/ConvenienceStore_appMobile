from collections import defaultdict
from itertools import combinations

class Node:
    def __init__(self, item, count=0, parent=None):
        self.item = item
        self.count = count
        self.parent = parent
        self.children = {}
        self.node_link = None

def print_tree(node, level=0):
    if node.item is not None:
        print(" " * level + f"{node.item}: {node.count}")
    for child in node.children.values():
        print_tree(child, level + 1)

def get_item_frequencies(transactions, str_items='MASP'):
    """Tính tần suất xuất hiện của từng sản phẩm trong giao dịch."""
    item_counts = defaultdict(int)
    for tran in transactions:
        # Loại bỏ sản phẩm lặp lại trong cùng một giao dịch
        unique_items = set(tran[str_items])
        for item in unique_items:
            item_counts[item] += 1
    return item_counts

def build_fp_tree(transactions, min_sup, str_items='MASP'):
    """Xây dựng cây FP-Tree từ danh sách giao dịch."""
    # Tính tần suất các sản phẩm
    item_counts = get_item_frequencies(transactions, str_items)
    print("Tần suất các sản phẩm:")
    for item, count in sorted(item_counts.items()):
        print(f"{item}: {count}")

    # Lọc các sản phẩm thường xuyên (tần suất >= min_sup)
    frequent_items = {item: count for item, count in item_counts.items() if count >= min_sup}
    if not frequent_items:
        print(f"Không có sản phẩm nào đạt ngưỡng hỗ trợ tối thiểu ({min_sup}).")
        return None, None

    # Xây dựng cây FP-Tree
    header_table = defaultdict(list)
    root = Node(None)
    for tran in transactions:
        # Lọc và loại bỏ sản phẩm lặp lại trong giao dịch
        items = list(set([item for item in tran[str_items] if item in frequent_items]))
        if not items:
            continue
        # Tạo tất cả các tổ hợp sản phẩm trong giao dịch
        current_node = root
        for item in sorted(items):  # Sắp xếp để đảm bảo thứ tự nhất quán
            if item in current_node.children:
                current_node.children[item].count += 1
                current_node = current_node.children[item]
            else:
                new_node = Node(item, 1, current_node)
                current_node.children[item] = new_node
                header_table[item].append(new_node)
                current_node = new_node

    # Liên kết các node cùng loại qua node_link
    for item in header_table:
        for i in range(len(header_table[item]) - 1):
            header_table[item][i].node_link = header_table[item][i + 1]

    return root, header_table

def get_conditional_pattern_base(item, header_table):
    """Lấy mẫu điều kiện (conditional pattern base) cho một sản phẩm."""
    patterns = []
    current_node = header_table[item][0]
    while current_node is not None:
        path = []
        node = current_node
        while node.parent is not None and node.parent.item is not None:  # Loại bỏ nút gốc
            path.append((node.item, node.count))
            node = node.parent
        if path:
            patterns.append((path[::-1], current_node.count))
        current_node = current_node.node_link
    return patterns

def build_conditional_fp_tree(patterns, min_sup):
    """Xây dựng cây FP-Tree điều kiện từ các mẫu điều kiện."""
    if not patterns:
        return None, None

    # Tính tần suất các sản phẩm trong mẫu điều kiện
    item_counts = defaultdict(int)
    for path, count in patterns:
        unique_items = set(item for item, _ in path)
        for item in unique_items:
            item_counts[item] += count

    # Lọc sản phẩm thường xuyên
    frequent_items = {item: count for item, count in item_counts.items() if count >= min_sup}
    if not frequent_items:
        return None, None

    # Xây dựng cây điều kiện
    header_table = defaultdict(list)
    root = Node(None)
    for path, count in patterns:
        items = list(set([item for item, _ in path if item in frequent_items]))
        if not items:
            continue
        current_node = root
        for item in sorted(items):  # Sắp xếp để đảm bảo thứ tự nhất quán
            if item in current_node.children:
                current_node.children[item].count += count
                current_node = current_node.children[item]
            else:
                new_node = Node(item, count, current_node)
                current_node.children[item] = new_node
                header_table[item].append(new_node)
                current_node = new_node

    # Liên kết các node cùng loại qua node_link
    for item in header_table:
        for i in range(len(header_table[item]) - 1):
            header_table[item][i].node_link = header_table[item][i + 1]

    return root, header_table

def fp_growth(header_table, min_sup, transactions, str_items='MASP', prefix=None, frequent_itemsets=None):
    """Tìm các tập mục thường xuyên bằng thuật toán FP-Growth."""
    if frequent_itemsets is None:
        frequent_itemsets = []

    # Điều kiện dừng: nếu header_table rỗng, không cần đệ quy thêm
    if not header_table:
        return frequent_itemsets

    # Duyệt qua từng sản phẩm trong header_table
    for item in reversed(header_table.keys()):
        total_count = sum(node.count for node in header_table[item])
        if total_count < min_sup:
            continue

        # Thêm tập mục thường xuyên mới
        new_frequent_set = [item] if prefix is None else prefix + [item]
        frequent_itemsets.append((new_frequent_set, total_count))

        # Lấy mẫu điều kiện và xây dựng cây điều kiện
        cond_patterns = get_conditional_pattern_base(item, header_table)
        cond_tree, cond_header = build_conditional_fp_tree(cond_patterns, min_sup)

        # Đệ quy trên cây điều kiện nếu có
        if cond_header:
            fp_growth(cond_header, min_sup, transactions, str_items, new_frequent_set, frequent_itemsets)

    # Thêm các tập mục đa phần tử từ dữ liệu giao dịch
    for tran in transactions:
        items = list(set(tran[str_items]))
        if len(items) < 2:
            continue
        for r in range(2, len(items) + 1):
            for combo in combinations(items, r):
                combo = list(combo)
                # Đếm tần suất của tập mục
                count = sum(1 for t in transactions if all(item in t[str_items] for item in combo))
                if count >= min_sup and sorted(combo) not in [sorted(fs) for fs, _ in frequent_itemsets]:
                    frequent_itemsets.append((combo, count))

    return frequent_itemsets

def generate_association_rules(frequent_itemsets, min_conf):
    """Tạo quy tắc kết hợp từ các tập mục thường xuyên."""
    rules = []
    for itemset, support in frequent_itemsets:
        if len(itemset) < 2:  # Chỉ tạo quy tắc cho tập mục có ít nhất 2 sản phẩm
            continue
        if len(set(itemset)) != len(itemset):  # Loại bỏ tập mục lặp lại
            continue
        for i in range(1, len(itemset)):
            for antecedent in combinations(itemset, i):
                antecedent = list(antecedent)
                consequent = [item for item in itemset if item not in antecedent]
                if not consequent:
                    continue
                # Tìm support của antecedent
                antecedent_support = next((s for a, s in frequent_itemsets if sorted(a) == sorted(antecedent)), None)
                if antecedent_support is None:
                    continue
                confidence = support / antecedent_support
                if confidence >= min_conf:
                    rules.append((antecedent, consequent, support, confidence))
    return rules