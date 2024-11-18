# Overview

These function are used in conjunction with Optitrack Motion Capture cameras to expirementally determine the static and kinetic coefficients of friction for a SELQIE end effector on a given surface.  

## Physical Setup

To run experiements correctly, you must use a single marker on the end effector that you are testing. There is a pink mount with a velcro command strip attached to it that can be used to hold the end effector.  This is to allow for a mounting place for the marker, and to ensure that the end effector does not rotate as it goes down the ramp.  See below: 

<img width="220" alt="EndEffectorInMount" src="https://github.com/user-attachments/assets/5c5a04a2-5f7b-40db-a60c-634cb8b428f1">

Then, using a board, for example, slide the marker down multiple times.  If you select to calculate both static and kinetic friction at the same time, the static coeffecient will be calcualated as if the angele the board is at during sliding was the angle that the makrer first started sliding.  In other words, **to get a reliable static coefficient of friction reading, you must slowly increase the angle of the board from the horizontal until the marker starts moving**.  This is not the case for the kinetic coefficient of friction- any angle can be used.  For this reason, the results for the kinetic coefficient of friciton are more reliable than for the static.

See the following image for a typical setup that was used to determine the kinetic coefficient of friction: 

<img width="193" alt="TypicalSetup" src="https://github.com/user-attachments/assets/3c7a9701-1d09-4d76-a7a4-2a70d8110087">

## CombinedMuSMuk.m

This is the main script, and is used to calculate and save the static and kinetic coefficients of friction.

The user is able to enter the number of materials tested.  From there, for each material, the user must enter: FileName and Material Name.  Next, the frameParser.m function is used to allow the user to determine two points to use as the beginning and end of the trial.  This is to avoid any errors in the sampling. Finally, the user gets to choose wheter or not to save the data to a struct.

## MuKSCalcFN

This function calculates the static and kinetic coefficients of friction, MuS and MuK respectively.

The function takes as inputs the Beginning and End of the sampling range, the FileName of the .csv from the exported Optitrack file, and StaticBool which determines if calculations for MuS should be done.  MuS should not be calculated when the slider wasn't slowly elevated until breaking static friction.

MuS is calculated as tan(phi).

MuK is calculated using an energy balance, where the estimated linear
velocity at Beginning and End are used to calculate Kinetic Energies and the change in elevation is used to calculate Potential Energy.  

## frameParser.m

This function takes in as input the FileName of the .csv from the Optitrack takes.  The outputs 'Frames' is a list of the Frame numbers that the user clicked on in the figure that was created. These will later be used as the Beginning and End as used in MuKSCalcFN.m.  The 'doubleTrials' output counts the number of clicks the user inputs.  It is called double trials as    there are two clicks per trial, thus this number is twice as large as the number of trials.
