function [] = subsample_dfa(mean_path,dfa_path,box_lengths)
    load(mean_path, "m");
    [~,F] = DFA_fun(m(~isnan(m)), box_lengths, 1);
    save(dfa_path, "box_lengths", "F");
end