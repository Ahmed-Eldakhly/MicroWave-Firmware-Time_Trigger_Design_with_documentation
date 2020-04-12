/******************************************************************************* 
 * File:                KeyPad.c
 * 
 * Author:              Ahmed Eldakhly
 * 
 * Comments:            it contains functions implementation of Keypad module.
 * 
 * Revision history:    21/2/2020
 * 
 ******************************************************************************/

/*******************************************************************************
 *                             Included libraries
 /******************************************************************************/
#include "keyPad.h"
#include "KeyPad_config.h"
#include "GPIO.h"

/*******************************************************************************
 *                           Static Functions                                  *
 *******************************************************************************/

/********************************************************************************
 * Function Name:	KeyPad_4x4_switch
 *
 * Description: 	prototype for static function to return value of Pressed Key
 *
 * Inputs:			uint8       row of pressed Key 
 * 					uint8       column of pressed Key 
 *
 * Outputs:			NULL
 *
 * Return:			uint8       value of Pressed Key
 *******************************************************************************/
static uint8 KeyPad_switch(uint8 a_u8row, uint8 a_u8col);

/*******************************************************************************
 * Function Name:	KeyPad_getPressedKey
 *
 * Description: 	Return value of pressed key
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			uint8       pressed key 
 *******************************************************************************/
static uint8 KeyPad_getPressedKey(void);

/********************************************************************************
 *                          Functions implementation							*
 *******************************************************************************/

/********************************************************************************
 * Function Name:	KeyPad_Initialization
 *
 * Description: 	Initialize KeyPad by set directions of Keypad pins 
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
void KeyPad_Initialization(void)
{
	/* set keypad rows pins as output */
    for(uint8 u8counter = START_ROW ; u8counter <= END_ROW ; u8counter++)
    {
        GPIO_SetPinDirection(KEYPAD_PORT_OUT_ROW , u8counter , OUTPUT);
        GPIO_WriteOnPin(KEYPAD_PORT_OUT_ROW , u8counter , HIGH);
    }
    /* set keypad columns pins as input */
    for(uint8 u8counter = START_COL ; u8counter <= END_COL ; u8counter++)
    {
        GPIO_SetPinDirection(KEYPAD_PORT_IN_COL , u8counter , INPUT);
    }
}

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
uint8 KeyPad_get_PressedKey_with_debouncing(void)
{
    /* flag to avoid Push button bouncing effect */
    static uint8 u8debouncing_counter = 0;
    uint8 u8pressed_key = KEYPAD_NO_KEY_PRESSED;
    uint8 u8retVal = KEYPAD_NO_KEY_PRESSED;
    /* initialize KeyPad every function calling because when ADC module corrupt Direction of pins*/
    KeyPad_Initialization();
    /* get the value of pressed key */
    u8pressed_key = KeyPad_getPressedKey();
    /* check if key is released */
    if(u8pressed_key != KEYPAD_NO_KEY_PRESSED)
    {
        /* check to avoid bouncing effect */
        switch(u8debouncing_counter)
        {
            case 0:
                u8debouncing_counter++;
                break;
            case 1:
                /* get key value */
                u8retVal = u8pressed_key;
                /* to prevent multi reading for the long press */
                u8debouncing_counter++;
                break;
            case 2:
                /* Do nothing */
                break;
            default:
                /* Do nothing */
                break;
        }
    }
    else
    {
        /* reset de_bouncing flag to a new press */
        u8debouncing_counter = 0;
    }
    return u8retVal;
}

/*******************************************************************************
 * Function Name:	KeyPad_getPressedKey
 *
 * Description: 	Return value of pressed key
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			uint8       pressed key 
 *******************************************************************************/
static uint8 KeyPad_getPressedKey(void)
{
	/*return value*/
	uint8 u8ReturnVal = KEYPAD_NO_KEY_PRESSED;
	/*Loop on rows to check if Key is pressed to return its value*/
	for(uint8 u8rowCounter = START_ROW ; u8rowCounter <= END_ROW ; u8rowCounter++)
	{
        /* put zero on row to check if any key on this row has been pressed */
		GPIO_WriteOnPin(KEYPAD_PORT_OUT_ROW , u8rowCounter , LOW);
        /*Loop on columns to check if Key is pressed to return its value*/
		for(uint8 u8colCounter = START_COL ; u8colCounter <= END_COL ; u8colCounter++)
		{
            /* check if the key on this row and this column has been pressed. */
			if(GPIO_ReadFromPin(KEYPAD_PORT_IN_COL , u8colCounter) == LOW)
			{
                /* return the value assigned to this key */
                return KeyPad_switch(u8rowCounter - START_ROW , u8colCounter - START_COL);
			}
		}
        /* put one on row to check another row next iteration */
        GPIO_WriteOnPin(KEYPAD_PORT_OUT_ROW , u8rowCounter , HIGH);
	}
	return u8ReturnVal;
}

/********************************************************************************
 * Function Name:	KeyPad_4x4_switch
 *
 * Description: 	static function to return value of Pressed Key
 *
 * Inputs:			row of pressed Key (uint8)
 * 					column of pressed Key (uint8)
 *
 * Outputs:			NULL
 *
 * Return:			value of Pressed Key (uint8)
 *******************************************************************************/
static uint8 KeyPad_switch(uint8 a_u8row , uint8 a_u8col)
{
	/*variable of return value*/
	uint8 u8ReturnVal = 0;

	/*determine row of pressed key*/
	switch(a_u8row)
	{
	case 0:
		/*determine column of pressed key*/
		switch(a_u8col)
		{
		case 0: u8ReturnVal = R1_C1;
            break;
		case 1: u8ReturnVal = R1_C2;
            break;
		case 2: u8ReturnVal = R1_C3;
            break;
/* check if keypad type is 3x4 or 4x4 to enable fourth column */
#if KEYPAD_TYPE == KEYPAD_3x4_TYPE || KEYPAD_TYPE == KEYPAD_4x4_TYPE
		case 3: u8ReturnVal = R1_C4;
            break;
#endif
        default:
            /*Do Nothing*/
            break;
		}
		break;

	case 1:
		/*determine column of pressed key*/
		switch(a_u8col)
		{
		case 0: u8ReturnVal = R2_C1;
			break;
		case 1: u8ReturnVal = R2_C2;
			break;
		case 2: u8ReturnVal = R2_C3;
			break;
/* check if keypad type is 3x4 or 4x4 to enable fourth column */            
#if KEYPAD_TYPE == KEYPAD_3x4_TYPE || KEYPAD_TYPE == KEYPAD_4x4_TYPE
		case 3: u8ReturnVal = R2_C4;
			break;
#endif
        default:
            /*Do Nothing*/
            break;
		}
		break;

	case 2:
		/*determine column of pressed key*/
		switch(a_u8col)
		{
		case 0: u8ReturnVal = R3_C1;
			break;
		case 1: u8ReturnVal = R3_C2;
			break;
		case 2: u8ReturnVal = R3_C3;
			break;
/* check if keypad type is 3x4 or 4x4 to enable fourth column */            
#if KEYPAD_TYPE == KEYPAD_3x4_TYPE || KEYPAD_TYPE == KEYPAD_4x4_TYPE
		case 3: u8ReturnVal = R3_C4;
			break;
#endif
        default:
            /*Do Nothing*/
            break;
		}
		break;
/* check if keypad type is 4x3 or 4x4 to enable fourth row */        
#if KEYPAD_TYPE == KEYPAD_4x3_TYPE || KEYPAD_TYPE == KEYPAD_4x4_TYPE
	case 3:
		/*determine column of pressed key*/
		switch(a_u8col)
		{
		case 0: u8ReturnVal = R4_C1;
			break;
		case 1: u8ReturnVal = R4_C2;
			break;
		case 2: u8ReturnVal = R4_C3;
			break;
/* check if keypad type 4x4 to enable fourth column */            
#if  KEYPAD_TYPE == KEYPAD_4x4_TYPE
		case 3: u8ReturnVal = R4_C4;
			break;
#endif
        default:
            /*Do Nothing*/
            break;
		}
		break;
#endif
    default:
        /*Do Nothing*/
        break;
	}

	/*return value of pressed key*/
	return u8ReturnVal;
}
