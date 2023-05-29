class Solution:
    def isValid(self, s: str) -> bool:
        stack = []
        for char in s:
            if char in "([{":
                stack.append(char)
            elif char in ")]}":
                if not stack:
                    return False
                if char == ")" and stack[-1] == "(":
                    stack.pop()
                elif char == "}" and stack[-1] == "{":
                    stack.pop()
                elif char == "]" and stack[-1] == "[":
                    stack.pop()
                else:
                    return False
        return not stack


def check_file(filename: str) -> None:
    solution = Solution()
    with open(filename, "r") as file:
        for line in file:
            line = line.strip()
            if solution.isValid(line):
                # Green for valid
                print(f'\033[92m"{line}" is valid\033[0m')
            else:
                # Red for invalid
                print(f'\033[91m"{line}" is invalid\033[0m')


if __name__ == "__main__":
    check_file("./data/article.txt")
