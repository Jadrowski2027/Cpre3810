
char *strrchr(char *str, int character) {
    char target     = (char) character;  
    char *match = NULL;             
    char current    = *str;              

    while (1) {
        if (current == target) {
            match = str;           
        }
        if (current == '\0') {
            break;                      
        }
        str++;
        current = *str;
    }

    return match;
}