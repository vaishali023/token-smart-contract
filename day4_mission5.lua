--Mission 5 : Testing the Token Contract
-- Description: Load the contract and perform a series of tests for each feature.


--Step 1: Load token contract code into AO process
--[[.load day4_mission1.lua  -- Load token initialization
.load day4_mission2.lua  -- Load info and balance handlers
.load day4_mission3.lua  -- Load transfer handler
.load day4_mission4.lua  -- Load mint handler

]]

--Step 2: Test Info query:
Send({ Target = ao.id, Tags = { Action = "Info" } })
print(Inbox[#Inbox].Tags)
--[[Output: {
   From-Module = "JArYBF-D8q2OmZ4Mok00sD2Y_6SYEQ7Hjx-6VZ_jl3g",
   Variant = "ao.TN.1",
   Reference = "3",
   From-Process = "owq0VVZNCzaHrkUZ1dbgEfZ2TTJy5QK5yiB1oQuneYI",
   Pushed-For = "o0WSXjVa9d-QMc7gr_paehKIJtRoFj7glkEx-dI2CLc",
   Denomination = "8",
   Ticker = "PNT",
   Name = "PioneerToken",
   Type = "Message",
   Data-Protocol = "ao"
}
]]

--Step 3: Test Balance query (for your own account):
Send({ Target = ao.id, Tags = { Action = "Balance" } })
print(Inbox[#Inbox].Tags.Balance)

--Output: 1000000

--Step 4: Test Transfer:
Send({ Target = ao.id, Tags = { Action = "Transfer", Recipient = "-iyoNi9pqha3jXZqzcXSFc8mx61ojGHJXt_NDbKhTXM", Quantity = "5000" } })
--Output: New Message From owq...eYI: Action = DebitNotice

-- Step 5: Verify Transfer
Send({ Target = ao.id, Tags = { Action = "Balance", Target = "-iyoNi9pqha3jXZqzcXSFc8mx61ojGHJXt_NDbKhTXM" } })
print(Inbox[#Inbox].Tags.Balance)
-- Expected Output: 5000

Send({ Target = ao.id, Tags = { Action = "Balance" } })
print(Inbox[#Inbox].Tags.Balance)
-- Expected Output: 995000 (Owner's balance should have decreased)

--Step 6: Test Insufficient Balance Transfer
Send({ Target = ao.id, Tags = { Action = "Transfer", Recipient = "-iyoNi9pqha3jXZqzcXSFc8mx61ojGHJXt_NDbKhTXM", Quantity = "999999999" } })
print(Inbox[#Inbox].Tags)
-- Expected Output:
-- {
--    Action = "Transfer-Error",
--    Error = "Insufficient Balance!"
-- }


-- Step 7: Test Minting (Owner-Only)
Send({ Target = ao.id, Tags = { Action = "Mint", Quantity = "10000" } })
print(Inbox[#Inbox].Tags)
-- Expected Output:
-- {
--    Action = "MintSuccess",
--    Amount = "10000",
--    NewSupply = "<Updated_Total_Supply>"
-- }

-- Step 8: Test Unauthorized Minting (Other Process)
Send({ Target = ao.id, From = "-iyoNi9pqha3jXZqzcXSFc8mx61ojGHJXt_NDbKhTXM", Tags = { Action = "Mint", Quantity = "5000" } })
print(Inbox[#Inbox].Tags)
-- Expected Output:
-- {
--    Action = "Mint-Error",
--    Error = "Only the Owner can mint new tokens!"
-- }

-- Step 9: Test Full Supply Query
Send({ Target = ao.id, Tags = { Action = "Balances" } })
print(Inbox[#Inbox].Data) -- Prints JSON string of all balances
-- Expected Output:
-- {
--   "owq0VVZNCzaHrkUZ1dbgEfZ2TTJy5QK5yiB1oQuneYI": 995000,
--   "-iyoNi9pqha3jXZqzcXSFc8mx61ojGHJXt_NDbKhTXM": 5000
-- }
