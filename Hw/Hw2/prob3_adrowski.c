#include<stdio.h>
#include<stdlib.h>

// Input an array of n integers and find the average of the array elements.
int main()
{
    int vals[11] = {25, 1, 4, 10, 381, 42, 100, 60, 0, 12, 25};
    int num;
    int index;

    printf("Please enter a number (0-100): ");
    scanf("%d", &num);
    printf("Please enter an index (0-10): ");
    scanf("%d", &index);

    vals[index] += num;

    printf("The new value at index %d is: %d", index, vals[index]);
    return 0;
}