;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

globals [
  vapor-incrementer
  cloud-line      ;; y coordinate of bottom row of cloud
  surface        ;; y coordinate of top row of earth
  top-of-cloud
  bottom-of-cloud
  mountain-incrementer
  runoff-mover
  vapor-mover
  rain-incrementer ;;tell me when to delete cloud
  cloudsize
  hitCloud?
  isRaining?
  makeCloud?
  sideCloudSize
  climate
  cloudInPosition?
  cloudYcor
  cloudDeleter
  cloudrain
  rainxcor
  infiltratexcor
  isInfiltrating?
  firstCloud
  firstCloudXCor
  leftFirstCloud
]

breed [trees my-tree]
breed [fishes fish]
breed [cacti cactus]
breed [rivers river]
breed [boats boat]
breed [clouds cloud]
breed [rainfall rain]
breed [lakes lake]
breed [suns sun]
breed [vapors vapor]
breed [mountain-peak mountain]
breed [mountain-body mountain1]
breed [runoff run1]
breed [ponds pond]
breed [water infiltration]
breed [vegetations vegetation]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup Procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;;;;;; Setup ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to reset
  clear-all
  set cloudDeleter 0
  set cloudInPosition? false
  set climate "temperate"
  set LandTemperature 60
  set Relative_humidity 70
  set AirTemperature 45
  set MountainTemperature 33
  set LakeTemperature 55
   set runoff-mover 1
  set sideCloudSize 56
  set makeCloud? false
  set isRaining? 0
  set hitCloud? false
  set vapor-incrementer 45
  set cloudsize 70
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; set global variable values
  set cloud-line 100
  set surface -30; set the height of the earth
  set top-of-cloud 86
  set bottom-of-cloud 72

   ask patches [
    if pycor = surface ;; set color of the earth surface with input number of positive streamers
      [set pcolor green - 1]
    if pycor > (cloud-line - 1)
      [set pcolor gray]    ;;set color of the cloud
    if pycor > surface and pycor < cloud-line
      [set pcolor blue]  ;; set color of the sky
    if pycor < surface
      [set pcolor green] ;; set color of the earth
    if pycor < -70 and pycor > -100 ;; set groundwater
       [set pcolor brown]
    if pxcor > -70 and pxcor < 70 and pycor < -80
        [set pcolor blue + 1]
    ;;set up mountain
    if pycor < 20 and pxcor < -75 and pycor > surface
       [set pcolor gray - 2]
    ;;lake
    if pycor < surface and pxcor > 60 and pycor > -55
    [set pcolor blue + 1]
  ]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; create the trees in the meadow based on the slider value for the number of trees
  create-trees 30 [
    set shape "grass"
    set size (5)
    setxy random(50) - 25 (surface + size / 2)
  ]

  create-trees 10 [
    set shape "myPineTree"
    set size random(10) + 30
    setxy random(70) - 110 (surface - random(5) - 20)
  ]

  create-ponds 1 [
    set shape "circle"
    set size 9
    setxy -70 -85
    set color blue + 1
  ]
   create-ponds 1 [
    set shape "circle"
    set size 9
    setxy 70 -85
    set color blue + 1
  ]

  create-vegetations 4[
    set shape "rabbit"
    set size random(2) + 5
    setxy random(90) - 110 (surface - random(15) - 25)
  ]
  create-vegetations 4[
    set shape "bug"
    set size random(2) + 2
    setxy random(70) - 110 (surface - random(15) - 20)
  ]

  ;;create rainfall
  create-rainfall 14[
    set shape "line"
    set size 5
    setxy random(7 * 7) - (117) 70 + random(10)
    set heading 180
    set color blue + 1
  ]

  ;;create lake/ocean
  create-lakes 1[
    set shape "circle"
    set size 50
    setxy 60 surface
    set color blue + 1
  ]

  create-vapors 14[
    set shape "dot"
    set size 5
    setxy 75 + (sideCloudSize / 2) - random(vapor-incrementer) surface
    set color red + 2
  ]

  ;;create sun
  create-suns 1 [
    set shape "sun"
    set color yellow
    set size 20
    setxy 90 75
  ]

  create-mountain-peak 1[
    set shape "triangle"
    set size 30
    set color white
    setxy -109 30
  ]

  create-mountain-peak 1[
    set shape "triangle"
    set size 30
    set color white
    setxy -90 30
  ]

  create-mountain-body 1[
    set shape "triangle"
    set size 70
    set color gray - 2
    setxy -95 surface + 21.5
  ]
  create-mountain-body 1[
    set shape "triangle"
    set size 70
    set color gray - 2
    setxy -76 surface + 21.5
  ]

     create-clouds 1 [
    set heading 0
    set shape "cloud3"
    set size 90
    setxy -90 75
    set color grey
    set cloudYCor ycor
    set firstCloudXCor xcor
    set leftFirstCloud (firstCloudXCor - (size / 3))
  ]
  set firstCloud one-of clouds

  create-clouds 1 [
    set heading 0
    set shape "cloud3"
    set size 86
    setxy 75 35
    set color white - 1
  ]

  create-lakes 1[
    set color blue
    set size 80
    set heading 360
    set shape "rectangle"
    setxy 60 surface + 13
  ]

  create-runoff 14[
    set color blue + 1
    set shape "dot"
    set size 5
    setxy -109 40
  ]
   create-runoff 14[
    set color blue + 1
    set shape "dot"
    set size 5
    setxy -89 40
  ]

  create-water 14[
    set color blue + 1
    set shape "line"
    set heading 180
    set size 8
    setxy random(50) - 25 surface - 10
  ]
  reset-ticks
end




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Runtime Procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to go
  ifelse (landTemperature < 32)
  [
    ask patches[
    if pycor = surface
      [set pcolor white]
    if pycor < surface
      [set pcolor white]
      if pycor <= surface and pxcor > 60 and pycor > -55
    [set pcolor blue + 1]
      if pycor < -65 and pycor > -100 ;; set groundwater
       [set pcolor brown]
    if pxcor > -70 and pxcor < 70 and pycor < -80
        [set pcolor blue + 1]
    ]

  ]
  [
    ask patches[
      if pycor <= surface
      [
        set pcolor green
      ]
      if pycor <= surface and pxcor > 60 and pycor > -55
    [set pcolor blue + 1]
      if pycor < -70 and pycor > -100 ;; set groundwater
       [set pcolor brown]
    if pxcor > -70 and pxcor < 70 and pycor < -80
        [set pcolor blue + 1]
    ]
  ]
    try-rain
    try-runoff
    try-infiltrate
    try-vapor
    move-cloud-temperate
    if ticks mod (11 - floor (Relative_humidity / 10)) = 0 [
      if (isRaining? = 0 and climate = "temperate")[
        create-rain
    ]
      create-infiltration
      runoff-maker
    ]
  ifelse LandTemperature  >= 0[
    if makeCloud? = true[
      create-cloud
    ]
    if ticks mod (floor (Relative_humidity / 10) + 1) = 0 [
      create-vapor
    ]
    set vapor-mover 1
  ]
  [
    set vapor-mover 0
  ]
  tick
end

;;Has the rain go down
to try-rain
  ask rainfall[
    ifelse ycor >= surface [
      if AirTemperature < 25[
        set ycor ycor - 2 ]
      if AirTemperature >= 25 and AirTemperature < 50[
        set ycor ycor - 3 ]
      if AirTemperature >= 50[
        set ycor ycor - 4 ]
    ]
    [
      set infiltratexcor xcor
      set isInfiltrating? true
      die
    ]
  ]
  if count rainfall = 0 [
    set isInfiltrating? false
  ]
end

to try-vapor
  ask vapors[
    ifelse ycor + (LakeTemperature / 4) < 30 [
      if ycor != -60[
      set ycor ycor + (LakeTemperature / 4) / 3
      ]
    ]
    [
      set hitCloud? true
      die
    ]
  ]
    if hitCloud? = true[
    ask clouds[
    if (color = white - 1)[
          ifelse (size + 5 <= 70)[
            set size size + 1
            set vapor-incrementer size
            set sideCloudSize size
          ]
          [
            set vapor-incrementer 0
            set size 70
            set xcor 74
            set hitCloud? false
            set makeCloud? true
          ifelse (climate = "temperate")
          [
            set color white
          ]
          [
            set color grey
          ]
        ]
    ]
    ]
    ]

end


to create-vapor
   create-vapors 14[
    set shape "dot"
    set size 5
    setxy 80 + (sideCloudSize / 2) - random(vapor-incrementer) surface
    set color red + 2
  ]
end

;;Creates rain so there is a continuous supply
to create-rain

    ifelse (is-turtle? firstCloud)
    [
      ask firstCloud[
        set firstCloudXCor xcor
      ]
      create-rainfall 14[
        set shape "line"
        set size 5
      ifelse (firstCloudXCor - (cloudsize / 3) < -120)
      [
        set leftFirstCloud -120
      ]
      [
        set leftFirstCloud firstCloudXCor - (cloudsize / 3)
      ]
        setxy leftFirstCloud + random((cloudsize / 7) * 5) cloudYcor + random(5)
        set color blue + 1
        set heading 180
      ]
    ]
    [
    if LandTemperature < 33 and AirTemperature > 32 and AirTemperature <= 75[

        create-rainfall 14[
    set shape "line"
    set size 5
    setxy random((cloudsize / 5) * 7) - (80) cloudYcor + random(5)
    set color blue + 1
    set heading 180
    ]
      ask rainfall[
        if ycor < surface + 35[

    set shape "dot"
    set size 5

    set color white
    set heading 180
    ]
    ]
  ]


  if LandTemperature > 32 and AirTemperature < 33 [

        create-rainfall 14[
    set shape "dot"
    set size 5
    setxy random((cloudsize / 5) * 7) - (80) cloudYcor + random(5)
    set color white
    set heading 180
    ]
      ask rainfall[
        if ycor < surface + 35[

    set shape "line"
    set size 5

    set color blue + 1
    set heading 180
    ]
    ]
  ]


    if AirTemperature < 33[
    create-rainfall 14[
    set shape "dot"
    set size 5
    setxy random((cloudsize / 5) * 7) - (80) cloudYcor + random(5)
    set color white
    set heading 180
    ]
    ]
    if AirTemperature >= 33 and AirTemperature <= 75[
        create-rainfall 14[
    set shape "line"
    set size 5
    setxy random((cloudsize / 5) * 7) - (80) cloudYcor + random(5)
    set color blue + 1
    set heading 180
    ]
    ]
  ]
    make-cloud-smaller


    if Relative_humidity > 50
    [create-rainfall 14[
    set shape "line"
    set size 5
    setxy random((cloudsize / 5) * 7) - (80) cloudYcor + random(5)
    set color blue + 1
    set heading 180
    ]
  ]
  ask rainfall[
  if AirTemperature > 75 and Relative_humidity < 50[
      die]
    if Relative_humidity = 0[
      die]
  ]
end

to make-cloud-smaller
  if (Relative_humidity > 75)
  [
    set cloudDeleter cloudDeleter + 1
  ]
  ifelse (cloudDeleter < 3 and Relative_humidity > 75)
  [
  ]
  [
    set cloudDeleter 0
    ask clouds[
      if color = grey[
        if (ycor + 4 <= 75)
        [
          set ycor ycor + 4
          set xcor xcor - 4
          set cloudYCor ycor
        ]
        ifelse (size - 4 >= 20)
        [
          set size size - 4
          set cloudsize cloudsize - 4
          set xcor xcor - 1
        ]
        [
          set cloudsize 70
          set isRaining? 1
          die
        ]
      ]
    ]
  ]
end

to try-runoff
  if (climate = "temperate")[
    ask runoff [
      ifelse ycor - runoff-mover >= surface - 3
      [
        ifelse MountainTemperature < 33[
          die]
        [
        set ycor ycor - (runoff-mover / 2.5) - (MountainTemperature / 150)
        set xcor xcor + (random(runoff-mover + .5)) / 2.5
      ]]
      [
        if color != green[
          set xcor xcor + runoff-mover
        ]
      ]
      if xcor > 70
      [die]
  ]
  ]
  if LandTemperature < 33 [
    ask runoff[
      if xcor > -42 [
        die]
    ]
  ]


end

to runoff-maker

    if MountainTemperature < 33[
    create-runoff 1[
      set color white
      set shape "dot"
      set size 5
      setxy -109 40
      if xcor < -30 [
        die]
    ]
  ]
    if MountainTemperature >= 33[
       create-runoff 5[
      set color blue + 1
      set shape "dot"
      set size 5
      setxy -109 40
    ]]
     if MountainTemperature < 33[
    create-runoff 1[
      set color white
      set shape "dot"
      set size 5
      setxy -89 40
      if xcor < -30 [
        die]
    ]
  ]
    if MountainTemperature >= 33[
       create-runoff 5[
      set color blue + 1
      set shape "dot"
      set size 5
      setxy -89 40
    ]]
  if LandTemperature > 33[
  create-runoff 8[
      set color blue + 1
      set shape "dot"
      set size 5
      setxy -54 -20
    ]
  ]


end

to try-infiltrate
  ask water[
    ifelse ycor - runoff-mover >= -80[
      set ycor ycor - runoff-mover
    ]
    [
      die
    ]
  ]
end

to create-infiltration
  if (climate = "temperate") and LandTemperature > 32[
  create-water (LandTemperature / 5)[
    set color blue + 1
    set shape "line"
    set heading 180
    set size 8
    setxy random(150) - 80 surface - 12
  ]
  ]


end

to move-cloud-temperate
  ask clouds[
    if color = white[
      ifelse xcor - 2 > -20[
        set xcor xcor - 4
      ]
      [
        ask clouds[
          if color = grey
          [die]
          if color = white[
            set cloudSize size
          ]
        ]
        set color grey
        set xcor xcor + 3
        set cloudInPosition? true
        set isRaining? 0
        set cloudYcor ycor
      ]
    ]
  ]
end


to create-cloud
create-clouds 1[
          set color white - 1
          set size 0
          set shape "cloud3"
          set heading 0
          setxy 75 25
          set sideCloudSize size
        ]
  set makeCloud? false
end
@#$#@#$#@
GRAPHICS-WINDOW
215
20
946
548
-1
-1
3.0
1
10
1
1
1
0
0
0
1
-120
120
-86
86
1
1
1
ticks
15.0

BUTTON
15
20
200
53
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

TEXTBOX
40
145
190
163
Pick the climate here!
11
0.0
1

BUTTON
15
60
200
93
Reset!
reset
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
20
275
192
308
LakeTemperature
LakeTemperature
0
100
55.0
1
1
NIL
HORIZONTAL

SLIDER
20
145
192
178
AirTemperature
AirTemperature
0
100
76.0
1
1
NIL
HORIZONTAL

SLIDER
20
190
190
223
MountainTemperature
MountainTemperature
0
60
46.0
1
1
NIL
HORIZONTAL

SLIDER
20
230
192
263
LandTemperature
LandTemperature
0
100
57.0
1
1
NIL
HORIZONTAL

SLIDER
20
105
192
138
Relative_humidity
Relative_humidity
0
100
59.0
1
1
%
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

This is an interactive simulation that models the water cycle. It aims to illustrate how relative humidity and the temperature of air, mountain, land, and lake affect the movement of water molecules. This model represents the following five phases of the water cycle: evaporation, condensation, precipitation, surface runoff, and infiltration.

Water is one of the most important element on Earth that is necessary to sustain life. All living organisms need water to survive. Also, learning how water can be made available for consumption helps us understand how we can be responsible in managing our water resources. Therefore, it is important to educate every generation on what causes the water cycle and how it works.

In order to understand the concept of water cycle, one must have knowledge of how the Earth’s gravity pulls objects toward its center and how the sun causes heat on Earth. This simulation will potentially help the user to describe and reason non-numerically about the factors that affect the flow of the water molecules in the cycle. The user will observe the behavior of the water molecules while changing the relative humidity and temperature (air, mountain, land, and lake) parameters.

## HOW IT WORKS

### How does Water Cycle work?

Water vapors (orange dots) evaporate from the lake (light blue curved shape) and rise into the sky (blue background). The occurrence and speed of evaporation vary depending on the temperature of the lake. As the water vapor moves into the sky, the cloud (white cloud) forms. This cloud forms by accumulating the water vapor which cools off during evaporation. Then, the cloud is blown by the wind towards another place, such as the mountain (triangular shape). Then the cloud appears darker (dark cloud) and releases rain (ticks) or snow (white dots) while it slowly disappears (growing smaller). 

The precipitation in the form of rain, snow or a mixture of rain or snow varies depending on the percentage of humidity and the temperature of air, mountain, land, and lake. These temperatures are mainly influenced by the sun (yellow object appearing in the sky), gases, and other things.

On top of the mountain, there are existing snowcaps (white triangular shapes). The melting of the snowcaps and precipitation causes water to runoff (flowing of blue dots from the top of the mountain) towards the lower surface of the Earth (green or white plain). Similar to precipitation, the occurrence of surface runoff depends on the temperature of the mountain.

Meanwhile, the Earth's surface (plain on the lower ground) is filled with plants (turns green) or covered with snow (turns white) depending on the temperature of the land. Underneath the ground surface, the water (ticks) infiltrates. The occurrence of infiltration varies depending on the temperature of the land. 

Then, the water that is accumulated on the Earth's surface (including lake, ponds, and oceans) goes back into the sky in the form of water vapor. Similar to the other phases of the water cycle, the temperature of the land, lake, pond and ocean mainly influences the movement of the water vapor to rise into the sky. Note that water evaporates at any temperature but of varying quantities.

There are other attributes that influence the water molecules to move around the Earth, such as gravity, speed of the wind, area of the vegetation, elevation of the land, and population of living things but these are not illustrated in this simulation. Also, we did not include all the water cycle phases, such as evapo-transpiration, in which the water molecules  transpired by plants, animals, and human beings evaporate into the sky. Future development of this simulation may include more phases and attributes.

### How does the model work?

There are several attributes that influence the water cycle. In this model, only the following factors are illustrated:

Sun - emits energy that heats up the Earth's water, air, land, and atmosphere. 

Relative Humidity - the amount of water vapor present in air. This is expressed as a percentage of water vapor or moisture in the air compared to how much the air can hold at a particular temperature. In this model, the values of the relative humidity vary from 0% to 100%. In a natural environment, relative humidity has never dropped to zero percent because water vapor is always present in the air even on the smallest quantity. A reading of 100% relative humidity implies that the air is completely saturated with water vapor and can no longer hold more water vapor. The possibility of precipitation can occur anytime from 1% to 100% humidity.

Temperature (air, mountain, land, lake) - measures how hot or cold the air or surface (mountain, land, or lake) is. In this simulation, the values for the temperature can vary from 0 to 100 degrees Fahrenheit (°F). Water molecules begin to freeze when the temperature falls below 32°F. Otherwise, water molecules remain in their liquid or gaseous state. In a natural environment, water begins to boil at 200°F depending on the altitude, but this is not included in this model. 

Water vapor - the gaseous (invisible) state of water molecule. Water vapor in the atmosphere serves as the raw material for cloud and rain formation.

Cloud - forms during condensation and is made of tiny drops of water in the form of liquid or ice. Cloud is a vital part of precipitation as it brings water molecules in the form of rain or snow.

Rain - is a liquid water falling visibly from the clouds.

Snow - ice crystals formed from frozen water vapor and is falling from the clouds in light white flakes.

Mountain - a higher elevation of the Earth's surface.

Earth's surface - surface of the Earth that changes into green if it is filled with plants and other green vegetation, or white if it is covered with snow.

## HOW TO USE IT

Reset button - sets up the background with white cloud forming above the lake and dark cloud pouring rain above the mountain. Trees, grasses, and animals will also vary upon clicking this button. At the same time, the following parameters were set with initial values: Relative humidity - 70%; Air Temperature - 45; Mountain Temperature - 33; Land Temperature - 60; Lake Temperature - 55.

GO button - turns black and runs the model.

Relative_humidity slider - changes the percentage of humidity from 0% (left) to 100% (right)

AirTemperature slider - changes the temperature of the air from 0°F (left) to 100°F (right).

MountainTemperature slider - changes the temperature of the mountain surface from 0°F to 100°F.

LandTemperature slider - changes the temperature of the land surface from 0°F to 100°F.

LakeTemperature slider - changes the temperature of the lake surface from 0°F to 100°F.

ticks slider - changes the speed of the simulation. The speed of the simulation can be adjusted into either slower (left) or faster (right) pace. (The ticks don't seem to mean anything besides showing that the simulation is on the GO).

The simulation runs until the GO button is clicked again and returns into grey color.

## THINGS TO NOTICE

Notice the changes on the following features:

Rate of water vapor and how it depends on the lake temperature.

Form of precipitation and how it is affected by the air, mountain, land temperature.

Earth's surface and how it relates to the land temperature.

Water runoff and infiltration and how those relate to mountain and land temperature.

## THINGS TO EXPLORE

1. Manipulate the sliders and identify the factors that influence evaporation. Note that you need to click on Reset! and go before you start exploring each slider. 

2. Manipulate only the air temperature and the land temperature to make the precipitation to be in the form of snow. In what conditions of the air temperature and land temperature will release more snow? 

3. What conditions will STOP the water runoff from the surface of the mountain?

4. In what land temperature will infiltration occur?

5. “The less precipitation the more runoff. The more runoff the more infiltration. So, the less precipitation the more infiltration.” Is this statement true? If not, correct it.

## EXTENDING THE SIMULATION

Consider other features such as:	

Wind direction and speed that influence precipitation.

Evapo-transpiration from plants, animals and human beings.

Water accumulation under the surface of the Earth.

## CREDITS AND REFERENCES

Lee, T. D., Jones, M. G., & Chesnutt, K. (2017). Teaching Systems Thinking In The Context of the Water Cycle. Research in Science Education, pp. 1-36, (URL: https://doi.org/10.1007/s11165-017-9613-7).
https://pmm.nasa.gov/education/lesson-plans/exploring-water-cycle

https://science.nasa.gov/earth-science/oceanography/ocean-earth-system/ocean-water-cycle

https://pmm.nasa.gov/education/sites/default/files/videos/A_Tour_of_the_Water_Cycle.mp4

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the simulation itself: 

ACMES Group (2018). NetLogo Water Cycle simulation. Assimilating Computational and Mathematical Thinking into Earth and Environmental Science. Montclair State University, Montclair, NJ.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.



## COPYRIGHT AND LICENSE
Copyright 2018 ACMES Group at Montclair State University 
This work is licensed under the GNU GENERAL PUBLIC LICENSE V3. Everyone is permitted to copy and distribute verbatim copies of this license document, but changing it is not allowed. To view the details of the license, you can visit https://www.gnu.org/licenses/gpl.html.

Acknowledgment
This research is supported through a STEM+Computing grant from the Division of Research on Learning of the National Science Foundation (# 1742125). 
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

+
false
0
Rectangle -7500403 false true 120 30 180 270
Rectangle -7500403 false true 30 120 270 180
Rectangle -2674135 true false 120 30 180 270
Rectangle -2674135 true false 30 120 270 180

-
false
0
Rectangle -13791810 true false 45 135 225 195

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -11221820 true false 150 0 0 150 105 150 105 293 195 293 195 150 300 150

boat
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 33 230 157 182 150 169 151 157 156
Polygon -7500403 true true 149 55 88 143 103 139 111 136 117 139 126 145 130 147 139 147 146 146 149 55

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

cactus
false
0
Polygon -7500403 true true 130 300 124 206 110 207 94 201 81 183 75 171 74 95 79 79 88 74 97 79 100 95 101 151 104 169 115 180 126 169 129 31 132 19 145 16 153 20 158 32 162 142 166 149 177 149 185 137 185 119 189 108 199 103 212 108 215 121 215 144 210 165 196 177 176 181 164 182 159 302
Line -16777216 false 142 32 146 143
Line -16777216 false 148 179 143 300
Line -16777216 false 123 191 114 197
Line -16777216 false 113 199 96 188
Line -16777216 false 95 188 84 168
Line -16777216 false 83 168 82 103
Line -16777216 false 201 147 202 123
Line -16777216 false 190 162 199 148
Line -16777216 false 174 164 189 163

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

cloud
false
0
Circle -1 true false 158 68 134
Circle -1 true false 13 118 94
Circle -1 true false 86 101 127
Circle -1 true false 51 51 108
Circle -1 true false 118 43 95

cloud2
true
0
Circle -7500403 true true 60 90 60
Circle -7500403 true true 90 75 90
Circle -7500403 true true 103 118 124
Circle -7500403 true true 15 120 90
Circle -7500403 true true 56 176 67
Circle -7500403 true true 111 66 108
Circle -7500403 true true 168 123 85
Circle -7500403 true true 51 66 108

cloud3
true
0
Circle -7500403 true true 30 105 60
Circle -7500403 true true 60 90 90
Circle -7500403 true true 116 86 67
Circle -7500403 true true 135 105 90
Circle -7500403 true true 236 101 67
Circle -7500403 true true 195 135 60
Circle -7500403 true true 195 90 60
Circle -7500403 true true 150 90 60
Circle -7500403 true true 9 114 42
Circle -7500403 true true 105 135 60
Circle -7500403 true true 54 144 42
Circle -7500403 true true 69 144 42
Circle -7500403 true true 30 135 30

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
1
Circle -7500403 true false 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

grass
false
0
Rectangle -13840069 true false 135 240 165 300
Polygon -13840069 true false 135 255 90 210 45 195 75 255 135 285
Polygon -13840069 true false 165 255 210 210 255 195 225 255 165 285
Polygon -13840069 true false 135 240 120 195 150 165 180 195 165 240

house
false
0
Rectangle -11221820 true false 45 120 255 285
Rectangle -13345367 true false 120 210 180 285
Polygon -2674135 true false 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

mountain
true
1
Line -6459832 false 45 225 135 75
Line -6459832 false 135 75 240 225
Line -6459832 false 45 225 240 225
Rectangle -7500403 true false 120 165 195 225
Polygon -7500403 true false 45 225 135 75 135 75 240 225 45 225 135 105 210 195 90 195 90 165 135 75 225 225 60 225 90 165
Polygon -7500403 true false 135 75 195 165 135 105 90 165 135 75
Rectangle -7500403 true false 90 165 120 225
Rectangle -7500403 true false 120 105 150 180
Rectangle -7500403 true false 60 210 225 225
Polygon -7500403 true false 75 210 90 165 90 210 75 210
Polygon -7500403 true false 135 75 60 210 225 210 135 75

myburnttree
false
1
Circle -7500403 true false 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true false 65 21 108
Circle -7500403 true false 116 41 127
Circle -7500403 true false 45 90 120
Circle -7500403 true false 104 74 152

mypinetree
false
0
Rectangle -6459832 true false 120 225 180 300
Polygon -14835848 true false 150 240 240 270 150 135 60 270
Polygon -14835848 true false 150 75 75 210 150 195 225 210
Polygon -14835848 true false 150 7 90 157 150 142 210 157 150 7

mytree
false
1
Circle -13840069 true false 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -13840069 true false 65 21 108
Circle -13840069 true false 116 41 127
Circle -13840069 true false 45 90 120
Circle -13840069 true false 104 74 152

negativestrm
false
0
Circle -11221820 true false 0 0 300
Circle -16777216 true false 30 30 240
Rectangle -2674135 false false 60 120 240 180
Rectangle -11221820 true false 60 120 240 180

oasis
true
0
Line -7500403 true 60 150 240 150
Circle -7500403 true true 41 146 67
Circle -7500403 true true 135 150 120
Polygon -7500403 true true 60 210 120 225 180 270 270 225 240 240 195 210 195 225
Circle -7500403 true true 225 150 60
Polygon -7500403 true true 240 150 255 150 135 225 75 210 90 150 240 150 255 150 210 210
Polygon -7500403 true true 240 150 255 150 225 225 90 210 60 180 240 150 255 150
Polygon -7500403 true true 270 210 285 180 255 240 210 270 240 195 270 195

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

positivestrm
true
0
Circle -2674135 false false 15 15 270
Circle -2674135 false false 36 36 228
Rectangle -2674135 true false 120 60 180 240
Rectangle -2674135 true false 60 120 240 180

postivearrow
true
0
Polygon -8630108 true false 150 15 180 75 180 120 255 120 255 180 180 180 180 255 120 255 120 180 45 180 45 120 120 120 120 75 150 15

rabbit
false
0
Polygon -7500403 true true 61 150 76 180 91 195 103 214 91 240 76 255 61 270 76 270 106 255 132 209 151 210 181 210 211 240 196 255 181 255 166 247 151 255 166 270 211 270 241 255 240 210 270 225 285 165 256 135 226 105 166 90 91 105
Polygon -7500403 true true 75 164 94 104 70 82 45 89 19 104 4 149 19 164 37 162 59 153
Polygon -7500403 true true 64 98 96 87 138 26 130 15 97 36 54 86
Polygon -7500403 true true 49 89 57 47 78 4 89 20 70 88
Circle -16777216 true false 37 103 16
Line -16777216 false 44 150 104 150
Line -16777216 false 39 158 84 175
Line -16777216 false 29 159 57 195
Polygon -5825686 true false 0 150 15 165 15 150
Polygon -5825686 true false 76 90 97 47 130 32
Line -16777216 false 180 210 165 180
Line -16777216 false 165 180 180 165
Line -16777216 false 180 165 225 165
Line -16777216 false 180 210 210 240

rectangle
true
0
Rectangle -7500403 true true 30 105 270 195

river
true
10
Polygon -7500403 false false 60 45
Polygon -7500403 true false 60 45 75 150 90 165 105 180 120 180 135 195 180 195 225 195 240 210 270 210 285 195 285 150 210 150 150 135 120 135 120 105 105 75 105 45 60 45

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

sun
false
0
Circle -7500403 true true 75 75 150
Polygon -7500403 true true 300 150 240 120 240 180
Polygon -7500403 true true 150 0 120 60 180 60
Polygon -7500403 true true 150 300 120 240 180 240
Polygon -7500403 true true 0 150 60 120 60 180
Polygon -7500403 true true 60 195 105 240 45 255
Polygon -7500403 true true 60 105 105 60 45 45
Polygon -7500403 true true 195 60 240 105 255 45
Polygon -7500403 true true 240 195 195 240 255 255

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269
@#$#@#$#@
NetLogo 6.0.2
@#$#@#$#@
setup
repeat 50 [ go ]
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
