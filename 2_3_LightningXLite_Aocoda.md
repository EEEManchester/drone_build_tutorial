# 1 Develop kits
1. Drone frame:
    - Chassis TransTEC Lightning X Lite
    - Motor FPV 致盈EX2306 PLUS [site in Taobao](https://item.taobao.com/item.htm?spm=a1z10.5-c-s.w4002-22611654657.27.52b858176s1EdF&id=634695941707)
2. ESC: Aocoda 60A 4 in 1 [site in Taobao](https://item.taobao.com/item.htm?spm=a1z0d.6639537/tb.1997196601.4.55627484xw5sv5&id=682898024012)

3. Autopilot and framework
    - Aocoda RC H743 [site in Taobo](https://item.taobao.com/item.htm?spm=a1z0d.6639537/tb.1997196601.4.55627484xUOMZu&id=679995875558)     
    - BetaFlight 4.4.0
4. Onboard computer and OS
    - Navidia NX
    - Ubuntu 20.04
5. Transmitter
    - RadioLink AT9S Pro
    - RadioLink R12DSM [Site in Tabo](https://item.taobao.com/item.htm?spm=a1z10.3-c-s.w4002-22611654662.9.59a41dc7RXezIK&id=561805355565)
6. Work station
    - Ubuntu 20.04

# 2 Assembly MAVs
## 2.1 Build chassis
First, take parts from Lightning X Lite and prepare alex keys.
<figure>
    <img src="1_Assembly/Chassis/Lightning_X_Lite.jpg"
    height="200">
</figure>

We build the base like the picture below. Then, we add the upper part and use M3 screws to fix them together. 

|                        |                          |
| ----------------------------------- | ----------------------------------- |
| ![](1_Assembly/Chassis/Lightning_X_Lite_step1.jpg) | ![](1_Assembly/Chassis/Lightning_X_Lite_step2.jpg) |


It is the time to place them on the chassis

### 2.2 Link ESC with power and actuation modules
Lets take Tekko32 for example.

First, we its order for motors.
<figure>
    <img src="1_Assembly/BetaFlight_Aocoda/Acoda_ESC.png"
         height="250">
</figure>

We weld a power wire with XT60 and a 35v 470uf capacitance to the power input of Acoda ESC. Then, we weld four motors in the correct order. We weld them like this 

|                        |                          |
| ----------------------------------- | ----------------------------------- |
| ![](1_Assembly/BetaFlight_Aocoda/Motor_ESC_Connection_step1.jpg) | ![dog](1_Assembly/BetaFlight_Aocoda/Motor_ESC_Connection_step2.jpg) |


### 2.3 Connect autopilot to ESC 

We can find the pins of ESC and autopilot at the [Aocoda 60A 4 in 1](https://item.taobao.com/item.htm?spm=a1z0d.6639537/tb.1997196601.4.55627484xw5sv5&id=682898024012) and [Aocoda RC H743](https://item.taobao.com/item.htm?spm=a1z0d.6639537/tb.1997196601.4.55627484xUOMZu&id=679995875558).  

<figure>
    <img src="1_Assembly/BetaFlight_Aocoda/Aocoda_RCH743_pins.png"
         height="400">
</figure>

More specifically, they share the same strcture and we can connect them directly like this
<figure>
    <img src="1_Assembly/BetaFlight_Aocoda/Autopilot_ESC.jpg"
         height="250">
</figure>


## 2.4 Connect receiver to autopilot
It can been from [Site in Tabo](https://item.taobao.com/item.htm?spm=a1z10.3-c-s.w4002-22611654662.9.59a41dc7RXezIK&id=561805355565) that R12DSM supports S.BUS and PPM protocols working with 4.8v-6v.

Also, check pins of Aocoda and find RX1 is for receivers. Note that R12DSM needs to be connected 5v instead of 4.5v (example in the image).


Therefore, the three ports of R12DSM should be connected to Kakute in the following way:
- "+" of R12DSM ----> 5V of Aocoda
- "-" of R12DSM ----> GND of Aocoda
- "S.B/PPM" of R12DSM ----> RX1 of Aocoda

