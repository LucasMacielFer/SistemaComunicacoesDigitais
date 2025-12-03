function [tempo, wave] = TX(data, N_levels, pulse, conv, g1, g2)
% Com os dados já obtidos, utiliza-se essa função para transformar uma
% linha de dados binários em uma onda modulada, incluindo no processo a
% codificação convolucional e o filtro adaptado.
arguments(Input)
    data
    N_levels
    pulse
    conv
    g1 = ''
    g2 = ''
end
    if conv
        bin_data = conv_encoder(data, g1, g2);
    else
        bin_data = data;
    end
    
    switch N_levels
        case 1
            [tempo, coeffs_I, wave_I] = NRZ_polar_BPSK(bin_data);
            if pulse
                [wave_I, ~, ~] = pulse_shaping_filter(coeffs_I, 1);
            end
            wave = modulate_cos(wave_I, tempo);
        case 2
            [tempo, coeffs_I, coeffs_Q, wave_I, wave_Q] = NRZ_polar_QAM(bin_data, 2);
            if pulse
                [wave_I, ~, ~] = pulse_shaping_filter(coeffs_I, 2);
                [wave_Q, ~, ~] = pulse_shaping_filter(coeffs_Q, 2);
            end
            wave = modulate_cos(wave_I, tempo) + modulate_sin(wave_Q, tempo);
        case 4
            [tempo, coeffs_I, coeffs_Q, wave_I, wave_Q] = NRZ_polar_QAM(bin_data, 4);
            if pulse
                [wave_I, ~, ~] = pulse_shaping_filter(coeffs_I, 4);
                [wave_Q, ~, ~] = pulse_shaping_filter(coeffs_Q, 4);
            end
            wave = modulate_cos(wave_I, tempo) + modulate_sin(wave_Q, tempo);
        case 8
            [tempo, coeffs_I, coeffs_Q, wave_I, wave_Q] = NRZ_polar_QAM(bin_data, 8);
            if pulse
                [wave_I, ~, ~] = pulse_shaping_filter(coeffs_I, 8);
                [wave_Q, ~, ~] = pulse_shaping_filter(coeffs_Q, 8);
            end
            wave = modulate_cos(wave_I, tempo) + modulate_sin(wave_Q, tempo);
        case 16
            [tempo, coeffs_I, coeffs_Q, wave_I, wave_Q] = NRZ_polar_QAM(bin_data, 16);
            if pulse
                [wave_I, ~, ~] = pulse_shaping_filter(coeffs_I, 16);
                [wave_Q, ~, ~] = pulse_shaping_filter(coeffs_Q, 16);
            end
            wave = modulate_cos(wave_I, tempo) + modulate_sin(wave_Q, tempo);
    end
end