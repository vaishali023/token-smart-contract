-- Mission 2: Token Info and Balance Handlers
-- Description: Handlers to retrieve token info and account balances.

-- 1. Info Handler: returns the token's basic info (Name, Ticker, etc.)
Handlers.add(
    "info",
    Handlers.utils.hasMatchingTag("Action", "Info"), -- trigger on a message with tag Action="Info"
    function(msg)
        ao.send({
            Target = msg.From,
            Tags   = {
                Name = Name,
                Ticker = Ticker,
                Denomination = tostring(Denomination),
                Owner = Owner
            }
        })
    end
)
-- If someone sends a message asking for Info, we respond with a message containing the token's Name, Ticker, etc.
-- Note: We include Owner (or could omit) to identify who controls the token.

-- 2. Balance Handler: returns the balance of a requested account (or sender's if none specified)
Handlers.add(
    "balance",
    Handlers.utils.hasMatchingTag("Action", "Balance"),
    function(msg)
        local target = msg.Tags.Target or
        msg.From                                   -- if message provides a Target account, use it; otherwise use sender
        local bal = Balances[target] or 0          -- get balance (or 0 if account not in table)
        ao.send({
            Target = msg.From,
            Tags   = { Target = target, Balance = tostring(bal), Ticker = Ticker }
        })
    end
)
-- This allows a user to query an account balance.
-- Example: Send a message with Tags: {Action="Balance", Target="<some_id>"} to get that account's balance.
-- If no Target is given, it defaults to sender's own balances.

-- 3. Balances Handler (optional): returns the entire balances table (perhaps for the owner or debugging)
Handlers.add(
    "all_balances",
    Handlers.utils.hasMatchingTag("Action", "Balances"),
    function(msg)
        ao.send({
            Target = msg.From,
            Data   = require('json').encode(Balances) -- send the whole Balances table as JSON string
        })
    end
)
