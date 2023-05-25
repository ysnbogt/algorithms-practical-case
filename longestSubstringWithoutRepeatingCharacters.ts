function lengthOfLongestSubstring(s: string): number {
  const characterSet = new Set<string>();
  let maxLength = 0;
  let start = 0;

  for (let i = 0; i < s.length; i++) {
    const character = s[i];
    if (characterSet.has(character)) {
      characterSet.delete(s[start]);
      start++;
    }
    characterSet.add(character);
    maxLength = Math.max(maxLength, characterSet.size);
  }
  return maxLength;
}

console.assert(lengthOfLongestSubstring("abcabcbb") === 3);
console.assert(lengthOfLongestSubstring("bbbbb") === 1);
console.assert(lengthOfLongestSubstring("pwwkew") === 3);

const passwords = ["abc", "abc12", "1a2b3c4"];
passwords.forEach((password) => {
  const longestSubstring = lengthOfLongestSubstring(password);

  if (longestSubstring <= 3) {
    console.log(`Password ${password} is DANGEROUS.`);
  } else if (4 <= longestSubstring && longestSubstring <= 6) {
    console.log(`Password ${password} is WARNING.`);
  } else {
    console.log(`Password ${password} is SAFE.`);
  }
  console.log(
    `Longest non-repeating substring is ${longestSubstring} characters long.`
  );
});
