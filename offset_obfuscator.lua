-- offset_obfuscator.lua
-- Lua script for andlua environment to obfuscate and deobfuscate game offsets
-- The obfuscation transforms a hex offset into a large number and can be reversed

local offset_obfuscator = {}

-- Secret key for obfuscation (can be any number, used for reversible transformation)
local secret_key = 0xA5A5A5A5

-- Function to obfuscate the offset
-- Input: offset (number) - original offset as a number (e.g., 0x134D3C)
-- Output: obfuscated number (number)
function offset_obfuscator.obfuscate_offset(offset)
    -- Example obfuscation: XOR with secret_key, then multiply by a large prime number
    local xor_val = bit32.bxor(offset, secret_key)
    local obfuscated = xor_val * 15485863  -- 1 millionth prime number for obfuscation
    return obfuscated
end

-- Function to deobfuscate the offset
-- Input: obfuscated (number) - obfuscated number
-- Output: original offset (number)
function offset_obfuscator.deobfuscate_offset(obfuscated)
    -- Reverse the obfuscation: divide by the prime, then XOR with secret_key
    local xor_val = math.floor(obfuscated / 15485863)
    local original_offset = bit32.bxor(xor_val, secret_key)
    return original_offset
end

-- Example usage
local example_offset = 0x134D3C
print(string.format("Original offset: 0x%X", example_offset))

local obfuscated = offset_obfuscator.obfuscate_offset(example_offset)
print("Obfuscated offset:", obfuscated)

local deobfuscated = offset_obfuscator.deobfuscate_offset(obfuscated)
print(string.format("Deobfuscated offset: 0x%X", deobfuscated))

-- Return the module
return offset_obfuscator
