# 1 "KeyPad.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.10\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "KeyPad.c" 2
# 15 "KeyPad.c"
# 1 "./keyPad.h" 1
# 21 "./keyPad.h"
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
# 21 "./keyPad.h" 2
# 38 "./keyPad.h"
extern void KeyPad_Initialization(void);
# 51 "./keyPad.h"
extern uint8 KeyPad_get_PressedKey_with_debouncing(void);
# 15 "KeyPad.c" 2

# 1 "./KeyPad_config.h" 1
# 16 "KeyPad.c" 2

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
# 17 "KeyPad.c" 2
# 35 "KeyPad.c"
static uint8 KeyPad_switch(uint8 a_u8row, uint8 a_u8col);
# 48 "KeyPad.c"
static uint8 KeyPad_getPressedKey(void);
# 65 "KeyPad.c"
void KeyPad_Initialization(void)
{

    for(uint8 u8counter = 0u ; u8counter <= 0u + 3u ; u8counter++)
    {
        GPIO_SetPinDirection(3u , u8counter , 0u);
        GPIO_WriteOnPin(3u , u8counter , 1u);
    }

    for(uint8 u8counter = 0u ; u8counter <= 0u + 2u ; u8counter++)
    {
        GPIO_SetPinDirection(1u , u8counter , 1u);
    }
}
# 91 "KeyPad.c"
uint8 KeyPad_get_PressedKey_with_debouncing(void)
{

    static uint8 u8debouncing_counter = 0;
    uint8 u8pressed_key = '_';
    uint8 u8retVal = '_';

    KeyPad_Initialization();

    u8pressed_key = KeyPad_getPressedKey();

    if(u8pressed_key != '_')
    {

        switch(u8debouncing_counter)
        {
            case 0:
                u8debouncing_counter++;
                break;
            case 1:

                u8retVal = u8pressed_key;

                u8debouncing_counter++;
                break;
            case 2:

                break;
            default:

                break;
        }
    }
    else
    {

        u8debouncing_counter = 0;
    }
    return u8retVal;
}
# 143 "KeyPad.c"
static uint8 KeyPad_getPressedKey(void)
{

 uint8 u8ReturnVal = '_';

 for(uint8 u8rowCounter = 0u ; u8rowCounter <= 0u + 3u ; u8rowCounter++)
 {

  GPIO_WriteOnPin(3u , u8rowCounter , 0u);

  for(uint8 u8colCounter = 0u ; u8colCounter <= 0u + 2u ; u8colCounter++)
  {

   if(GPIO_ReadFromPin(1u , u8colCounter) == 0u)
   {

                return KeyPad_switch(u8rowCounter - 0u , u8colCounter - 0u);
   }
  }

        GPIO_WriteOnPin(3u , u8rowCounter , 1u);
 }
 return u8ReturnVal;
}
# 180 "KeyPad.c"
static uint8 KeyPad_switch(uint8 a_u8row , uint8 a_u8col)
{

 uint8 u8ReturnVal = 0;


 switch(a_u8row)
 {
 case 0:

  switch(a_u8col)
  {
  case 0: u8ReturnVal = '*';
            break;
  case 1: u8ReturnVal = 0;
            break;
  case 2: u8ReturnVal = '#';
            break;





        default:

            break;
  }
  break;

 case 1:

  switch(a_u8col)
  {
  case 0: u8ReturnVal = 7;
   break;
  case 1: u8ReturnVal = 8;
   break;
  case 2: u8ReturnVal = 9;
   break;





        default:

            break;
  }
  break;

 case 2:

  switch(a_u8col)
  {
  case 0: u8ReturnVal = 4;
   break;
  case 1: u8ReturnVal = 5;
   break;
  case 2: u8ReturnVal = 6;
   break;





        default:

            break;
  }
  break;


 case 3:

  switch(a_u8col)
  {
  case 0: u8ReturnVal = 1;
   break;
  case 1: u8ReturnVal = 2;
   break;
  case 2: u8ReturnVal = 3;
   break;





        default:

            break;
  }
  break;

    default:

        break;
 }


 return u8ReturnVal;
}
