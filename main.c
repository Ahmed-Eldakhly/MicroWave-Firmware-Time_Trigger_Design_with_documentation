/*******************************************************************************
 *  
 * File:                main.c 
 * 
 * Author:              Ahmed Eldakhly
 * 
 * Comments:            the application code.
 * 
 * Revision history:    24/2/2020
 * 
 ******************************************************************************/

/*******************************************************************************
 *                       	Included Libraries                                 *
 *******************************************************************************/
#include "general_bitConfig.h"
#include "Tasks.h"
#include "KeyPad.h"
#include "scheduler.h"
#include "GPIO.h"
#include "LCD.h"
#include "ADC.h"
#include "PWM.h"

/* main application code */
void main(void) 
{
    GPIO_SetPinDirection(GPIO_PORTC , GPIO_PIN7 , OUTPUT);
    /* Disable all ADC Channels Pins except Channel 0 */
    GPIO_Disable_ADC_On_Pins(GPIO_PORTA , GPIO_PIN1);
    /* Disable comparator module on PORT A */
    GPIO_Disable_Comparator_On_PORTA();
    /* enable weak internal Pull up resistors on input pins on PORT B */
    GPIO_Enable_Pull_Up_On_PortB();
    /* Set Heater pin as output pin */
    GPIO_SetPinDirection(HEATER_PORT , HEATER_PIN , OUTPUT);
    /* Set Buzzer pin as output pin */
    GPIO_SetPinDirection(BUZZER_PORT , BUZZER_PIN , OUTPUT);
    /* Disable Buzzer */
    GPIO_WriteOnPin(BUZZER_PORT , BUZZER_PIN , HIGH);
    /* Set LED pin as output pin */
    GPIO_SetPinDirection(LED_PORT , LED_PIN , OUTPUT);
    /* Disable LED */
    GPIO_WriteOnPin(LED_PORT , LED_PIN , LOW);
    /* Set Door sensor pin as input pin */
    GPIO_SetPinDirection(DOOR_SENSOR_PORT , DOOR_SENSOR_PIN , INPUT);
    /* Set weight sensor pin as input pin */
    GPIO_SetPinDirection(WEIGHT_SENSOR_PORT , WEIGHT_SENSOR_PIN , INPUT);
    /* initialize LCD module */
    LCD_Initialization();
    /* initialize PWM module on Channel 1 "PORT C - PIN 2" to make fan 
     * work to set the user desired temperature for heating operation. */
    PWM_Initialization(PWM_CHANNEL_1);
    /* Select frequency of PWM module */
    PWM_Frequency(3000);
    /* initialize ADC module on Channel 1 "PORT A - PIN 0" to allow user 
     * select temperature for heating operation by potentiometer device. */
    ADC_Initialization(ADC_CHANNEL_0);
    /* Select Auto acquisition feature for ADC channel 1 with mapped time = 4 */
    ADC_Select_acquisition_time(ADC_ACQUISITION_TIME_4);
    /* Select ADC clock by devision system clock on the selected 
     * number "16" to determine time of conversion on ADC channel 1. */
    ADC_Select_prescaler(ADC_PRESCALER_16); 
    /* enable scheduler to run tasks in specified time */
    Scheduler_Initialization(TICK_1_MS_);
    /* this task start immediately for one time to initialize all tasks to put 
     * them in scheduler queue. */
    Scheduler_StartFunction(initialization_Tasks , 1 , 1 , 0 , ONCE);
    /* loop to make program is worked as long the power is on */
    while(1)
    {
        /* run the scheduler dispatcher to run tasks at their time */
        Scheduler_Dispatcher();
    }
}

