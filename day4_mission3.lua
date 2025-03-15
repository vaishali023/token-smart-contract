--Mission 3: Token Transfer Handler
-- Description: Enable transferring tokens between accounts, with proper checks.

Handlers.add(
    "transfer",
    Handlers.utils.hasMatchingTag("Action", "Transfer"),
    function(msg)
        -- Validate recipient and quantity
        assert(type(msg.Tags.Recipient) == "string", "Recipient is required!")
        assert(type(msg.Tags.Quantity) == "string", "Quantity is required!")

        local qty = tonumber(msg.Tags.Quantity)
        assert(qty and qty > 0, "Quantity must be a positive number!")

        local sender = msg.From
        local recipient = msg.Tags.Recipient

        -- Initialize balances if needed
        if not Balances[sender] then Balances[sender] = 0 end
        if not Balances[recipient] then Balances[recipient] = 0 end

        -- Ensure sender has enough balance
        if Balances[sender] >= qty then
            Balances[sender] = Balances[sender] - qty
            Balances[recipient] = Balances[recipient] + qty

            -- Notify both parties
            ao.send({ Target = sender, Tags = { Action = "DebitNotice", To = recipient, Amount = tostring(qty) } })
            ao.send({ Target = recipient, Tags = { Action = "CreditNotice", From = sender, Amount = tostring(qty) } })
        else
            -- Notify sender of insufficient balance
            ao.send({ Target = sender, Tags = { Action = "Transfer-Error", Error = "Insufficient Balance!" } })
        end
    end
)
