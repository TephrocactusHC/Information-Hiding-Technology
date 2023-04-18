%% CalculateBlack
function out = CalculateBlack(x, i)
out = 0;
for a = i : i + 3
    if x(a) == 0
        out = out + 1;
    end
end
end
        
    