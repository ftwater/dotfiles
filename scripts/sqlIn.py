#!/usr/bin/env python3
import argparse
import os
import io
import locale

def process_content(content, merge, number):
    lines = content.split('\n')
    processed_lines = []
    for line in lines:
        # Skip empty lines
        if not line.strip():
            continue
        processed_lines.append(line)
    for i, line in enumerate(processed_lines):
        if number:
            if i == len(processed_lines) - 1:
                processed_line = line
            else:
                processed_line = line + ","
        else:
            if i == len(processed_lines) - 1:
                processed_line = "'" + line + "'"
            else:
                processed_line = "'" + line + "',"
        processed_lines[i] = processed_line
    if merge:
        return ''.join(processed_lines)
    else:
        return '\n'.join(processed_lines)

def main():
    parser = argparse.ArgumentParser(description='处理sql中的where in 参数' if locale.getdefaultlocale()[0] == 'zh_CN' else 'Process sql where in params.')
    parser.add_argument('input_file', type=str, help='处理sql中的where in 参数' if locale.getdefaultlocale()[0] == 'zh_CN' else 'Process sql where in params.')
    parser.add_argument('-m', '--merge', action='store_true', help='是否合并为一行' if locale.getdefaultlocale()[0] == 'zh_CN' else 'Whether to merge lines.')
    parser.add_argument('-n', '--number', action='store_true', help='内容是否为数字。' if locale.getdefaultlocale()[0] == 'zh_CN' else 'Whether the content is numeric.')
    parser.add_argument('-o', '--output', action='store_true', help='是否输出到文件。' if locale.getdefaultlocale()[0] == 'zh_CN' else 'Whether to output to a file.')
    args = parser.parse_args()

    if not os.path.isfile(args.input_file):
        print(f"{args.input_file} does not exist.")
        return

    with open(args.input_file, 'r') as file:
        content = file.read()

    result = process_content(content, args.merge, args.number)

    if args.output:
        output_file_path = os.path.splitext(args.input_file)[0] + '.sqlin.txt'
        with open(output_file_path, 'w') as output_file:
            output_file.write(result)
            output_file.write('\n')  # Add a newline at the end of the file

    else:
        print(result)

if __name__ == "__main__":
    main()
