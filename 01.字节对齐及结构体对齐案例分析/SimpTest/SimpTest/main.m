#import <stdio.h>


//#pragma pack(push)
//#pragma pack(1)
struct Obj{
    char i; //1
    short j; //2,x00012 - x00013
    double k; //8, x00018 - 0x00020
} __attribute__ ((packed));
//#pragma pack(pop)

//struct Obj{
//    char i; //1
//    double k;
//    short j; //2,x00012 - x00013
//
//};
struct Obj i,j;

int main(int argc, const char *argv[]) {

//    static char i;
//    static short j;
//    static double k;
    
//    printf(" %p %lu \n %p %lu \n %p %lu \n", &i,sizeof(i), &j, sizeof(j));
    

    
    printf(" %p %lu \n %p %lu \n", &i,sizeof(i), &j, sizeof(j));
    
    return 0;
}
