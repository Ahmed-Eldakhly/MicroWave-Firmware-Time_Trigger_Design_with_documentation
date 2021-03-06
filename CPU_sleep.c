/******************************************************************************* 
 * File:                CPU_sleep.c 
 * 
 * Author:              Ahmed Eldakhly
 * 
 * Comments:            it contains functions implementation to sleep CPU.
 * 
 * Revision history:    12/3/2020
 * 
 ******************************************************************************/

/*******************************************************************************
 *                       	Included Libraries                                 *
 *******************************************************************************/
#include "helped_macros.h"
#include "stdtypes.h"

/*******************************************************************************
 *                              Definitions                                    *
 *******************************************************************************/
#define OCILLATOR_CONTROL_REG           *(volatile uint8*)0xFD3
#define SLEEP_MODE_ENABLE_BIT           7u

/*******************************************************************************
 *                      Functions implementation                               *
 *******************************************************************************/

/*******************************************************************************
 * Function Name:	CPU_sleep
 *
 * Description: 	make CPU sleep.
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
void CPU_sleep(void)
{
    /* enable sleeping mode */
    CLEAR_BIT(OCILLATOR_CONTROL_REG , SLEEP_MODE_ENABLE_BIT);
    /* start sleeping mode */
    asm(" sleep");
}