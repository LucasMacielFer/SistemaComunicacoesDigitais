function modulated = modulate_cos(mod_wave, t, Fc)
% Função para multiplicar o sinal modulante com a portadora (cos) de 2MHz
arguments (Input)
    mod_wave
    t
    Fc = 2e6
end
   
    carrier = cos(2*pi*Fc*t);
    modulated = mod_wave .* carrier;
end