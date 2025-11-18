function modulated = modulate_sin(mod_wave, t, Fc)
% Função para multiplicar o sinal modulante com a portadora (sin) de 2MHz
arguments (Input)
    mod_wave
    t
    Fc = 2e6
end
   
    carrier = -sin(2*pi*Fc*t);
    modulated = mod_wave .* carrier;
end