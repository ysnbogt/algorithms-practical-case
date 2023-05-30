from typing import List


class Solution:
    # A method to find three integers in nums such that the sum is closest to target.
    def threeSumClosest(self, nums: List[int], target: int) -> int:
        n = len(nums)
        nums.sort()  # Sort the array
        diff = float("inf")  # Initialize difference as infinite
        val = 0  # Initialize result
        for i in range(n):
            a = i + 1
            b = n - 1
            while a < b:
                cc = nums[i] + nums[a] + nums[b]
                kk = abs(cc - target)
                # If the absolute difference is smaller than diff, update diff and val
                if kk < diff:
                    diff = kk
                    val = cc
                # If sum of triplet is equal to target, return target
                if cc == target:
                    return target
                # If sum of triplet is less than the target, increment a
                elif cc < target:
                    a += 1
                # If sum of triplet is more than the target, decrement b
                else:
                    b -= 1
        # Return the triplet sum closest to target
        return val


# You are a nutritionist trying to build a meal plan and you want to select three foods whose combined calories are as close as possible to a specific target calorie count.
# The 'nums' array represents the calories of each food item. The target is the target calorie count (in this case, 1000).
# We can apply the 'threeSumClosest' algorithm to find the three food items whose combined calories are closest to the target calorie count.
solution = Solution()
print(solution.threeSumClosest([200, 300, 250, 350, 400, 450], 1000))
# This will output the sum of the calories of the three food items that is closest to the target calorie count of 1000.
