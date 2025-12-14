function modulated = modulate_cos(mod_wave, t, Fc)
% Uso Geral: Modula um sinal em banda-base (mod_wave) usando uma portadora cossenoidal 
% com frequência Fc.
arguments (Input)
    mod_wave
    t
    Fc = 100e3
end
    carrier = cos(2*pi*Fc*t);
    modulated = mod_wave .* carrier;
end