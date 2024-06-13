import sys

def find_and_split(input_string, substring):
    index = input_string.find(substring)
    if index != -1:
        before_substring = input_string[:index]
        after_substring = input_string[index + len(substring):]
        return before_substring, after_substring
    else:
        return None, None

def replace_footnotes(line, count):
  curly_brace_count = 1
  inside_footnote = True
  result, after = find_and_split(line, '\\footnote{')
  if after is not None:
    for char in after:
      if inside_footnote and char == '{':
        curly_brace_count += 1
      elif inside_footnote and char == '}':
        curly_brace_count -= 1
        if curly_brace_count == 0:
          inside_footnote = False
          result += f'\\cite{{Note{count}}}'
      elif not inside_footnote:
        result += char

  return result

# Read count from command-line argument
count = int(sys.argv[1])

# Read lines from standard input
for line in sys.stdin:
  # Perform the replacement using the function
  modified_line = replace_footnotes(line, count)
  # Print the modified line to standard output
  print(modified_line, end='')
