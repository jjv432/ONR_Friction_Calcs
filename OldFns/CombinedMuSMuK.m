clc
close all
format compact

%%

%%  General Input from the use
NumMaterials = input("Enter the number of materials tested: ");

%% Calculating Mu
fprintf("\n******** WARNING: STATIC COEFF OF FRICTION ONLY RELIABLE IF SLIDER BEGAN AT REST ********\n");
StaticBool = input("With this in mind, do you want to calculate the static coefficient of friction? (Y/N): ", 's');
fprintf("\n\n")

for j = 1:NumMaterials %Allows multiple materials to be analyzed together
    fprintf("Material #%d:\n", j);
    FileName = input("Enter the filename without extension: ", "s");
    %Finding information about the material used, and the number of trials
    %used for this material
    Material = input("Enter the name of the material that you will be using: ", "s");
    MaterialNames(j) = string(Material);
    Trials = input("Enter the number of trials done for this material: ");

    %Calculates and stores the value of Mu in the structure called Mu.
    %This is calculated using the MuCalc function.  This function takes as
    %inputs the beginning and ending frame of the take (from the
    %perspective of the MoCap), and the name of the exported MoCap file to
    %be read from.  The coefficient of friction is calculated using a
    %linear approximation of velocity at two points in time selected by the
    %user by clicking on the graph of the trajectory.
    for i = 1:Trials
        close all
        fprintf("\nTrial #%d \n", i);

        Beginning = input("Enter the beginning frame for this take: ");
        if ~Beginning
            Beginning = 1;
        end
        End = input("Enter the ending frame for this take: ");
        [MuK, MuS] = MuKSCalc(Beginning, End, strcat(FileName, '.csv'), StaticBool);
        MuKS.(Material).(strcat("Trial", num2str(i), 'k')) = MuK;
        MuKS.(Material).(strcat("Trial", num2str(i), 's')) = MuS;
        tempMuK(i) = MuK;
        tempMuS(i) = MuS;
        
    end
    
    MuKS.(Material).AvgMuK = mean(tempMuK);
    MuKS.(Material).AvgMuS = mean(tempMuS);

    MuKS.(Material).MuKList = tempMuK;
    MuKS.(Material).MuSList = tempMuS;

    clearvars -except MuKS FileName MaterialNames StaticBool
end

MuKS.Materials = MaterialNames;

SaveBool = input("Do you want to save this data to a .mat file named after the CSV (overwrites previous saves)? (Y/N): ", 's');

if (SaveBool == 'Y')||(SaveBool == 'y')
    save(strcat(FileName,".mat"),"-struct","MuKS");
    fprintf("\n***Saved to .mat file***\n")
else
    fprintf("\n***Data not saved to .mat file***\n")
end

clear SaveBool MaterialNames