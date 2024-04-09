def split_file(original_file_path):
    with open(original_file_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()
    
    one_third = len(lines) // 3
    two_thirds = 2 * (len(lines) // 3)
    
    with open(original_file_path[:-3] + 'first_third.txt', 'w', encoding='utf-8') as file:
        file.writelines(lines[:one_third])
    
    with open(original_file_path[:-3] + 'first_two_thirds.txt', 'w', encoding='utf-8') as file:
        file.writelines(lines[:two_thirds])

    # with open(original_file_path[:-3] + 'all_lines.txt', 'w', encoding='utf-8') as file:
    #     file.writelines(lines)

if __name__ == '__main__':
    split_file('./wi+locness/txt_by_difficulty/ABC_ordered.train.gold.bea19.corr.txt')
    split_file('./wi+locness/txt_by_difficulty/ABC_ordered.train.gold.bea19.orig.txt')
