function active2 = active_array(active)

    active2 = zeros(size(active));
    
    for elec = 1:size(active, 2)
        time=0; % time since the begining of an activation
        for i=1:size(active, 1)
            a=active(i,elec);
            if (~a & time>0)
                active2(i-time, elec) = 1; % active in the beginning
                time=0;
            elseif a
                time=time+1;
            end
            
        end
    end
end