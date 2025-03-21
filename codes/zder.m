% MIT License
% Copyright (c) 2025 Carlos Yanes Pérez
% https://github.com/alu0101430720/MNEDP-MetodoTiro/tree/main

function g = zder(t, z, y)
    % G
    g = [z(2); -2*(y(1)*z(2) + y(2)*z(1))/t];
end