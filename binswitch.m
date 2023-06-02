function [newvalue]=binswitch(missingbit)
binvalue=dec2bin(missingbit);
switch length(binvalue)
    case 8
        newvalue=bin2dec(['1' binvalue]);
    case 7
        newvalue=bin2dec(['10' binvalue]);
    case 6
        newvalue=bin2dec(['100' binvalue]);
    case 5
        newvalue=bin2dec(['1000' binvalue]);
    case 4
        newvalue=bin2dec(['10000' binvalue]);
    case 3
        newvalue=bin2dec(['100000' binvalue]);
    case 2
        newvalue=bin2dec(['1000000' binvalue]);
    case 1
        newvalue=bin2dec(['10000000' binvalue]);
end