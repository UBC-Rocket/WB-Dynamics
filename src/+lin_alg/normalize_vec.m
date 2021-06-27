function v_norm = normalize_vec(v)
%NORMALIZE_VEC Normalizes vector to unit length
%   If the vector is a zero vector the function returns the zero vector to
%   prevent division by zero. If the vector has length greater than zero,
%   the vector will be converted to unit length.
%
%   Input:
%       v: vector of any size
%   Output:
%       v_norm : v normalized or zero vector if v is zero vector
%
    if norm(v) == 0
        v_norm = v;
    else
        v_norm = v/norm(v);
    end
end

