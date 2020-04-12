# 1 "Tasks.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.10\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "Tasks.c" 2
# 17 "Tasks.c"
# 1 "./Tasks.h" 1
# 52 "./Tasks.h"
void initialization_Tasks(void);
# 65 "./Tasks.h"
extern void LCD_Task(void);
# 78 "./Tasks.h"
extern void KeyPad_Task(void);
# 91 "./Tasks.h"
extern void Temperature_Task (void);
# 104 "./Tasks.h"
extern void Door_Sensor_Task(void);
# 117 "./Tasks.h"
extern void Weight_Sensor_Task(void);
# 130 "./Tasks.h"
extern void LED_Buzzer_Task(void);
# 143 "./Tasks.h"
extern void Reminding_time_Task(void);
# 156 "./Tasks.h"
extern void Welcome_screen_Task(void);
# 170 "./Tasks.h"
extern void Home_screen_display(void);
# 17 "Tasks.c" 2

# 1 "./KeyPad.h" 1
# 21 "./KeyPad.h"
# 1 "./stdtypes.h" 1
# 52 "./stdtypes.h"
typedef unsigned char uint8;
typedef signed char sint8;
typedef unsigned short int uint16;
typedef signed short int sint16;
typedef unsigned long int uint32;
typedef signed long int sint32;
typedef unsigned long long int uint64;
typedef signed long long int sint64;
# 21 "./KeyPad.h" 2
# 38 "./KeyPad.h"
extern void KeyPad_Initialization(void);
# 51 "./KeyPad.h"
extern uint8 KeyPad_get_PressedKey_with_debouncing(void);
# 18 "Tasks.c" 2

# 1 "./scheduler.h" 1
# 21 "./scheduler.h"
# 1 "./scheduler_config.h" 1
# 21 "./scheduler.h" 2








typedef char TickTime;


typedef enum {
 ONCE,
 REPEAT
}EnumScheduler_RepeatedFunction_t;


typedef enum {
 SCHEDULER_NOT_AVAILABLE_TICK_TIME_ERROR,
    SCHEDULER_TASKS_QUEUE_IS_FULL_ERROR,
    SCHEDULER_ID_IS_NOT_EXIST_ERROR,
    SCHEDULER_NO_ERROR
}EnumScheduler_Error_t;
# 60 "./scheduler.h"
extern EnumScheduler_Error_t Scheduler_Initialization(TickTime a_u8tickTme);
# 77 "./scheduler.h"
extern EnumScheduler_Error_t Scheduler_StartFunction(void (*task_function_ptr) (void),
        uint8 a_u8task_ID , uint16 a_u16task_periodicity , uint16 a_u16task_start_time ,
                                            EnumScheduler_RepeatedFunction_t a_RepeatType_t);
# 92 "./scheduler.h"
extern EnumScheduler_Error_t Scheduler_StopFunction(uint8 a_u8_task_ID);
# 105 "./scheduler.h"
extern void Scheduler_Dispatcher(void);
# 19 "Tasks.c" 2

# 1 "./GPIO.h" 1
# 46 "./GPIO.h"
typedef enum {
    GPIO_CORRECT_SET,
    GPIO_UNCORRECT_SET
}EnumGPIO_Status_t;
# 68 "./GPIO.h"
extern EnumGPIO_Status_t GPIO_SetPinDirection(uint8 a_u8port , uint8 a_u8pin , uint8 a_u8direction);
# 82 "./GPIO.h"
extern EnumGPIO_Status_t GPIO_SetPortDirection(uint8 a_u8port , uint8 a_u8direction);
# 97 "./GPIO.h"
extern EnumGPIO_Status_t GPIO_WriteOnPin(uint8 a_u8port , uint8 a_u8pin , uint8 a_u8value);
# 111 "./GPIO.h"
extern EnumGPIO_Status_t GPIO_WriteOnPort(uint8 a_u8port , uint8 a_u8value);
# 125 "./GPIO.h"
extern uint8 GPIO_ReadFromPin(uint8 a_u8port , uint8 a_u8pin);
# 138 "./GPIO.h"
extern uint8 GPIO_ReadFromPort(uint8 a_u8port);
# 152 "./GPIO.h"
extern EnumGPIO_Status_t GPIO_TogglePin(uint8 a_u8port , uint8 a_u8pin);
# 165 "./GPIO.h"
extern EnumGPIO_Status_t GPIO_TogglePort(uint8 a_u8port);
# 178 "./GPIO.h"
extern void GPIO_Disable_Comparator_On_PORTA(void);
# 192 "./GPIO.h"
extern EnumGPIO_Status_t GPIO_Disable_ADC_On_Pins(uint8 a_u8port , uint8 a_u8pin);
# 205 "./GPIO.h"
extern void GPIO_Enable_Pull_Up_On_PortB(void);
# 218 "./GPIO.h"
extern void GPIO_Disable_Pull_Up_On_PortB(void);
# 20 "Tasks.c" 2

# 1 "./LCD.h" 1
# 22 "./LCD.h"
# 1 "./LCD_config.h" 1
# 22 "./LCD.h" 2
# 62 "./LCD.h"
extern void LCD_Initialization (void);
# 75 "./LCD.h"
extern void LCD_SendCommand(uint8 a_u8command);
# 88 "./LCD.h"
extern void LCD_SendDataByte(uint8 a_u8data);
# 101 "./LCD.h"
extern void LCD_SendDataString(uint8* a_u8data_ptr);
# 115 "./LCD.h"
extern void LCD_SetDisplayPosition(uint8 a_u8position_X , uint8 a_u8position_Y);
# 131 "./LCD.h"
extern void LCD_SetUserCharacter(uint8* a_u8arr_ptr , uint8 a_u8size , uint8 a_u8position_X , uint8 a_u8position_Y);
# 145 "./LCD.h"
extern void LCD_DisplaNumber(sint32 a_s32number);
# 159 "./LCD.h"
extern void LCD_ClearScreen(void);
# 21 "Tasks.c" 2

# 1 "./PWM.h" 1
# 22 "./PWM.h"
# 1 "./PWM_config.h" 1
# 22 "./PWM.h" 2







typedef enum{
    PWM_CHANNEL_1,
    PWM_CHANNEL_2
}EnumPWM_channel_t;
# 51 "./PWM.h"
extern void PWM_Initialization(EnumPWM_channel_t a_PWM_channel_t);
# 65 "./PWM.h"
extern void PWM_Start(EnumPWM_channel_t a_PWM_channel_t);
# 79 "./PWM.h"
extern void PWM_Stop(EnumPWM_channel_t a_PWM_channel_t);
# 92 "./PWM.h"
extern void PWM_Frequency(uint32 a_u32PWM_frequency);
# 107 "./PWM.h"
extern void PWM_DutyCycle(EnumPWM_channel_t a_PWM_channel_t , uint8 a_u16PWM_duty_cycle);
# 22 "Tasks.c" 2

# 1 "./timers.h" 1
# 21 "./timers.h"
# 1 "./timers_config.h" 1
# 21 "./timers.h" 2
# 31 "./timers.h"
typedef enum{
            TIMER_8BIT_SIZE,
            TIMER_16BIT_SIZE
}EnumTimer_regesterSize_t;


typedef enum{
            TIMER_INTERNAL_CLOCK,
            TIMER_TRANSITION_ON_TCKI_PIN
}EnumTimer_clockSource_t;







typedef enum{
            TIMER0_PRESCALER_2,
            TIMER0_PRESCALER_4,
            TIMER0_PRESCALER_8,
            TIMER0_PRESCALER_16,
            TIMER0_PRESCALER_32,
            TIMER0_PRESCALER_64,
            TIMER0_PRESCALER_128,
            TIMER0_PRESCALER_256,
            TIMER0_NO_PRESCALER
}EnumTimer0_prescaler_t;


typedef enum{
            TIMER0_RISING_EDGE_CLOCK_ON_TCKI,
            TIMER0_FALLING_EDGE_CLOCK_ON_TCKI,
            TIMER0_NO_TRANSITION_ON_TCKI
}EnumTimer0_edgeTypeOn_TCKI_t;


typedef struct{
            EnumTimer0_prescaler_t timer_prescaler_t;
            EnumTimer_regesterSize_t timer_size_t;
            EnumTimer_clockSource_t timer_clock_source_t;
            EnumTimer0_edgeTypeOn_TCKI_t timer_edge_type_on_TCKI_t;
}StrTimer0_config_t;





extern StrTimer0_config_t Timer0_config_t;
# 98 "./timers.h"
extern void Timer0_Initialization(void);
# 111 "./timers.h"
extern void Timer0_enable(void);
# 124 "./timers.h"
extern void Timer0_disable(void);
# 137 "./timers.h"
extern uint16 Timer0_read_counter(void);
# 151 "./timers.h"
extern void Timer0_write_counter(uint16 a_u16init_value_for_timer);
# 350 "./timers.h"
typedef enum{
            TIMER2_NO_PRESCALER,
            TIMER2_PRESCALER_4,
            TIMER2_PRESCALER_16
}EnumTimer2_prescaler_t;


typedef enum{
            TIMER2_POSTSCALER_1,
            TIMER2_POSTSCALER_2,
            TIMER2_POSTSCALER_3,
            TIMER2_POSTSCALER_4,
            TIMER2_POSTSCALER_5,
            TIMER2_POSTSCALER_6,
            TIMER2_POSTSCALER_7,
            TIMER2_POSTSCALER_8,
            TIMER2_POSTSCALER_9,
            TIMER2_POSTSCALER_10,
            TIMER2_POSTSCALER_11,
            TIMER2_POSTSCALER_12,
            TIMER2_POSTSCALER_13,
            TIMER2_POSTSCALER_14,
            TIMER2_POSTSCALER_15,
            TIMER2_POSTSCALER_16
}EnumTimer2_postscaler_t;


typedef struct{
            EnumTimer2_prescaler_t timer_prescaler_t;
            EnumTimer2_postscaler_t timer_postscaler_t;
}StrTimer2_config_t;





extern StrTimer2_config_t Timer2_config_t;
# 404 "./timers.h"
extern void Timer2_Initialization(void);
# 417 "./timers.h"
extern void Timer2_enable(void);
# 430 "./timers.h"
extern void Timer2_disable(void);
# 443 "./timers.h"
extern uint8 Timer2_read_counter(void);
# 457 "./timers.h"
extern void Timer2_write_counter(uint8 a_u8init_value_for_timer);
# 471 "./timers.h"
extern uint8 Timer2_read_period_register(void);
# 484 "./timers.h"
extern void Timer2_write_period_register(uint8 a_u8init_value_for_period_register);
# 23 "Tasks.c" 2

# 1 "./interrupt.h" 1
# 22 "./interrupt.h"
# 1 "./interrupt_config.h" 1
# 22 "./interrupt.h" 2
# 44 "./interrupt.h"
extern void Global_interrupt_enable(void);
# 57 "./interrupt.h"
extern void Global_interrupt_disable(void);
# 71 "./interrupt.h"
extern void Peripherals_interrupt_enable(void);
# 85 "./interrupt.h"
extern void Peripherals_interrupt_disable(void);
# 242 "./interrupt.h"
extern void Timer0_enable_overflow_interrupt(void);
# 255 "./interrupt.h"
extern void Timer0_disable_overflow_interrupt(void);
# 268 "./interrupt.h"
extern void Timer0_set_callback_function(void(*a_function_ptr)(void));
# 24 "Tasks.c" 2

# 1 "./ADC.h" 1
# 29 "./ADC.h"
typedef enum{
    ADC_CHANNEL_0,
    ADC_CHANNEL_1,
    ADC_CHANNEL_2,
    ADC_CHANNEL_3,
    ADC_CHANNEL_4,
    ADC_CHANNEL_5,
    ADC_CHANNEL_6,
    ADC_CHANNEL_7,
    ADC_CHANNEL_8,
    ADC_CHANNEL_9,
    ADC_CHANNEL_10,
    ADC_CHANNEL_11,
    ADC_CHANNEL_12
}EnumADC_channels_t;


typedef enum{
    ADC_ACQUISITION_TIME_0,
    ADC_ACQUISITION_TIME_2,
    ADC_ACQUISITION_TIME_4,
    ADC_ACQUISITION_TIME_6,
    ADC_ACQUISITION_TIME_8,
    ADC_ACQUISITION_TIME_12,
    ADC_ACQUISITION_TIME_16,
    ADC_ACQUISITION_TIME_20
}EnumADC_acquisition_Time_t;


typedef enum{
    ADC_PRESCALER_2,
    ADC_PRESCALER_8,
    ADC_PRESCALER_32,
    ADC_OSCILLATOR_CLOCK,
    ADC_PRESCALER_4,
    ADC_PRESCALER_16,
    ADC_PRESCALER_64
}EnumADC_prescaler_t;


typedef enum{
    ADC_RESULT_LEFT_JUSTIFIED,
    ADC_RESULT_RIGHT_JUSTIFIED
}EnumADC_result_format_t;


typedef enum{
    ADC_V_REF_HIGH,
    ADC_V_REF_LOW
}EnumADC_Vref_type_t;


typedef enum{
    ADC_V_REF_INPUT_PIN,
    ADC_V_REF_DEFAULT_VALUE
}EnumADC_Vref_value_t;
# 102 "./ADC.h"
extern void ADC_Initialization(EnumADC_channels_t a_ADC_channel_t);
# 117 "./ADC.h"
extern void ADC_Select_acquisition_time(EnumADC_acquisition_Time_t a_ADC_acquisition_Time_t);
# 132 "./ADC.h"
extern void ADC_Select_prescaler(EnumADC_prescaler_t a_ADC_prescaler_t);
# 145 "./ADC.h"
extern uint16 ADC_Read_value(void);
# 158 "./ADC.h"
extern void ADC_Start_conversion(void);
# 171 "./ADC.h"
extern void ADC_Disable(void);
# 186 "./ADC.h"
extern void ADC_Set_result_format(EnumADC_result_format_t a_ADC_result_format_t);
# 204 "./ADC.h"
extern void ADC_Set_Vref(EnumADC_Vref_type_t a_ADC_Vref_type_t , EnumADC_Vref_value_t a_ADC_Vref_value_t);
# 25 "Tasks.c" 2






typedef enum {
            SYSTEM_IDLE_STATE,
            SYSTEM_HEATING_STATE,
            SYSTEM_END_TIME
}EnumSystem_states_t;


typedef enum{
            DOOR_IS_OPENED,
            DOOR_IS_CLOSED
}EnumDoor_sensor_t;


typedef enum{
            MICROWAVE_IS_EMPTY,
            MICROWAVE_HAS_SOMETHING_INSIDE
}EnumWeight_sensor_t;





static uint16 g_u16MicrowaveTime = 0;

static EnumSystem_states_t g_system_state_var_t = SYSTEM_IDLE_STATE;

static uint8 g_u8heating_finished_flag = 0;

static EnumDoor_sensor_t g_door_state_t = DOOR_IS_CLOSED;

static EnumWeight_sensor_t g_inside_microwave = MICROWAVE_IS_EMPTY;

static uint8 g_u8timer_arr[6] = {0x30 , 0x30 , ':' , 0x30 , 0x30 , '\0'};

static uint8 g_u8time_digits = 0;

static uint8 g_u8keypad_button_val = '_';

static uint8 g_u8temperature = 0;

static uint8 g_u8old_temp_reading = 100;

static uint8 g_u8door_change_state_flag = 0;

static uint8 g_u8weight_change_state_flag = 0;
# 92 "Tasks.c"
static void Display_finishing_message(void)
{

    static uint16 u8counter = 0;

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
# 142 "Tasks.c"
static void Display_reminding_time (void)
{

    if(g_u8heating_finished_flag == 1)
    {

        LCD_SetDisplayPosition(11,1);
        LCD_SendDataByte((g_u16MicrowaveTime / 600) + 0x30);
        LCD_SendDataByte(((g_u16MicrowaveTime / 60) % 10) + 0x30);
        LCD_SendDataByte(':');
        LCD_SendDataByte(((g_u16MicrowaveTime % 60) / 10) + 0x30);
        LCD_SendDataByte(((g_u16MicrowaveTime % 60) % 10) + 0x30);

        g_u8heating_finished_flag = 0;
    }
}
# 170 "Tasks.c"
static void Get_and_Set_desired_temp(void)
{

    ADC_Start_conversion();

    g_u8temperature = ADC_Read_value() * 50u / 1023;

    if(g_u8old_temp_reading != g_u8temperature)
    {

        PWM_DutyCycle(PWM_CHANNEL_1 , 100 - g_u8temperature * 2);

        g_u8old_temp_reading = g_u8temperature;
    }
    else
    {

    }
}
# 205 "Tasks.c"
void initialization_Tasks(void)
{

    Scheduler_StartFunction(Welcome_screen_Task , 1 , 2000 , 0 , ONCE);


    Scheduler_StartFunction(Home_screen_display , 1 , 5 , 2000 , ONCE);

    Scheduler_StartFunction(Reminding_time_Task , 1 , 1000 , 2020 , REPEAT);

    Scheduler_StartFunction(KeyPad_Task , 2 , 30 , 2021 , REPEAT);

    Scheduler_StartFunction(Weight_Sensor_Task , 3 , 30 , 2024 , REPEAT);

    Scheduler_StartFunction(Door_Sensor_Task , 4 , 30 , 2025 , REPEAT);

    Scheduler_StartFunction(Temperature_Task , 5 , 30 , 2026 , REPEAT);

    Scheduler_StartFunction(LED_Buzzer_Task , 6 , 30 , 2027 , REPEAT);

    Scheduler_StartFunction(LCD_Task , 7 , 30 , 2028 , REPEAT);

}
# 240 "Tasks.c"
void LCD_Task(void)
{GPIO_WriteOnPin(2u , 7u , 1u);

    static EnumSystem_states_t old_system_state_var_t = SYSTEM_IDLE_STATE;

    switch(g_system_state_var_t)
    {


        case SYSTEM_IDLE_STATE:

            if(old_system_state_var_t == SYSTEM_HEATING_STATE)
            {

                LCD_SetDisplayPosition(0,3);
                LCD_SendDataString("Door_St:  Closed");
                LCD_SetDisplayPosition(0,4);
                LCD_SendDataString("Inside_St:  Food");

                old_system_state_var_t = SYSTEM_IDLE_STATE;

                g_u8keypad_button_val = '_';
            }

            else if(old_system_state_var_t == SYSTEM_END_TIME)
            {

                Home_screen_display();

                old_system_state_var_t = SYSTEM_IDLE_STATE;

                g_u8keypad_button_val = '_';
            }
            else
            {

                LCD_SetDisplayPosition(13,2);

                LCD_DisplaNumber(g_u8temperature + 27u);

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

                    g_u8door_change_state_flag = 0;
                }

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

                    g_u8weight_change_state_flag = 0;
                }

                if(g_u8keypad_button_val >= 0 && g_u8keypad_button_val < 10 && g_u8time_digits < 5)
                {

                    LCD_SetDisplayPosition(11,1);
                    LCD_SendDataString(g_u8timer_arr);

                    g_u8keypad_button_val = '_';
                 }

                else if(g_u8keypad_button_val == '#')
                {

                    LCD_SetDisplayPosition(4,1);
                    LCD_SendDataString(": ");
                    LCD_SetDisplayPosition(11,1);
                    LCD_SendDataString("__:__");

                    g_u8keypad_button_val = '_';
                }
            }
            break;


        case SYSTEM_HEATING_STATE:
            if(old_system_state_var_t == SYSTEM_IDLE_STATE)
            {

                LCD_SetDisplayPosition(4,1);
                LCD_SendDataString("r:");
                LCD_SetDisplayPosition(0,3);

                LCD_SendDataString("Heating Process ");
                LCD_SendDataString("#:Pause ##:Stop ");

                old_system_state_var_t = SYSTEM_HEATING_STATE;

                g_u8keypad_button_val = '_';
            }

            LCD_SetDisplayPosition(13,2);

            LCD_DisplaNumber(g_u8temperature + 27u);

            Display_reminding_time();
            break;

        case SYSTEM_END_TIME:

            if(old_system_state_var_t == SYSTEM_HEATING_STATE)
            {
                LCD_ClearScreen();

                old_system_state_var_t = SYSTEM_END_TIME;
            }

            Display_finishing_message();
            break;
        default:

            break;
    }
GPIO_WriteOnPin(2u , 7u , 0u);}
# 386 "Tasks.c"
void KeyPad_Task(void)
{

    uint8 u8pressed_key = '_';

    static EnumSystem_states_t old_system_state_var_t = SYSTEM_IDLE_STATE;

    switch(g_system_state_var_t)
    {


        case SYSTEM_IDLE_STATE:

            if(old_system_state_var_t == SYSTEM_END_TIME)
            {

                g_u8timer_arr[0] = 0x30;
                g_u8timer_arr[1] = 0x30;
                g_u8timer_arr[3] = 0x30;
                g_u8timer_arr[4] = 0x30;

                g_u8time_digits = 0;

                old_system_state_var_t = SYSTEM_IDLE_STATE;
            }

            u8pressed_key = KeyPad_get_PressedKey_with_debouncing();

            if(u8pressed_key >= 0 && u8pressed_key < 10)
            {

                g_u8keypad_button_val = u8pressed_key;

                switch(g_u8time_digits)
                {
                    case 0:

                        g_u8timer_arr[4] = g_u8keypad_button_val + 0x30;

                        if(g_u8keypad_button_val != 0)
                        {

                            g_u8time_digits++;
                        }

                        g_u16MicrowaveTime = g_u8keypad_button_val;
                        break;
                    case 1:

                        g_u8timer_arr[3] = g_u8timer_arr[4];

                        g_u8timer_arr[4] = g_u8keypad_button_val + 0x30;

                        g_u8time_digits++;

                        g_u16MicrowaveTime = g_u16MicrowaveTime * 10 + g_u8keypad_button_val;
                        break;
                    case 2:

                        g_u8timer_arr[1] = g_u8timer_arr[3];

                        g_u8timer_arr[3] = g_u8timer_arr[4];

                        g_u8timer_arr[4] = g_u8keypad_button_val + 0x30;

                        g_u8time_digits++;

                        g_u16MicrowaveTime = (g_u8timer_arr[1] - 0x30) * 60 +
                                (g_u8timer_arr[3] - 0x30) * 10 + g_u8keypad_button_val;
                        break;
                    case 3:

                        if(!(g_u8timer_arr[1] == 57 && g_u8timer_arr[3] == 57 && g_u8timer_arr[4] >= 54 ))
                        {

                            g_u8timer_arr[0] = g_u8timer_arr[1];

                            g_u8timer_arr[1] = g_u8timer_arr[3];

                            g_u8timer_arr[3] = g_u8timer_arr[4];

                            g_u8timer_arr[4] = g_u8keypad_button_val + 0x30;

                            g_u8time_digits++;

                            g_u16MicrowaveTime = (g_u8timer_arr[0] - 0x30) * 600 +
                                    (g_u8timer_arr[1] - 0x30) * 60 +
                                    (g_u8timer_arr[3] - 0x30) * 10 + g_u8keypad_button_val;
                        }
                        else
                        {

                        }
                        break;
                    default:

                        break;
                }
            }

            else if(u8pressed_key == '*')
            {

                g_u8keypad_button_val = u8pressed_key;


                if(g_u16MicrowaveTime != 0 && g_door_state_t == DOOR_IS_CLOSED && g_inside_microwave == MICROWAVE_HAS_SOMETHING_INSIDE)
                {

                    g_u8time_digits = 5;

                    g_system_state_var_t = SYSTEM_HEATING_STATE;
                }
                else
                {

                }
            }

            else if(u8pressed_key == '#')
            {

                g_u8keypad_button_val = u8pressed_key;

                g_u8timer_arr[0] = 0x30;
                g_u8timer_arr[1] = 0x30;
                g_u8timer_arr[3] = 0x30;
                g_u8timer_arr[4] = 0x30;

                g_u8time_digits = 0;

                g_u16MicrowaveTime = 0;
            }
            break;


        case SYSTEM_HEATING_STATE:

            u8pressed_key = KeyPad_get_PressedKey_with_debouncing();

            if(u8pressed_key == '#')
            {

                g_u8keypad_button_val = u8pressed_key;


                g_system_state_var_t = SYSTEM_IDLE_STATE;
            }
            break;

        case SYSTEM_END_TIME:

            old_system_state_var_t = SYSTEM_END_TIME;

            u8pressed_key = KeyPad_get_PressedKey_with_debouncing();


            if(u8pressed_key == '#')
            {

                g_u8keypad_button_val = u8pressed_key;

                g_system_state_var_t = SYSTEM_IDLE_STATE;
            }
            break;
        default:

            break;
    }
}
# 568 "Tasks.c"
void Temperature_Task (void)
{
    static EnumSystem_states_t old_system_state_var_t = SYSTEM_IDLE_STATE;

    switch(g_system_state_var_t)
    {


        case SYSTEM_IDLE_STATE:
            if(old_system_state_var_t == SYSTEM_HEATING_STATE)
            {

                GPIO_WriteOnPin(2u , 5u , 0u);

                PWM_Stop(PWM_CHANNEL_1);

                old_system_state_var_t = SYSTEM_IDLE_STATE;
            }
            else if(old_system_state_var_t == SYSTEM_END_TIME)
            {

                g_u8old_temp_reading = 100;

                old_system_state_var_t = SYSTEM_IDLE_STATE;
            }


            Get_and_Set_desired_temp();
            break;


        case SYSTEM_HEATING_STATE:

            if(old_system_state_var_t == SYSTEM_IDLE_STATE)
            {

                PWM_Start(PWM_CHANNEL_1);

                GPIO_WriteOnPin(2u , 5u , 1u);

                old_system_state_var_t = SYSTEM_HEATING_STATE;
            }


            Get_and_Set_desired_temp();
            break;

        case SYSTEM_END_TIME:
            if(old_system_state_var_t == SYSTEM_HEATING_STATE)
            {

                GPIO_WriteOnPin(2u , 5u , 0u);

                PWM_Stop(PWM_CHANNEL_1);

                old_system_state_var_t = SYSTEM_END_TIME;
            }
        default:

            break;
    }
}
# 642 "Tasks.c"
void Door_Sensor_Task(void)
{

    static uint8 u8Debouncing_time = 0;

    if(GPIO_ReadFromPin(1u , 4u) == 0u)
    {

        switch(u8Debouncing_time)
        {
            case 0:
                 u8Debouncing_time++;
                break;
            case 1:
                u8Debouncing_time++;
                break;
            case 2:

                switch(g_system_state_var_t)
                {


                    case SYSTEM_IDLE_STATE:

                        if(g_door_state_t == DOOR_IS_CLOSED)
                        {
                            g_door_state_t = DOOR_IS_OPENED;
                        }
                        else
                        {
                            g_door_state_t = DOOR_IS_CLOSED;
                        }
                        break;


                    case SYSTEM_HEATING_STATE:

                        break;

                    case SYSTEM_END_TIME:

                        g_door_state_t = DOOR_IS_OPENED;

                        g_system_state_var_t = SYSTEM_IDLE_STATE;
                        break;
                    default:

                        break;
                }

                g_u8door_change_state_flag++;

                u8Debouncing_time++;
                break;
            default:

                break;
        }
    }
    else
    {

        u8Debouncing_time = 0;
    }
}
# 719 "Tasks.c"
void Weight_Sensor_Task(void)
{

    static uint8 u8Debouncing_time = 0;

    if(g_door_state_t == DOOR_IS_OPENED && GPIO_ReadFromPin(1u , 5u) == 0u)
    {

        switch(u8Debouncing_time)
        {
            case 0:
                u8Debouncing_time++;
                break;
            case 1:
                u8Debouncing_time++;
                break;
            case 2:

                switch(g_system_state_var_t)
                {


                    case SYSTEM_IDLE_STATE:

                        if(g_inside_microwave == MICROWAVE_IS_EMPTY)
                        {
                            g_inside_microwave = MICROWAVE_HAS_SOMETHING_INSIDE;
                        }
                        else
                        {
                            g_inside_microwave = MICROWAVE_IS_EMPTY;
                        }
                        break;


                    case SYSTEM_HEATING_STATE:

                        break;

                    case SYSTEM_END_TIME:

                        break;
                    default:

                        break;
                }

                g_u8weight_change_state_flag++;

                u8Debouncing_time++;
                break;
            default:

                break;
        }
    }
    else
    {

        u8Debouncing_time = 0;
    }
}
# 793 "Tasks.c"
void LED_Buzzer_Task(void)
{

    static uint16 u8counter = 0;

    switch(g_system_state_var_t)
    {


        case SYSTEM_IDLE_STATE:
            u8counter = 0;

            GPIO_WriteOnPin(2u , 1u , 1u);
            break;


        case SYSTEM_HEATING_STATE:

            GPIO_WriteOnPin(1u , 7u , 1u);
            break;

        case SYSTEM_END_TIME:

            GPIO_WriteOnPin(1u , 7u , 0u);

            if(u8counter < 20)
            {
                u8counter++;

                GPIO_WriteOnPin(2u , 1u , 0u);
            }
            else if(u8counter < 40)
            {
                u8counter++;

                GPIO_WriteOnPin(2u , 1u , 1u);
            }
            else
            {
                u8counter = 0;
            }
            break;
        default:

            break;
    }
}
# 852 "Tasks.c"
void Reminding_time_Task(void)
{

    if(g_system_state_var_t == SYSTEM_HEATING_STATE)
    {

        g_u16MicrowaveTime--;

        g_u8heating_finished_flag = 1;

        if (g_u16MicrowaveTime == 0)
        {
            g_system_state_var_t = SYSTEM_END_TIME;
        }
    }
}
# 880 "Tasks.c"
void Welcome_screen_Task(void)
{

    LCD_SetDisplayPosition(3,1);
    LCD_SendDataString("Welcome to");
    LCD_SetDisplayPosition(0,2);
    LCD_SendDataString("----------------");
    LCD_SetDisplayPosition(0,3);
    LCD_SendDataString("SWIFT ACT");
    LCD_SetDisplayPosition(7,4);
    LCD_SendDataString("MicroWave");
}
# 905 "Tasks.c"
void Home_screen_display(void)
{

    LCD_ClearScreen();
    LCD_SendDataString("Time:");
    LCD_SetDisplayPosition(11,1);
    LCD_SendDataString("__:__");
    LCD_SetDisplayPosition(0,2);
    LCD_SendDataString("Temperature:");
    LCD_SetDisplayPosition(15,2);
    LCD_SendDataByte('c');

    LCD_SetDisplayPosition(0,3);
    if(g_door_state_t == DOOR_IS_CLOSED)
    {
        LCD_SendDataString("Door_St:  Closed");
    }
    else
    {
        LCD_SendDataString("Door_St:  Opened");
    }

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
