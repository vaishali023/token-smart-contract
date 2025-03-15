--Mission 1: Token Contract Initialization
-- Description: Set up initial state variables for the token (name, ticker, balances, etc.).


-- 1. Basic token parameters:
if not Balances then 
    Balances = { [ao.id] = 1000000 }   -- Give the contract creator (Owner) an initial supply of 1,000,000 units.
end
if not Owner then 
    Owner = ao.id  -- Ensures the deploying process becomes the owner
end
if Name ~= "PioneerToken" then Name = "PioneerToken" end        -- Token name 
if Ticker ~= "PNT" then Ticker = "PNT" end            -- Token symbol/ticker
if Denomination ~= 8 then Denomination = 8 end        -- Supports fractional values

-- (The above pattern ensures we don't overwrite these if they are already set, following persistent state practice.

-- 2. Optionally, include a token logo or other metadata:
if not Logo then Logo = nil end  -- could store an Arweave TXID of an image, for example.

-- Now our state has:
-- Balances: a table mapping account IDs to token balances (initialized with all supply to Owner's process ID).
-- Name, Ticker, Denomination, Logo: metadata about the token.
