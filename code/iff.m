function result = iff(condition, a, b)
    %IFF Implement an inline IF in Matlab
    assert(isa(condition, 'logical'), 'Condition MUST be a boolean');
    if condition
        result = a;
    else
        result = b;
    end
end

