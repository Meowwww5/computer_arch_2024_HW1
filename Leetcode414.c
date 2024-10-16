#include "stdio.h"

int test_data2[2] = {1, 2};
int test_data1[3] = { 3, 2, 1 };
int test_data3[4] = { 2, 2, 3, 1 };

int thirdMax(int* nums, int numsize) {

	int max1 = 0, max2 = 0, max3 = 0, out = 0;

	for (int i = 0; i < numsize; i++){
		if (nums[i] != max1 && nums[i] != max2 && nums[i] != max3) {
			if (nums[i] > max1){
				max3 = max2;
				max2 = max1;
				max1 = nums[i];
			}
			else if(nums[i] > max2){
				max3 = max2;
				max2 = nums[i];
			}
			else if (nums[i] > max3) {
				max3 = nums[i];
			}
		}
	}
	if (numsize >= 3 ){
		out = max3;
	}
	else{
		out = max1;
	}
	return out;
}

int main() {
	int numsize, result;
	for (int i = 0; i < 3; i++){
		if (i==0){
			numsize = sizeof(test_data1) / 4;
			result = thirdMax(&test_data1, numsize);
			printf("%d \n", result);
		}
		if (i == 1) {
			numsize = sizeof(test_data2) / 4;
			result = thirdMax(&test_data2, numsize);
			printf("%d \n", result);
		}
		if (i == 2) {
			numsize = sizeof(test_data3) / 4;
			result = thirdMax(&test_data3, numsize);
			printf("%d \n", result);
		}
	}

	return 0;
}
