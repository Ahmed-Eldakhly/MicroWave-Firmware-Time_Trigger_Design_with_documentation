/*******************************************************************************
 *  
 * File:                Taks.c 
 * 
 * Author:              Ahmed Eldakhly
 * 
 * Comments:            it contains all tasks and helped function that will run
 *                      to make interfacing for Microwave device.
 * 
 * Revision history:    4/3/2020
 * 
 ******************************************************************************/

/*******************************************************************************
 *                       	Included Libraries                                 *
 *******************************************************************************/
#include "Tasks.h"
#include "KeyPad.h"
#include "scheduler.h"
#include "GPIO.h"
#include "LCD.h"
#include "PWM.h"
#include "timers.h"
#include "interrupt.h"
#include "ADC.h"
/*******************************************************************************
 *                         Types Declaration                                   *
 *******************************************************************************/

/************************** EnumSystem_states_t ********************************/
typedef enum {
            SYSTEM_IDLE_STATE,
            SYSTEM_HEATING_STATE,
            SYSTEM_END_TIME
}EnumSystem_states_t;

/**************************** EnumDoor_sensor_t ********************************/
typedef enum{
            DOOR_IS_OPENED,
            DOOR_IS_CLOSED
}EnumDoor_sensor_t;

/**************************** EnumWeight_sensor_t ******************************/
typedef enum{
            MICROWAVE_IS_EMPTY,
            MICROWAVE_HAS_SOMETHING_INSIDE
}EnumWeight_sensor_t;

/*******************************************************************************
 *                              Static Variables                               *
 *******************************************************************************/
/* inserted time in seconds to count down when the heating begin */
static uint16 g_u16MicrowaveTime = 0;
/* System state variable that used to make system state machine */
static EnumSystem_states_t g_system_state_var_t = SYSTEM_IDLE_STATE;
/* flag to check if the heating finish */
static uint8 g_u8heating_finished_flag = 0;
/* Door state that used to show reading of door sensor */
static EnumDoor_sensor_t g_door_state_t = DOOR_IS_CLOSED;
/* inside microwave state that used to show reading of weight sensor */
static EnumWeight_sensor_t g_inside_microwave = MICROWAVE_IS_EMPTY;
/* array of 6 elements to save inserted time */
static uint8 g_u8timer_arr[6] = {ASCII_ZERO_NUMBER , ASCII_ZERO_NUMBER , ':' , ASCII_ZERO_NUMBER , ASCII_ZERO_NUMBER , '\0'};
/* variable is used to determine which time digit is inserted */
static uint8 g_u8time_digits = 0;
/* variable used to read pressed key on KeyPad */
static uint8 g_u8keypad_button_val = KEYPAD_NO_KEY_PRESSED;
/* value of user selected temperature of microwave */
static uint8 g_u8temperature = 0;
/* variable used to check if user change selected temperature to display new value on LCD*/
static uint8 g_u8old_temp_reading = 100;
/* flag to synchronize door state between tasks */
static uint8 g_u8door_change_state_flag = 0;
/* flag to synchronize inside microwave state between tasks */
static uint8 g_u8weight_change_state_flag = 0;

/*******************************************************************************
 *                             Static functions                               *
 *******************************************************************************/

/*******************************************************************************
 * Function Name:	Display_finishing_message
 *
 * Description: 	Display the finishing process screen
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
static void Display_finishing_message(void)
{
    /* counter to blank LCD when the heating process is finish for alarming process design */
    static uint16 u8counter = 0;
    /* Blank the finishing process message on LCD */
    if(u8counter == 0)
    {
        LCD_SetDisplayPosition(0 , 1);
        LCD_SendDataString("Timer:");
        LCD_SetDisplayPosition(11 , 1);
        LCD_SendDataString("00:00");
        LCD_SendDataString("Heating finished");
        LCD_SetDisplayPosition(0 , 3);
        LCD_SendDataString("PRESS '#' to");
        LCD_SetDisplayPosition(5 , 4);
        LCD_SendDataString("return home");
        LCD_SetDisplayPosition(11 , 1);
        LCD_SendDataString("00:00");
        u8counter++;
    }
    else if(u8counter < 7)
    {
        u8counter++;
    }
    else if(u8counter == 7)
    {
        LCD_ClearScreen();
        u8counter++;
    }
    else if(u8counter < 14)
    {
        u8counter++;
    }
    else
    {
        u8counter = 0;
    }
}

/*******************************************************************************
 * Function Name:	Display_reminding_time
 *
 * Description: 	Display the reminding time for the heating process to finish.
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
static void Display_reminding_time (void)
{
    /* check if one second passed to update timer and display the new value on LCD*/
    if(g_u8heating_finished_flag == 1)
    {
        /* go to specific position on LCD to display the reminding time*/
        LCD_SetDisplayPosition(11,1);
        LCD_SendDataByte((g_u16MicrowaveTime / 600) + ASCII_ZERO_NUMBER);       /* Display second digits of minutes */
        LCD_SendDataByte(((g_u16MicrowaveTime / 60) % 10) + ASCII_ZERO_NUMBER); /* Display first digits of minutes */
        LCD_SendDataByte(':');
        LCD_SendDataByte(((g_u16MicrowaveTime % 60) / 10) + ASCII_ZERO_NUMBER); /* Display second digits of seconds */
        LCD_SendDataByte(((g_u16MicrowaveTime % 60) % 10) + ASCII_ZERO_NUMBER); /* Display first digits of seconds */
        /* reset the flag */
        g_u8heating_finished_flag = 0;
    }
}

/*******************************************************************************
 * Function Name:	Get_and_Set_desired_temp
 *
 * Description: 	Get the wanted temperature from user and set it on microwave. 
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
static void Get_and_Set_desired_temp(void)
{
    /* start ADC sampling to get user selected temperature from potentiometer device */
    ADC_Start_conversion();
    /* difference between max. and min. temperature can we get by our microwave is 50 degree*/
    g_u8temperature = ADC_Read_value() * MAX_DEF_TEMPERATURE / 1023;
    /* check if user inserted new value for the temperature to change duty cycle and LCD screen*/
    if(g_u8old_temp_reading != g_u8temperature)
    {
        /* update duty cycle for fan to get specified temperature */
        PWM_DutyCycle(PWM_CHANNEL_1 , 100 - g_u8temperature * 2);
        /* update the old value to another check next time this function will be called */
        g_u8old_temp_reading = g_u8temperature;
    }
    else
    {
        /* Do nothing*/
    }
}

/*******************************************************************************
 *                          Functions Definitions                              *
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
void initialization_Tasks(void)
{
    /* this task start immediately for one time to show welcome message */
    Scheduler_StartFunction(Welcome_screen_Task , 1 , 2000 , 0 , ONCE);
    /* this task start after 2 seconds to display home screen for one time after
     *  seconds from welcome message */
    Scheduler_StartFunction(Home_screen_display , 1 , 5 , 2000 , ONCE);
    /* this task start after 2.02 seconds to reminding time update function to repeat every one second  */
    Scheduler_StartFunction(Reminding_time_Task , 1 , 1000 , 2020 , REPEAT);
    /* this task start after 2.021 seconds to start KeyPad function to repeat every 10 ms */
    Scheduler_StartFunction(KeyPad_Task , 2 , 30 , 2021 , REPEAT);
    /* this task start after 2.024 seconds to start Weight Sensor function to repeat every 25 ms */
    Scheduler_StartFunction(Weight_Sensor_Task , 3 , 30 , 2024 , REPEAT);
    /* this task start after 2.025 seconds to start Door Sensor function to repeat every 25 ms */
    Scheduler_StartFunction(Door_Sensor_Task , 4 , 30 , 2025 , REPEAT);
    /* this task start after 2.026 seconds to start Temperature function to repeat every 25 ms */
    Scheduler_StartFunction(Temperature_Task , 5 , 30 , 2026 , REPEAT);
    /* this task start after 2.027 seconds to start LED_Buzzer function to repeat every 25 ms */
    Scheduler_StartFunction(LED_Buzzer_Task , 6 , 30 , 2027 , REPEAT);
    /* this task start after 2.028 seconds to start LCD function to repeat every 25 ms */
    Scheduler_StartFunction(LCD_Task , 7 , 30 , 2028 , REPEAT);

}

/*******************************************************************************
 * Function Name:	LCD_Task
 *
 * Description: 	Display on LCD at any time of microwave operations.
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
void LCD_Task(void)
{GPIO_WriteOnPin(GPIO_PORTC , GPIO_PIN7 , HIGH);
    /* check on pervious state to clear or display specific screen at change moment */
    static EnumSystem_states_t old_system_state_var_t = SYSTEM_IDLE_STATE;
    /* check on device states to move from state to another depend on user choices */
    switch(g_system_state_var_t)
    {
        /* idle state that make user select heating time, open door, put food
         *  inside microwave and set suitable temperature from 27c to 77c */
        case SYSTEM_IDLE_STATE:
            /* check if the user pauses the heating process before the end of the specified time */
            if(old_system_state_var_t == SYSTEM_HEATING_STATE)
            {
                /* Display Door and weight sensors states */
                LCD_SetDisplayPosition(0,3);
                LCD_SendDataString("Door_St:  Closed");
                LCD_SetDisplayPosition(0,4);
                LCD_SendDataString("Inside_St:  Food");
                /* update the old state with the current state */
                old_system_state_var_t = SYSTEM_IDLE_STATE;
                /* reset KeyPad pressed flag for next check */
                g_u8keypad_button_val = KEYPAD_NO_KEY_PRESSED;
            }
            /* check if  the heating process end with the specified time */
            else if(old_system_state_var_t == SYSTEM_END_TIME)
            {
                /* display idle state screen before any insertion */
                Home_screen_display();
                /* update the old state with the current state */
                old_system_state_var_t = SYSTEM_IDLE_STATE;
                /* reset KeyPad pressed flag for next check */
                g_u8keypad_button_val = KEYPAD_NO_KEY_PRESSED;
            }
            else
            {
                /* Display the new temperature on the screen */
                LCD_SetDisplayPosition(13,2);
                /* when user insert zero it mean 27c */
                LCD_DisplaNumber(g_u8temperature + MIN_TEMPERATURE);
                /* check if door sensor changes the door state to display the new state on LCD */
                if(g_u8door_change_state_flag == 1)
                {
                    if(g_door_state_t == DOOR_IS_OPENED)
                    {
                        LCD_SetDisplayPosition(10,3);
                        LCD_SendDataString("Opened");
                    }
                    else
                    {
                        LCD_SetDisplayPosition(10,3);
                        LCD_SendDataString("Closed");
                    }
                    /* reset the flag to check again next time */
                    g_u8door_change_state_flag = 0;
                }
                /* check if weight sensor changes the inside state to display the new state on LCD */
                if(g_u8weight_change_state_flag == 1)
                {
                    if(g_inside_microwave == MICROWAVE_IS_EMPTY)
                    {
                        LCD_SetDisplayPosition(10 , 4);
                        LCD_SendDataString("N_Food");
                    }
                    else
                    {
                        LCD_SetDisplayPosition(10 , 4);
                        LCD_SendDataString("  Food");
                    }
                    /* reset the flag to check again next time */
                    g_u8weight_change_state_flag = 0;
                }
                /* check if key is pressed and the key value is number from 0 to 9 to set timer */
                if(g_u8keypad_button_val >= 0 && g_u8keypad_button_val < 10 && g_u8time_digits < 5)
                {
                    /* Display the inserted number on LCD */
                    LCD_SetDisplayPosition(11,1);
                    LCD_SendDataString(g_u8timer_arr);
                    /* reset KeyPad pressed flag for next check */
                    g_u8keypad_button_val = KEYPAD_NO_KEY_PRESSED;
                 }
                /* check if the user wants to clear the inserted number to reset the timer again from beginning */
                else if(g_u8keypad_button_val == '#')
                {
                    /* Display home Screen on LCD to begin new insertion for time */
                    LCD_SetDisplayPosition(4,1);
                    LCD_SendDataString(": ");
                    LCD_SetDisplayPosition(11,1);
                    LCD_SendDataString("__:__");
                    /* reset KeyPad pressed flag for next check */
                    g_u8keypad_button_val = KEYPAD_NO_KEY_PRESSED;
                }
            }
            break;
        /* the microwave is heating the food when the time is selected 
         * and the door is closed and the food is inside the microwave */    
        case SYSTEM_HEATING_STATE:
            if(old_system_state_var_t == SYSTEM_IDLE_STATE)
            {
                /* Display the timer time */
                LCD_SetDisplayPosition(4,1);
                LCD_SendDataString("r:");
                LCD_SetDisplayPosition(0,3);
                /* Display State of system and options for the user in this state */
                LCD_SendDataString("Heating Process ");
                LCD_SendDataString("#:Pause ##:Stop ");
                /* update the old state with the current state */
                old_system_state_var_t = SYSTEM_HEATING_STATE;
                /* reset KeyPad pressed flag for next check */
                g_u8keypad_button_val = KEYPAD_NO_KEY_PRESSED;
            }
            /* Display the new temperature on the screen */
            LCD_SetDisplayPosition(13,2);
            /* when user insert zero it mean 27c */
            LCD_DisplaNumber(g_u8temperature + MIN_TEMPERATURE);
            /* check if one second passed to update timer and display the new value on LCD*/
            Display_reminding_time();
            break;
        /* state after the heating process finished, in this state the system alarm the user*/
        case SYSTEM_END_TIME:
            /* clear screen and change the old state to current state */
            if(old_system_state_var_t == SYSTEM_HEATING_STATE)
            {
                LCD_ClearScreen();
                /* update the old state with the current state */
                old_system_state_var_t = SYSTEM_END_TIME;
            }
            /* blank message to alarm user for the heating finishing with specified time */
            Display_finishing_message();
            break;
        default:
            /* Do nothing*/
            break;
    }
GPIO_WriteOnPin(GPIO_PORTC , GPIO_PIN7 , LOW);}

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
void KeyPad_Task(void)
{
    /* get the value of pressed key in this buffer */
    uint8 u8pressed_key = KEYPAD_NO_KEY_PRESSED;
    /* check on pervious state to clear the timer buffer at some events */
    static EnumSystem_states_t old_system_state_var_t = SYSTEM_IDLE_STATE;
    /* check on device states to move from state to another depend on user choices */
    switch(g_system_state_var_t)
    {
        /* idle state that make user select heating time, open door, put food
         *  inside microwave and set suitable temperature from 27c to 77c */
        case SYSTEM_IDLE_STATE:
            /* reset the time buffer array to new operation */
            if(old_system_state_var_t == SYSTEM_END_TIME)
            {
                /* return the timer array elements to zero to reset them again */
                g_u8timer_arr[0] = ASCII_ZERO_NUMBER;
                g_u8timer_arr[1] = ASCII_ZERO_NUMBER;
                g_u8timer_arr[3] = ASCII_ZERO_NUMBER;
                g_u8timer_arr[4] = ASCII_ZERO_NUMBER;
                /* to allow the user accessing on timer setting */
                g_u8time_digits = 0;
                /* update the old state with the current state */
                old_system_state_var_t = SYSTEM_IDLE_STATE;
            }
            /* get pressed key value */
            u8pressed_key = KeyPad_get_PressedKey_with_debouncing();
            /* check if key is pressed and the key value is number from 0 to 9 to set timer */
            if(u8pressed_key >= 0 && u8pressed_key < 10)
            {
                /* synchronize with other tasks with pressed key value */
                g_u8keypad_button_val = u8pressed_key;
                /* check this value for which digit in the timer value */
                switch(g_u8time_digits)
                {
                    case 0:
                        /* if user don't insert other digit, this value will be seconds value */
                        g_u8timer_arr[4] = g_u8keypad_button_val + ASCII_ZERO_NUMBER;
                        /* check if user insert zero as the first number */
                        if(g_u8keypad_button_val != 0)
                        {
                            /* increment the number of digits in inserted number */
                            g_u8time_digits++;
                        }
                        /* update timer counter with inserted key value */
                        g_u16MicrowaveTime = g_u8keypad_button_val;
                        break;
                    case 1:
                        /* set the previous inserted number as second digits for seconds */
                        g_u8timer_arr[3] = g_u8timer_arr[4];
                        /* set the current inserted number as first digits for seconds */
                        g_u8timer_arr[4] = g_u8keypad_button_val + ASCII_ZERO_NUMBER;
                        /* increment the number of digits in inserted number */
                        g_u8time_digits++;
                        /* update timer counter with inserted key value */
                        g_u16MicrowaveTime = g_u16MicrowaveTime * 10 + g_u8keypad_button_val;
                        break;
                    case 2:
                        /* set the first inserted number as first digits for minutes */
                        g_u8timer_arr[1] = g_u8timer_arr[3];
                        /* set the previous inserted number as second digits for seconds*/
                        g_u8timer_arr[3] = g_u8timer_arr[4];
                        /* set the current inserted number as first digits for seconds */
                        g_u8timer_arr[4] = g_u8keypad_button_val + ASCII_ZERO_NUMBER;
                        /* increment the number of digits in inserted number */
                        g_u8time_digits++;
                        /* update timer counter with inserted key value */
                        g_u16MicrowaveTime = (g_u8timer_arr[1] - ASCII_ZERO_NUMBER) * 60 +
                                (g_u8timer_arr[3] - ASCII_ZERO_NUMBER) * 10 + g_u8keypad_button_val;
                        break;
                    case 3:
                        /*check if the insertion for the Timer value didn't exceed the max value (99:59).*/
                        if(!(g_u8timer_arr[1] == 57 && g_u8timer_arr[3] == 57 && g_u8timer_arr[4] >= 54 ))
                        {
                            /* set the first inserted number as second digits for minutes */
                            g_u8timer_arr[0] = g_u8timer_arr[1];
                            /* set the second inserted number as first digits for minutes */
                            g_u8timer_arr[1] = g_u8timer_arr[3];
                            /* set the previous inserted number as second digits for seconds*/
                            g_u8timer_arr[3] = g_u8timer_arr[4];
                            /* set the current inserted number as first digits for seconds */
                            g_u8timer_arr[4] = g_u8keypad_button_val + ASCII_ZERO_NUMBER;
                            /* increment the number of digits to prevent any other number insertion */
                            g_u8time_digits++;
                            /* update timer counter with inserted key value */
                            g_u16MicrowaveTime = (g_u8timer_arr[0] - ASCII_ZERO_NUMBER) * 600 +
                                    (g_u8timer_arr[1] - ASCII_ZERO_NUMBER) * 60 +
                                    (g_u8timer_arr[3] - ASCII_ZERO_NUMBER) * 10 + g_u8keypad_button_val;
                        }
                        else
                        {
                            /* Do nothing */
                        }
                        break;
                    default:
                        /* Do nothing */
                        break;
                }
            }
            /* check if user pressed on the start heating key */
            else if(u8pressed_key == '*')
            {
                /* synchronize with other tasks with pressed key value */
                g_u8keypad_button_val = u8pressed_key;
                /* check if microwave has something inside itself, door is closed and timer not 
                 * equal zero when the user pressed on the start heating key */
                if(g_u16MicrowaveTime != 0 && g_door_state_t == DOOR_IS_CLOSED && g_inside_microwave == MICROWAVE_HAS_SOMETHING_INSIDE)
                {
                    /* update digits of timer to prevent any modify in timer when the heating is paused */
                    g_u8time_digits = 5;
                    /* convert system state to the heating process and start count down the inserted timer */
                    g_system_state_var_t = SYSTEM_HEATING_STATE;
                }
                else
                {
                    /* Do nothing */
                }
            }
            /* check if the user wants to clear the inserted number to reset the timer again from beginning */
            else if(u8pressed_key == '#')
            {
                /* synchronize with other tasks with pressed key value */
                g_u8keypad_button_val = u8pressed_key;
                /* return the timer array elements to zero to reset them again */
                g_u8timer_arr[0] = ASCII_ZERO_NUMBER;
                g_u8timer_arr[1] = ASCII_ZERO_NUMBER;
                g_u8timer_arr[3] = ASCII_ZERO_NUMBER;
                g_u8timer_arr[4] = ASCII_ZERO_NUMBER;
                /* to allow the user accessing on timer setting */
                g_u8time_digits = 0;
                /* return timer zero counter to zero */
                g_u16MicrowaveTime = 0;
            }
            break;
        /* the microwave is heating the food when the time is selected 
         * and the door is closed and the food is inside the microwave */    
        case SYSTEM_HEATING_STATE:
            /* get pressed key value */
            u8pressed_key = KeyPad_get_PressedKey_with_debouncing();
            /* check if the user pressed on pause_cancel key*/
            if(u8pressed_key == '#')
            {
                /* synchronize with other tasks with pressed key value */
                g_u8keypad_button_val = u8pressed_key;
                /* return system to Idle state as a pause condition without ability to modify timer time
                 * before cancel the previous process by pressing on '#' again */
                g_system_state_var_t = SYSTEM_IDLE_STATE;
            }
            break;
        /* state after the heating process finished, in this state the system alarm the user*/
        case SYSTEM_END_TIME:
            /* update the old state with the current state */
            old_system_state_var_t = SYSTEM_END_TIME;
            /* get pressed key value */
            u8pressed_key = KeyPad_get_PressedKey_with_debouncing();
            /* if the user pressed on '#' or the door is opened after finishing heating
             * the buzzer alarm will stop and system return to idle state to get new operation */
            if(u8pressed_key == '#')
            {
                /* synchronize with other tasks with pressed key value */
                g_u8keypad_button_val = u8pressed_key;
                /* return to idle state to new operation */
                g_system_state_var_t = SYSTEM_IDLE_STATE;
            } 
            break;
        default:
            /* Do nothing*/
            break;
    }
}

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
void Temperature_Task (void)
{
    static EnumSystem_states_t old_system_state_var_t = SYSTEM_IDLE_STATE;
    /* check on device states to move from state to another depend on user choices */
    switch(g_system_state_var_t)
    {
        /* idle state that make user select heating time, open door, put food
         *  inside microwave and set suitable temperature from 27c to 77c */
        case SYSTEM_IDLE_STATE:
            if(old_system_state_var_t == SYSTEM_HEATING_STATE)
            {
                /* turn off the heater */
                GPIO_WriteOnPin(HEATER_PORT , HEATER_PIN , LOW);
                /* Stop PWM to stop the fan */
                PWM_Stop(PWM_CHANNEL_1);
                /* update the old state with the current state */
                old_system_state_var_t = SYSTEM_IDLE_STATE;
            }
            else if(old_system_state_var_t == SYSTEM_END_TIME)
            {
                /* change the old value of temp to make the user see the current selected temperature */
                g_u8old_temp_reading = 100;
                /* update the old state with the current state */
                old_system_state_var_t = SYSTEM_IDLE_STATE;                
            }
            /* user selects temperature by potentiometer and Display this temp */
            /* start ADC sampling to get user selected temperature from potentiometer device */
            Get_and_Set_desired_temp();
            break;
        /* the microwave is heating the food when the time is selected 
         * and the door is closed and the food is inside the microwave */    
        case SYSTEM_HEATING_STATE:
            
            if(old_system_state_var_t == SYSTEM_IDLE_STATE)
            {
                /* start PWM to turn on the fan to get selected temperature*/
                PWM_Start(PWM_CHANNEL_1);
                /* turn on the heater */
                GPIO_WriteOnPin(HEATER_PORT , HEATER_PIN , HIGH);
                /* update the old state with the current state */
                old_system_state_var_t = SYSTEM_HEATING_STATE;
            }
            /* user selects temperature by potentiometer and Display this temp */
            /* start ADC sampling to get user selected temperature from potentiometer device */
            Get_and_Set_desired_temp();
            break;
        /* state after the heating process finished, in this state the system alarm the user*/
        case SYSTEM_END_TIME:
            if(old_system_state_var_t == SYSTEM_HEATING_STATE)
            {
                /* turn off the heater */
                GPIO_WriteOnPin(HEATER_PORT , HEATER_PIN , LOW);
                /* Stop PWM to stop the fan */
                PWM_Stop(PWM_CHANNEL_1);
                /* update the old state with the current state */
                old_system_state_var_t = SYSTEM_END_TIME;
            }
        default:
            /* Do nothing*/
            break;
    }
}

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
void Door_Sensor_Task(void)
{
    /* flag to avoid Push button bouncing effect */
    static uint8 u8Debouncing_time = 0;
    /* check if the push button has been pressed */
    if(GPIO_ReadFromPin(GPIO_PORTB , GPIO_PIN4) == LOW)
    {
        /* check on de_bouncing flag to read the button after bouncing time to avoid bouncing effect */
        switch(u8Debouncing_time)
        {
            case 0:
                 u8Debouncing_time++;
                break;
            case 1:
                u8Debouncing_time++;
                break;
            case 2:        
                /* check on device states to move from state to another depend on user choices */
                switch(g_system_state_var_t)
                {
                    /* idle state that make user can select heating time, open door, put food
                     *  inside microwave and set suitable temperature from 27c to 77c */
                    case SYSTEM_IDLE_STATE:
                        /* change the state of door */
                        if(g_door_state_t == DOOR_IS_CLOSED)
                        {
                            g_door_state_t = DOOR_IS_OPENED;
                        }
                        else
                        {
                            g_door_state_t = DOOR_IS_CLOSED;
                        }
                        break;
                    /* the microwave is heating the food when the time is selected 
                     * and the door is closed and the food is inside the microwave */    
                    case SYSTEM_HEATING_STATE:
                        /* Do nothing */
                        break;
                    /* state after the heating process finished, in this state the system alarm the user*/
                    case SYSTEM_END_TIME:
                        /* change the state of door */
                        g_door_state_t = DOOR_IS_OPENED;
                        /* change the all system to idle state for new operation */
                        g_system_state_var_t = SYSTEM_IDLE_STATE;
                        break;
                    default:
                       /* Do nothing*/
                        break;
                }
                /* synchronize with LCD with this flag to display the change in door state */
                g_u8door_change_state_flag++;
                /* to prevent multi reading for the long press */
                u8Debouncing_time++;
                break;
            default:
                /* Do nothing */
                break;
        }
    }
    else
    {
        /* reset de_bouncing flag to a new press */
        u8Debouncing_time = 0;
    }
}

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
void Weight_Sensor_Task(void)
{
    /* flag to avoid Push button bouncing effect */
    static uint8 u8Debouncing_time = 0;
    /* check if the door is opened when the weight push button has been pressed */
    if(g_door_state_t == DOOR_IS_OPENED && GPIO_ReadFromPin(GPIO_PORTB , GPIO_PIN5) == LOW)
    {
        /* check on de_bouncing flag to read the button after bouncing time to avoid bouncing effect */
        switch(u8Debouncing_time)
        {
            case 0:
                u8Debouncing_time++;
                break;
            case 1:
                u8Debouncing_time++;
                break;
            case 2:
                /* check on device states to move from state to another depend on user choices */
                switch(g_system_state_var_t)
                {
                    /* idle state that make user select heating time, open door, put food
                     *  inside microwave and set suitable temperature from 27c to 77c */
                    case SYSTEM_IDLE_STATE:
                        /* change the state of door */
                        if(g_inside_microwave == MICROWAVE_IS_EMPTY)
                        {
                            g_inside_microwave = MICROWAVE_HAS_SOMETHING_INSIDE;
                        }
                        else
                        {
                            g_inside_microwave = MICROWAVE_IS_EMPTY;
                        }
                        break;
                    /* the microwave is heating the food when the time is selected 
                     * and the door is closed and the food is inside the microwave */    
                    case SYSTEM_HEATING_STATE:
                        /* Do nothing */
                        break;
                    /* state after the heating process finished, in this state the system alarm the user*/
                    case SYSTEM_END_TIME:
                        /* Do nothing */
                        break;
                    default:
                       /* Do nothing*/
                        break;
                }
                /* synchronize with LCD with this flag to display the change in inside state */
                g_u8weight_change_state_flag++;
                /* to prevent multi reading for the long press */
                u8Debouncing_time++;
                break;
            default:
                /* Do nothing */
                break;
        }
    }
    else
    {
        /* reset de_bouncing flag to a new press */
        u8Debouncing_time = 0;
    }
}

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
void LED_Buzzer_Task(void)
{
    /* counter to blank Buzzer */
    static uint16 u8counter = 0;
    /* check on device states to move from state to another depend on user choices */
    switch(g_system_state_var_t)
    {
        /* idle state that make user select heating time, open door, put food
         *  inside microwave and set suitable temperature from 27c to 77c */
        case SYSTEM_IDLE_STATE:
            u8counter = 0;
            /* turn off the Buzzer */
            GPIO_WriteOnPin(BUZZER_PORT , BUZZER_PIN , HIGH);
            break;
        /* the microwave is heating the food when the time is selected 
         * and the door is closed and the food is inside the microwave */    
        case SYSTEM_HEATING_STATE:
            /* turn on the LED */
            GPIO_WriteOnPin(LED_PORT , LED_PIN , HIGH);
            break;
        /* state after the heating process finished, in this state the system alarm the user*/
        case SYSTEM_END_TIME:    
            /* turn off the LED */
            GPIO_WriteOnPin(LED_PORT , LED_PIN , LOW);
            /* Blank the buzzer alarm */
            if(u8counter < 20)
            {
                u8counter++;
                /* turn on the Buzzer */
                GPIO_WriteOnPin(BUZZER_PORT , BUZZER_PIN , LOW);
            }
            else if(u8counter < 40)
            {
                u8counter++;
                /* turn off the Buzzer */
                GPIO_WriteOnPin(BUZZER_PORT , BUZZER_PIN , HIGH);
            }
            else
            {
                u8counter = 0;
            }
            break;
        default:
            /* Do nothing*/
            break;
    }
}

/*******************************************************************************
 * Function Name:	Reminding_time_Task
 *
 * Description: 	update reminding time for heating operation.
 *
 * Inputs:			NULL
 *
 * Outputs:			NULL
 *
 * Return:			NULL
 *******************************************************************************/
void Reminding_time_Task(void)
{
    /* check if the heating is in progress */
    if(g_system_state_var_t == SYSTEM_HEATING_STATE)
    {
        /* decrement timer counter */
        g_u16MicrowaveTime--;
        /* set flag to refer one second passed */
        g_u8heating_finished_flag = 1;
        /* check if heating time has passed */
        if (g_u16MicrowaveTime == 0)
        {
            g_system_state_var_t = SYSTEM_END_TIME;
        }
    }
}

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
void Welcome_screen_Task(void)
{
    /* Display Welcome Screen on LCD when the microwave starts */
    LCD_SetDisplayPosition(3,1);
    LCD_SendDataString("Welcome to");
    LCD_SetDisplayPosition(0,2);
    LCD_SendDataString("----------------");
    LCD_SetDisplayPosition(0,3);
    LCD_SendDataString("SWIFT ACT");
    LCD_SetDisplayPosition(7,4);
    LCD_SendDataString("MicroWave");
}

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
void Home_screen_display(void)
{
    /* Display home Screen on LCD after welcome message screen or at idle state of the system */
    LCD_ClearScreen();
    LCD_SendDataString("Time:");
    LCD_SetDisplayPosition(11,1);
    LCD_SendDataString("__:__");
    LCD_SetDisplayPosition(0,2);
    LCD_SendDataString("Temperature:");
    LCD_SetDisplayPosition(15,2);
    LCD_SendDataByte('c');
    /* display state of door sensor at start or when the heating is paused */
    LCD_SetDisplayPosition(0,3);
    if(g_door_state_t == DOOR_IS_CLOSED)
    {
        LCD_SendDataString("Door_St:  Closed");
    }
    else
    {
        LCD_SendDataString("Door_St:  Opened");
    }
    /* display state of weight sensor at start or when the heating is paused */
    LCD_SetDisplayPosition(0,4);
    if(g_inside_microwave == MICROWAVE_IS_EMPTY)
    {
        LCD_SendDataString("Inside_St:N_Food");
    }
    else
    {
        LCD_SendDataString("Inside_St:  Food");
    }
}

