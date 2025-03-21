% MIT License
% Copyright (c) 2025 Carlos Yanes Pérez
% https://github.com/alu0101430720/MNEDP-MetodoTiro/tree/main

function f = der(t, y)
    % F
    f = [y(2); -2*y(1)*y(2)/t];
end