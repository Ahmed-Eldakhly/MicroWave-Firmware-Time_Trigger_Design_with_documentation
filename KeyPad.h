/*******************************************************************************
 *  
 * File:                KeyPad.h
 * 
 * Author:              Ahmed Eldakhly
 * 
 * Comments:            it contains functions prototypes of Keypad module.
 * 
 * Revision history:    21/2/2020
 * 
 ******************************************************************************/

/* This is a guard condition so that contents of this file are not included
 * more than once. */ 
#ifndef KEYPAD_H
#define	KEYPAD_H

/*******************************************************************************
 *                             Included libraries
 /******************************************************************************/
#include "stdtypes.h"

/*******************************************************************************
 *                            Functions Prototype
 /******************************************************************************/

/*******************************************************************************
 * Function Name:	KeyPad_Initialization
 *
 * Description: 	Initialize KeyPad with Configured mode
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
extern void KeyPad_Initialization(void);

/*******************************************************************************
 * Function Name:	KeyPad_get_PressedKey_with_debouncing
 *
 * Description: 	get pressed key from keypad with avoid bouncing effect.
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			uint8
 *******************************************************************************/
extern uint8 KeyPad_get_PressedKey_with_debouncing(void);

#endif	/* KEYPAD_H */

