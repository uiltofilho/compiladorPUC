#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_ARRAY_SIZE 100
#define MAX_VARS 100

typedef struct {
    char name[100];
    int isArray;          // 0 = variável, 1 = array
    int values[MAX_ARRAY_SIZE];  // Valores do array
    char stringValue[100];       // Valor se for string
} Variable;

Variable variables[MAX_VARS];
int varCount = 0;

// Busca ou cria uma variável
Variable* getVariable(char* name) {
    for (int i = 0; i < varCount; i++) {
        if (strcmp(variables[i].name, name) == 0) {
            return &variables[i];
        }
    }
    strcpy(variables[varCount].name, name);
    variables[varCount].isArray = 0; // Por padrão, não é array
    return &variables[varCount++];
}
