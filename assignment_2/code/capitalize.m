function result = capitalize(string)
    %%CAPITALIZE: make the first letter of a string uppercase.
    assert(ischar(string), "Input is not a string.");
    
    result = string;
    result(1) = upper(string(1));
end

