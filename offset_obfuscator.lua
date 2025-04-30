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

-- UI part for andlua environment
local andlua = require("andlua")

local function create_ui()
    local window = andlua.createWindow("Offset Obfuscator", 400, 300)
    window:setBackgroundColor(0x222222)

    local label_original = andlua.createLabel("Original Offset (hex):", 20, 20, 360, 30)
    label_original:setTextColor(0xFFFFFF)
    window:addChild(label_original)

    local input_original = andlua.createTextBox(20, 50, 360, 30)
    input_original:setText("0x134D3C")
    window:addChild(input_original)

    local label_obfuscated = andlua.createLabel("Obfuscated Offset (decimal):", 20, 100, 360, 30)
    label_obfuscated:setTextColor(0xFFFFFF)
    window:addChild(label_obfuscated)

    local output_obfuscated = andlua.createTextBox(20, 130, 360, 30)
    output_obfuscated:setReadOnly(true)
    window:addChild(output_obfuscated)

    local label_deobfuscated = andlua.createLabel("Deobfuscated Offset (hex):", 20, 180, 360, 30)
    label_deobfuscated:setTextColor(0xFFFFFF)
    window:addChild(label_deobfuscated)

    local output_deobfuscated = andlua.createTextBox(20, 210, 360, 30)
    output_deobfuscated:setReadOnly(true)
    window:addChild(output_deobfuscated)

    local function update_offsets()
        local input_text = input_original:getText()
        local offset_num = nil
        -- Parse hex input, allow with or without 0x prefix
        if input_text:match("^0x") then
            offset_num = tonumber(input_text)
        else
            offset_num = tonumber("0x" .. input_text)
        end

        if offset_num then
            local obf = offset_obfuscator.obfuscate_offset(offset_num)
            local deobf = offset_obfuscator.deobfuscate_offset(obf)
            output_obfuscated:setText(tostring(obf))
            output_deobfuscated:setText(string.format("0x%X", deobf))
        else
            output_obfuscated:setText("Invalid input")
            output_deobfuscated:setText("Invalid input")
        end
    end

    input_original:onTextChanged(update_offsets)

    -- Initialize with default value
    update_offsets()

    window:show()
end

-- Run the UI
create_ui()

-- Return the module
return offset_obfuscator
