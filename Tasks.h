/**********************************************************************************
 *  
 * File:                Tasks.h 
 * 
 * Author:              Ahmed Eldakhly
 * 
 * Comments:            it contains prototypes and definitions of microwave tasks.
 * 
 * Revision history:    28/2/2020
 * 
 *********************************************************************************/

/* This is a guard condition so that contents of this file are not included
 * more than once. */ 
#ifndef TASKS_H
#define	TASKS_H

/*******************************************************************************
 *                              Definitions                                    *
 *******************************************************************************/
#define _XTAL_FREQ              8000000u
#define ASCII_ZERO_NUMBER       48u
#define MAX_DEF_TEMPERATURE     50u
#define MIN_TEMPERATURE         27u
#define KEYPAD_NO_KEY_PRESSED   '_'
#define LED_PIN                 GPIO_PIN7
#define LED_PORT                GPIO_PORTB
#define BUZZER_PIN              GPIO_PIN1
#define BUZZER_PORT             GPIO_PORTC
#define HEATER_PIN              GPIO_PIN5
#define HEATER_PORT             GPIO_PORTC
#define DOOR_SENSOR_PIN         GPIO_PIN4
#define DOOR_SENSOR_PORT        GPIO_PORTB
#define WEIGHT_SENSOR_PIN       GPIO_PIN5
#define WEIGHT_SENSOR_PORT      GPIO_PORTB

/*******************************************************************************
 *                          Functions Prototypes                               *
 *******************************************************************************/

/*******************************************************************************
 * Function Name:	initialization_Tasks
 *
 * Description: 	initialize all tasks to put them in scheduler queue.
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
void initialization_Tasks(void);

/*******************************************************************************
 * Function Name:	LCD_Task
 *
 * Description: 	Display on LCD screen at any state of microwave operations.
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
extern void LCD_Task(void);

/*******************************************************************************
 * Function Name:	KeyPad_Task
 *
 * Description: 	Read user insertion.
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
extern void KeyPad_Task(void);

/*******************************************************************************
 * Function Name:	Temperature_Task
 *
 * Description: 	set and update microwave temperature.
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
extern void Temperature_Task (void);

/*******************************************************************************
 * Function Name:	Door_Sensor_Task
 *
 * Description: 	get microwave door sensor state.
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
extern void Door_Sensor_Task(void);

/*******************************************************************************
 * Function Name:	Weight_Sensor_Task
 *
 * Description: 	get microwave weight sensor state.
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
extern void Weight_Sensor_Task(void);

/*******************************************************************************
 * Function Name:	Weight_Sensor_Task
 *
 * Description: 	set and update microwave LED & Buzzer.
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
extern void LED_Buzzer_Task(void);

/*******************************************************************************
 * Function Name:	Reminding_time_Task
 *
 * Description: 	update the reminding time for heating operation.
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
extern void Reminding_time_Task(void);

/*******************************************************************************
 * Function Name:	Welcome_screen_Task
 *
 * Description: 	Display the welcome message.
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
extern void Welcome_screen_Task(void);

/*******************************************************************************
 * Function Name:	Home_screen_display
 *
 * Description: 	Display home screen or the state of door and weight and time 
 *                  and temperature insertion before start of the heating process.
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
extern void Home_screen_display(void);

#endif	/* TASKS_H */