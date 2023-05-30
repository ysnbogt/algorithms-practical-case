from typing import List


class Solution:
    # A method to find all unique triplets in the array which give the sum of target.
    def threeSum(self, nums: List[int], target: int) -> List[List[int]]:
        nums.sort()  # Sort the array
        triplets = set()  # We use a set to automatically eliminate duplicate triplets
        for i in range(len(nums) - 2):  # Fix the first element of the potential triplet
            # Skip same element to avoid duplicate triplets
            if i > 0 and nums[i] == nums[i - 1]:
                continue
            firstNum = nums[i]
            j, k = (
                i + 1,
                len(nums) - 1,
            )  # Initialize two pointers as corners of the sub-array
            while j < k:
                secondNum, thirdNum = nums[j], nums[k]
                potentialSum = firstNum + secondNum + thirdNum
                # If sum of triplet is more than the target, decrement k
                if potentialSum > target:
                    k -= 1
                # If sum of triplet is less than the target, increment j
                elif potentialSum < target:
                    j += 1
                else:
                    # If sum of triplet is equal to target, save it and increment j and
                    # decrement k
                    triplets.add((firstNum, secondNum, thirdNum))
                    j, k = j + 1, k - 1
                    # Skip same element to avoid duplicate triplets
                    while j < k and nums[j] == nums[j - 1]:
                        j += 1
                    while j < k and nums[k] == nums[k + 1]:
                        k -= 1
        return triplets


# We are a data scientist at a big travel company, planning a new package tour.
# The company's goal is to provide a tour of three different cities with a total tour
# cost equal to a certain budget (e.g., $3000).
# The 'nums' array represents the cost of visiting each city. The target sum is the
# budget (in this case, $3000).
# We can apply the 'threeSum' algorithm to find all possible combinations of three
# cities that fit within the designated budget.
solution = Solution()
print(
    solution.threeSum([500, 200, 300, 800, 1500, 400, 700, 350, 1000, 250, 1200], 3000)
)
# This will output the combinations of trips that sum up to $3000
