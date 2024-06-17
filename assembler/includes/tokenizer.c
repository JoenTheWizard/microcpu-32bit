#include "tokenizer.h"

const char *tokenTypes[] = {
    "LABEL_DECLARE",
    "LABEL_INITIALIZE",
    "INSTRUCTION",
    "REGISTER",
    "IMMEDIATE",
    "COMMA",
    "NEWLINE",
    "EOF",
    "INVALID"
};

TokenList *InitializeTokenList(void) {
    TokenList *list = (TokenList*)malloc(sizeof(TokenList));

    if (!list)
        return NULL;

    list->head_token = NULL;
    return list;
}

TokenNode *InitializeTokenNode(TokenType type, const char *value, size_t length, uint32_t memory) {
    TokenNode *node = (TokenNode*)malloc(sizeof(TokenNode));

    if (!node)
        return NULL;

    node->type = type;

    node->value = malloc(length + 1);
    if (!node->value) {
        free(node);
        return NULL;
    }
    strncpy(node->value, value, length);
    node->value[length] = '\0';

    node->length = length;

    node->memory = memory;

    node->next = NULL;

    return node;
}

void AddTokenList(TokenList *list, TokenType type, const char *value, size_t length, uint32_t memory) {
    TokenNode *cur = NULL;
    
    if (list->head_token == NULL) {
        list->head_token = InitializeTokenNode(type, value, length, memory);
    }
    else {
        cur = list->head_token;

        while (cur->next != NULL)
            cur = cur->next;

        cur->next = InitializeTokenNode(type, value, length, memory);
    }
}

void PrintTokenList(TokenList *list) {
    TokenNode *cur = list->head_token;

    if (list->head_token == NULL) {
        return;
    }

    while (cur != NULL) {
        printf("TokType: %s - %s (l: %ld) (mem: %u)\n",
               tokenTypes[cur->type], cur->value, cur->length, cur->memory);
        cur = cur->next;
    } 
}

void FreeTokenList(TokenList *list) {
    TokenNode *cur = list->head_token;
    TokenNode *next = cur;
    
    while (cur != NULL) {
        next = cur->next;

        free(cur->value);
        free(cur);
        
        cur = next;
    }

    free(list);
}

char *ReadFile(const char *filename) {
    FILE *fasm = fopen(filename, "r");

    if (fasm == NULL) {
        fprintf(stderr, "[-] Unable to find file '%s'\n", filename);
        return NULL;
    }

    //Find size of file
    fseek(fasm, 0, SEEK_END);
    long fasm_size = ftell(fasm);
    rewind(fasm);

    //Allocate memory
    char *buffer = malloc((fasm_size + 1) * sizeof(char));
    if (buffer == NULL) {
        fprintf(stderr, "[-] Failed to allocate file buffer memory\n");
        fclose(fasm);
        return NULL;
    }

    //Read file into buffer
    size_t bytes_read = fread(buffer, sizeof(char), fasm_size, fasm);
    if (bytes_read != fasm_size) {
        fprintf(stderr, "[-] Failed to read entire file size\n");
        free(buffer);
        fclose(fasm);
        return NULL;
    }

    buffer[fasm_size] = '\0';

    fclose(fasm);

    return buffer;
}

//TODO: Set the memory in each Token Node
void SetMemoryTokenList(TokenList *list) {
    TokenNode *cur = list->head_token;

    if (list->head_token == NULL) {
        return;
    }

    //First pass: Find all labels and set their memory value
    TokenList *label_list = InitializeTokenList();
    uint32_t line_count = 0;
    while (cur != NULL) {
        if (cur->type == TOKEN_NEWLINE)
            line_count++;

        if (cur->type == TOKEN_LABEL_DECLARE) {
            cur->memory = line_count;
            AddTokenList(label_list, cur->type, cur->value, cur->length - 1, cur->memory);
        }

        cur = cur->next;
    }

    //Reset node to start
    cur = list->head_token;

    //Second pass: Set every other token memory value
    while (cur != NULL) {
        //INVALID: Invalid tokens return error
        if (cur->type == TOKEN_INVALID) {
            fprintf(stderr, "[-] Error: Unknown token '%s'\n", cur->value);
            FreeTokenList(label_list);
            return;
        }

        //INSTRUCTION: Set the memory value to the mapped instruction
        if (cur->type == TOKEN_INSTRUCTION) {
            size_t i;
            for (i = 0; i < sizeof(instruction_map) / sizeof(instruction_map[0]); i++) {
                if (!strcmp(cur->value, instruction_map[i].instruction)) {
                    cur->memory = instruction_map[i].memory_value;
                }
            }
        }

        //IMMEDIATE: Set the memory value to the value stored in token
        if (cur->type == TOKEN_IMMEDIATE) {
            char *endptr;
            uint32_t imm = strtoul(cur->value, &endptr, 0);

            if (*endptr == '\0') 
                cur->memory = imm;
            else 
                fprintf(stderr, "[-] Error: Invalid immediate value '%s'\n", endptr);
        }

        //REGISTER: Set the memory value to the register value
        if (cur->type == TOKEN_REGISTER) {
            char *endptr;
            uint32_t imm = strtoul(cur->value + 1, &endptr, 0);

            if (*endptr == '\0' && imm <= MAX_REGISTER) {
                cur->memory = imm;
            } else {
                fprintf(stderr, "[-] Error: Invalid register value '%s'\n", cur->value);
            }
        }

        cur = cur->next;
    }
    
    FreeTokenList(label_list);
}

int ParseToken(const char *source, TokenList *list, int position) {
    int end_pos = position, start_pos = position;
    TokenType token_type;

    //Skip whitespace characters (except for new line for the assembler)
    while (isspace(source[start_pos]) && source[start_pos] != '\n')
        start_pos++;

    end_pos = start_pos;

    //Determine token type
    if (isalpha(source[start_pos])) {
        //Label or instruction
        end_pos++;
        while (isalnum(source[end_pos]) || source[end_pos] == '_')
            end_pos++;
        token_type = TOKEN_INSTRUCTION; //Assume instruction by default

        //Check if it's register
        if (tolower(source[start_pos]) == 'r' && start_pos + 1 != end_pos) {
            int i = start_pos + 1;
            token_type = TOKEN_REGISTER;
            while (i < end_pos) {
                if (!isdigit(source[i])) {
                    token_type = TOKEN_INSTRUCTION;
                    break;
                }
                i++;
            }
        }

        //Check if it's a label
        if (source[end_pos] == ':') {
            token_type = TOKEN_LABEL_DECLARE;
            end_pos++;
        }
    } 
    else if (isdigit(source[start_pos])) {
        //Immediate value
        token_type = TOKEN_IMMEDIATE;
        end_pos++;
        while (isdigit(source[end_pos]))
            end_pos++;
    } 
    else {
        //Special characters
        switch (source[start_pos]) {
            case ',':
                token_type = TOKEN_COMMA;
                end_pos++;
                break;
            case '\n':
                token_type = TOKEN_NEWLINE;
                end_pos++;
                break;
            case '\0':
                token_type = TOKEN_EOF;
                end_pos++;
                break;
            default:
                token_type = TOKEN_INVALID;
                end_pos++;
                break;
        }
    }

    size_t token_length = end_pos - start_pos;
    AddTokenList(list, token_type, &source[start_pos], token_length, 0);

    return end_pos;
}

int Tokenize(const char *source, TokenList *list) {
    int position      = 0;
    int source_length = strlen(source) + 1;

    while (position < source_length) {
        position = ParseToken(source, list, position);
    }

    return 0;
}

void Assemble(const char *filename) {
    char *fasm_content = ReadFile(filename);

    if (fasm_content == NULL) {
        fprintf(stderr, "[-] There was an error when trying to read the file '%s'\n", filename);
        return;
    }

    TokenList *token_list = InitializeTokenList();

    if (!token_list) {
        fprintf(stderr, "[-] Failed to initialize token list\n");
        free(fasm_content);
        return;
    }

    Tokenize(fasm_content, token_list);

    SetMemoryTokenList(token_list);

    PrintTokenList(token_list);

    free(fasm_content);

    FreeTokenList(token_list);
}