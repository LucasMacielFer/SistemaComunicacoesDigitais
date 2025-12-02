function [RXBinSeq, symbols] = RX(t, recieved, N_levels, pulse, convolucional, g1, g2)
    symbols = demodulate(recieved, t, N_levels, pulse);

    if N_levels == 1
        RXBinSeq = slicer_demapper_BPSK(symbols);
        return;
    end

    sliced = slicer(symbols, N_levels);
    demapped = demapper(sliced, N_levels);

    if convolucional
        RXBinSeq = viterbi(demapped, g1, g2);
    else
        RXBinSeq = demapped;
    end
end