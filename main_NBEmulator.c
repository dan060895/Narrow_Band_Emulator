// Standard Directories
#include "stdio.h"
#include "stdint.h"
#include "stdlib.h"
#include "string.h"
#include <stdbool.h>

// Configuration Directories 
#include "system.h"
#include "id00003000.h"
#include "id00003000_configuration.h"
#include "debug.h"



// IPs Directories
#include "ID00001008_SDRAMController.h"
#include "ID00001007_MxV.h"
#include "ID00001009_P2SConverter.h"
#include "ID00001010_Concatenator.h"
#include "ID00001011_IntPol2_D3.h"
#include "ID00001012_IntPol2_D4.h"
#include "ID00001013_Decimator.h"
#include "ID00002001_DDS.h"
#include "ID00002004_URVG.h"
#include "ID00002005_GRVG.h"




#include "ID00004003_masterSOC.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_timestamp.h"
#include <unistd.h>
//#include "ID00001001_dummy.h"
#include <sys/alt_irq.h>
#include <time.h>
#include <sys/alt_alarm.h>
#include "io.h"

#include "altera_avalon_timer_regs.h"


/*For NoC Manager*/
#define MASK  0x04 //Done and communications error flags
#define NOC_MANAGER_RETRANSMISIONS 1
#define NOC_MANAGER_TIMESTAMP 0x05F5E100
/* --------------*/
#define ADDR0 0
#define ADDR1 1

//Assign port to each IP
#define SDRAMC_PORT 0
#define URVG_PORT 1
#define GRVG_PORT 2
#define MXV0_PORT 3
#define MXV1_PORT 4
#define P2S_PORT 5
#define CONCATER_PORT 6
#define INTPOL_PORT 7
#define DECIMATOR_PORT 8
#define MULTIRATE_PORT 9
#define DDS_PORT 10

#define MSEC  3000 //ip dummy delay

#define ONE_FLIT_SIZE 1
#define ZERO_OFFSET   0
#define AIP_DUMMY_MEM_SIZE 8
#define DONE_FLAG 0
#define DONE_INDEX 7
#define NIC_TIMESTAMP_INT 10000
#define NIC_TIMESTAMP_ACK 10000
#define MAX_IPCORES 8
#define INT_REG_SIZE 8
#define NOC_IP_CORES          3  //3 IP Dummies



void start_isr(void * context_2);
void int_isr_1(void * context_1);

void int_setup();

void configure_noc_manager(void);

#ifdef PRINTF
    #define LOG_PRINTF(...) printf(__VA_ARGS__)
#else
    #define LOG_PRINTF(...)
#endif

//#define WRITE_SDRAM
#define TESTREAD_SDRAM
#define MASTERSOC_PORT 2
volatile static uint32_t start_state=0;
volatile int edge_val1 = 1; // Global variable to hold the value of the edge capture
volatile int edge_val2 = 1; // Global variable to hold the value of the edge capture

volatile uint8_t NetStatus[8][8];
volatile uint8_t wait_flag;

sdramC_state *sdramC_currentState;
mxv_state *mxv_currentState;

int main()
{
	int_setup();

    id00003000_init(nic_addr, port);

    configure_noc_manager();

    id00003000_enableNoCInterrupts(1, 10000, 10000);
    
    ID00004003_init(MASTERSOC_PORT);
 
    
    uint32_t seeds[8];
    uint32_t confreg_t[4];

    // Initialisation of IPs
    ID00001008_init(ADDR1, SDRAMC_PORT);
    ID00002004_init(ADDR1, URVG_PORT);
    ID00002005_init(ADDR1, GRVG_PORT);
    ID00001007_init(ADDR1, MXV0_PORT);
    ID00001007_init(ADDR1, MXV1_PORT);
    ID00001009_init(ADDR1, P2S_PORT);
    ID00001010_init(ADDR1, CONCATER_PORT);
    ID00001012_init(ADDR1, INTPOL_PORT);
    ID00001013_init(ADDR1, DECIMATOR_PORT);
    ID00001011_init(ADDR1, MULTIRATE_PORT);
    ID00002001_init(ADDR1, DDS_PORT);


    //Target IP: UNIFORM_RAND_GEN
    for (uint32_t i = 0; i < 2; i++)   //TO DO: Generate 2 seeds
    {
        //seeds[i] = randn(2,1); 
    }
    ID00002004_writeData(ADDR1, URVG_PORT, seeds, 2, 0);
    
    confreg_t[0]= URVG_LOAD_SEED;
    ID00002004_URVG_setConf(ADDR1, URVG_PORT, confreg_t);

    ID00002004_startIP(ADDR1, URVG_PORT);
    ID00002004_waitDone(ADDR1, URVG_PORT);



    //Target IP: GAUSSIAN_RAND_GEN    
    for (uint32_t i = 0; i < 2; i++)   //TO DO: Generate 8 seeds
    {
        //seeds[i] = randn(8,1);
    }
    ID00002005_writeData(ADDR1, GRVG_PORT, seeds, 2, 0);

    confreg_t[0]= GRVG_LOAD_SEED;
    ID00002005_writeConfReg(ADDR1, GRVG_PORT, confreg_t); 
    ID00002005_startIP(ADDR1, GRVG_PORT);
    ID00002005_waitDone(ADDR1, GRVG_PORT);


    //Target IP: DDS
    pkgDDS = new[1];
    $readmemh($sformatf({`SAVEPATH,`CONFIG_DDS_FILE}), pkgDDS); 


    pkgDDS[0] = 1074002*freq;
    confreg_t[0] = pkgDDS[0];
    confreg_t[1] = pkgDDS[0];
    confreg_t[2] = 0; //phase
    confreg_t[3] = 0x00004000; //Amplitude 1
    confreg_t[4] = 0x00004000; //Amplitude 2
    confreg_t[5] = 0; // Period2
    confreg_t[6] = 0; // Period1
    confreg_t[7] = 0x00000010;  // bit [4] Enabling generation

    ID00002001_writeData(ADDR1, DDS_PORT, confreg_t, 8, 0); 
    ID00002001_startIP(ADDR1, DDS_PORT);


    

 


















    //Target IP: UNIFORM_RAND_GEN
    num_flows = 1
    ID00002004_writeConfReg(ADDR1, URVG_PORT, num_flows, 1); // Get alpha
    ID00002004_startIP(ADDR1, URVG_PORT);
    ID00002004_waitDone(ADDR1, URVG_PORT);
    ID00002004_readMem(ADDR1, URVG_PORT, URVG_MEMOUT, alpha_reg, 1); 
    alpha_val = alpha_reg[0];

    //Target IP: CONCATER_GEN
    ID00001010_writeConfReg(alpha_val, 1);
    ID00001010_startIP();

    //Target IP: MXV0
    ID00001006_writeConfReg(config_MXV0, 1);
    ID00001006_startIP();

    //Target IP: MXV_CP1
    ID00001007_writeConfReg(config_MXV1, 1);
    ID00001007startIP();

    //Target IP: INTERP_D4
    ID00001012_writeConfReg(interp_factor, 1);
    ID00001012_startIP()
    ID00001012_writeConfReg(decim_factor, 1);
    ID00001012_startIP()

    while(True){

        // Obtain package of weighted random variables.
    
        //Target IP: GAUSSIAN_RAND_GEN
        ID00002005_writeData(ADDR1, GRVG_PORT, GRVG_MEMIN0, varz, DIM);
        temp[0] = CP_MODE;
        temp[2] = DIM;
        ID00002005_writeConfReg(ADDR1, GRVG_PORT, temp, 3); 
        ID00002005_startIP(ADDR1, GRVG_PORT);
        ID00002005_waitDone(ADDR1, GRVG_PORT);
        pkgA = ID00002005_readMem(ADDR1, GRVG_PORT, GRVG_MEMOUT0, DIM);

        //Target IP: MXV0

        //Write vector MXV0
        ID00001006_writeData(ADDR1, MXV0_MEMIN0, pkgA, DIM);
        ID00001006_startIP();
        ID00001006_waitDone();
        //Write MATRIX MXV0
        j = 0
        for(i = 1; i < TO MXV_NUM_PES; i++){
            //SDRAM
            pkgUa = sdram_ctrl();
            ID00001006_writeData(ADDR1, MXV0_MEMIN1+j, pkgUa, MXV0_SIZE);
            j = j + 2;
        }
        ID00001006_startIP();
        ID00001006_waitDone();
        pkgAUa = ID00001006_readMem(MXV0_MEMOUT0, DIM);
        
        //Target IP: MXV1

        //Write vector MXV1
        ID00001007_writeData(ADDR1, MXV1_MEMIN0, pkgAUa, DIM);
        ID00001007_startIP();
        //Write MATRIX MXV1
        j = 0
        for(i = 1; i < TO MXV_NUM_PES; i++){
            //SDRAM
            pkgPsiUB = sdram_ctrl();
            ID00001007_writeData(ADDR1, MXV1_MEMIN1+j, pkgPsiUB, MXV1_SIZE);
            j = j + 2
        }
        ID00001007_startIP();
        ID00001007_waitDone();
        pkgProcess = ID00001007_readMem(MXV1_MEMOUT0, PROC_LEN);

        //Target IP: P2S_CONVERTER
        do {
            ID00001009_getStatus(statusTemp);
        }while (statusTemp[done_bit]);  
        ID00001009_writeData(ADDR1, P2S_MEMIN0, pkgProcess);
        ID00001009_startIP();
        ID00001009_waitDone();







	return 0;
}

void configure_noc_manager(void)
{
    //Associate a NoC Address to an Interrupt Flags data
    id00003000_allocateINTinfo(ADDR1);
    printf("NoC Manager\n");

    //Configure NoC manager
    id00003000_config(MASK, ADDR0, NOC_MANAGER_RETRANSMISIONS, NOC_MANAGER_TIMESTAMP);

    LOG_PRINTF("NoC Manager configured succesfully\n");


}



void int_setup(void){
    IOWR_ALTERA_AVALON_PIO_IRQ_MASK(INT_IP_S1_BASE, 0x01);
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(INT_IP_S1_BASE, 0x00);

    void * edge_val_ptr1 = (void *) &edge_val1;
    alt_ic_isr_register(
        INT_IP_S1_IRQ_INTERRUPT_CONTROLLER_ID,
        INT_IP_S1_IRQ,
        int_isr_1,  // ISR específica para INT_IP_S1
        edge_val_ptr1,
        0x00
    );

    IOWR_ALTERA_AVALON_PIO_IRQ_MASK(START_UP_BASE, 0x01);
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(START_UP_BASE, 0);

    void * edge_val_ptr2 = (void *) &edge_val2;
    alt_ic_isr_register(
    	START_UP_IRQ_INTERRUPT_CONTROLLER_ID,
		START_UP_IRQ,
        start_isr,  // ISR específica para INT_IP_S2
        edge_val_ptr2,
        0x00
    );

}

void int_isr_1(void * context_1){

	    // expect the context passed to be a pointer
		// to the variable to hold the edge capture information
		//
		// create a pointer variable to hold the context
		volatile int * edge_ptr;
		edge_ptr = (volatile int *) context_1;
		// Read the edge capture register and assign the
		// value to the ptr variable
		*edge_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(INT_IP_S1_BASE);
		// Clear the edge capture register
		IOWR_ALTERA_AVALON_PIO_EDGE_CAP(INT_IP_S1_BASE, 0x00);
		//printf("IRQ DETECTED\n");

		wait_flag = 1;

}

void start_isr(void * context_2){
	// expect the context passed to be a pointer
		// to the variable to hold the edge capture information
		//
		// create a pointer variable to hold the context
		volatile int * edge_ptr;
		edge_ptr = (volatile int *) context_2;
		// Read the edge capture register and assign the
		// value to the ptr variable
		*edge_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(START_UP_BASE);
		// Clear the edge capture register
		IOWR_ALTERA_AVALON_PIO_EDGE_CAP(START_UP_BASE, 0);

		printf("------------start DETECTED ------------ \n");
		start_state=1;

}