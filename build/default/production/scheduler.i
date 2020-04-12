# 1 "scheduler.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.10\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "scheduler.c" 2
# 16 "scheduler.c"
# 1 "./scheduler.h" 1
# 21 "./scheduler.h"
# 1 "./scheduler_config.h" 1
# 21 "./scheduler.h" 2

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
# 22 "./scheduler.h" 2







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
# 16 "scheduler.c" 2

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
# 17 "scheduler.c" 2

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
# 18 "scheduler.c" 2

# 1 "./CPU_sleep.h" 1
# 33 "./CPU_sleep.h"
extern void CPU_sleep(void);
# 19 "scheduler.c" 2






typedef enum {
 READY,
 RUNNING,
 WAITING
}EnumScheduler_Status_t;


typedef struct {
 uint8 Task_ID;
 uint16 Task_ExecutionTime;
 uint16 Task_Periodicity;
 EnumScheduler_RepeatedFunction_t Task_RepeatType;
 EnumScheduler_Status_t Task_State;
 void (*Task_Function)(void);
}StructScheduler_Object_t;





volatile static uint16 g_u16_TickTimeCounter = 0;

static StructScheduler_Object_t Scheduler_Tasks[10u];

uint32 u32compare_value;
# 71 "scheduler.c"
static void Scheduler_Core(void)
{

 g_u16_TickTimeCounter++;

    Timer0_write_counter(65535u - u32compare_value);

 for(uint16 Counter = 0 ; Counter < 10u ; Counter++)
 {

  if((Scheduler_Tasks[Counter].Task_ExecutionTime == g_u16_TickTimeCounter)
    && Scheduler_Tasks[Counter].Task_ID != 0 )
  {

   Scheduler_Tasks[Counter].Task_State = READY;

            Scheduler_Tasks[Counter].Task_ExecutionTime += Scheduler_Tasks[Counter].Task_Periodicity;
  }
  else
  {

  }
 }
}
# 108 "scheduler.c"
static EnumScheduler_Error_t Scheduler_Tick_time_calculation(TickTime a_u8tickTme)
{

    EnumScheduler_Error_t tick_calculation_t = SCHEDULER_NO_ERROR;

    u32compare_value = (8000000u / 4000) * a_u8tickTme;

    if(u32compare_value < 65535u)
    {
        Timer0_config_t.timer_prescaler_t = TIMER0_NO_PRESCALER;

        Timer0_Initialization();
        tick_calculation_t = SCHEDULER_NO_ERROR;
    }
    else if (u32compare_value / 2 < 65535u)
    {
        Timer0_config_t.timer_prescaler_t = TIMER0_PRESCALER_2;
        u32compare_value /= 2;

        Timer0_Initialization();
        tick_calculation_t = SCHEDULER_NO_ERROR;
    }
    else if (u32compare_value / 4 < 65535u)
    {
        Timer0_config_t.timer_prescaler_t = TIMER0_PRESCALER_4;
        u32compare_value /= 4;

        Timer0_Initialization();
        tick_calculation_t = SCHEDULER_NO_ERROR;
    }
    else if (u32compare_value / 8 < 65535u)
    {
        Timer0_config_t.timer_prescaler_t = TIMER0_PRESCALER_8;
        u32compare_value /= 8;

        Timer0_Initialization();
        tick_calculation_t = SCHEDULER_NO_ERROR;
    }
    else if (u32compare_value / 16 < 65535u)
    {
        Timer0_config_t.timer_prescaler_t = TIMER0_PRESCALER_16;
        u32compare_value /= 16;

        Timer0_Initialization();
        tick_calculation_t = SCHEDULER_NO_ERROR;
    }
    else if (u32compare_value / 32 < 65535u)
    {
        Timer0_config_t.timer_prescaler_t = TIMER0_PRESCALER_32;
        u32compare_value /= 32;

        Timer0_Initialization();
        tick_calculation_t = SCHEDULER_NO_ERROR;
    }
    else if (u32compare_value / 64 < 65535u)
    {
        Timer0_config_t.timer_prescaler_t = TIMER0_PRESCALER_64;
        u32compare_value /= 64;

        Timer0_Initialization();
        tick_calculation_t = SCHEDULER_NO_ERROR;
    }
    else if (u32compare_value / 128 < 65535u)
    {
        Timer0_config_t.timer_prescaler_t = TIMER0_PRESCALER_128;
        u32compare_value /= 128;

        Timer0_Initialization();
        tick_calculation_t = SCHEDULER_NO_ERROR;
    }
    else if (u32compare_value / 256 < 65535u)
    {
        Timer0_config_t.timer_prescaler_t = TIMER0_PRESCALER_256;
        u32compare_value /= 256;

        Timer0_Initialization();
        tick_calculation_t = SCHEDULER_NO_ERROR;
    }
    else
    {
        tick_calculation_t = SCHEDULER_NOT_AVAILABLE_TICK_TIME_ERROR;
    }
    return tick_calculation_t;
}
# 207 "scheduler.c"
EnumScheduler_Error_t Scheduler_Initialization(TickTime a_u8tickTme)
{

    EnumScheduler_Error_t initialization_error_t = SCHEDULER_NO_ERROR;

    initialization_error_t = Scheduler_Tick_time_calculation(a_u8tickTme);

    if(initialization_error_t == SCHEDULER_NO_ERROR)
    {

        Timer0_set_callback_function(Scheduler_Core);

        Global_interrupt_enable();

        for(uint16 Counter = 0 ; Counter < 10u ; Counter++)
        {
            Scheduler_Tasks[Counter].Task_ID = 0;
            Scheduler_Tasks[Counter].Task_Periodicity = 0;
            Scheduler_Tasks[Counter].Task_RepeatType = ONCE;
            Scheduler_Tasks[Counter].Task_ExecutionTime = 0;
            Scheduler_Tasks[Counter].Task_State = WAITING;
            Scheduler_Tasks[Counter].Task_Function = (void*)0x00;
        }

        Timer0_enable();
    }
    else
    {
        initialization_error_t = SCHEDULER_NOT_AVAILABLE_TICK_TIME_ERROR;
    }
    return initialization_error_t;
}
# 255 "scheduler.c"
EnumScheduler_Error_t Scheduler_StartFunction(void (*task_function_ptr) (void), uint8 a_u8_task_ID ,
  uint16 a_u16_task_periodicity , uint16 a_u16_task_start_time ,
        EnumScheduler_RepeatedFunction_t Enum_Task_RepeatType)
{

    EnumScheduler_Error_t starting_task_error = SCHEDULER_NO_ERROR;

 Timer0_enable_overflow_interrupt();

 for(uint16 Counter = 0 ; Counter < 10u ; Counter++)
 {
  if(Scheduler_Tasks[Counter].Task_ID == 0)
  {
   Scheduler_Tasks[Counter].Task_ID = a_u8_task_ID;
   Scheduler_Tasks[Counter].Task_Periodicity = a_u16_task_periodicity;
   Scheduler_Tasks[Counter].Task_RepeatType = Enum_Task_RepeatType;
   Scheduler_Tasks[Counter].Task_ExecutionTime = a_u16_task_start_time + g_u16_TickTimeCounter + 1;
   Scheduler_Tasks[Counter].Task_State = WAITING;
   Scheduler_Tasks[Counter].Task_Function = task_function_ptr;
            starting_task_error = SCHEDULER_NO_ERROR;
   break;
  }
  else
  {
   starting_task_error = SCHEDULER_TASKS_QUEUE_IS_FULL_ERROR;
  }
 }
    return starting_task_error;
}
# 296 "scheduler.c"
EnumScheduler_Error_t Scheduler_StopFunction(uint8 a_u8_task_ID)
{

    EnumScheduler_Error_t stoping_task_error = SCHEDULER_NO_ERROR;

 for(uint16 Counter=0;Counter<10u;Counter++)
 {
  if(Scheduler_Tasks[Counter].Task_ID == a_u8_task_ID)
  {
   Scheduler_Tasks[Counter].Task_ID = 0;
   Scheduler_Tasks[Counter].Task_Periodicity = 0;
   Scheduler_Tasks[Counter].Task_RepeatType = ONCE;
   Scheduler_Tasks[Counter].Task_ExecutionTime = 0;
   Scheduler_Tasks[Counter].Task_State = WAITING;
   Scheduler_Tasks[Counter].Task_Function = (void*)0x00;
            stoping_task_error = SCHEDULER_NO_ERROR;
   break;
  }
  else
  {
   stoping_task_error = SCHEDULER_ID_IS_NOT_EXIST_ERROR;
  }
 }

 uint16 Counter = 0 ;

 for(; Counter < 10u ; Counter++)
 {
  if(Scheduler_Tasks[Counter].Task_ID != 0)
  {
   break;
  }
  else
  {

  }
 }

 if(Counter == 10u)
 {

  Timer0_disable_overflow_interrupt();
 }
 else
 {

 }
    return stoping_task_error;
}
# 357 "scheduler.c"
void Scheduler_Dispatcher(void)
{

 for(uint16 Counter = 0 ; Counter < 10u ; Counter++)
 {

  if(Scheduler_Tasks[Counter].Task_State == READY)
  {
   Scheduler_Tasks[Counter].Task_State = RUNNING;
   Scheduler_Tasks[Counter].Task_Function();
   Scheduler_Tasks[Counter].Task_State = WAITING;

            if(Scheduler_Tasks[Counter].Task_RepeatType == ONCE)
            {

                Scheduler_Tasks[Counter].Task_ID = 0;
                Scheduler_Tasks[Counter].Task_Periodicity = 0;
                Scheduler_Tasks[Counter].Task_RepeatType = ONCE;
                Scheduler_Tasks[Counter].Task_ExecutionTime = 0;
                Scheduler_Tasks[Counter].Task_State = WAITING;
                Scheduler_Tasks[Counter].Task_Function = (void*)0x00;
            }
            else
            {

            }
  }
  else
  {

  }
 }
    CPU_sleep();
}
