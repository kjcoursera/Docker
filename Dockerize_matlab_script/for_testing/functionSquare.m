function output =functionSquare(input)
output = input.^2;
fileName  = ['./execute/dataWriteNew' num2str(input) '.mat'];
save(fileName,'output');
end