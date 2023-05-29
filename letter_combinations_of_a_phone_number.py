import sys
from typing import List

from nltk.corpus import words


class Solution:
    def __init__(self):
        self.phone = {
            "2": "abc",
            "3": "def",
            "4": "ghi",
            "5": "jkl",
            "6": "mno",
            "7": "pqrs",
            "8": "tuv",
            "9": "wxyz",
        }
        self.english_words = set(words.words())  # English words list

    def letterCombinations(self, digits: str) -> List[str]:
        if not digits:
            return []

        res = []

        def backtrack(combination: str, next_digits: str) -> None:
            if not next_digits:
                if (
                    combination in self.english_words
                ):  # Check if the combination is an English word
                    res.append(combination)
                return

            for letter in self.phone[next_digits[0]]:
                backtrack(combination + letter, next_digits[1:])

        backtrack("", digits)
        return res


def text_to_keypad(text: str) -> str:
    keypad_mapping = {
        "a": "2",
        "b": "2",
        "c": "2",
        "d": "3",
        "e": "3",
        "f": "3",
        "g": "4",
        "h": "4",
        "i": "4",
        "j": "5",
        "k": "5",
        "l": "5",
        "m": "6",
        "n": "6",
        "o": "6",
        "p": "7",
        "q": "7",
        "r": "7",
        "s": "7",
        "t": "8",
        "u": "8",
        "v": "8",
        "w": "9",
        "x": "9",
        "y": "9",
        "z": "9",
    }

    numeric_string = ""
    for char in text.lower():
        if char in keypad_mapping:
            numeric_string += keypad_mapping[char]

    return numeric_string


# Test the function
print(text_to_keypad("Hello World"))  # Output: "4355696753"


if __name__ == "__main__":
    # NOTE: Uncomment the following lines to download the English words list
    # import nltk
    # nltk.download('words')

    solution = Solution()
    print(solution.letterCombinations("43556"))  # ['hello']
    print(solution.letterCombinations("96753"))  # ['world']
    print(
        solution.letterCombinations("4663")
    )  # ['gone', 'good', 'goof', 'home', 'hone', 'hood', 'hoof']

    args = sys.argv[1:]
    if args:
        print(text_to_keypad(args[0]))
        print(solution.letterCombinations(text_to_keypad(args[0])))
