/*
 *  author: deepak kumar
 *  mail  : deepakkumar@gmail.com
 *  23-07-2010
 */ 

/*
 *  Amazon @CET 22-07-2010
 *  problem statement:  Given two numbers as a linked list
 *  write a program to add these two lists.
 *  eg : 57348 is represented as 5->7->3->4->8
 *       and 789 is represented as 7->8->9
 *       the answer should be  5->8->1->3->7.
 */




#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#define STK1 1
#define STK2 2

struct node {
    int dig;
    struct node *next;
};

struct st {
    void *ptr;
    struct st *prev;
};

typedef struct node Node;
typedef struct st stack;


void makeList(Node *, char *); /*
                                * This function convers the number 
                                * represented as array to a linked list.
                                */
Node * addList(Node *, Node *);
void freeMem(Node *);
void push(int, void *);
Node *pop(stack*);


stack *stk1 = NULL;
stack *stk2 = NULL;

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage ./%s <num1> <num2>", argv[0]);
        return (-1);
    }

    Node *num1 = NULL;
    Node *num2 = NULL;
    num1 = (Node *) malloc(sizeof (Node));
    num2 = (Node *) malloc(sizeof (Node));
    num1->dig = argv[1][0] - '0';
    num2->dig = argv[2][0] - '0';
    num1->next = NULL;
    num2->next = NULL;
    makeList(num1, argv[1]);
    makeList(num2, argv[2]);
    Node *num3;
    num3 = addList(num1, num2);
    Node *temp = num3;
    while (temp) {
        printf("%d", temp->dig);
        temp = temp->next;
    }
    printf("\n");
    freeMem(num1);
    freeMem(num2);
    freeMem(num3);
    return (0);
}

void freeMem(Node *n) {
    Node *temp;
    while (n) {
        temp = n;
        n = n->next;
        free(temp);
    }
}

void makeList(Node *n, char *s) {
    int len = strlen(s);
    int i;
    Node *curr = n;
    for (i = 1; i < len; i++) {
        if (!(n->next = (Node*) malloc(sizeof (Node)))) {
            printf("Err in alocating memory\n");
            freeMem(n);
            exit(0);
        }
        n = n->next;
        n->dig = s[i] - '0';
        n->next = NULL;
    }
}

void push(int stkid, void *p) {
    if (stkid == STK1) {
        if (stk1 == NULL) {
            stk1 = (stack *) malloc(sizeof (stack));
            stk1->ptr = p;
            stk1->prev = NULL;
        } else {
            stack *t = (stack *) malloc(sizeof (stack));
            t->ptr = p;
            t->prev = stk1;
            stk1 = t;
        }
    } else {
        if (stk2 == NULL) {
            stk2 = (stack *) malloc(sizeof (stack));
            stk2->ptr = p;
            stk2->prev = NULL;
        } else {
            stack *t = (stack *) malloc(sizeof (stack));
            t->ptr = p;
            t->prev = stk2;
            stk2 = t;
        }

    }
}

Node *pop(stack * s) {
    if (s == NULL) {
        return (NULL);
    } else {
        if (s == stk1) {
            stk1 = stk1->prev;
        } else {
            stk2 = stk2->prev;
        }
        void *p;
        p = s->ptr;
        free(s);
        return (p);
    }
}

Node * addList(Node *n1, Node * n2) {
    Node *t1, *t2, *t3;
    Node *n3 = NULL;
    t1 = t2 = t3 = NULL;
    t1 = n1;
    t2 = n2;
    while (t1) {
        push(STK1, t1);
        t1 = t1->next;
    }
    while (t2) {
        push(STK2, t2);
        t2 = t2->next;
    }

    int C = 0; //carry after addition
    n3 = (Node *) malloc(sizeof (Node));
    Node *temp = NULL;
    n3->next = NULL;
    n3->dig = 0;
    t3 = n3;

    while (1) {
        t1 = pop(stk1);
        t2 = pop(stk2);
        if ((t1 != NULL) && (t2 != NULL)) {
            t3->dig = (t1->dig)+(t2->dig) + C;
            if ((t3->dig) > 9) {
                C = 1;
                t3->dig %= 10;
            } else {
                C = 0;
            }

            if (!(temp = (Node *) malloc(sizeof (Node)))) {
                printf("Cannot allocate memory:");
                freeMem(n1);
                freeMem(n2);
                freeMem(n3);
                exit(0);
            }

            temp->next = t3;
            temp->dig = 0;
            t3 = temp;
        }

        if ((t1 == NULL) && (t2 != NULL)) {
            while (t2) {
                t3->dig = (t2->dig) + C;
                if (t3->dig > 9) {
                    C = 1;
                    t3->dig %= 10;
                } else {
                    C = 0;
                }
                if (!(temp = (Node *) malloc(sizeof (Node)))) {
                    printf("Cannot allocate memory:");
                    freeMem(n1);
                    freeMem(n2);
                    freeMem(n3);
                    exit(0);
                }
                temp->next = t3;
                temp->dig = 0;
                t3 = temp;
                t2 = pop(stk2);
            }
        }
        if ((t2 == NULL) && (t1 != NULL)) {
            while (t1) {
                t3->dig = (t1->dig) + C;
                if ((t3->dig) > 9) {
                    C = 1;
                    t3->dig %= 10;
                } else {
                    C = 0;
                }
                if (!(temp = (Node *) malloc(sizeof (Node)))) {
                    printf("Cannot allocate memory:");
                    freeMem(n1);
                    freeMem(n2);
                    freeMem(n3);
                    exit(0);
                }
                temp->next = t3;
                temp->dig = 0;
                t3 = temp;
                t1 = pop(stk1);
            }
        }

        if ((t1 == NULL) && (t2 == NULL)) {
            t3->dig=C;
            if (t3->dig == 0) {
                temp = t3;
                n3 = t3->next;
                free(temp);
                return (n3);
            } else {
                return (t3);
            }
        }

    }
}
