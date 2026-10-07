#include<stdio.h>
#include<stdlib.h>
#include<math.h>

// Input an array of n integers and find the average of the array elements.
int main()
{
    int n, i;
    float sum = 0.0, avg;

    printf("Enter the number of elements: ");
    scanf("%d", &n);
    int *arr = (int*)malloc(n * sizeof(int));
    if (arr == NULL) {
        printf("Memory allocation failed\n");
        return 1;
    }

    printf("Enter the elements: ");
    for (i = 0; i < n; i++) {
        scanf("%d", &arr[i]);
        sum += arr[i];
    }

    avg = sum / n;
    printf("The average of the array elements is: %.2f\n", avg);

    free(arr);
    return 0;
}
